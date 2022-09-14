import QuoteVolumeDiscount from '@salesforce/customPermission/QuoteVolumeDiscount';
import QuoteLocationDiscount from '@salesforce/customPermission/QuoteLocationDiscount';
import CURRENCY from '@salesforce/i18n/currency';
import LABEL_CATEGORY from '@salesforce/label/c.Category';
import LABEL_COST from '@salesforce/label/c.Cost';
import LABEL_CURRENT_AMOUNT from '@salesforce/label/c.CurrentAmount';
import LABEL_CURRENT_MARGIN from '@salesforce/label/c.CurrentMargin';
import LABEL_DISCOUNT_AT_QUOTE_LEVEL from '@salesforce/label/c.DiscountatQuoteLevel';
import LABEL_DISCOUNT_BY_CATEGORY from '@salesforce/label/c.DiscountbyCategory';
import MESSAGE_DISCOUNT_SUCCESS from '@salesforce/label/c.DiscountSuccessMessage';
import LABEL_NEW_AMOUNT from '@salesforce/label/c.NewAmount';
import LABEL_NEW_MARGIN from '@salesforce/label/c.NewMargin';
import LABEL_QUOTE_DISCOUNTS from '@salesforce/label/c.QuoteDiscounts';
import LABEL_QUOTE_CONTINGENCIES from '@salesforce/label/c.QuoteContingencies';
import LABEL_VOLUME_DISCOUNTS from '@salesforce/label/c.VolumeDiscounts';
import LABEL_LOCATION_DISCOUNTS from '@salesforce/label/c.LocationDiscounts';
import DiscountCustomModal from '@salesforce/resourceUrl/DiscountCustomModal';
import { Discount } from 'c/constantUtil';
import { reduceErrors } from 'c/sparkUtils';
import { discountPercentage, marginPercentage, Discounting } from 'c/util';
import { CloseActionScreenEvent } from 'lightning/actions';
import { loadStyle } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { api, LightningElement, track } from 'lwc';
import ProvusMessagingService from 'c/provusMessagingService';
import VolumeDiscountAdjustment from 'c/volumeDiscountAdjustment';
import LocationDiscountAdjustment from 'c/locationDiscountAdjustment';
import { roundAmount } from 'c/currencyUtil';

export default class QuoteDiscounting extends LightningElement {
	@api recordId;
	@api discountName;
	@api discountMethod;
	@api discountAppliedTo;
	@api isMarkup;

	_discountName = this.discountName;
	_discountMethod = this.discountMethod;
	_discountAppliedTo = this.discountAppliedTo;

	laborRecord;
	addonAmount;
	quoteTotal;

	@track laborAdjustment = {};
	@track addOnAdjustment = {};
	@track quoteAdjustment = {};
	@track categorySummary = {
		baseExtendedAmount: 0,
		netExtendedAmount: 0,
		netExtendedCost: 0,
		discountAmount: 0,
		marginPercent: 0,
		adjustedMargin: 0,
	};

	rendered;
	_messageService;
	provusMessagingService = new ProvusMessagingService(this);
	_volumeDiscountAdjustment = new VolumeDiscountAdjustment();
	_locationDiscountAdjustment = new LocationDiscountAdjustment();
	totalState;
	currency = CURRENCY;

	disableLaborDiscounts = false;
	disableAddonDiscounts = false;
	disableQuoteDiscounts = false;
	types = {
		DISCOUNT_PERCENT: Discount.DISCOUNT_PERCENT,
		DISCOUNT_AMOUNT: Discount.DISCOUNT_AMOUNT,
	}

	labels = {
		DISCOUNT_BY_CATEGORY: LABEL_DISCOUNT_BY_CATEGORY,
		DISCOUNT_AT_QUOTE_LEVEL: LABEL_DISCOUNT_AT_QUOTE_LEVEL,
		QUOTE_DISCOUNTS: LABEL_QUOTE_DISCOUNTS,
		QUOTE_CONTINGENCIES: LABEL_QUOTE_CONTINGENCIES,
		VOLUME_DISCOUNTS: LABEL_VOLUME_DISCOUNTS,
		LOCATION_DISCOUNTS: LABEL_LOCATION_DISCOUNTS,
	}

