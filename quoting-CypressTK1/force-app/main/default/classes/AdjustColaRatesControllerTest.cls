/**
 *  Provus Services Quoting
 *  AdjustColaRatesControllerTest
 *  Copyright (c) 2022 Provus Inc. All rights reserved.
 */

@isTest
public with sharing class AdjustColaRatesControllerTest extends ColaRateSheetTestBase {
	@IsTest
	static void shouldReturnColaRatesForQuote() {
		Quote__c quote = newQuote();
		ColaRateSheet__c rateSheet = newColaRateSheet();
		rateSheet.Type__c = ColaRateSheet.TYPE_QUOTE;
		rateSheet.QuoteId__c = quote.Id;
		CRUDUtility.upsertRecords(rateSheet);

		ColaRate__c rate = ColaRateTestBase.newColaRate(rateSheet.Id);
		Test.startTest();
		System.assertEquals(
			1,
			AdjustColaRatesController.getColaRatesForQuote(quote.Id).size(),
			'should return a rate'
		);
		Test.stopTest();
	}

	@IsTest
	static void shouldSaveNewColaRateForQuote() {
		Quote__c quote = newQuote();
		Test.startTest();
		System.assertEquals(
			0,
			AdjustColaRatesController.getColaRatesForQuote(quote.Id).size(),
			'should be no rates at the start'
		);
		ColaRateDto rateDto = new ColaRateDto();
		rateDto.serviceYear = Date.today().year();
		rateDto.yearOverYearRate = 8;
		rateDto.rateOverride = 5;

		List<ColaRateDto> colaRates = AdjustColaRatesController.saveColaRateForQuote(
			new List<ColaRateDto>{ rateDto },
			new List<Id>(),
			quote.Id
		);
		System.assertEquals(1, colaRates.size(), 'should return a rate');
		System.assertEquals(Date.today().year(), colaRates[0].serviceYear, 'service date should match');
		System.assertEquals(8, colaRates[0].yearOverYearRate, 'year over year rate should match');
		System.assertEquals(5, colaRates[0].rateOverride, 'rate override should match');
		Test.stopTest();
	}

	@IsTest
	static void shouldUpdateExistingColaRateForQuote() {
		Quote__c quote = newQuote();
		Test.startTest();
		System.assertEquals(
			0,
			AdjustColaRatesController.getColaRatesForQuote(quote.Id).size(),
			'should be no rates at the start'
		);
		ColaRateDto rateDto = new ColaRateDto();
		rateDto.serviceYear = Date.today().year();
		rateDto.yearOverYearRate = 10;
		rateDto.rateOverride = 7;

		List<ColaRateDto> colaRates = AdjustColaRatesController.saveColaRateForQuote(
			new List<ColaRateDto>{ rateDto },
			new List<Id>(),
			quote.Id
		);

		System.assertEquals(1, colaRates.size(), 'should return a rate');
		System.assertEquals(Date.today().year(), colaRates[0].serviceYear, 'service date should match');
		System.assertEquals(10, colaRates[0].yearOverYearRate, 'year over year rate should match');
		System.assertEquals(7, colaRates[0].rateOverride, 'rate override should match');

		rateDto.country = 'United States';
		rateDto.state = 'Oregon';
		rateDto.city = 'Portland';

		List<ColaRateDto> updatedColaRates = AdjustColaRatesController.saveColaRateForQuote(
			new List<ColaRateDto>{ rateDto },
			new List<Id>(),
			quote.Id
		);

		System.assertEquals('United States', updatedColaRates[0].country, 'country should match');
		System.assertEquals('Oregon', updatedColaRates[0].state, 'state should match');
		System.assertEquals('Portland', updatedColaRates[0].city, 'city should match');

		Test.stopTest();
	}

	@IsTest
	static void shouldDeleteColaRateFromQuote() {
		Quote__c quote = newQuote();
		ColaRateDto rateDto = new ColaRateDto();
		rateDto.serviceYear = Date.today().year();
		rateDto.yearOverYearRate = 1;
		rateDto.rateOverride = 5;

		Test.startTest();
		List<ColaRateDto> updatedColaRates = AdjustColaRatesController.saveColaRateForQuote(
			new List<ColaRateDto>{ rateDto },
			new List<Id>(),
			quote.Id
		);
		System.assertEquals(1, updatedColaRates.size(), 'should return a rate');

		List<ColaRateDto> colaRates = new List<ColaRateDto>();
		List<Id> colaRatesToDelete = new List<Id>{ updatedColaRates[0].Id };
		AdjustColaRatesController.saveColaRateForQuote(colaRates, colaRatesToDelete, quote.Id);

		System.assertEquals(
			0,
			AdjustColaRatesController.getColaRatesForQuote(quote.Id).size(),
			'should return no rate'
		);
		Test.stopTest();
	}
}
