/**
 *  Provus Services Quoting
 *  reviewVolumeDiscounts
 *  @2022 Provus Inc. All rights reserved.
 */
import { LightningElement, api, track } from 'lwc';
import getVolumeDiscountSummary from '@salesforce/apex/VolumeDiscountController.getVolumeDiscountSummary';
import LABEL_BASED_ON from '@salesforce/label/c.BasedOn';
import LABEL_TOTAL_BY from '@salesforce/label/c.TotalBy';
import LABEL_DISCOUNT_PERCENT from '@salesforce/label/c.DiscountPercent';
import LABEL_QUALIFIED_AMOUNT from '@salesforce/label/c.QualifiedAmount';
import LABEL_EARNED_DISCOUNT from '@salesforce/label/c.EarnedDiscount';
import LABEL_TIER_MIN from '@salesforce/label/c.TierMin';
import LABEL_TIER_MAX from '@salesforce/label/c.TierMax';

import { ReviewVolumeDiscountFieldNames } from 'c/constantUtil';
import ReviewVolumeDiscountDataService from './reviewVolumeDiscountDataService';

export default class ReviewVolumeDiscounts extends LightningElement {
	@api quoteId;
	loaded = false;
	@track volumeDiscount = {
		headcountData: [],
		laborRevenueData: [],
	};
	labels = {
		BasedOn: LABEL_BASED_ON,
		TotalBy: LABEL_TOTAL_BY,
		TierMin: LABEL_TIER_MIN,
		TierMax: LABEL_TIER_MAX,
		DiscountPercent: LABEL_DISCOUNT_PERCENT,
		Revenue: LABEL_QUALIFIED_AMOUNT,
		DiscountAmount: LABEL_EARNED_DISCOUNT,
	}
	headcountColumns = [
		{
			label: this.labels.TotalBy,
			fieldName: ReviewVolumeDiscountFieldNames.TOTAL_BY,
			hideDefaultActions: true,
		},
		{
			label: this.labels.TierMin,
			fieldName: ReviewVolumeDiscountFieldNames.MIN_VALUE,
			type: 'number',
			hideDefaultActions: true,
			cellAttributes: { alignment: 'center' },
		},
		{
			label: this.labels.TierMax,
			fieldName: ReviewVolumeDiscountFieldNames.MAX_VALUE,
			type: 'number',
			hideDefaultActions: true,
			cellAttributes: { alignment: 'center' },
		},
		{
			label: this.labels.DiscountPercent,
			fieldName: ReviewVolumeDiscountFieldNames.DISCOUNT,
			type: 'percent',
			typeAttributes: { step: '0.00001', minimumFractionDigits: '2' },
			hideDefaultActions: true,
			cellAttributes: { alignment: 'center' },
		},
		{
			label: this.labels.Revenue,
			fieldName: ReviewVolumeDiscountFieldNames.REVENUE,
			type: 'currency',
			hideDefaultActions: true,
			cellAttributes: { alignment: 'center' },
		},
		{
			label: this.labels.DiscountAmount,
			fieldName: ReviewVolumeDiscountFieldNames.DISCOUNT_AMOUNT,
			type: 'currency',
			hideDefaultActions: true,
			cellAttributes: { alignment: 'center' },
		},
	];

	laborRevenueColumns = [
		{
			label: '',
			fieldName: ReviewVolumeDiscountFieldNames.TOTAL_BY,
			hideDefaultActions: true,
		},
		{
			label: this.labels.TierMin,
			fieldName: ReviewVolumeDiscountFieldNames.MIN_VALUE,
			type: 'currency',
			hideDefaultActions: true,
			cellAttributes: { alignment: 'center' },
		},
		{
			label: this.labels.TierMax,
			fieldName: ReviewVolumeDiscountFieldNames.MAX_VALUE,
			type: 'currency',
			hideDefaultActions: true,
			cellAttributes: { alignment: 'center' },
		},
		{
			label: this.labels.DiscountPercent,
			fieldName: ReviewVolumeDiscountFieldNames.DISCOUNT,
			type: 'percent',
			typeAttributes: { step: '0.00001', minimumFractionDigits: '2' },
			hideDefaultActions: true,
			cellAttributes: { alignment: 'center' },
		},
		{
			label: this.labels.Revenue,
			fieldName: ReviewVolumeDiscountFieldNames.REVENUE,
			type: 'currency',
			hideDefaultActions: true,
			cellAttributes: { alignment: 'center' },
		},
		{
			label: this.labels.DiscountAmount,
			fieldName: ReviewVolumeDiscountFieldNames.DISCOUNT_AMOUNT,
			type: 'currency',
			hideDefaultActions: true,
			cellAttributes: { alignment: 'center' },
		},
	];

	async renderedCallback() {
		if (!this.loaded) {
			this.loaded = true;

			const volumeDiscountReviewData = await getVolumeDiscountSummary({
				quoteId: this.quoteId,
			});

			this.volumeDiscount = ReviewVolumeDiscountDataService.mapDtosToViewModel(volumeDiscountReviewData);
			const revenueColumns = this.laborRevenueColumns;
			revenueColumns[1].label = this.volumeDiscount.laborRevenueTotalBy;
			this.laborRevenueColumns = [];
			revenueColumns.forEach((revenueColumn) => {
				this.laborRevenueColumns.push(revenueColumn);
			});
		}
	}
}
