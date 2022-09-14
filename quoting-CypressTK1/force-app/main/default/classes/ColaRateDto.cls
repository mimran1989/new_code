/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
@SuppressWarnings('PMD.ExcessivePublicCount')
public with sharing class ColaRateDto extends BaseDTO {
	public ColaRate__c rateSO;
	@AuraEnabled
	public String id { get; set; }
	@AuraEnabled
	public String rateSheetId { get; set; }
	@AuraEnabled
	public Integer serviceYear { get; set; }
	@AuraEnabled
	public String rateMatch { get; set; }
	@AuraEnabled
	public String country { get; set; }
	@AuraEnabled
	public String state { get; set; }
	@AuraEnabled
	public String city { get; set; }
	@AuraEnabled
	public Decimal yearOverYearRate { get; set; }
	@AuraEnabled
	public Decimal rateOverride { get; set; }
	@AuraEnabled
	public Decimal passthroughPercentage { get; set; }
	@AuraEnabled
	public Decimal passthroughOverride { get; set; }
	public ColaRateDto() {
	}

	public ColaRateDto(ColaRate__c rate) {
		this.id = rate.Id;
		this.serviceYear = rate.ServiceYear__c.intValue();
		this.rateMatch = rate.RateMatch__c;
		this.country = rate.Country__c;
		this.state = rate.State__c;
		this.city = rate.City__c;
		this.yearOverYearRate = rate.YearOverYearRate__c;
		this.rateOverride = rate.RateOverride__c;
		this.passthroughPercentage = rate.PassthroughPercentage__c;
		this.passthroughOverride = rate.PassthroughRateOverride__c;
	}

	public override SObject refreshSo() {
		if (rateSO == null) {
			this.rateSO = new ColaRate__c(Id = this.id, RateSheetId__c = this.rateSheetId);
		}

		this.rateSO.ServiceYear__c = this.serviceYear;
		this.rateSO.Country__c = this.country;
		this.rateSO.State__c = this.state;
		this.rateSO.City__c = this.city;
		this.rateSO.YearOverYearRate__c = this.yearOverYearRate;
		this.rateSO.RateOverride__c = this.rateOverride;
		this.rateSO.PassthroughPercentage__c = this.passthroughPercentage;
		this.rateSO.PassthroughRateOverride__c = this.passthroughOverride;

		return this.rateSO;
	}
}
