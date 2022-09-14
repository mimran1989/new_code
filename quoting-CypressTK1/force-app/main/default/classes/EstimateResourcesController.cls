/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class EstimateResourcesController {
	@AuraEnabled
	public static List<Map<String, String>> getTableColumns(Id estimateId) {
		Estimate__c estimateSo = [
			SELECT RateCardId__c
			FROM Estimate__c
			WHERE Id = :estimateId
			WITH SECURITY_ENFORCED
		];

		return ResourceDefaultsSupport.getTableColumns(estimateSo.RateCardId__c);
	}

	@AuraEnabled
	public static List<TaskRoleSummary__c> getTaskRoleSummaryDefaults(
		Id estimateId,
		List<String> fields
	) {
		Map<String, String> orderBy = new Map<String, String>{
			Schema.TaskRoleSummary__c.ResourceRole__c + '' => SOQLConstants.SORT_ASC
		};
		List<String> requestedFields = new List<String>{
			SObjectUtility.FIELD_ID,
			Schema.TaskRoleSummary__c.TotalEstimatedDuration__c + '',
			Schema.TaskRoleSummary__c.ResourceRoleId__c + '',
			(Schema.TaskRoleSummary__c.ResourceRoleId__c + '').replace('__c', '__r') +
			'.' +
			SObjectUtility.FIELD_NAME
		};
		requestedFields.addAll(fields);

		QueryRequest queryRequest = new QueryRequest(Schema.TaskRoleSummary__c.SObjectType);
		queryRequest.requestedFields = new Set<String>(requestedFields);
		queryRequest.setFilterBy(
			new Map<String, String>{ Schema.TaskRoleSummary__c.EstimateId__c + '' => estimateId }
		);
		queryRequest.fieldBySortOrder = orderBy;

		List<TaskRoleSummary__c> summariesWithDuration = new List<TaskRoleSummary__c>();
		for (
			TaskRoleSummary__c summarySo : (List<TaskRoleSummary__c>) SOQLUtility.querySObject(
				queryRequest
			)
		) {
			if (summarySo.TotalEstimatedDuration__c > 0) {
				summariesWithDuration.add(summarySo);
			}
		}

		return summariesWithDuration;
	}

	@AuraEnabled
	public static Map<String, Object> getDependencyTree(Id estimateId, List<String> fields) {
		Estimate__c estimateSo = [
			SELECT Id, RateCardId__c
			FROM Estimate__c
			WHERE Id = :estimateId
			WITH SECURITY_ENFORCED
		];

		return ResourceDefaultsSupport.buildDependencies(
			estimateSo.RateCardId__c,
			getResourceIds(estimateId),
			fields
		);
	}

	@AuraEnabled
	public static void saveRoleSummaries(List<TaskRoleSummaryDto> roleSummaries) {
		List<TaskRoleSummary__c> updateSummaries = new List<TaskRoleSummary__c>();
		for (TaskRoleSummaryDto summaryDto : roleSummaries) {
			updateSummaries.add(
				new TaskRoleSummary__c(Id = summaryDto.id, RateCardItemId__c = summaryDto.rateCardItemId)
			);
		}

		CRUDUtility.updateRecords(updateSummaries);
	}

	private static Set<Id> getResourceIds(Id estimateId) {
		Set<Id> resourceIds = new Set<Id>();

		for (TaskRoleSummary__c roleSummary : [
			SELECT Id, ResourceRoleId__c
			FROM TaskRoleSummary__c
			WHERE EstimateId__c = :estimateId
			WITH SECURITY_ENFORCED
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		]) {
			resourceIds.add(roleSummary.ResourceRoleId__c);
		}

		return resourceIds;
	}
}
