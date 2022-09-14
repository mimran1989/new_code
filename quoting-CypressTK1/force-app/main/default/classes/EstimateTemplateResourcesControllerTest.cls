/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
@IsTest
private class EstimateTemplateResourcesControllerTest extends TestBase {
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

		EstimateTemplate__c templateSo = EstimateTemplateTestBase.newEstimateTemplate(rateCard.Id);

		ResourceDefault__c defaultSo = ResourceDefaultTestBase.newResourceDefault(
			resource.Id,
			rateCardItem.Id
		);
		defaultSo.EstimateTemplateId__c = templateSo.Id;
		CRUDUtility.updateRecords(defaultSo);

		ActivityGroupTemplate__c groupTemplateSo = new ActivityGroupTemplate__c(
			EstimateTemplateId__c = templateSo.Id
		);
		CRUDUtility.insertRecords(groupTemplateSo);
		ActivityTemplate__c activityTemplateSo = new ActivityTemplate__c(
			ActivityGroupTemplateId__c = groupTemplateSo.Id
		);
		CRUDUtility.insertRecords(activityTemplateSo);
		TaskTemplate__c taskTemplateSo = new TaskTemplate__c(
			ActivityTemplateId__c = activityTemplateSo.Id,
			ResourceRoleId__c = resource.Id
		);
		CRUDUtility.insertRecords(taskTemplateSo);

		Test.startTest();
		{
			Map<String, Object> dependencyTree = EstimateTemplateResourcesController.getDependencyTree(
				templateSo.Id,
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
		RateCard__c rateCard = newRateCard();
		EstimateTemplate__c templateSo = EstimateTemplateTestBase.newEstimateTemplate(rateCard.Id);

		RateCardAttributeGroup__c attrGroup = newRateCardAttributeGroup();
		rateCard.AttributeGroupId__c = attrGroup.Id;
		CRUDUtility.updateRecords(rateCard);

		newRateCardAttribute(attrGroup.Id);
		Test.startTest();
		{
			System.assertEquals(
				1,
				EstimateTemplateResourcesController.getTableColumns(templateSo.Id).size(),
				'should contain 1 column'
			);
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldIncludeProductName() {
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

		EstimateTemplate__c templateSo = EstimateTemplateTestBase.newEstimateTemplate(rateCard.Id);

		ActivityGroupTemplate__c groupTemplateSo = new ActivityGroupTemplate__c(
			EstimateTemplateId__c = templateSo.Id
		);
		CRUDUtility.insertRecords(groupTemplateSo);
		ActivityTemplate__c activityTemplateSo = new ActivityTemplate__c(
			ActivityGroupTemplateId__c = groupTemplateSo.Id
		);
		CRUDUtility.insertRecords(activityTemplateSo);
		TaskTemplate__c taskTemplateSo = new TaskTemplate__c(
			ActivityTemplateId__c = activityTemplateSo.Id,
			ResourceRoleId__c = resource.Id
		);
		CRUDUtility.insertRecords(taskTemplateSo);

		Test.startTest();
		{
			System.assert(
				!String.isBlank(
					EstimateTemplateResourcesController.getResourceDefaults(
							templateSo.Id,
							new List<String>()
						)[0]
						?.ProductId__r
						?.Name
				),
				'should have a name for a role without an existing resource default'
			);
		}
		Test.stopTest();
	}
}