	get featQuoteVolumeDiscount() {
		return QuoteVolumeDiscount && !this.isContingencyMode;
	}
	get featureQuoteLocationDiscount() {
		return QuoteLocationDiscount && !this.isContingencyMode;
	}
	get isContingencyMode() {
		return this._discountName === 'Contingency';
	}
	get discountsTabLabel() {
		return this._discountName === 'Discount' ? this.labels.QUOTE_DISCOUNTS : this.labels.QUOTE_CONTINGENCIES;
	}

	notifyClose() {
		this._messageService.notifyClose();
		this.dispatchEvent(new CloseActionScreenEvent());
	}

	connectedCallback() {
		if (!this._discountName) {
			this._discountName = 'Discount';
		}

		if (!this._discountMethod) {
			this._discountMethod = 'Initial';
		}

		if (!this._discountAppliedTo) {
			this._discountAppliedTo = 'Price';
		}

		this.columnLabels = [
			LABEL_CATEGORY,
			LABEL_CURRENT_AMOUNT,
			LABEL_CURRENT_MARGIN,
			LABEL_COST,
			`${this._discountName} %`,
			`${this._discountName} Amount`,
			LABEL_NEW_AMOUNT,
			LABEL_NEW_MARGIN,
		];
		this.quoteColumnLabels = [
			LABEL_CATEGORY,
			LABEL_CURRENT_AMOUNT,
			`Current  ${this._discountName}`,
			LABEL_CURRENT_MARGIN,
			`${this._discountName} %`,
			`${this._discountName} Amount`,
			LABEL_NEW_AMOUNT,
			LABEL_NEW_MARGIN,
		];
	}

	get roundedLaborDiscountAmount() {
		return roundAmount(this.laborAdjustment?.discountAmount || 0);
	}

	get roundedAddOnDiscountAmount() {
		return roundAmount(this.addOnAdjustment?.discountAmount || 0);
	}

	async renderedCallback() {
		loadStyle(this, DiscountCustomModal);

		if (this.recordId && !this.rendered) {
			this.rendered = true;
			this._messageService = this.template.querySelector('c-message-service');
			this._messageService.publish({ key: 'deselect' });
			this.totalState = this.template.querySelector('c-quote-totals');
			const results = await this.totalState.getNamedRangesForQuote(this.recordId);

			const {
				laborRecord,
				addonAmount,
				quoteTotal,
				periods,
				periodGroups,
			} = Discounting.getNamedRangesByType(results);

			this.laborRecord = laborRecord;
			this.laborAdjustment = this.newAdjustmentDto(this.laborRecord);
			this.addonAmount = addonAmount;
			this.addOnAdjustment = this.newAdjustmentDto(this.addonAmount);
			this.quoteTotal = quoteTotal;
			this.quoteAdjustment = this.newAdjustmentDto(this.quoteTotal);
			this.periods = periods;
			this.periodGroups = periodGroups;

			this.recalculateCategorySummary();
			this.recalculateQuoteTotal();
			this.disableDiscountFields();
		}

		const style = document.createElement('style');
		style.innerText = `
			.slds-modal__content {
				overflow: visible !important;
			}
		`;
		this.template.querySelector('quote-volume-discount')?.appendChild(style);
	}

	getAdjustmentDiscountIdx(adjustments) {
		return adjustments?.findIndex((adjustment) => adjustment.method === this._discountMethod);
	}

