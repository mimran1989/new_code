/**
 *  Provus Services Quoting
 *  AdjustmentDTO
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class AdjustmentDTO extends BaseDTO {
	@AuraEnabled
	public String type;
	@AuraEnabled
	public Decimal amount;
	@AuraEnabled
	public Decimal sequence;
	@AuraEnabled
	public Decimal originalAmount;
	@AuraEnabled
	public String method;
	@AuraEnabled
	public String appliedTo;
	@AuraEnabled
	public String appliedBy;
	@AuraEnabled
	public Id adjustmentId;
	@AuraEnabled
	public String category;
	@AuraEnabled
	public Id tierId;
	@AuraEnabled
	public Id locationDiscountId;

	public AdjustmentDTO() {
	}

	public AdjustmentDTO(Adjustment__c adjustmentSO) {
		this.type = adjustmentSO.Type__c;
		this.amount = adjustmentSO.Amount__c;
		this.sequence = adjustmentSO.Sequence__c;
		this.method = adjustmentSO.Method__c;
		this.appliedTo = adjustmentSO.AppliedTo__c;
		this.appliedBy = adjustmentSO.AppliedBy__c;
		this.adjustmentId = adjustmentSO.Id;

		if (adjustmentSO.AdjustmentVolumeDiscountTiers__r.size() > 0) {
			this.category = adjustmentSO.AdjustmentVolumeDiscountTiers__r[0]
				.VolumeDiscountTierId__r.VolumeDiscountId__r.Category__c;
		}

		if (adjustmentSO.LocationDiscountAdjustments__r.size() > 0) {
			this.locationDiscountId = adjustmentSO.LocationDiscountAdjustments__r[0]
				.LocationDiscountId__c;
		}
	}

	public override SObject refreshSo() {
		this.sObj = new Adjustment__c(
			Type__c = this.type,
			Amount__c = this.amount,
			Sequence__c = this.sequence,
			Method__c = this.method,
			AppliedTo__c = this.appliedTo,
			AppliedBy__c = this.appliedBy,
			Id = this.adjustmentId
		);

		return this.sObj;
	}
}
