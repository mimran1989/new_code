/**
 *  Provus Services Quoting
 *  VolumeDiscountTier
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing virtual class VolumeDiscountTierDto extends BaseDTO {
	public VolumeDiscountTierDto() {
	}

	public VolumeDiscountTierDto(VolumeDiscountTier__c volumeDiscountSO) {
		this.volumeDiscountId = volumeDiscountSO.VolumeDiscountId__c;
		this.fromValue = volumeDiscountSO.From__c;
		this.toValue = volumeDiscountSO.To__c;
		this.discount = volumeDiscountSO.Discount__c;
		this.sequence = volumeDiscountSO.Sequence__c;
		this.id = volumeDiscountSO.Id;
	}

	@AuraEnabled
	public Id volumeDiscountId { get; set; }

	@AuraEnabled
	public Decimal fromValue { get; set; }

	@AuraEnabled
	public Decimal toValue { get; set; }

	@AuraEnabled
	public Decimal discount { get; set; }

	@AuraEnabled
	public Decimal sequence { get; set; }

	public override SObject refreshSo() {
		VolumeDiscountTier__c volumeDiscountTierSO = new VolumeDiscountTier__c(
			VolumeDiscountId__c = this.volumeDiscountId,
			Id = this.id,
			From__c = this.fromValue,
			To__c = this.toValue,
			Discount__c = this.discount,
			Sequence__c = this.sequence
		);

		return volumeDiscountTierSO;
	}
}