	// eslint-disable-next-line class-methods-use-this
	getEffectiveDiscount(adjustmentList, ctxNamedRange) {
		const effectiveDiscount = adjustmentList?.reduce((accumulator, nextAdjustment) => {
			let partialDiscount;
			const isMarkup = nextAdjustment.type.indexOf('Markup') >= 0;
			if (nextAdjustment.appliedTo !== 'Price') {
				return accumulator;
			}

			if (nextAdjustment.type.indexOf('Percent') >= 0) {
				partialDiscount = +nextAdjustment.amount / 100;
			} else {
				const amountBeforeDiscount = +ctxNamedRange.relatedTotal.baseExtendedAmount * (accumulator || 1);
				partialDiscount = +nextAdjustment.amount / amountBeforeDiscount;
			}

			return accumulator === 0 ? ((isMarkup ? 1 : 0) + partialDiscount) : accumulator * ((isMarkup ? 1 : 0) + partialDiscount);
		}, 0);

		return effectiveDiscount || 0;
	}

	// eslint-disable-next-line max-lines-per-function
	newAdjustmentDto(namedRange) {
		const adjustmentIdx = this.getAdjustmentDiscountIdx(namedRange.adjustmentList);
		const adjustment = namedRange.adjustmentList[adjustmentIdx];
		let discountAmount = 0;
		let discountPercent = 0;
		let accumulatedDiscount;
		if (adjustmentIdx >= 0) {
			accumulatedDiscount = this.getEffectiveDiscount([...namedRange.adjustmentList].splice(0, adjustmentIdx || 0), namedRange);
		} else {
			// all current discounts are effective as this will be added as the last discount
			accumulatedDiscount = this.getEffectiveDiscount([...namedRange.adjustmentList], namedRange);
		}

		if (adjustment?.type.indexOf('Percent') >= 0) {
			const partialDiscount = +adjustment.amount / 100;
			discountPercent = +adjustment.amount;
			const effective = accumulatedDiscount >= 1 ? accumulatedDiscount : 1 - accumulatedDiscount;
			discountAmount = +namedRange.relatedTotal.baseExtendedAmount * effective * partialDiscount;
		} else if (adjustment) {
			discountAmount = +adjustment.amount;
			discountPercent = roundAmount(discountPercentage(
				(namedRange.relatedTotal.baseExtendedAmount * (accumulatedDiscount || 1)) - discountAmount,
				namedRange.relatedTotal.baseExtendedAmount,
			));
		}

		const effective = accumulatedDiscount >= 1 ? accumulatedDiscount : 1 - accumulatedDiscount;
		const currentAmount = namedRange.relatedTotal.baseExtendedAmount * (effective || 1);
		const currentMargin = marginPercentage(currentAmount, namedRange.relatedTotal.netExtendedCost);
		const newAmount = currentAmount - (this.isMarkup ? (-1 * discountAmount) : discountAmount);
		const newMargin = marginPercentage(newAmount, namedRange.relatedTotal.netExtendedCost);
		return {
			adjustedMargin: newMargin,
			discountAmount,
			discountPercent,
			adjustment,
			currentAmount,
			currentMargin,
			newAmount,
			netExtendedCost: namedRange.relatedTotal.netExtendedCost,
		};
	}

	handleDiscountChange(event) {
		let ctxNamedRange;
		let ctxAdjustment;
		const discountCategory = event.target.name.substring(0, event.target.name.indexOf('-'));
		let recalculateQuoteTotal = true;
		switch (discountCategory) {
			case 'labor':
				ctxNamedRange = this.laborRecord;
				ctxAdjustment = this.laborAdjustment;
				break;
			case 'addOn':
				ctxNamedRange = this.addonAmount;
				ctxAdjustment = this.addOnAdjustment;
				break;
			case 'quote':
				ctxNamedRange = this.quoteTotal;
				ctxAdjustment = this.quoteAdjustment;
				recalculateQuoteTotal = false;
				break;
			default:
				break;
		}

		const isPercentageDiscount = event.target.name.indexOf('percent') >= 0;
		this.recalculateDiscount(ctxNamedRange, ctxAdjustment, +event.target.value, isPercentageDiscount);

		// recalculate net amounts
		// ctxTotal.netExtendedAmount = +ctxAdjustment.newAmount;
		ctxAdjustment.adjustedMargin = marginPercentage(ctxAdjustment.newAmount, ctxAdjustment.netExtendedCost);

		if (recalculateQuoteTotal) {
			this.recalculateCategorySummary();
			this.recalculateQuoteTotal();
		}

		this.disableDiscountFields();
	}

