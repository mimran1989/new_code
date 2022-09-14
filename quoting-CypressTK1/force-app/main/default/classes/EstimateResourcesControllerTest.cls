/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
@IsTest
private class EstimateResourcesControllerTest extends TestBase {
	@IsTest
	static void shouldReturnDependencyTree() {
		Id recordTypeId = Schema.SObjectType.Product__c.getRecordTypeInfosByName()
			.get('Resource Role')
			.getRecordTypeId();
		Product__c resource = TestDataFactory.createResource('Software Engineer', recordTypeId);
		CRUDUtility.insertRecords(resource);

		RateCard__c rateCard = TestBase.newRateCard();

		RateCardItem__c rateCardItem = TestBase.newRateCardItem(rateCard.Id, resource.Id);
		rateCardItem.IsActive__c = true;
		rateCardItem.SkillLevel__c = 'L1';
		CRUDUtility.updateRecords(rateCardItem);

		Estimate__c estimateSo = newEstimate();
		estimateSo.RateCardId__c = rateCard.Id;
		CRUDUtility.updateRecords(estimateSo);

		TaskRoleSummary__c roleSummary = TaskRoleSummaryTestBase.newTaskRoleSummary();
		roleSummary.EstimateId__c = estimateSo.Id;
		roleSummary.ResourceRoleId__c = resource.Id;
		CRUDUtility.updateRecords(roleSummary);

		Test.startTest();
		{
			Map<String, Object> dependencyTree = EstimateResourcesController.getDependencyTree(
				estimateSo.Id,
				new List<String>{ 'SkillLevel__c' }
			);
			Map<String, Object> innerTree = (Map<String, Object>) dependencyTree.get(resource.Id);
			String finalValue = (String) innerTree.get('L1');
			System.assertEquals(
				rateCardItem.Id,
				finalValue,
				'tree leaf should result in rate card item id'
			);
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldCreateTableColumns() {
		Estimate__c estimateSo = newEstimate();
		RateCard__c rateCard = newRateCard();
		estimateSo.RateCardId__c = rateCard.Id;
		CRUDUtility.updateRecords(estimateSo);

		RateCardAttributeGroup__c attrGroup = newRateCardAttributeGroup();
		rateCard.AttributeGroupId__c = attrGroup.Id;
		CRUDUtility.updateRecords(rateCard);

		RateCardAttribute__c attr = newRateCardAttribute(attrGroup.Id);
		Test.startTest();
		{
			System.assertEquals(
				1,
				EstimateResourcesController.getTableColumns(estimateSo.Id).size(),
				'should contain 1 column'
			);
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldReturnRoleSummariesWithDurations() {
		Estimate__c estimateSo = newEstimate();
		TaskRoleSummary__c roleSummary = TaskRoleSummaryTestBase.newTaskRoleSummary();
		roleSummary.EstimateId__c = estimateSo.Id;
		roleSummary.LevelAdjustment__c = 1;
		CRUDUtility.updateRecords(roleSummary);

		Test.startTest();
		{
			List<TaskRoleSummary__c> roleSummaries = EstimateResourcesController.getTaskRoleSummaryDefaults(
				estimateSo.Id,
				new List<String>{
					(Schema.TaskRoleSummary__c.RateCardItemId__c + '').replace('__c', '__r') +
					'.' +
					Schema.RateCardItem__c.SkillLevel__c +
					''
				}
			);
			System.assertEquals(1, roleSummaries.size(), 'should return the estimate task role summary');
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldNotReturnRoleSummariesWithoutDurations() {
		Estimate__c estimateSo = newEstimate();
		TaskRoleSummary__c roleSummary = TaskRoleSummaryTestBase.newTaskRoleSummary();
		roleSummary.EstimateId__c = estimateSo.Id;
		roleSummary.LevelAdjustment__c = 0;
		CRUDUtility.updateRecords(roleSummary);

		Test.startTest();
		{
			List<TaskRoleSummary__c> roleSummaries = EstimateResourcesController.getTaskRoleSummaryDefaults(
				estimateSo.Id,
				new List<String>{
					(Schema.TaskRoleSummary__c.RateCardItemId__c + '').replace('__c', '__r') +
					'.' +
					Schema.RateCardItem__c.SkillLevel__c +
					''
				}
			);
			System.assertEquals(0, roleSummaries.size(), 'should not return any role summaries');
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldUpdateTheRateCardItemOnly() {
		Estimate__c estimateSo = newEstimate();
		TaskRoleSummary__c roleSummary = TaskRoleSummaryTestBase.newTaskRoleSummary();
		roleSummary.EstimateId__c = estimateSo.Id;
		roleSummary.LevelAdjustment__c = 0;
		CRUDUtility.updateRecords(roleSummary);

		Id recordTypeId = Schema.SObjectType.Product__c.getRecordTypeInfosByName()
			.get('Resource Role')
			.getRecordTypeId();
		Product__c resource = TestDataFactory.createResource('Software Engineer', recordTypeId);

		RateCard__c rateCard = TestBase.newRateCard();
		RateCardItem__c rateCardItem = TestBase.newRateCardItem(rateCard.Id, resource.Id);

		Test.startTest();
		{
			TaskRoleSummaryDto summaryDto = new TaskRoleSummaryDto();
			summaryDto.id = roleSummary.Id;
			summaryDto.rateCardItemId = rateCardItem.Id;

			EstimateResourcesController.saveRoleSummaries(new List<TaskRoleSummaryDto>{ summaryDto });
			TaskRoleSummary__c roleSummarySo = [
				SELECT Id, RateCardItemId__c, EstimateId__c
				FROM TaskRoleSummary__c
				WHERE Id = :summaryDto.id
			];
			System.assertEquals(rateCardItem.Id, roleSummarySo.RateCardItemId__c);
			System.assertEquals(
				estimateSo.Id,
				roleSummarySo.EstimateId__c,
				'estimate should not have changed'
			);
		}
		Test.stopTest();
	}
}
