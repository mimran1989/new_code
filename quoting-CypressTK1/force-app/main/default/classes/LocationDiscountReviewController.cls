/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class LocationDiscountReviewController {
	@AuraEnabled
	public static List<LocationDiscountReviewDto> getLocationDiscountReviewForQuote(Id quoteId) {
		List<LocationDiscountReviewDto> locationDiscountReviewDtos = LocationDiscountReviewService.getLocationDiscountsReviewForQuote(
			quoteId
		);
		return locationDiscountReviewDtos;
	}
}