	recalculateQuoteTotal() {
		const baseExtendedAmount = this.categorySummary.netExtendedAmount;
		this.quoteAdjustment.currentAmount = this.categorySummary.netExtendedAmount;
		this.quoteAdjustment.currentMargin = marginPercentage(baseExtendedAmount, this.quoteAdjustment.netExtendedCost);

		const quoteTotalAdjustment = this.quoteAdjustment.adjustment;
		if (quoteTotalAdjustment) {
			const isPercentageDiscount = quoteTotalAdjustment.type.indexOf('Percent') >= 0;
			this.recalculateDiscount(this.quoteTotal, this.quoteAdjustment, +quoteTotalAdjustment.amount, isPercentageDiscount);
		} else {
			this.quoteAdjustment.newAmount = baseExtendedAmount;
			this.quoteAdjustment.adjustedMargin = this.quoteAdjustment.currentMargin;
		}
	}

	recalculateCategorySummary() {
		this.categorySummary.baseExtendedAmount = +this.laborAdjustment.currentAmount + +this.addOnAdjustment.currentAmount;
		this.categorySummary.netExtendedAmount = +this.laborAdjustment.newAmount + +this.addOnAdjustment.newAmount;
		this.categorySummary.netExtendedCost = +this.laborAdjustment.netExtendedCost + +this.addOnAdjustment.netExtendedCost;
		this.categorySummary.discountAmount = +this.laborAdjustment.discountAmount + +this.addOnAdjustment.discountAmount;
		this.categorySummary.discountPercent = roundAmount(
			discountPercentage(this.categorySummary.netExtendedAmount, this.categorySummary.baseExtendedAmount),
		) * (this.isMarkup ? -1 : 1);

		this.categorySummary.marginPercent = marginPercentage(this.categorySummary.baseExtendedAmount, this.categorySummary.netExtendedCost);
		this.categorySummary.adjustedMargin = marginPercentage(this.categorySummary.netExtendedAmount, this.categorySummary.netExtendedCost);
	}

	recalculateDiscount(namedRange, adjustmentDto, newDiscount, isPercentageDiscount) {
		const ctxAdjustmentDto = adjustmentDto;
		const ctxNamedRange = namedRange;
		if (isPercentageDiscount) {
			ctxAdjustmentDto.discountPercent = roundAmount(+newDiscount || 0);
			ctxAdjustmentDto.discountAmount = +adjustmentDto.currentAmount * (ctxAdjustmentDto.discountPercent / 100);
		} else {
			ctxAdjustmentDto.discountAmount = +newDiscount || 0;
			ctxAdjustmentDto.discountPercent = roundAmount(discountPercentage(
				adjustmentDto.currentAmount - ctxAdjustmentDto.discountAmount,
				adjustmentDto.currentAmount,
			));
		}

		ctxAdjustmentDto.newAmount = ctxAdjustmentDto.currentAmount - (ctxAdjustmentDto.discountAmount * (this.isMarkup ? -1 : 1));
		ctxAdjustmentDto.newMargin = marginPercentage(ctxAdjustmentDto.newAmount, ctxAdjustmentDto.netExtendedCost);

		if (!ctxAdjustmentDto.adjustment) {
			ctxAdjustmentDto.adjustment = this.newAdjustment(ctxNamedRange.adjustmentList.length);
			ctxNamedRange.adjustmentList = [...namedRange.adjustmentList, ctxAdjustmentDto.adjustment];
		}

		// refresh the adjustment records
		ctxAdjustmentDto.adjustment.amount = +newDiscount || 0;
		ctxAdjustmentDto.adjustment.type = (this.isMarkup ? 'Markup ' : 'Discount ') + (isPercentageDiscount ? 'Percent' : 'Amount');
	}

