/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class EstimateTemplateResourcesController {
	@AuraEnabled
	public static List<Map<String, String>> getTableColumns(Id templateId) {
		EstimateTemplate__c templateSo = [
			SELECT RateCardId__c
			FROM EstimateTemplate__c
			WHERE Id = :templateId
			WITH SECURITY_ENFORCED
		];

		return ResourceDefaultsSupport.getTableColumns(templateSo.RateCardId__c);
	}

	@AuraEnabled
	public static List<ResourceDefault__c> getResourceDefaults(Id templateId, List<String> fields) {
		Map<Id, ResourceDefault__c> defaultsByRoleId = new Map<Id, ResourceDefault__c>();
		for (TaskTemplate__c task : TaskTemplateService.getTasksForEstimateTemplate(templateId)) {
			defaultsByRoleId.put(
				task.ResourceRoleId__c,
				new ResourceDefault__c(
					EstimateTemplateId__c = templateId,
					ProductId__c = task.ResourceRoleId__c,
					ProductId__r = task.ResourceRoleId__r
				)
			);
		}

		List<String> requestedFields = new List<String>{
			SObjectUtility.FIELD_ID,
			Schema.ResourceDefault__c.ProductId__c + '',
			(Schema.ResourceDefault__c.ProductId__c + '').replace('__c', '__r') +
			'.' +
			SObjectUtility.FIELD_NAME
		};
		requestedFields.addAll(fields);

		QueryRequest queryRequest = new QueryRequest(Schema.ResourceDefault__c.SObjectType);
		queryRequest.requestedFields = new Set<String>(requestedFields);
		queryRequest.setFilterBy(
			new Map<String, String>{ Schema.ResourceDefault__c.EstimateTemplateId__c + '' => templateId }
		);

		for (
			ResourceDefault__c resourceDefault : (List<ResourceDefault__c>) SOQLUtility.querySObject(
				queryRequest
			)
		) {
			defaultsByRoleId.put(resourceDefault.ProductId__c, resourceDefault);
		}

		return (List<ResourceDefault__c>) CRUDUtility.upsertRecords(defaultsByRoleId.values());
	}

	@AuraEnabled
	public static Map<String, Object> getDependencyTree(Id templateId, List<String> fields) {
		EstimateTemplate__c templateSo = [
			SELECT Id, RateCardId__c
			FROM EstimateTemplate__c
			WHERE Id = :templateId
			WITH SECURITY_ENFORCED
		];

		return ResourceDefaultsSupport.buildDependencies(
			templateSo.RateCardId__c,
			getResourceIds(templateId),
			fields
		);
	}

	private static Set<Id> getResourceIds(Id templateId) {
		Set<Id> resourceIds = new Set<Id>();

		for (TaskTemplate__c roleSummary : [
			SELECT Id, ResourceRoleId__c
			FROM TaskTemplate__c
			WHERE ActivityTemplateId__r.ActivityGroupTemplateId__r.EstimateTemplateId__c = :templateId
			WITH SECURITY_ENFORCED
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		]) {
			resourceIds.add(roleSummary.ResourceRoleId__c);
		}

		return resourceIds;
	}

	@AuraEnabled
	public static void saveResourceDefaults(List<ResourceDefaultDto> resourceDefaults) {
		List<ResourceDefault__c> updateDefaults = new List<ResourceDefault__c>();
		for (ResourceDefaultDto defaultDto : resourceDefaults) {
			updateDefaults.add(defaultDto.updateSo());
		}

		CRUDUtility.updateRecords(updateDefaults);
	}
}
