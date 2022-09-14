/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
@IsTest
private class EstimateTreeSummarySupportTest extends TestBase {
	static Task__c createNewTask() {
		TaskSummary__c taskSummarySO = newTaskSummary();
		ActivityGroupTemplate__c activityGroupTemplateSO = newActivityGroupTemplate();
		ActivityTemplate__c activityTemplateSO = newActivityTemplate(activityGroupTemplateSO.Id);
		TaskTemplate__c taskTemplateSO = newTaskTemplate(activityTemplateSO.Id);
		TaskRoleSummary__c taskRoleSummarySO = newTaskRoleSummary(taskSummarySO.Id);
		Task__c taskSO = newTask(taskTemplateSO.Id, taskRoleSummarySO.Id);
		return taskSO;
	}

	@IsTest
	static void shouldCreateLineageFromActivity() {
		TaskSummary__c summarySO = newTaskSummary();
		Estimate__c estimateSO = new Estimate__c(SummaryId__c = summarySO.Id);
		CRUDUtility.insertRecords(estimateSO);
		ActivityGroup__c groupSO = new ActivityGroup__c(
			EstimateId__c = estimateSO.Id,
			SummaryId__c = summarySO.Id
		);
		CRUDUtility.insertRecords(groupSO);
		Activity__c activitySO = new Activity__c(
			EstimateId__c = estimateSO.Id,
			ActivityGroupId__c = groupSO.Id,
			SummaryId__c = summarySO.Id
		);
		CRUDUtility.insertRecords(activitySO);

		Id productTypeId = SObjectUtility.getRecordTypeIdbyName(
			Schema.SObjectType.Product__c.getName(),
			'Product'
		);
		Product__c productSO = newProduct('Test Product', productTypeId);

		Test.startTest();
		EstimateTreeSummarySupport.createRoleSummaryLineageForActivity(activitySO.Id, productSO.Id, 8);
		TaskRoleSummary__c activitySummarySO = [
			SELECT LevelAdjustment__c
			FROM TaskRoleSummary__c
			WHERE SummaryLevel__c = 'Activity'
		];
		System.assertEquals(
			3,
			EstimateTreeSummarySupport.getRoleSummaryLineageForActivity(activitySO.Id, productSO.Id)
				.size(),
			'should have 3 task role summaries (estimate, group, activity)'
		);
		System.assert(activitySummarySO.LevelAdjustment__c == 8, 'should persist the level adjustment');
		Test.stopTest();
	}

	@IsTest
	static void shouldCreateLineageFromActivityGroup() {
		TaskSummary__c summarySO = newTaskSummary();
		Estimate__c estimateSO = new Estimate__c(SummaryId__c = summarySO.Id);
		CRUDUtility.insertRecords(estimateSO);
		ActivityGroup__c groupSO = new ActivityGroup__c(
			EstimateId__c = estimateSO.Id,
			SummaryId__c = summarySO.Id
		);
		CRUDUtility.insertRecords(groupSO);

		Id productTypeId = SObjectUtility.getRecordTypeIdbyName(
			Schema.SObjectType.Product__c.getName(),
			'Product'
		);
		Product__c productSO = newProduct('Test Product', productTypeId);

		Test.startTest();
		EstimateTreeSummarySupport.createRoleSummaryLineageForActivityGroup(
			groupSO.Id,
			productSO.Id,
			8
		);
		TaskRoleSummary__c groupSummarySO = [
			SELECT LevelAdjustment__c
			FROM TaskRoleSummary__c
			WHERE SummaryLevel__c = 'Activity Group'
		];
		System.assertEquals(
			2,
			EstimateTreeSummarySupport.getRoleSummaryLineageForActivityGroup(groupSO.Id, productSO.Id)
				.size(),
			'should have 2 task role summaries (estimate, group)'
		);
		System.assert(groupSummarySO.LevelAdjustment__c == 8, 'should persist the level adjustment');
		Test.stopTest();
	}

	@IsTest
	static void shouldRetrieveEstimatedDurationFormula() {
		Task__c taskSO = createNewTask();
		TaskParameterTemplate__c parameterTemplateSO = newTaskParameterTemplate(taskSO.TemplateId__c);
		TaskParameterValueTemplate__c parameterValueTemplateSO = newTaskParameterValueTemplate(
			parameterTemplateSO.Id
		);
		parameterValueTemplateSO.EstimatedDurationFormula__c = '=1+2+3';
		CRUDUtility.updateRecords(parameterValueTemplateSO);
		List<Task__c> taskSOs = new List<Task__c>{ taskSO };
		{
			Test.startTest();
			Map<Id, Map<Id, EstimateTreeSupport.FormulaDto>> durationFormulaByTaskId = EstimateTreeSupport.getDurationFormulaByTaskId(
				taskSOs
			);

			System.assertEquals(
				'=1+2+3',
				durationFormulaByTaskId.get(taskSO.Id)
					.get(parameterValueTemplateSO.TaskParameterTemplateId__c)
					.formula
			);
			Test.stopTest();
		}
	}
}
