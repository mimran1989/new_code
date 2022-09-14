/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
@SuppressWarnings('PMD.ExcessivePublicCount')
public with sharing class ColaAdjustmentDto extends BaseDTO {
	public ColaAdjustment__c colaAdjustmentSO;
	@AuraEnabled
	public String colaRateId { get; set; }
	@AuraEnabled
	public Decimal rateOverride { get; set; }
	@AuraEnabled
	public Decimal costIncrease { get; set; }
	@AuraEnabled
	public Decimal costIncreaseWithOverride { get; set; }
	@AuraEnabled
	public Decimal currentCost { get; set; }
	@AuraEnabled
	public Decimal currentRevenue { get; set; }
	@AuraEnabled
	public Decimal newCost { get; set; }
	@AuraEnabled
	public Decimal newCostWithOverride { get; set; }
	@AuraEnabled
	public Decimal originalCost { get; set; }
	@AuraEnabled
	public Id quoteId { get; set; }

	public ColaAdjustmentDto() {
	}

	public ColaAdjustmentDto(ColaAdjustment__c colaAdjustmentSO) {
		this.colaRateId = colaAdjustmentSO.ColaRateId__c;
		this.costIncrease = colaAdjustmentSO.CostIncrease__c;
		this.costIncreaseWithOverride = colaAdjustmentSO.CostIncreaseWithOverride__c;
		this.currentCost = colaAdjustmentSO.CurrentCost__c;
		this.currentRevenue = colaAdjustmentSO.CurrentRevenue__c;
		this.newCost = colaAdjustmentSO.NewCost__c;
		this.newCostWithOverride = colaAdjustmentSO.NewCostWithOverride__c;
		this.originalCost = colaAdjustmentSO.OriginalCost__c;
		this.quoteId = colaAdjustmentSO.QuoteId__c;
	}

	public override SObject refreshSo() {
		if (this.colaAdjustmentSO == null) {
			this.colaAdjustmentSO = new ColaAdjustment__c();
			this.colaAdjustmentSO.ColaRateId__c = this.colaRateId;
			this.colaAdjustmentSO.ColaRateId__r = new ColaRate__c(
				Id = this.colaRateId,
				RateOverride__c = this.rateOverride
			);
			this.colaAdjustmentSO.CostIncrease__c = this.costIncrease;
			this.colaAdjustmentSO.CostIncreaseWithOverride__c = this.costIncreaseWithOverride;
			this.colaAdjustmentSO.CurrentCost__c = this.currentCost;
			this.colaAdjustmentSO.CurrentRevenue__c = this.currentRevenue;
			this.colaAdjustmentSO.NewCost__c = this.newCost;
			this.colaAdjustmentSO.NewCostWithOverride__c = this.newCostWithOverride;
			this.colaAdjustmentSO.OriginalCost__c = this.originalCost;
			this.colaAdjustmentSO.QuoteId__c = this.quoteId;
		}

		return colaAdjustmentSO;
	}
}
