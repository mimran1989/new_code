/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class ScopeParameterValueTemplateDto {
	public ScopeParameterValueTemplate__c templateSo;
	@AuraEnabled
	public Decimal sequence { get; set; }
	@AuraEnabled
	public Id id { get; set; }
	@AuraEnabled
	public Decimal fromValue { get; set; }
	@AuraEnabled
	public Decimal toValue { get; set; }
	@AuraEnabled
	public String label { get; set; }

	public ScopeParameterValueTemplateDto() {
	}

	public ScopeParameterValueTemplateDto(ScopeParameterValueTemplate__c valueTemplateSo) {
		this.sequence = valueTemplateSo.Sequence__c;
		this.id = valueTemplateSo.Id;
		this.fromValue = valueTemplateSo.FromValue__c;
		this.toValue = valueTemplateSo.ToValue__c;
		this.label = valueTemplateSo.Label__c;
	}

	public ScopeParameterValueTemplate__c refreshSo() {
		if (this.templateSo == null) {
			this.templateSo = new ScopeParameterValueTemplate__c(Id = this.id);
		}

		this.templateSo.Sequence__c = this.sequence;
		this.templateSo.FromValue__c = this.fromValue;
		this.templateSo.ToValue__c = this.toValue;
		this.templateSo.Label__c = this.label;

		return this.templateSo;
	}
}
