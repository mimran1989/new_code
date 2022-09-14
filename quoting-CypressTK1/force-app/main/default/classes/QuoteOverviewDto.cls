/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class QuoteOverviewDto {
	@AuraEnabled
	public Id id;
	@AuraEnabled
	public String name;
	@AuraEnabled
	public String createdBy;
	@AuraEnabled
	public Date createdDate;
	@AuraEnabled
	public Decimal revenue;
	@AuraEnabled
	public Integer duration;
	@AuraEnabled
	public String durationUnit;
	@AuraEnabled
	public Decimal discount;
	@AuraEnabled
	public Decimal margin;
	@AuraEnabled
	public Decimal cost;
	@AuraEnabled
	public Map<String, Decimal> headcountByLocation;
	@AuraEnabled
	public String approvalSubmissionComments;

	public QuoteOverviewDto() {
	}

	public QuoteOverviewDto(Quote__c quoteSo) {
		this.id = quoteSo.Id;
		this.name = quoteSo.Name;
		this.createdBy = quoteSo.CreatedBy.Name;
		this.createdDate = quoteSo.CreatedDate.date();
		this.revenue = SystemUtility.nullToZero(quoteSo.TotalAmount__c);
		this.duration = quoteSo.QuotePeriods__r.size();
		this.durationUnit = quoteSo.TimePeriod__c;
		this.discount = SystemUtility.nullToZero(quoteSo.DiscountAmount__c);
		this.margin = SystemUtility.nullToZero(quoteSo.MarginPercent__c);
		this.cost = SystemUtility.nullToZero(quoteSo.TotalCost__c);
		this.headcountByLocation = new Map<String, Decimal>();
	}
}
