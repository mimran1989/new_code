/**
 *  Provus Services Quoting
 *  VolumeDiscountDTO
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class VolumeDiscountDto extends BaseDTO {
	public VolumeDiscountDto() {
		this.tiers = new List<VolumeDiscountTierDto>();
	}

	public VolumeDiscountDto(VolumeDiscount__c volumeDiscountSO) {
		this.id = volumeDiscountSO.Id;
		this.quoteId = volumeDiscountSO.QuoteId__c;
		this.category = volumeDiscountSO.Category__c;
		this.totalBy = volumeDiscountSO.TotalBy__c;
		this.tiers = new List<VolumeDiscountTierDto>();
	}

	@AuraEnabled
	public Id quoteId { get; set; }

	@AuraEnabled
	public String category { get; set; }

	@AuraEnabled
	public String totalBy { get; set; }

	@AuraEnabled
	public List<VolumeDiscountTierDto> tiers { get; set; }

	public override SObject refreshSo() {
		this.sObj = new VolumeDiscount__c(
			QuoteId__c = this.quoteId,
			Id = this.id,
			Category__c = this.category,
			TotalBy__c = this.totalBy
		);

		return this.sObj;
	}
}
