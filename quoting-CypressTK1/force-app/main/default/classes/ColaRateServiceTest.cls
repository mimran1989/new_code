/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

@IsTest
private class ColaRateServiceTest extends ColaRateSheetTestBase {
	@IsTest
	static void shouldAllowZeroRateForNonGlobalRate() {
		ColaRateSheet__c rateSheet = newColaRateSheet();
		rateSheet.Type__c = ColaRateSheet.TYPE_QUOTE;
		CRUDUtility.upsertRecords(rateSheet);

		ColaRate__c rate = ColaRateTestBase.newColaRate(rateSheet.Id);
		ColaRateDto rateDto = new ColaRateDto(rate);
		Test.startTest();
		{
			rateDto.yearOverYearRate = 0;
			ColaRateService.saveColaRates(new List<ColaRateDto>{ rateDto });
			ColaRate__c updatedRate = [SELECT YearOverYearRate__c FROM ColaRate__c WHERE Id = :rate.Id];

			System.assertEquals(0, updatedRate.YearOverYearRate__c);
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldNotAllowNegativeRateForNonGlobalRate() {
		ColaRateSheet__c rateSheet = newColaRateSheet();
		rateSheet.Type__c = ColaRateSheet.TYPE_QUOTE;
		CRUDUtility.upsertRecords(rateSheet);

		ColaRate__c rate = ColaRateTestBase.newColaRate(rateSheet.Id);
		ColaRateDto rateDto = new ColaRateDto(rate);
		Test.startTest();
		{
			rateDto.yearOverYearRate = -1;
			try {
				ColaRateService.saveColaRates(new List<ColaRateDto>{ rateDto });
			} catch (Exception e) {
			}
			ColaRate__c updatedRate = [SELECT YearOverYearRate__c FROM ColaRate__c WHERE Id = :rate.Id];

			System.assertEquals(1, updatedRate.YearOverYearRate__c);
		}
		Test.stopTest();
	}
}
