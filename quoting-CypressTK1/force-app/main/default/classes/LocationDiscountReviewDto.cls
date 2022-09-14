/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class LocationDiscountReviewDto extends BaseDTO {
	@AuraEnabled
	public String rateMatch { get; set; }
	@AuraEnabled
	public String location { get; set; }
	@AuraEnabled
	public Decimal locationAmount { get; set; }
	@AuraEnabled
	public Decimal discountPercentage { get; set; }
	@AuraEnabled
	public Decimal discountAmount { get; set; }
	@AuraEnabled
	public Decimal newAmount { get; set; }
	@AuraEnabled
	public Id adjustmentId { get; set; }
	@AuraEnabled
	public Id locationDiscountId { get; set; }

	public LocationDiscountReviewDto() {
	}

	public LocationDiscountReviewDto(LocationDiscount__c locationDiscount) {
		super(locationDiscount);
		this.locationDiscountId = locationDiscount.Id;
		this.rateMatch = locationDiscount.RateMatch__c;
		this.location = locationDiscount.Country__c;
		if (locationDiscount.State__c != null) {
			this.location = this.location + '/' + locationDiscount.State__c;
		}
		if (locationDiscount.City__c != null) {
			this.location = this.location + '/' + locationDiscount.City__c;
		}

		this.locationAmount = 0;
		this.discountAmount = 0;
		this.newAmount = 0;

		if (!SystemUtility.nullOrEmpty(locationDiscount.LocationDiscountAdjustments__r)) {
			this.calculateAmounts(locationDiscount);
		}
	}

	private class AdjustmentAmounts {
		protected Decimal discountAmount;
		protected Decimal discountPercentage;
		protected Decimal newAmount;
	}

	private void calculateAmounts(LocationDiscount__c locationDiscount) {
		for (
			LocationDiscountAdjustment__c locationAdjustment : locationDiscount.LocationDiscountAdjustments__r
		) {
			this.adjustmentId = locationAdjustment.AdjustmentId__c;
			Decimal extendedAmount = locationAdjustment.AdjustmentId__r
				?.NamedRangeId__r
				?.NamedRangeTotalId__r
				?.BaseExtendedAmount__c;

			// need to check in case we have bad data still with orphaned adjustments
			// where the named range was deleted for some quote items
			this.locationAmount += SystemUtility.nullToZero(extendedAmount);
			if (
				locationDiscount.Type__c == Adjustment.TYPE_DISCOUNT_PERCENT ||
				locationDiscount.Type__c == null
			) {
				this.discountPercentage = SystemUtility.nullToZero(locationDiscount.Amount__c);
				AdjustmentAmounts amounts = calculateAmount(extendedAmount);

				this.discountAmount += amounts.discountAmount;
				this.newAmount += amounts.newAmount;
			}
			if (locationDiscount.Type__c == Adjustment.TYPE_DISCOUNT_AMOUNT) {
				Decimal discountAmount = SystemUtility.nullToZero(locationDiscount.Amount__c);
				this.discountAmount += discountAmount;
				AdjustmentAmounts amounts = calculatePercentage(extendedAmount);
				this.discountPercentage = amounts.discountPercentage;
				this.newAmount += amounts.newAmount;
			}
		}
	}

	private AdjustmentAmounts calculateAmount(Decimal extendedAmount) {
		AdjustmentAmounts amounts = new AdjustmentAmounts();
		Decimal discountAmount = 0;
		Decimal newAmount = 0;

		if (extendedAmount != null) {
			discountAmount = extendedAmount * this.discountPercentage / 100;
			newAmount = extendedAmount - discountAmount;
		}

		amounts.discountAmount = discountAmount;
		amounts.newAmount = newAmount;
		return amounts;
	}

	private AdjustmentAmounts calculatePercentage(Decimal extendedAmount) {
		AdjustmentAmounts amounts = new AdjustmentAmounts();
		Decimal discountPercentage = 0;
		Decimal newAmount = 0;

		if (extendedAmount != null) {
			discountPercentage = this.discountAmount / extendedAmount * 100;
			newAmount = extendedAmount - this.discountAmount;
		}

		amounts.discountPercentage = discountPercentage;
		amounts.newAmount = newAmount;
		return amounts;
	}

	public override SObject refreshSo() {
		return null;
	}
}
