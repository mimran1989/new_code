/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class QuotePeriod {
	@AuraEnabled
	public Id id;
	@AuraEnabled
	public String name;
	@AuraEnabled
	public Date startDate;
	@AuraEnabled
	public Date endDate;
	@AuraEnabled
	public Decimal sequence;
	@AuraEnabled
	public Decimal term;
	@AuraEnabled
	public String periodGroupName;
	@AuraEnabled
	public Id periodGroupId;

	@AuraEnabled
	public Id projectPhaseId;
	@AuraEnabled
	public String projectPhaseName;

	public QuotePeriod() {
	}
}
