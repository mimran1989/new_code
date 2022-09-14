/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
@IsTest
private class GlobalColaRateAdminControllerTest extends ColaRateSheetTestBase {
	@IsTest
	static void shouldReturnActiveColaRates() {
		ColaRateSheet__c rateSheet = newColaRateSheet();
		rateSheet.Type__c = ColaRateSheet.TYPE_GLOBAL;
		CRUDUtility.upsertRecords(rateSheet);

		ColaRate__c rate = ColaRateTestBase.newColaRate(rateSheet.Id);
		Test.startTest();
		System.assertEquals(
			1,
			GlobalColaRateAdminController.getActiveGlobalColaRates().size(),
			'should return a rate'
		);
		Test.stopTest();
	}

	@IsTest
	static void shouldSaveColaRates() {
		ColaRateDto rateDto = new ColaRateDto();
		rateDto.serviceYear = Date.today().year();
		rateDto.yearOverYearRate = 1;

		Test.startTest();
		GlobalColaRateAdminController.saveGlobalColaRates(new List<ColaRateDto>{ rateDto });
		System.assertEquals(
			1,
			GlobalColaRateAdminController.getActiveGlobalColaRates().size(),
			'should return a rate'
		);
		Test.stopTest();
	}

	@IsTest
	static void shouldDeleteColaRates() {
		ColaRateSheet__c rateSheet = newColaRateSheet();
		rateSheet.Type__c = ColaRateSheet.TYPE_GLOBAL;
		CRUDUtility.upsertRecords(rateSheet);

		ColaRateDto rateDto = new ColaRateDto();
		rateDto.serviceYear = Date.today().year();
		rateDto.yearOverYearRate = 1;

		Test.startTest();
		GlobalColaRateAdminController.saveGlobalColaRates(new List<ColaRateDto>{ rateDto });
		GlobalColaRateAdminController.deleteGlobalColaRates(
			new List<Id>{ GlobalColaRateAdminController.getActiveGlobalColaRates()[0].Id }
		);
		System.assertEquals(
			0,
			GlobalColaRateAdminController.getActiveGlobalColaRates().size(),
			'should return no rate'
		);
		Test.stopTest();
	}

	@IsTest
	static void shouldNotSaveZeroRate() {
		ColaRateDto rateDto = new ColaRateDto();
		rateDto.serviceYear = Date.today().year();
		rateDto.yearOverYearRate = 0;

		Test.startTest();
		try {
			GlobalColaRateAdminController.saveGlobalColaRates(new List<ColaRateDto>{ rateDto });
		} catch (Exception e) {
		}
		System.assertEquals(0, GlobalColaRateAdminController.getActiveGlobalColaRates().size());
		Test.stopTest();
	}

	@IsTest
	static void shouldNotSaveNegativeRate() {
		ColaRateDto rateDto = new ColaRateDto();
		rateDto.serviceYear = Date.today().year();
		rateDto.yearOverYearRate = -1;

		Test.startTest();
		try {
			GlobalColaRateAdminController.saveGlobalColaRates(new List<ColaRateDto>{ rateDto });
		} catch (Exception e) {
		}
		System.assertEquals(0, GlobalColaRateAdminController.getActiveGlobalColaRates().size());
		Test.stopTest();
	}
}
