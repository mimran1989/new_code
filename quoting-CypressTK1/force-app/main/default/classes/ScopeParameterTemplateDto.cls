/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class ScopeParameterTemplateDto extends ScopeParameterBaseDto {
	public ScopeParameterTemplate__c templateSo;
	@AuraEnabled
	public Id estimateTemplateId { get; set; }
	@AuraEnabled
	public Id activityGroupTemplateId { get; set; }
	@AuraEnabled
	public Id activityTemplateId { get; set; }
	@AuraEnabled
	public List<ScopeParameterValueTemplateDto> paramValues { get; set; }
	@AuraEnabled
	public String allowedValues { get; set; }

	public ScopeParameterTemplateDto() {
		super();
	}

	public ScopeParameterTemplateDto(ScopeParameterTemplate__c scopeParameterSo) {
		super(scopeParameterSo);
		stripUnqueried();
		scopeParameterSo = (ScopeParameterTemplate__c) this.sObj;

		this.id = scopeParameterSo.Id;
		this.sequence = scopeParameterSo.Sequence__c;
		this.name = scopeParameterSo.Name;
		this.guidance = scopeParameterSo.Guidance__c;
		this.dataType = scopeParameterSo.DataType__c;
		this.developerName = scopeParameterSo.DeveloperName__c; // the hash tag name
		this.estimateTemplateId = scopeParameterSo.EstimateTemplateId__c;
		this.activityGroupTemplateId = scopeParameterSo.ActivityGroupTemplateId__c;
		this.activityTemplateId = scopeParameterSo.ActivityTemplateId__c;
		this.allowedValues = scopeParameterSo.AllowedValues__c;

		List<ScopeParameterValueTemplateDto> paramValues = new List<ScopeParameterValueTemplateDto>();
		if (scopeParameterSo.ScopeParameterValueTemplates__r != null) {
			for (
				ScopeParameterValueTemplate__c valueTemplateSo : scopeParameterSo.ScopeParameterValueTemplates__r
			) {
				paramValues.add(new ScopeParameterValueTemplateDto(valueTemplateSo));
			}
		}
		this.paramValues = paramValues;
	}

	public override SObject refreshSo() {
		if (this.templateSo == null) {
			this.templateSo = new ScopeParameterTemplate__c(Id = this.id);
		}

		this.templateSo.Sequence__c = this.sequence;
		this.templateSo.Name = this.name;
		this.templateSo.Guidance__c = this.guidance;
		this.templateSo.DataType__c = this.dataType;
		this.templateSo.DeveloperName__c = this.developerName;
		this.templateSo.EstimateTemplateId__c = this.estimateTemplateId;
		this.templateSo.ActivityGroupTemplateId__c = this.activityGroupTemplateId;
		this.templateSo.ActivityTemplateId__c = this.activityTemplateId;
		this.templateSo.AllowedValues__c = this.allowedValues;
		return this.templateSo;
	}
}
