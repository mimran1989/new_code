/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
@IsTest
private class TaskParameterTemplateTriggersTest {
	@IsTest
	static void shouldCopyScopeParamValuesToTaskTemplate() {
		ScopeParameterTemplate__c scopeParam = new ScopeParameterTemplate__c();
		CRUDUtility.insertRecords(scopeParam);

		ScopeParameterValueTemplate__c scopeParamValue = new ScopeParameterValueTemplate__c(
			ScopeParameterTemplateId__c = scopeParam.Id
		);
		CRUDUtility.insertRecords(scopeParamValue);

		ActivityGroupTemplate__c activityGroup = new ActivityGroupTemplate__c();
		CRUDUtility.insertRecords(activityGroup);

		ActivityTemplate__c activity = new ActivityTemplate__c(
			ActivityGroupTemplateId__c = activityGroup.Id
		);
		CRUDUtility.insertRecords(activity);

		TaskTemplate__c task = new TaskTemplate__c(ActivityTemplateId__c = activity.Id);
		CRUDUtility.insertRecords(task);

		TaskParameterTemplate__c taskParam = new TaskParameterTemplate__c(
			TaskTemplateId__c = task.Id,
			ScopeParameterTemplateId__c = scopeParam.Id
		);
		Test.startTest();
		{
			CRUDUtility.insertRecords(taskParam);
			List<TaskParameterValueTemplate__c> taskParameterValueTemplates = [
				SELECT Id
				FROM TaskParameterValueTemplate__c
				WHERE TaskParameterTemplateId__c = :taskParam.Id
				WITH SECURITY_ENFORCED
				LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
			];
			System.assert(
				taskParameterValueTemplates.size() > 0,
				'should have task parameter values copied'
			);

			taskParam.ScopeParameterTemplateId__c = null;
			CRUDUtility.updateRecords(taskParam);

			taskParameterValueTemplates = [
				SELECT Id
				FROM TaskParameterValueTemplate__c
				WHERE TaskParameterTemplateId__c = :taskParam.Id
				WITH SECURITY_ENFORCED
				LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
			];
			System.assert(
				taskParameterValueTemplates.size() == 0,
				'should have task parameter values deleted'
			);
		}
		Test.stopTest();
	}
}
