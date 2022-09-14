/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class ScopeSummaryDto extends BaseDTO {
	@AuraEnabled
	public String activityName;
	@AuraEnabled
	public String activityGroupName;
	@AuraEnabled
	public String taskName;
	@AuraEnabled
	public String parameterName;
	@AuraEnabled
	public String isNotApplicable;
	@AuraEnabled
	public Decimal estimatedDuration;
	@AuraEnabled
	public String userInput;

	public ScopeSummaryDto(TaskParameterValue__c paramValueSo) {
		super(paramValueSo);

		if (paramValueSo.TemplateId__r.DataType__c == ScopeParameterService.DATATYPE_PICKLIST) {
			this.userInput = paramValueSo.TextValue__c;
		} else if (paramValueSo.TemplateId__r.DataType__c == ScopeParameterService.DATATYPE_BOOLEAN) {
			this.userInput = paramValueSo.BooleanValue__c ? Label.Yes : Label.No;
		} else if (
			paramValueSo.TemplateId__r.DataType__c == ScopeParameterService.DATATYPE_INTEGER ||
			paramValueSo.TemplateId__r.DataType__c == ScopeParameterService.DATATYPE_INTEGER_TIER
		) {
			this.userInput = '' + paramValueSo.IntegerValue__c;
		}

		this.activityGroupName = paramValueSo.TaskId__r.ActivityId__r.ActivityGroupId__r.Name;
		this.activityName = paramValueSo.TaskId__r.ActivityId__r.Name;
		this.taskName = paramValueSo.TaskId__r.Name;
		this.parameterName = paramValueSo.TemplateId__r.Name;
		this.isNotApplicable = paramValueSo.TaskId__r.IsNotApplicable__c ? Label.Yes : '';
		this.estimatedDuration = paramValueSo.TaskId__r.EstimatedDuration__c;
	}

	public override SObject refreshSo() {
		return null;
	}
}
