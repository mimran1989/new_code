/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class NamedRangeDTO {
	@AuraEnabled
	public Id id;
	@AuraEnabled
	public String name;
	@AuraEnabled
	public String category;
	@AuraEnabled
	public Decimal netExtendedAmount;
	@AuraEnabled
	public Decimal marginPercent;
	@AuraEnabled
	public Decimal netExtendedCost;
	@AuraEnabled
	public Decimal newAmount;
	@AuraEnabled
	public Decimal baseExtendedAmount;
	@AuraEnabled
	public Id adjustmentId;
	@AuraEnabled
	public List<AdjustmentDTO> adjustments;

	// discounting fields
	@AuraEnabled
	public String discountType;
	@AuraEnabled
	public Decimal newMargin;
	@AuraEnabled
	public Decimal discountPercent;
	@AuraEnabled
	public Decimal discountAmount;

	public NamedRangeDTO(NamedRange__c namedRangeSO) {
		this.id = namedRangeSO.Id;
		this.name = namedRangeSO.Name;
		this.category = namedRangeSO.Name;
		this.netExtendedAmount = SystemUtility.nullToZero(
			namedRangeSO.NamedRangeTotalId__r.NetExtendedAmount__c
		);
		this.marginPercent = SystemUtility.nullToZero(
			namedRangeSO.NamedRangeTotalId__r.MarginPercent__c
		);
		this.netExtendedCost = SystemUtility.nullToZero(
			namedRangeSO.NamedRangeTotalId__r.NetExtendedCost__c
		);
		this.discountPercent = 0;
		this.discountAmount = 0;
		this.newAmount = SystemUtility.nullToZero(
			namedRangeSO.NamedRangeTotalId__r.NetExtendedAmount__c
		);
		this.baseExtendedAmount = SystemUtility.nullToZero(
			namedRangeSO.NamedRangeTotalId__r.BaseExtendedAmount__c
		);
		this.newMargin = SystemUtility.nullToZero(namedRangeSO.NamedRangeTotalId__r.MarginPercent__c);

		if (namedRangeSO.Adjustments__r.size() > 0) {
			this.discountType = namedRangeSO.Adjustments__r[0].Type__c;
			if (namedRangeSO.Adjustments__r[0].Type__c == Adjustment.TYPE_DISCOUNT_AMOUNT) {
				this.discountAmount = namedRangeSO.Adjustments__r[0].Amount__c;
				this.discountPercent =
					(1 - ((this.baseExtendedAmount - this.discountAmount) / this.baseExtendedAmount)) * 100;
			} else if (namedRangeSO.Adjustments__r[0].Type__c == Adjustment.TYPE_DISCOUNT_PERCENT) {
				this.discountPercent = namedRangeSO.Adjustments__r[0].Amount__c;
				this.discountAmount = (this.discountPercent / 100) * this.baseExtendedAmount;
			}
		}
	}
}
