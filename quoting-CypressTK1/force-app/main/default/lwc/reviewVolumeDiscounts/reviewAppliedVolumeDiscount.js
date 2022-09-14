/**
 *  Provus Services Quoting
 *  reviewAppliedVolumeDiscount
 *  @2022 Provus Inc. All rights reserved.
 */
export default class ReviewAppliedVolumeDiscount {
	basedOn;
	totalBy;
	minValue;
	maxValue;
	discount;
	revenue;
	discountAmount;
	constructor(reviewVolumeDiscountDto, appliedTierSummary) {
		this.totalBy = appliedTierSummary.periodName;
		this.id = appliedTierSummary.id;
		this.minValue = appliedTierSummary.activeTier.fromValue;
		this.maxValue = appliedTierSummary.activeTier.toValue;
		this.discount = appliedTierSummary.activeTier.discount / 100;
		this.revenue = appliedTierSummary.revenue;
		this.discountAmount = appliedTierSummary.discountAmount;
	}
}
