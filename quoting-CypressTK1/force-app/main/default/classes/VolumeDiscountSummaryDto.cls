/**
 *  Provus Services Quoting
 *  VolumeDiscountSummary
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class VolumeDiscountSummaryDto {
	public VolumeDiscountSummaryDto() {
		this.appliedTierSummaries = new List<VolumeDiscountAppliedTierSummaryDto>();
	}

	public VolumeDiscountSummaryDto(
		VolumeDiscount__c volumeDiscountSO,
		Map<String, String> categoryPicklistOptions
	) {
		this.appliedTierSummaries = new List<VolumeDiscountAppliedTierSummaryDto>();
		this.categoryValue = volumeDiscountSO.Category__c;
		// get category label by value from category picklist options
		this.categoryLabel = categoryPicklistOptions.get(volumeDiscountSO.Category__c);
		this.totalBy = volumeDiscountSO.TotalBy__c;
	}

	@AuraEnabled
	public String basedOn { get; set; }

	@AuraEnabled
	public String categoryValue { get; set; }

	@AuraEnabled
	public String categoryLabel { get; set; }

	@AuraEnabled
	public String totalBy { get; set; }

	@AuraEnabled
	public List<VolumeDiscountAppliedTierSummaryDto> appliedTierSummaries { get; set; }
}
