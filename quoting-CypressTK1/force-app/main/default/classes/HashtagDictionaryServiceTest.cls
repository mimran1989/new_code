/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
@IsTest
private class HashtagDictionaryServiceTest extends TestBase {
	@IsTest
	static void shouldGenerateADictionaryForTheGivenEstimate() {
		Estimate__c estimateSo = newEstimate();
		ScopeParameter__c scopeParamSo1 = ScopeParameterTestBase.newIntegerScopeParameter(
			estimateSo.Id
		);
		scopeParamSo1.DeveloperName__c = 'hashtag1';
		scopeParamSo1.IntegerValue__c = 1;
		ScopeParameter__c scopeParamSo2 = ScopeParameterTestBase.newIntegerScopeParameter(
			estimateSo.Id
		);
		scopeParamSo2.DeveloperName__c = 'hashtag2';
		scopeParamSo2.IntegerValue__c = 2;
		ScopeParameter__c scopeParamSo3 = ScopeParameterTestBase.newIntegerScopeParameter(
			estimateSo.Id
		);
		scopeParamSo3.DeveloperName__c = 'hashtag3';
		scopeParamSo3.IntegerValue__c = 3;

		CRUDUtility.updateRecords(
			new List<ScopeParameter__c>{ scopeParamSo1, scopeParamSo2, scopeParamSo3 }
		);

		Test.startTest();
		{
			Map<String, Decimal> dictionary = HashtagDictionaryService.generateDictionaryForEstimate(
				estimateSo.Id
			);
			System.assertEquals(1, dictionary.get('hashtag1'));
			System.assertEquals(2, dictionary.get('hashtag2'));
			System.assertEquals(3, dictionary.get('hashtag3'));
		}
		Test.stopTest();
	}
}
