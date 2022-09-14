/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class EstimateDto extends BaseDTO {
	@AuraEnabled
	public Id rateCardId;

	public EstimateDto(Estimate__c estimateSo) {
		super(estimateSo);
		this.rateCardId = estimateSo.RateCardId__c;
	}

	public override SObject refreshSo() {
		return null;
	}
}
