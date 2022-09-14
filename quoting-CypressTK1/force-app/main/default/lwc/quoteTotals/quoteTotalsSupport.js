/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import AMOUNT_FIELD from '@salesforce/schema/Adjustment__c.Amount__c';
import APPLIED_TO_FIELD from '@salesforce/schema/Adjustment__c.AppliedTo__c';
import METHOD_FIELD from '@salesforce/schema/Adjustment__c.Method__c';
import NAMED_RANGE_ID_FIELD from '@salesforce/schema/Adjustment__c.NamedRangeId__c';
import TYPE_FIELD from '@salesforce/schema/Adjustment__c.Type__c';
import DISCOUNT_AMOUNT_FIELD from '@salesforce/schema/Quote__c.DiscountAmount__c';
import MARGIN_PERCENT_FIELD from '@salesforce/schema/Quote__c.MarginPercent__c';
import TOTAL_AMOUNT_BEFORE_DISCOUNT_FIELD from '@salesforce/schema/Quote__c.TotalAmountBeforeDiscount__c';
import TOTAL_AMOUNT_FIELD from '@salesforce/schema/Quote__c.TotalAmount__c';
import { Discount } from 'c/constantUtil';
import { marginPercentage } from 'c/util';
import { roundAmount } from 'c/currencyUtil';

const newNamedRangeDto = () => {
	const namedRangeDto = {};
	namedRangeDto.adjustedBaseAmount = 0;
	namedRangeDto.netExtendedAmount = 0;
	namedRangeDto.baseExtendedAmount = 0;
	namedRangeDto.marginPercent = 0;
	namedRangeDto.currentDiscount = 0;
	namedRangeDto.discountAmount = 0;
	namedRangeDto.discountPercent = 0;
	namedRangeDto.newAmount = 0;
	namedRangeDto.newMargin = 0;
	namedRangeDto.netExtendedCost = 0;
	return namedRangeDto;
};

const updateFieldValues = (record, newValue, fieldType) => {
	const element = record;
	if (fieldType === Discount.DISCOUNT_PERCENT) {
		if (element.discountPercent !== newValue) {
			element.discountType = fieldType;
			element.discountAmount = roundAmount(
				(element.baseExtendedAmount * newValue) / 100,
			);
			element.discountPercent = newValue;
			element.newAmount = record.netExtendedAmount - element.discountAmount;

			if (record.netExtendedCost !== 0) {
				element.newMargin = roundAmount(
					((element.newAmount - element.netExtendedCost) / element.newAmount) * 100,
				);
			}
		}
	} else if (fieldType === Discount.DISCOUNT_AMOUNT) {
		if (element.discountAmount !== newValue) {
			element.discountType = fieldType;
			element.discountAmount = newValue;
			element.discountPercent = roundAmount(
				(newValue / record.baseExtendedAmount) * 100,
			);
			element.newAmount = record.baseExtendedAmount - element.discountAmount;

			if (record.netExtendedCost !== 0) {
				element.newMargin = roundAmount(
					((element.newAmount - element.netExtendedCost) / element.newAmount) * 100,
				);
			}
		}
	}
};

const recalculateMargin = (namedRangeDto) => {
	const ctxNamedRange = namedRangeDto;
	if (!+ctxNamedRange.relatedTotal.netExtendedAmount) {
		ctxNamedRange.relatedTotal.marginPercent = 0;
	} else {
		ctxNamedRange.relatedTotal.marginPercent = roundAmount(marginPercentage(
			ctxNamedRange.relatedTotal.netExtendedAmount,
			ctxNamedRange.relatedTotal.netExtendedCost,
		));
	}
};

const recalculateMarginForRelatedTotal = (relatedTotal) => {
	const ctxRelatedTotal = relatedTotal;
	if (!+ctxRelatedTotal.netExtendedAmount) {
		ctxRelatedTotal.marginPercent = 0;
	} else {
		ctxRelatedTotal.marginPercent = roundAmount(marginPercentage(
			ctxRelatedTotal.netExtendedAmount,
			ctxRelatedTotal.netExtendedCost,
		));
	}
};

const calculatePartialDiscount = (runningDiscount, baseValue, nextAdjustment) => {
	const isMarkup = nextAdjustment.type.indexOf('Markup') >= 0;
	let partialDiscount = 0;
	if (nextAdjustment.type.indexOf('Percent') >= 0) {
		partialDiscount = +nextAdjustment.amount;
	} else {
		const amountBeforeDiscount = +baseValue * (runningDiscount || 1);
		partialDiscount = (+nextAdjustment.amount / amountBeforeDiscount) * 100;
	}

	if (isMarkup) {
		partialDiscount *= -1;
	}

	return partialDiscount;
};

const calculateEffectiveDiscount = (baseValue, adjustments) => {
	const effectiveDiscount = adjustments?.reduce((accumulator, nextAdjustment) => {
		const partialDiscount = calculatePartialDiscount(accumulator, baseValue, nextAdjustment);
		return accumulator + partialDiscount - ((accumulator * partialDiscount) / 100);
	}, 0) || 0;

	const discountOrMarkup = effectiveDiscount < 0 ? (1 + (-1 * (effectiveDiscount / 100))) : effectiveDiscount / 100;
	return discountOrMarkup || 0;
};

const getEffectiveDiscounts = (namedRange) => {
	const costAdjustments = namedRange.adjustmentList.filter((adjustment) => adjustment.appliedTo === 'Cost' && adjustment.operationType !== 'delete');

	const priceAdjustments = namedRange.adjustmentList.filter((adjustment) => (!adjustment.appliedTo || adjustment.appliedTo === 'Price')
		&& adjustment.operationType !== 'delete');

	return {
		cost: calculateEffectiveDiscount(namedRange.relatedTotal.baseExtendedCost, costAdjustments),
		revenue: calculateEffectiveDiscount(namedRange.relatedTotal.baseExtendedAmount, priceAdjustments),
	};
};

