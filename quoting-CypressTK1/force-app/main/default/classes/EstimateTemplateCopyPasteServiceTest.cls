/**
 *  Provus Services Quoting
 *  EstimateTemplateClonerTest
 *  @2022 Provus Inc. All rights reserved.
 */
@IsTest
public with sharing class EstimateTemplateCopyPasteServiceTest {
	@testSetup
	private static void setup() {
		EstimateTemplate__c estimateTemplate = TestDataFactory.createEstimateTemplate(
			'Estimate Template 1',
			true,
			null
		);
		CRUDUtility.insertRecords(estimateTemplate);

		ActivityGroupTemplate__c activityGroupTemplate = TestDataFactory.createActivityGroupTemplate(
			'Activity Group 1',
			true,
			estimateTemplate.Id
		);
		activityGroupTemplate.Sequence__c = 1;
		CRUDUtility.insertRecords(activityGroupTemplate);

		ActivityTemplate__c activityTemplate = TestDataFactory.createActivityTemplate(
			'Activity 1',
			true,
			activityGroupTemplate.Id
		);
		activityTemplate.Sequence__c = 1;
		CRUDUtility.insertRecords(activityTemplate);

		TaskTemplate__c taskTemplate = TestDataFactory.createTaskTemplate(
			'Task 1',
			true,
			activityTemplate.Id
		);
		taskTemplate.Sequence__c = 1;
		CRUDUtility.insertRecords(taskTemplate);

		TaskParameterTemplate__c taskParamTemplate = TestDataFactory.createTaskParamTemplate(
			'Task Param 1',
			true,
			taskTemplate.Id
		);
		CRUDUtility.insertRecords(taskParamTemplate);

		TaskParameterValueTemplate__c taskParamValueTemplate = TestDataFactory.createTaskParamValueTemplate(
			taskParamTemplate.Id
		);
		CRUDUtility.insertRecords(taskParamValueTemplate);
	}

	@IsTest
	static void shouldCopyAndResequenceActivityGroup() {
		Test.startTest();
		Id estimateTemplateId = [SELECT Id FROM EstimateTemplate__c LIMIT 1].Id;
		Id activityGroupTemplateId = [SELECT Id FROM ActivityGroupTemplate__c LIMIT 1].Id;
		EstimateTemplateCopyPasteService.copyActivityGroupIntoEstimateTemplate(
			activityGroupTemplateId,
			estimateTemplateId,
			1
		);

		List<ActivityGroupTemplate__c> activityGroups = [
			SELECT Id, Name, Sequence__c
			FROM ActivityGroupTemplate__c
			WHERE EstimateTemplateId__c = :estimateTemplateId
		];
		System.assertEquals(
			2,
			activityGroups.size(),
			'estimate should have both original and copied activity groups'
		);

		ActivityGroupTemplate__c originalActivityGroup = activityGroups.get(0);
		ActivityGroupTemplate__c copiedActivityGroup = activityGroups.get(1);
		System.assertEquals(
			originalActivityGroup.Name,
			copiedActivityGroup.Name,
			'original and copied activity group names should match'
		);
		System.assertEquals(
			1,
			originalActivityGroup.Sequence__c,
			'original activity group sequence should stay the same'
		);
		System.assertEquals(
			2,
			copiedActivityGroup.Sequence__c,
			'copied activity group sequence should be 2'
		);

		List<ActivityTemplate__c> activityTemplates = [
			SELECT Id, Name, Sequence__c
			FROM ActivityTemplate__c
			WHERE ActivityGroupTemplateId__c = :activityGroupTemplateId
		];
		System.assertEquals(1, activityTemplates.size(), 'activity template should be copied over');
		List<TaskTemplate__c> taskTemplates = [
			SELECT Id, Name, Sequence__c
			FROM TaskTemplate__c
			WHERE ActivityTemplateId__c = :activityTemplates.get(0).Id
		];
		System.assertEquals(1, taskTemplates.size(), 'task template should be copied over');
		List<TaskParameterTemplate__c> taskParameterTemplates = [
			SELECT Id, Name
			FROM TaskParameterTemplate__c
			WHERE TaskTemplateId__c = :taskTemplates.get(0).Id
		];
		System.assertEquals(
			1,
			taskParameterTemplates.size(),
			'task parameter template should be copied over'
		);
		List<TaskParameterValueTemplate__c> taskParameterValueTemplates = [
			SELECT Id, Name
			FROM TaskParameterValueTemplate__c
			WHERE TaskParameterTemplateId__c = :taskParameterTemplates.get(0).Id
		];
		System.assertEquals(
			1,
			taskParameterValueTemplates.size(),
			'task parameter value template should be copied over'
		);

		Test.stopTest();
	}

	@IsTest
	static void shouldCopyAndResequenceActivity() {
		Test.startTest();
		Id activityGroupTemplateId = [SELECT Id FROM ActivityGroupTemplate__c LIMIT 1].Id;
		Id activityTemplateId = [SELECT Id FROM ActivityTemplate__c LIMIT 1].Id;
		EstimateTemplateCopyPasteService.copyActivityIntoActivityGroup(
			activityTemplateId,
			activityGroupTemplateId,
			1
		);

		List<ActivityTemplate__c> activityTemplates = [
			SELECT Id, Name, Sequence__c
			FROM ActivityTemplate__c
			WHERE ActivityGroupTemplateId__c = :activityGroupTemplateId
		];
		System.assertEquals(
			2,
			activityTemplates.size(),
			'activity group should have both original and copied activity templates'
		);

		ActivityTemplate__c originalActivityTemplate = activityTemplates.get(0);
		ActivityTemplate__c copiedActivityTemplate = activityTemplates.get(1);
		System.assertEquals(
			originalActivityTemplate.Name,
			copiedActivityTemplate.Name,
			'original and copied activity template names should match'
		);
		System.assertEquals(
			originalActivityTemplate.Sequence__c,
			1,
			'original activity template sequence should stay the same'
		);
		System.assertEquals(
			copiedActivityTemplate.Sequence__c,
			2,
			'copied activity template sequence should be 2'
		);

		List<TaskTemplate__c> taskTemplates = [
			SELECT Id, Name, Sequence__c
			FROM TaskTemplate__c
			WHERE ActivityTemplateId__c = :activityTemplateId
		];
		System.assertEquals(1, taskTemplates.size(), 'task template should be copied over');
		List<TaskParameterTemplate__c> taskParameterTemplates = [
			SELECT Id, Name
			FROM TaskParameterTemplate__c
			WHERE TaskTemplateId__c = :taskTemplates.get(0).Id
		];
		System.assertEquals(
			1,
			taskParameterTemplates.size(),
			'task parameter template should be copied over'
		);
		List<TaskParameterValueTemplate__c> taskParameterValueTemplates = [
			SELECT Id, Name
			FROM TaskParameterValueTemplate__c
			WHERE TaskParameterTemplateId__c = :taskParameterTemplates.get(0).Id
		];
		System.assertEquals(
			1,
			taskParameterValueTemplates.size(),
			'task parameter value template should be copied over'
		);

		Test.stopTest();
	}

	@IsTest
	static void shouldCopyAndResequenceTask() {
		Test.startTest();
		Id activityTemplateId = [SELECT Id FROM ActivityTemplate__c LIMIT 1].Id;
		Id taskTemplateId = [SELECT Id FROM TaskTemplate__c LIMIT 1].Id;
		EstimateTemplateCopyPasteService.copyTaskIntoActivity(taskTemplateId, activityTemplateId, 1);

		List<TaskTemplate__c> taskTemplates = [
			SELECT Id, Name, Sequence__c
			FROM TaskTemplate__c
			WHERE ActivityTemplateId__c = :activityTemplateId
		];
		System.assertEquals(
			2,
			taskTemplates.size(),
			'activity template should have both original and copied task templates'
		);

		TaskTemplate__c originalTaskTemplate = taskTemplates.get(0);
		TaskTemplate__c copiedTaskTemplate = taskTemplates.get(1);
		System.assertEquals(
			originalTaskTemplate.Name,
			copiedTaskTemplate.Name,
			'original and copied task template names should match'
		);
		System.assertEquals(
			originalTaskTemplate.Sequence__c,
			1,
			'original task template sequence should stay the same'
		);
		System.assertEquals(
			copiedTaskTemplate.Sequence__c,
			2,
			'copied task template sequence should be 2'
		);

		List<TaskParameterTemplate__c> taskParameterTemplates = [
			SELECT Id, Name
			FROM TaskParameterTemplate__c
			WHERE TaskTemplateId__c = :taskTemplateId
		];
		System.assertEquals(
			1,
			taskParameterTemplates.size(),
			'task parameter template should be copied over'
		);
		List<TaskParameterValueTemplate__c> taskParameterValueTemplates = [
			SELECT Id, Name
			FROM TaskParameterValueTemplate__c
			WHERE TaskParameterTemplateId__c = :taskParameterTemplates.get(0).Id
		];
		System.assertEquals(
			1,
			taskParameterValueTemplates.size(),
			'task parameter value template should be copied over'
		);

		Test.stopTest();
	}
}
