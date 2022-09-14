/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
@IsTest
private class ColaRateDtoTest extends ColaRateSheetTestBase {
	@IsTest
	static void shouldCreateGlobalRate() {
		ColaRateSheet__c rateSheet = newColaRateSheet();
		ColaRate__c rateSo = new ColaRate__c(
			RateSheetId__c = rateSheet.Id,
			ServiceYear__c = Date.today().year(),
			YearOverYearRate__c = 1
		);
		CRUDUtility.insertRecords(rateSo);

		Test.startTest();
		ColaRateDto rateDto = new ColaRateDto(
			[
				SELECT
					ServiceYear__c,
					Country__c,
					State__c,
					City__c,
					RateMatch__c,
					YearOverYearRate__c,
					RateOverride__c,
					PassthroughPercentage__c,
					PassthroughRateOverride__c
				FROM ColaRate__c
				WHERE Id = :rateSo.Id
			]
		);
		System.assert(rateDto.serviceYear == Date.today().year(), 'should have the current year');
		System.assert(
			rateDto.rateMatch == ColaRate.RATE_MATCH_GLOBAL,
			'should have a global rate match'
		);
		Test.stopTest();
	}

	@IsTest
	static void shouldCreateCountryRate() {
		ColaRateSheet__c rateSheet = newColaRateSheet();
		ColaRate__c rateSo = new ColaRate__c(
			RateSheetId__c = rateSheet.Id,
			ServiceYear__c = Date.today().year(),
			Country__c = 'United States',
			YearOverYearRate__c = 1
		);
		CRUDUtility.insertRecords(rateSo);

		Test.startTest();
		ColaRateDto rateDto = new ColaRateDto(
			[
				SELECT
					ServiceYear__c,
					Country__c,
					State__c,
					City__c,
					RateMatch__c,
					YearOverYearRate__c,
					RateOverride__c,
					PassthroughPercentage__c,
					PassthroughRateOverride__c
				FROM ColaRate__c
				WHERE Id = :rateSo.Id
			]
		);
		System.assert(rateDto.serviceYear == Date.today().year(), 'should have the current year');
		System.assert(
			rateDto.rateMatch == ColaRate.RATE_MATCH_COUNTRY,
			'should have a country rate match'
		);
		Test.stopTest();
	}

	@IsTest
	static void shouldCreateStateRate() {
		ColaRateSheet__c rateSheet = newColaRateSheet();
		ColaRate__c rateSo = new ColaRate__c(
			RateSheetId__c = rateSheet.Id,
			ServiceYear__c = Date.today().year(),
			Country__c = 'United States',
			State__c = 'California',
			YearOverYearRate__c = 1
		);
		CRUDUtility.insertRecords(rateSo);

		Test.startTest();
		ColaRateDto rateDto = new ColaRateDto(
			[
				SELECT
					ServiceYear__c,
					Country__c,
					State__c,
					City__c,
					RateMatch__c,
					YearOverYearRate__c,
					RateOverride__c,
					PassthroughPercentage__c,
					PassthroughRateOverride__c
				FROM ColaRate__c
				WHERE Id = :rateSo.Id
			]
		);
		System.assert(rateDto.serviceYear == Date.today().year(), 'should have the current year');
		System.assert(rateDto.rateMatch == ColaRate.RATE_MATCH_STATE, 'should have a state rate match');
		Test.stopTest();
	}

	@IsTest
	static void shouldCreateCityRate() {
		ColaRateSheet__c rateSheet = newColaRateSheet();
		ColaRate__c rateSo = new ColaRate__c(
			RateSheetId__c = rateSheet.Id,
			ServiceYear__c = Date.today().year(),
			Country__c = 'United States',
			State__c = 'California',
			City__c = 'San Jose',
			YearOverYearRate__c = 1
		);
		CRUDUtility.insertRecords(rateSo);

		Test.startTest();
		ColaRateDto rateDto = new ColaRateDto(
			[
				SELECT
					ServiceYear__c,
					Country__c,
					State__c,
					City__c,
					RateMatch__c,
					YearOverYearRate__c,
					RateOverride__c,
					PassthroughPercentage__c,
					PassthroughRateOverride__c
				FROM ColaRate__c
				WHERE Id = :rateSo.Id
			]
		);
		System.assert(rateDto.serviceYear == Date.today().year(), 'should have the current year');
		System.assert(rateDto.rateMatch == ColaRate.RATE_MATCH_CITY, 'should have a city rate match');
		Test.stopTest();
	}
}
