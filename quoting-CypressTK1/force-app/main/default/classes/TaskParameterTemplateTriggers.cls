/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class TaskParameterTemplateTriggers extends TriggerHandler {
	public static void processTriggers(
		Map<Id, TaskParameterTemplate__c> oldMap,
		List<TaskParameterTemplate__c> newParams,
		Boolean isBefore
	) {
		final TaskParameterTemplateTriggers myTrigger = new TaskParameterTemplateTriggers(
			oldMap,
			newParams,
			isBefore
		);
		if (!RuntimeContext.skipCopyScopeParamValuesToTask) {
			myTrigger.copyScopeParamValuesToTask();
		}
	}

	public TaskParameterTemplateTriggers(
		Map<Id, TaskParameterTemplate__c> oldMap,
		List<TaskParameterTemplate__c> newParams,
		Boolean isBefore
	) {
		super(oldMap, newParams, isBefore);
	}

	public void copyScopeParamValuesToTask() {
		List<TaskParameterTemplate__c> scopeChangedTemplates = new List<TaskParameterTemplate__c>();
		List<Id> scopeChangedTemplateIds = new List<Id>();
		List<Id> scopeParamTemplateIds = new List<Id>();
		for (Id paramTemplateId : this.newMap.keySet()) {
			TaskParameterTemplate__c newTemplate = (TaskParameterTemplate__c) newMap.get(paramTemplateId);
			if (
				isChanged(paramTemplateId, Schema.TaskParameterTemplate__c.ScopeParameterTemplateId__c + '')
			) {
				if (newTemplate.ScopeParameterTemplateId__c != null) {
					scopeParamTemplateIds.add(newTemplate.ScopeParameterTemplateId__c);
				}
				scopeChangedTemplateIds.add(newTemplate.Id);
				scopeChangedTemplates.add(newTemplate);
			}
		}

		delete [
			SELECT Id
			FROM TaskParameterValueTemplate__c
			WHERE TaskParameterTemplateId__c IN :scopeChangedTemplateIds
			WITH SECURITY_ENFORCED
		];

		EstimateTreeTaskSupport.copyScopeParameterValueTemplates(
			scopeChangedTemplates,
			scopeChangedTemplateIds,
			scopeParamTemplateIds
		);
	}
}
