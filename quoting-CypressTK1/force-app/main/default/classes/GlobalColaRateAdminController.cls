/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class GlobalColaRateAdminController {
	@AuraEnabled
	public static List<ColaRateDto> getActiveGlobalColaRates() {
		ColaRateSheet__c globalRateSheet = ColaRateSheetService.getActiveGlobalRateSheet();
		if (globalRateSheet != null) {
			return ColaRateService.getColaRates(globalRateSheet.Id);
		}

		return new List<ColaRateDto>();
	}

	@AuraEnabled
	public static List<ColaRateDto> saveGlobalColaRates(List<ColaRateDto> rateDtos) {
		ColaRateSheet__c globalRateSheet = ColaRateSheetService.getActiveGlobalRateSheet();
		if (globalRateSheet == null) {
			globalRateSheet = new ColaRateSheet__c(
				Name = ColaRateSheet.TYPE_GLOBAL,
				Type__c = ColaRateSheet.TYPE_GLOBAL
			);
			CRUDUtility.insertRecords(globalRateSheet);
		}

		for (ColaRateDto colaRateDto : rateDtos) {
			colaRateDto.rateSheetId = globalRateSheet.Id;
		}

		ColaRateService.saveColaRates(rateDtos);
		return getActiveGlobalColaRates();
	}

	@AuraEnabled
	public static void deleteGlobalColaRates(List<Id> rateIds) {
		ColaRateService.deleteColaRates(rateIds);
	}
}
