/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

@IsTest
private class ScopeParameterTemplateServiceTest extends TestBase {
	@IsTest
	static void shouldReturnHashtagsForEstimate() {
		RateCard__c rateCardSo = newRateCard();
		EstimateTemplate__c estimateTemplateSo = EstimateTemplateTestBase.newEstimateTemplate(
			rateCardSo.Id
		);
		ScopeParameterTemplate__c paramSo1 = new ScopeParameterTemplate__c(
			EstimateTemplateId__c = estimateTemplateSo.Id,
			DeveloperName__c = 'Test'
		);
		CRUDUtility.insertRecords(paramSo1);

		Test.startTest();
		{
			List<String> hashtags = HashtagDictionaryService.getHashtagsForEstimateTemplate(
				estimateTemplateSo.Id
			);
			System.assertEquals(1, hashtags.size(), 'should return 1 hashtag');
			System.assertEquals('Test', hashtags.get(0), 'should contain the developer name');
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldReturnParamsForEstimate() {
		RateCard__c rateCardSo = newRateCard();
		EstimateTemplate__c estimateTemplateSo = EstimateTemplateTestBase.newEstimateTemplate(
			rateCardSo.Id
		);
		ScopeParameterTemplate__c paramSo1 = new ScopeParameterTemplate__c(
			EstimateTemplateId__c = estimateTemplateSo.Id,
			DeveloperName__c = 'Test'
		);
		CRUDUtility.insertRecords(paramSo1);

		Test.startTest();
		{
			List<ScopeParameterTemplateDto> paramDtos = ScopeParameterTemplateService.getParamsForParentId(
				estimateTemplateSo.Id
			);
			System.assertEquals(1, paramDtos.size(), 'should contain one element');
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldReturnParamsForGroup() {
		ActivityGroupTemplate__c groupTemplateSo = EstimateTemplateTestBase.newActivityGroupTemplate(
			'Initiation',
			new Map<String, String>(),
			1
		);
		CRUDUtility.insertRecords(groupTemplateSo);

		ScopeParameterTemplate__c paramSo1 = new ScopeParameterTemplate__c(
			ActivityGroupTemplateId__c = groupTemplateSo.Id,
			DeveloperName__c = 'Test'
		);
		CRUDUtility.insertRecords(paramSo1);

		Test.startTest();
		{
			List<ScopeParameterTemplateDto> paramDtos = ScopeParameterTemplateService.getParamsForParentId(
				groupTemplateSo.Id
			);
			System.assertEquals(1, paramDtos.size(), 'should contain one element');
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldReturnParamsForActivity() {
		ActivityGroupTemplate__c groupTemplateSo = EstimateTemplateTestBase.newActivityGroupTemplate(
			'Initiation',
			new Map<String, String>(),
			1
		);
		CRUDUtility.insertRecords(groupTemplateSo);

		ActivityTemplate__c activityTemplateSo = EstimateTemplateTestBase.newActivityTemplate(
			'Initiation',
			new Map<String, String>(),
			1
		);
		activityTemplateSo.ActivityGroupTemplateId__c = groupTemplateSo.Id;
		CRUDUtility.insertRecords(activityTemplateSo);

		ScopeParameterTemplate__c paramSo1 = new ScopeParameterTemplate__c(
			ActivityTemplateId__c = activityTemplateSo.Id,
			DeveloperName__c = 'Test'
		);
		CRUDUtility.insertRecords(paramSo1);

		Test.startTest();
		{
			List<ScopeParameterTemplateDto> paramDtos = ScopeParameterTemplateService.getParamsForParentId(
				activityTemplateSo.Id
			);
			System.assertEquals(1, paramDtos.size(), 'should contain one element');
		}
		Test.stopTest();
	}
}
