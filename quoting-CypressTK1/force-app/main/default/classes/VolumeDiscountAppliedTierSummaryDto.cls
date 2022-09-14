/**
 *  Provus Services Quoting
 *  VolumeDiscountSummaryActiveTierDto
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class VolumeDiscountAppliedTierSummaryDto {
	public static final String TOTAL_BY_PERIOD = 'Period';
	public static final String TOTAL_BY_PERIOD_GROUP = 'Period Group';
	public static final String TOTAL_BY_QUOTE = 'Quote';

	public VolumeDiscountAppliedTierSummaryDto() {
	}

	public VolumeDiscountAppliedTierSummaryDto(AdjustmentVolumeDiscountTier__c tier) {
		Decimal adjustedBaseAmount = SystemUtility.nullToZero(
			tier.AdjustmentId__r?.NamedRangeId__r?.NamedRangeTotalId__r?.AdjustedBaseAmount__c
		);
		String totalBy = tier.VolumeDiscountTierId__r.VolumeDiscountId__r.TotalBy__c;

		this.activeTier = new VolumeDiscountTierDto(tier.VolumeDiscountTierId__r);
		this.id = tier.Id;

		if (totalBy == TOTAL_BY_PERIOD) {
			this.periodName = tier.AdjustmentId__r.NamedRangeId__r.QuotePeriodId__r.Name;
		} else if (totalBy == TOTAL_BY_PERIOD_GROUP) {
			this.periodName = tier.AdjustmentId__r.NamedRangeId__r.QuotePeriodGroupId__r.Name;
		} else {
			this.periodName = TOTAL_BY_QUOTE;
		}

		this.revenue = adjustedBaseAmount;
		this.discountAmount = this.revenue * (SystemUtility.nullToZero(this.activeTier.discount) / 100);
	}

	public VolumeDiscountAppliedTierSummaryDto(VolumeDiscountTierDto volumeDiscountTier) {
		this.activeTier = volumeDiscountTier;
	}

	@AuraEnabled
	public String id { get; set; }

	@AuraEnabled
	public VolumeDiscountTierDto activeTier { get; set; }

	@AuraEnabled
	public String periodName { get; set; }

	@AuraEnabled
	public Decimal revenue { get; set; } // Revenue = AdjustmentId__r.NamedRangeId__r.NamedRangeTotalId__r.BaseExtendedAmount__c

	@AuraEnabled
	public Decimal discountAmount { get; set; }
}
