/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class TaskTemplateService {
	public static List<TaskTemplate__c> getTasksForEstimateTemplate(Id templateId) {
		return [
			SELECT Id, ResourceRoleId__c, ResourceRoleId__r.Name
			FROM TaskTemplate__c
			WHERE ActivityTemplateId__r.ActivityGroupTemplateId__r.EstimateTemplateId__c = :templateId
			WITH SECURITY_ENFORCED
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		];
	}
}
