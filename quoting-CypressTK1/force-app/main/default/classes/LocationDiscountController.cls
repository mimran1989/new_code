/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class LocationDiscountController {
	@AuraEnabled
	public static List<LocationDiscountDto> getLocationDiscounts(Id quoteId) {
		List<LocationDiscountDto> locationDiscountDtos = LocationDiscountService.getLocationDiscounts(
			quoteId
		);
		return locationDiscountDtos;
	}

	@AuraEnabled
	public static List<LocationDiscountDto> saveLocationDiscounts(
		List<LocationDiscountDto> locationDiscountDtos
	) {
		List<LocationDiscountDto> locationDiscounts = new List<LocationDiscountDto>();
		if (!locationDiscountDtos.isEmpty()) {
			LocationDiscountService.saveLocationDiscounts(locationDiscountDtos);
			locationDiscounts = getLocationDiscounts(locationDiscountDtos[0].quoteId);
		}

		return locationDiscounts;
	}
}
