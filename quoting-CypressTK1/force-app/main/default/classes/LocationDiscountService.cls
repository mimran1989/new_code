/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class LocationDiscountService {
	public static List<LocationDiscountDto> getLocationDiscounts(Id quoteId) {
		List<LocationDiscountDto> locationDiscountDtos = new List<LocationDiscountDto>();
		for (LocationDiscount__c locationDiscount : [
			SELECT Id, RateMatch__c, Country__c, State__c, City__c, Amount__c, QuoteId__c, Type__c
			FROM LocationDiscount__c
			WHERE QuoteId__c = :quoteId
			WITH SECURITY_ENFORCED
		]) {
			locationDiscountDtos.add(new LocationDiscountDto(locationDiscount));
		}

		return locationDiscountDtos;
	}

	public static void saveLocationDiscounts(List<LocationDiscountDto> locationDiscountDtos) {
		List<LocationDiscount__c> locationDiscountsToSave = new List<LocationDiscount__c>();
		List<LocationDiscount__c> locationDiscountsToDelete = new List<LocationDiscount__c>();

		for (LocationDiscountDto locationDiscountDto : locationDiscountDtos) {
			if (locationDiscountDto.isDelete()) {
				locationDiscountsToDelete.add((LocationDiscount__c) locationDiscountDto.refreshSo());
			} else {
				locationDiscountsToSave.add((LocationDiscount__c) locationDiscountDto.refreshSo());
			}
		}

		CRUDUtility.upsertRecords(locationDiscountsToSave);
		CRUDUtility.deleteRecords(locationDiscountsToDelete);
	}
}
