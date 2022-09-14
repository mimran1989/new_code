/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class AdjustColaRatesController {
	@AuraEnabled
	public static List<ColaRateDto> getColaRatesForQuote(Id quoteId) {
		ColaRateSheet__c quoteRateSheet = ColaRateSheetService.getRateSheetForQuote(quoteId);
		if (quoteRateSheet != null) {
			return ColaRateService.getColaRates(quoteRateSheet.Id);
		}
		return new List<ColaRateDto>();
	}

	@AuraEnabled
	public static List<ColaRateDto> saveColaRateForQuote(
		List<ColaRateDto> rateDtos,
		List<Id> colaRatesToDelete,
		Id quoteId
	) {
		ColaRateSheet__c quoteRateSheet = ColaRateSheetService.getRateSheetForQuote(quoteId);
		if (quoteRateSheet == null) {
			quoteRateSheet = new ColaRateSheet__c(
				QuoteId__c = quoteId,
				Type__c = ColaRateSheet.TYPE_QUOTE
			);
			CRUDUtility.insertRecords(quoteRateSheet);
		}
		for (ColaRateDto colaRateDto : rateDtos) {
			colaRateDto.rateSheetId = quoteRateSheet.Id;
		}

		ColaRateService.saveColaRates(rateDtos);
		ColaRateService.deleteColaRates(colaRatesToDelete);
		return getColaRatesForQuote(quoteId);
	}
}