	newAdjustment(currentIdx) {
		return Discounting.newAdjustment({
			discountAppliedTo: this._discountAppliedTo,
			discountMethod: this._discountMethod,
			currentIdx,
		});
	}

	disableDiscountFields() {
		if (this.laborRecord.netExtendedAmount === 0) {
			this.disableLaborDiscounts = true;
		}

		if (this.addonAmount.netExtendedAmount === 0) {
			this.disableAddonDiscounts = true;
		}

		if (this.quoteTotal.netExtendedAmount === 0) {
			this.disableQuoteDiscounts = true;
		}
	}

	@api
	async saveAction() {
		const savedVolumeDiscounts = await this.saveVolumeDiscounts();
		if (!savedVolumeDiscounts) {
			return false;
		}

		const savedLocationDiscounts = await this.saveLocationDiscounts();
		if (!savedLocationDiscounts) {
			return false;
		}

		await this.totalState.saveTotals(true);
		this.showSuccessToast('Success', MESSAGE_DISCOUNT_SUCCESS, 'success');
		return true;
	}

	@api
	async saveTotalsAndClose() {
		await this.totalState.saveTotals(true);
		this.showSuccessToast('Success', MESSAGE_DISCOUNT_SUCCESS, 'success');
		this.notifyClose();
	}

	async saveVolumeDiscounts() {
		try {
			const quoteVolumeDiscountComponent = this.template.querySelector('c-quote-volume-discount');
			if (quoteVolumeDiscountComponent) {
				const validationResults = quoteVolumeDiscountComponent.validate();
				// handle validation errors if any
				if (validationResults.length > 0) {
					this.provusMessagingService.handleValidationErrors(validationResults);
					return false;
				}

				const savedVolumeDiscountDtos = await quoteVolumeDiscountComponent.saveVolumeDiscountDtos();
				const laborAmountNamedRange = await this.totalState.laborTotal;
				const periodNamedRanges = await this.totalState.periodTotals;
				const periodGroupNamedRanges = await this.totalState.quotePeriodGroupTotals;

				const namedRanges = {
					laborAmount: laborAmountNamedRange,
					periods: periodNamedRanges,
					periodGroups: periodGroupNamedRanges,
				};

				await this._volumeDiscountAdjustment.updateVolumeDiscountAdjustment({
					volumeDiscounts: savedVolumeDiscountDtos,
					namedRanges,
				});
				return true; // kill the process here because this call will invoke a save
			}
		} catch (e) {
			this.notifyError(e);
			return false;
		}

		return true;
	}

	async saveLocationDiscounts() {
		try {
			const locationDiscount = this.template.querySelector('c-location-discount');
			if (locationDiscount) {
				const validationResults = locationDiscount.validate();
				// handle validation errors if any
				if (validationResults.length > 0) {
					this.provusMessagingService.handleValidationErrors(validationResults);
					return false;
				}

				const savedLocationDiscountDtos = await locationDiscount.saveLocationDiscounts();
				const laborAmountNamedRange = await this.totalState.laborTotal;
				const quoteItemsNamedRanges = await this.totalState.quoteItemTotals();

				const namedRanges = {
					laborAmount: laborAmountNamedRange,
					quoteItems: quoteItemsNamedRanges,
				};

				await this._locationDiscountAdjustment.updateLocationDiscountAdjustments({
					locationDiscounts: savedLocationDiscountDtos,
					namedRanges,
				});
				return true; // kill the process here because this call will invoke a save
			}
		} catch (e) {
			this.notifyError(e);
			return false;
		}

		return true;
	}

	notifyError(error) {
		this.showNotification('Error', error.message, 'error');
	}

	showNotification(title, message, variant) {
		const evt = new ShowToastEvent({
			title,
			message: reduceErrors(message).join(', '),
			variant,
		});

		this.dispatchEvent(evt);
	}

	showSuccessToast(title, message, variant) {
		const event = new ShowToastEvent({
			title,
			message,
			variant,
			mode: 'dismissable',
		});

		this.dispatchEvent(event);
	}
}
