/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

@SuppressWarnings(
	'PMD.FieldNamingConventions'
) // TODO: remove this when we correct the property names
public with sharing class TemplateElementDto {
	@AuraEnabled
	public Id id;
	@AuraEnabled
	public String Type;
	@AuraEnabled
	public String ActivityGroup;
	@AuraEnabled
	public String ActivityGroupName;
	@AuraEnabled
	public String ActivityGroupId;
	@AuraEnabled
	public String ActionIcon;
	@AuraEnabled
	public String IconType;
	@AuraEnabled
	public String Actionlabel;
	@AuraEnabled
	public List<TemplateElementDto> children;
	@AuraEnabled
	public String ResourceName;
	@AuraEnabled
	public String ParentLabel;
	@AuraEnabled
	public List<String> gridExpandedIds;
	@AuraEnabled
	public String scopeParamCss;

	public TemplateElementDto(ActivityGroupTemplate__c activityGroupTemplate) {
		this.id = activityGroupTemplate.Id;
		this.ActivityGroup = activityGroupTemplate.Path__c + ' ' + activityGroupTemplate.Name;

		this.ActivityGroupName = activityGroupTemplate.Name;
		this.ActivityGroupId = activityGroupTemplate.Id;
		this.Type = 'ActivityGroupTemplate';
		this.ActionIcon = 'standard:work_type';
		this.IconType = 'standard:work_type_group';
		this.Actionlabel = System.Label.AddEditActivities;
	}

	public TemplateElementDto(TaskTemplate__c taskTemplate) {
		this.id = taskTemplate.Id;
		this.ActivityGroup = taskTemplate.Path__c + ' ' + taskTemplate.Name;
		this.ActivityGroupName = taskTemplate.Name;
		this.ActivityGroupId = taskTemplate.Id;
		this.ResourceName = taskTemplate.ResourceRoleId__r.Name;
		this.Type = 'TaskTemplate';
		this.ActionIcon = 'action:edit';
		this.IconType = 'standard:task';
		this.Actionlabel = System.Label.AddEditTaskParameters;
		this.scopeParamCss = 'slds-hide';
	}

	public TemplateElementDto(ActivityTemplate__c activityTemplate) {
		this.id = activityTemplate.Id;
		this.ActivityGroup = activityTemplate.Path__c + ' ' + activityTemplate.Name;
		this.ActivityGroupName = activityTemplate.Name;
		this.ActivityGroupId = activityTemplate.Id;
		this.Type = 'ActivityTemplate';
		this.ActionIcon = 'standard:task';
		this.IconType = 'standard:work_type';
		this.Actionlabel = System.Label.AddEditTasks;
	}

	public TemplateElementDto(PhaseTemplate__c phaseTemplate) {
		this.id = phaseTemplate.Id;
		this.ActivityGroup = phaseTemplate.Sequence__c + ' ' + phaseTemplate.Name;
		this.ActivityGroupName = phaseTemplate.Name;
		this.ActivityGroupId = phaseTemplate.Id;
		this.Type = 'PhaseTemplate';
		this.ActionIcon = 'standard:work_type';
		this.IconType = 'standard:event';
		this.Actionlabel = System.Label.AddEditActivityGroups;
	}
}
