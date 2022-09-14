/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class LocationDiscountReviewService {
	public static List<LocationDiscountReviewDto> getLocationDiscountsReviewForQuote(Id quoteId) {
		List<LocationDiscount__c> locationDiscounts = getLocationDiscounts(quoteId);
		List<LocationDiscountReviewDto> reviewDtos = new List<LocationDiscountReviewDto>();
		for (LocationDiscount__c locationDiscount : locationDiscounts) {
			reviewDtos.add(new LocationDiscountReviewDto(locationDiscount));
		}
		return reviewDtos;
	}

	private static List<LocationDiscount__c> getLocationDiscounts(Id quoteId) {
		return [
			SELECT
				Id,
				Name,
				Country__c,
				State__c,
				City__c,
				RateMatch__c,
				Type__c,
				Amount__c,
				QuoteId__c,
				(
					SELECT
						Id,
						AdjustmentId__r.NamedRangeId__r.NamedRangeTotalId__r.BaseExtendedAmount__c,
						AdjustmentId__c
					FROM LocationDiscountAdjustments__r
				)
			FROM LocationDiscount__c
			WHERE QuoteId__c = :quoteId
			WITH SECURITY_ENFORCED
		];
	}

	private static List<LocationDiscountReviewDto> generateLocationReviewDtos() {
		List<LocationDiscountReviewDto> generatedDtos = new List<LocationDiscountReviewDto>();
		List<String> sampleCountries = new List<String>{
			'United States',
			'India',
			'Afghanistan',
			'Albania',
			'Algeria',
			'Barbados',
			'Belgium',
			'Bolivia'
		};
		List<String> sampleStates = new List<String>{
			'Andhra Pradesh',
			'Assam',
			'Chhattisgarh',
			'Gujarat',
			'Puducherry',
			'Delaware',
			'Florida',
			'Iowa'
		};
		List<String> sampleCities = new List<String>{
			'San Francisco',
			'Boise',
			'Los Angeles',
			'New York City',
			'Miami',
			'Paris',
			'London',
			'Moscow'
		};

		Integer numOfDtos = Integer.valueOf((Math.random() * 15) + 5); // Guarantees at least 5 DTOs, plus up to 15 more.
		String mockLocation;
		for (Integer i = 0; i < numOfDtos; i++) {
			LocationDiscountReviewDto newDto = new LocationDiscountReviewDto();
			// Each DTO will always have a country assigned (for rate match)
			newDto.location = sampleCountries.get(
				Integer.valueOf(Math.random() * (sampleCountries.size() - 1))
			);
			newDto.rateMatch = 'Country';
			// Randomly determine if we are adding a state
			if ((Math.random() * 2) >= 1) {
				newDto.location =
					newDto.location +
					'/' +
					sampleStates.get(Integer.valueOf(Math.random() * (sampleStates.size() - 1)));
				newDto.rateMatch = 'State';
				// Randomly determine if we are adding a city
				if ((Math.random() * 2) >= 1) {
					newDto.location =
						newDto.location +
						'/' +
						sampleCities.get(Integer.valueOf(Math.random() * (sampleCities.size() - 1)));
					newDto.rateMatch = 'City';
				}
			}
			Decimal locationAmt = Math.random() * 100.00;
			newDto.locationAmount = locationAmt.setScale(2, RoundingMode.CEILING);
			// Assign a discount amount anywhere from 0 to 100.
			Decimal discountAmt = Math.random() * 100.00;
			newDto.discountAmount = discountAmt.setScale(2, RoundingMode.CEILING);
			Decimal discountPercentage = Math.random() * 100.00;
			newDto.discountPercentage = discountPercentage.setScale(2, RoundingMode.CEILING);
			Decimal newAmt = Math.random() * 100.00;
			newDto.newAmount = newAmt;

			generatedDtos.add(newDto);
		}

		return generatedDtos;
	}
}
