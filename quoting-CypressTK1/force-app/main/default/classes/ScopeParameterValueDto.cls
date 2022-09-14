/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class ScopeParameterValueDto {
	@AuraEnabled
	public Id id { get; set; }

	@AuraEnabled
	public Decimal integerValue { get; set; }

	@AuraEnabled
	public Boolean booleanValue { get; set; }

	@AuraEnabled
	public String textValue { get; set; }

	public ScopeParameterValueDto() {
	}

	public ScopeParameterValueDto(ScopeParameter__c paramSo) {
		this.id = paramSo.Id;
		this.integerValue = paramSo.IntegerValue__c;
		this.booleanValue = paramSo.BooleanValue__c;
		this.textValue = paramSo.TextValue__c;
	}
}
