/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class ColaRateService {
	private class GlobalColaRatesDto {
		public ColaRateSheet__c globalColaRateSheet;
		Map<Decimal, List<ColaRate__c>> ratesByServiceYear;
		Map<Id, ColaRateSheet__c> rateSheetsByQuoteId;
	}

	public static List<ColaRateDto> getColaRates(Id rateSheetId) {
		List<ColaRateDto> rateDtos = new List<ColaRateDto>();
		for (ColaRate__c rate : [
			SELECT
				Id,
				ServiceYear__c,
				RateMatch__c,
				Country__c,
				State__c,
				City__c,
				YearOverYearRate__c,
				RateOverride__c,
				PassthroughRateOverride__c,
				RateSheetId__c,
				PassthroughPercentage__c
			FROM ColaRate__c
			WHERE ServiceYear__c >= :Date.today().year() AND RateSheetId__c = :rateSheetId
			WITH SECURITY_ENFORCED
			ORDER BY ServiceYear__c, Country__c NULLS FIRST, State__c NULLS FIRST, City__c NULLS FIRST
		]) {
			rateDtos.add(new ColaRateDto(rate));
		}

		return rateDtos;
	}

	public static void saveColaRates(List<ColaRateDto> rateDtos) {
		List<ColaRate__c> colaRates = new List<ColaRate__c>();

		for (ColaRateDto colaRateDto : rateDtos) {
			colaRates.add((ColaRate__c) colaRateDto.refreshSo());
		}

		CRUDUtility.upsertRecords(colaRates);
	}

	public static void deleteColaRates(List<Id> rateIds) {
		List<ColaRate__c> colaRates = new List<ColaRate__c>();
		for (Id id : rateIds) {
			colaRates.add(new ColaRate__c(Id = id));
		}

		CRUDUtility.deleteRecords(colaRates);
	}

	public static List<ColaRateDto> getColaRatesForQuote(Id quoteId) {
		ColaRateSheet__c rateSheet = [
			SELECT Id
			FROM ColaRateSheet__c
			WHERE QuoteId__c = :quoteId
			WITH SECURITY_ENFORCED
			LIMIT 1
		];

		return getColaRates(rateSheet.Id);
	}

	private static ColaRateSheet__c getGlobalRatesForServiceYears(Set<Decimal> serviceYears) {
		List<ColaRateSheet__c> globalColaRateSheets = [
			SELECT
				Id,
				(
					SELECT
						ServiceYear__c,
						RateMatch__c,
						Country__c,
						State__c,
						City__c,
						YearOverYearRate__c,
						RateOverride__c
					FROM ColaRates__r
					WHERE ServiceYear__c = :serviceYears
				)
			FROM ColaRateSheet__c
			WHERE Type__c = :ColaRateSheet.TYPE_GLOBAL
			WITH SECURITY_ENFORCED
			LIMIT 1
		];

		return globalColaRateSheets.isEmpty() ? null : globalColaRateSheets[0];
	}

	/*
	 * Copy Global Cola Rates to a quote.
	 * Note: this will clone the rates only for the service year
	 * defined for the quote
	 * @param quoteId the Id of the context quote
	 */
	public static void copyGlobalColaRatesToQuotes(Set<Id> quoteIds) {
		GlobalColaRatesDto globalColaRatesDto = new GlobalColaRatesDto();
		Map<Id, Decimal> quoteServiceYear = new Map<Id, Decimal>();
		Set<Decimal> serviceYears = new Set<Decimal>();
		for (
			Quote__c contextQuote : [
				SELECT Id, ServiceStartDate__c
				FROM Quote__c
				WHERE Id = :quoteIds AND ServiceStartDate__c != NULL // adding a gate for potential bad data
				WITH SECURITY_ENFORCED
				LIMIT 1
			]
		) {
			serviceYears.add(contextQuote.ServiceStartDate__c.year());
			quoteServiceYear.put(contextQuote.Id, contextQuote.ServiceStartDate__c.year());
		}

		globalColaRatesDto.globalColaRateSheet = getGlobalRatesForServiceYears(serviceYears);
		if (globalColaRatesDto.globalColaRateSheet == null) {
			return;
		}

		globalColaRatesDto.ratesByServiceYear = getRatesByServiceYear(globalColaRatesDto);
		globalColaRatesDto.rateSheetsByQuoteId = getRateSheetsByQuoteId(
			globalColaRatesDto,
			quoteIds,
			quoteServiceYear
		);
		CRUDUtility.insertRecords(globalColaRatesDto.rateSheetsByQuoteId.values());

		List<ColaRate__c> clonedRates = getClonedRates(globalColaRatesDto, quoteIds, quoteServiceYear);
		CRUDUtility.insertRecords(clonedRates);
	}

	private static Map<Decimal, List<ColaRate__c>> getRatesByServiceYear(
		GlobalColaRatesDto globalColaRatesDto
	) {
		Map<Decimal, List<ColaRate__c>> ratesByServiceYear = new Map<Decimal, List<ColaRate__c>>();
		for (ColaRate__c colaRate : globalColaRatesDto.globalColaRateSheet.ColaRates__r) {
			List<ColaRate__c> colaRatesForYear = ratesByServiceYear.get(colaRate.ServiceYear__c);
			if (colaRatesForYear == null) {
				colaRatesForYear = new List<ColaRate__c>();
				ratesByServiceYear.put(colaRate.ServiceYear__c, colaRatesForYear);
			}
			colaRatesForYear.add(colaRate);
		}
		return ratesByServiceYear;
	}

	private static Map<Id, ColaRateSheet__c> getRateSheetsByQuoteId(
		GlobalColaRatesDto globalColaRatesDto,
		Set<Id> quoteIds,
		Map<Id, Decimal> quoteServiceYear
	) {
		Map<Id, ColaRateSheet__c> rateSheetsByQuoteId = new Map<Id, ColaRateSheet__c>();
		Set<Id> quotesWithRates = new Set<Id>();

		for (Id quoteId : quoteIds) {
			Boolean hasRatesForServiceYear =
				globalColaRatesDto.ratesByServiceYear.get(quoteServiceYear.get(quoteId)) != null;
			if (hasRatesForServiceYear) {
				ColaRateSheet__c quoteColaRateSheet = globalColaRatesDto.globalColaRateSheet.clone();
				quoteColaRateSheet.Type__c = ColaRateSheet.TYPE_QUOTE;
				quoteColaRateSheet.QuoteId__c = quoteId;
				rateSheetsByQuoteId.put(quoteId, quoteColaRateSheet);
				quotesWithRates.add(quoteId);
			}
		}

		return rateSheetsByQuoteId;
	}

	private static List<ColaRate__c> getClonedRates(
		GlobalColaRatesDto globalColaRatesDto,
		Set<Id> quoteIds,
		Map<Id, Decimal> quoteServiceYear
	) {
		List<ColaRate__c> clonedRates = new List<ColaRate__c>();
		for (Id quoteId : quoteIds) {
			Boolean hasGlobalRate = false;
			Decimal serviceYear = quoteServiceYear.get(quoteId);
			List<ColaRate__c> ratesForQuote = globalColaRatesDto.ratesByServiceYear.get(serviceYear);
			if (SystemUtility.nullOrEmpty(ratesForQuote)) {
				continue;
			}

			Id rateSheetId = globalColaRatesDto.rateSheetsByQuoteId.get(quoteId).Id;

			for (ColaRate__c colaRateSO : ratesForQuote) {
				ColaRate__c clonedColaRate = colaRateSO.clone();
				clonedColaRate.RateSheetId__c = rateSheetId;
				clonedRates.add(clonedColaRate);

				if (clonedColaRate.RateMatch__c == ColaRate.RATE_MATCH_GLOBAL) {
					hasGlobalRate = true;
				}
			}

			if (!hasGlobalRate) {
				ColaRate__c globalColaRate = new ColaRate__c(
					RateSheetId__c = rateSheetId,
					ServiceYear__c = serviceYear,
					YearOverYearRate__c = 0
				);
				clonedRates.add(globalColaRate);
			}
		}

		return clonedRates;
	}
}
