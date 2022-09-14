@IsTest
public with sharing class LocationDiscountControllerTest extends TestBase {
	@IsTest
	public static void shouldSaveLocationDiscounts() {
		Quote__c quoteSO = newQuote();
		List<LocationDiscountDto> discountDtos = new List<LocationDiscountDto>();
		LocationDiscountDto cityRateDto = new LocationDiscountDto();
		cityRateDto.country = 'United States';
		cityRateDto.state = 'Florida';
		cityRateDto.city = 'Miami';
		cityRateDto.quoteId = quoteSO.Id;
		discountDtos.add(cityRateDto);

		LocationDiscountDto stateRateDto = new LocationDiscountDto();
		stateRateDto.country = 'United States';
		stateRateDto.state = 'Florida';
		stateRateDto.quoteId = quoteSO.Id;
		discountDtos.add(stateRateDto);

		LocationDiscountDto countryRateDto = new LocationDiscountDto();
		countryRateDto.country = 'United States';
		countryRateDto.quoteId = quoteSO.Id;
		discountDtos.add(countryRateDto);

		LocationDiscountDto globalRateDto = new LocationDiscountDto();
		globalRateDto.quoteId = quoteSO.Id;
		discountDtos.add(globalRateDto);

		Test.startTest();
		LocationDiscountController.saveLocationDiscounts(discountDtos);

		List<LocationDiscountDto> updatedDiscountDtos = LocationDiscountController.getLocationDiscounts(
			quoteSO.Id
		);
		System.assert(updatedDiscountDtos.size() == 4, 'New Dtos should be saved');

		LocationDiscountDto updatedCityRateDto = updatedDiscountDtos.get(0);
		System.assert(updatedCityRateDto.rateMatch == 'City', 'Rate match should be city');

		LocationDiscountDto updatedStateRateDto = updatedDiscountDtos.get(1);
		System.assert(updatedStateRateDto.rateMatch == 'State', 'Rate match should be state');

		LocationDiscountDto updatedCountryRateDto = updatedDiscountDtos.get(2);
		System.assert(updatedCountryRateDto.rateMatch == 'Country', 'Rate match should be country');

		LocationDiscountDto updatedGlobalRateDto = updatedDiscountDtos.get(3);
		System.assert(updatedGlobalRateDto.rateMatch == 'Global', 'Rate match should be global');

		Test.stopTest();
	}
}