const calculateNetAmount = (baseAmount, discountPercent) => {
	const isMarkup = discountPercent > 1;
	const discountAmount = discountPercent === 0 ? 0 : +baseAmount * discountPercent;
	let netAmount = 0;
	if (discountPercent === 0) {
		netAmount = +baseAmount;
	} else if (isMarkup) {
		netAmount = discountAmount;
	} else {
		netAmount = +baseAmount - discountAmount;
	}

	return netAmount;
};

const recalculateNetAmount = (namedRangeDto) => {
	const ctxNamedRange = namedRangeDto;
	const { cost: costDiscount, revenue: revenueDiscount } = getEffectiveDiscounts(ctxNamedRange);
	ctxNamedRange.relatedTotal.netExtendedCost = calculateNetAmount(ctxNamedRange.relatedTotal.baseExtendedCost, costDiscount);
	ctxNamedRange.relatedTotal.netExtendedAmount = calculateNetAmount(ctxNamedRange.relatedTotal.adjustedBaseAmount, revenueDiscount);
};

const recalculateTotals = (namedRangeDto) => {
	recalculateNetAmount(namedRangeDto);
	recalculateMargin(namedRangeDto);
};

const updateRelatedTotal = (namedRangeDto) => {
	recalculateMarginForRelatedTotal(namedRangeDto.relatedTotal);
};

const createQuoteRecord = (quoteTotal, quoteId) => {
	const quoteRecord = {};
	quoteRecord.Id = quoteId;
	quoteRecord[TOTAL_AMOUNT_BEFORE_DISCOUNT_FIELD.fieldApiName] = quoteTotal.relatedTotal.baseExtendedAmount;
	quoteRecord[MARGIN_PERCENT_FIELD.fieldApiName] = quoteTotal.relatedTotal.marginPercent;
	quoteRecord[TOTAL_AMOUNT_FIELD.fieldApiName] = quoteTotal.relatedTotal.netExtendedAmount;

	let effectiveDiscount = 0;
	if (quoteTotal.relatedTotal.baseExtendedAmount !== quoteTotal.relatedTotal.netExtendedAmount) {
		effectiveDiscount = (quoteTotal.relatedTotal.baseExtendedAmount / quoteTotal.relatedTotal.netExtendedAmount) * 100;
	}

	quoteRecord[DISCOUNT_AMOUNT_FIELD.fieldApiName] = effectiveDiscount;

	return quoteRecord;
};

const processAdjustmentRecords = (records) => {
	const adjustmentRecords = [];
	records.forEach((element) => {
		const adjustmentRecord = {};
		adjustmentRecord.Id = element.adjustmentId;
		adjustmentRecord[NAMED_RANGE_ID_FIELD.fieldApiName] = element.Id;

		if (element.discountType === Discount.DISCOUNT_PERCENT) {
			adjustmentRecord[AMOUNT_FIELD.fieldApiName] = element.discountPercent;
			adjustmentRecord[TYPE_FIELD.fieldApiName] = Discount.DISCOUNT_PERCENT;
		} else if (element.discountType === Discount.DISCOUNT_AMOUNT) {
			adjustmentRecord[AMOUNT_FIELD.fieldApiName] = element.discountAmount;
			adjustmentRecord[TYPE_FIELD.fieldApiName] = Discount.DISCOUNT_AMOUNT;
		}

		adjustmentRecord[METHOD_FIELD.fieldApiName] = Discount.INITIAL;
		adjustmentRecord[APPLIED_TO_FIELD.fieldApiName] = Discount.COST;
		adjustmentRecords.push(adjustmentRecord);
	});
	return adjustmentRecords;
};

const applyColaAdjustments = (laborRelatedTotals, adjustmentList) => {
	const ctxLaborRelatedTotals = laborRelatedTotals;

	const colaAdjustments = adjustmentList.filter((adjustment) => adjustment.method === 'Cola'
		&& adjustment.appliedTo === 'Cost'
		&& adjustment.operationType !== 'delete');

	const effectiveDiscount = calculateEffectiveDiscount(ctxLaborRelatedTotals.baseExtendedCost, colaAdjustments);
	ctxLaborRelatedTotals.netExtendedCost = calculateNetAmount(ctxLaborRelatedTotals.baseExtendedCost, effectiveDiscount);
	recalculateMargin(ctxLaborRelatedTotals);
	return ctxLaborRelatedTotals.netExtendedCost;
};

const applyPassthroughAdjustments = (laborRelatedTotals, adjustmentList) => {
	const ctxLaborRelatedTotals = laborRelatedTotals;

	const colaAdjustments = adjustmentList.filter((adjustment) => adjustment.method === 'Pass-through'
		&& adjustment.appliedTo === 'Price'
		&& adjustment.operationType !== 'delete');

	const effectiveAdjustment = calculateEffectiveDiscount(ctxLaborRelatedTotals.baseExtendedAmount, colaAdjustments);
	ctxLaborRelatedTotals.netExtendedAmount = calculateNetAmount(ctxLaborRelatedTotals.baseExtendedAmount, effectiveAdjustment);
	recalculateMargin(ctxLaborRelatedTotals);
	return ctxLaborRelatedTotals.netExtendedAmount;
};

export {
	processAdjustmentRecords, createQuoteRecord, updateFieldValues, newNamedRangeDto,
	recalculateTotals, updateRelatedTotal, applyColaAdjustments, applyPassthroughAdjustments,
};
