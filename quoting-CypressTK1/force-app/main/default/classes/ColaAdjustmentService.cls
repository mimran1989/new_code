/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class ColaAdjustmentService {
	public static List<ColaAdjustment__c> getColaAdjustmentSOs(Id quoteId) {
		return [
			SELECT
				Id,
				ColaRateId__c,
				ColaRateId__r.RateOverride__c,
				CostIncrease__c,
				CostIncreaseWithOverride__c,
				CurrentCost__c,
				CurrentRevenue__c,
				NewCost__c,
				NewCostWithOverride__c,
				OriginalCost__c,
				QuoteId__c
			FROM ColaAdjustment__c
			WHERE QuoteId__c = :quoteId
			WITH SECURITY_ENFORCED
		];
	}

	public static List<ColaAdjustmentDto> getColaAdjustments(Id quoteId) {
		List<ColaAdjustmentDto> colaAdjustmentDtos = new List<ColaAdjustmentDto>();
		for (ColaAdjustment__c colaAdjustmentSO : getColaAdjustmentSOs(quoteId)) {
			colaAdjustmentDtos.add(new ColaAdjustmentDto(colaAdjustmentSO));
		}
		return colaAdjustmentDtos;
	}

	public static void saveColaAdjustments(List<ColaAdjustmentDto> colaAdjustmentDtos) {
		List<ColaAdjustment__c> colaAdjustments = new List<ColaAdjustment__c>();
		for (ColaAdjustmentDto colaAdjustmentDto : colaAdjustmentDtos) {
			colaAdjustments.add((ColaAdjustment__c) colaAdjustmentDto.refreshSo());
		}
		CRUDUtility.upsertRecords(colaAdjustments);
	}

	public static void deleteColaAdjustments(Id quoteId) {
		List<ColaAdjustment__c> colaAdjustmentSOs = getColaAdjustmentSOs(quoteId);
		CRUDUtility.deleteRecords(colaAdjustmentSOs);
	}
}
