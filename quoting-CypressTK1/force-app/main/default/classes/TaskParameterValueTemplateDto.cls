/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class TaskParameterValueTemplateDto extends BaseDTO {
	@AuraEnabled
	public String estimatedDurationFormula;
	@AuraEnabled
	public Decimal fromValue;
	@AuraEnabled
	public Decimal toValue;
	@AuraEnabled
	public String label;
	@AuraEnabled
	public Decimal perUnitDuration;
	@AuraEnabled
	public Decimal estimatedDuration;

	public TaskParameterValueTemplateDto() {
	}

	public TaskParameterValueTemplateDto(TaskParameterValueTemplate__c paramValueTemplateSo) {
		super(paramValueTemplateSo);
		this.estimatedDurationFormula = paramValueTemplateSo.EstimatedDurationFormula__c;
		this.toValue = paramValueTemplateSo.ToValue__c;
		this.fromValue = paramValueTemplateSo.FromValue__c;
		this.label = paramValueTemplateSo.Label__c;
		this.perUnitDuration = paramValueTemplateSo.PerUnitDuration__c;
		this.estimatedDuration = paramValueTemplateSo.EstimatedDuration__c;
	}

	public override SObject refreshSo() {
		return null;
	}
}
