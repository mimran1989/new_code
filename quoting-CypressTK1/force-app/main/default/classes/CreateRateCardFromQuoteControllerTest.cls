@IsTest
public with sharing class CreateRateCardFromQuoteControllerTest extends TestBase {
	private static Quote__c setup() {
		Quote__c quote = TestBase.newQuote();
		quote.ServiceStartDate__c = Date.valueOf('2021-01-01');
		quote.ServiceEndDate__c = Date.valueOf('2021-12-31');
		quote.TimePeriod__c = TimePeriodDay.NAME_PLURAL;
		CRUDUtility.updateRecords(quote);

		Id recordTypeId = Schema.SObjectType.Product__c.getRecordTypeInfosByName()
			.get('Resource Role')
			.getRecordTypeId();
		Product__c resource = TestDataFactory.createResource('Software Engineer', recordTypeId);

		RateCardAttributeGroup__c rateCardAttributeGroup = TestBase.newRateCardAttributeGroup();
		RateCard__c rateCard = TestBase.newRateCard();
		rateCard.AttributeGroupId__c = rateCardAttributeGroup.Id;
		CRUDUtility.updateRecords(rateCard);

		TestBase.newRateCardAttribute(rateCardAttributeGroup.Id);
		RateCardItem__c rateCardItem = TestBase.newRateCardItem(rateCard.Id, resource.Id);
		rateCardItem.IsActive__c = true;
		rateCardItem.LocationCity__c = 'San Jose';
		rateCardItem.LocationStateProvince__c = 'California';
		rateCardItem.LocationDisplayName__c = 'United States/California/San Jose';
		rateCardItem.LocationCountry__c = 'United States';
		rateCardItem.PriceUOM__c = 'Daily';
		rateCardItem.UnitCost__c = 100;
		rateCardItem.UnitPrice__c = 200;
		CRUDUtility.updateRecords(rateCardItem);

		QuoteItem__c newQuoteItem = new QuoteItem__c(
			QuoteId__c = quote.Id,
			UnitCost__c = 100,
			UnitPrice__c = 200,
			AdjustedUnitPrice__c = 150,
			ProductId__c = resource.Id,
			RateCardItemId__c = rateCardItem.Id
		);

		CRUDUtility.insertRecords(newQuoteItem);

		return quote;
	}

	@IsTest
	public static void itShouldCreateRateCard() {
		Quote__c quote = setup();
		String rateCardName = 'Rate Card ' + quote.Id;
		Test.startTest();
		RateCard__c newRateCard = CreateRateCardFromQuoteController.createRateCardFromQuoteId(
			createRateCardFromQuoteArgs(quote, rateCardName)
		);
		System.assertEquals(newRateCard.Name, rateCardName, 'expected new rate card record created');
		Test.stopTest();
	}

	@IsTest
	public static void itShouldCreateRateCardQuote() {
		Quote__c quote = setup();
		String rateCardName = 'Rate Card ' + quote.Id;
		Test.startTest();
		CreateRateCardFromQuoteController.createRateCardFromQuoteId(
			createRateCardFromQuoteArgs(quote, rateCardName)
		);

		List<RateCard__c> rateCartQuotes = CreateRateCardFromQuoteController.getRateCardByQuoteId(
			quote.Id
		);

		System.assertEquals(1, rateCartQuotes.size(), 'expected new rate card quote record created');
		Test.stopTest();
	}

	@IsTest
	public static void itShouldCreateRateCardItems() {
		Quote__c quote = setup();
		String rateCardName = 'Rate Card ' + quote.Id;
		Test.startTest();
		RateCard__c newRateCard = CreateRateCardFromQuoteController.createRateCardFromQuoteId(
			createRateCardFromQuoteArgs(quote, rateCardName)
		);

		List<RateCardItem__c> rateCardItems = [
			SELECT Id, Name
			FROM RateCardItem__c
			WHERE RateCardId__c = :newRateCard.Id
		];

		System.assertEquals(1, rateCardItems.size(), 'expected new rate card item created');
		Test.stopTest();
	}

	@IsTest
	public static void itShouldCreateRateCardItemsDailyPriceUom() {
		Quote__c quote = setup();
		String rateCardName = 'Rate Card ' + quote.Id;
		Test.startTest();
		RateCard__c newRateCard = CreateRateCardFromQuoteController.createRateCardFromQuoteId(
			createRateCardFromQuoteArgs(quote, rateCardName)
		);

		List<RateCardItem__c> rateCardItems = [
			SELECT Id, Name, PriceUom__c, UnitPrice__c
			FROM RateCardItem__c
			WHERE RateCardId__c = :newRateCard.Id
		];

		System.assertEquals(1, rateCardItems.size(), 'expected new rate card item created');
		System.assertEquals(
			RateCardItem.PRICEUOM_DAILY,
			rateCardItems[0].PriceUom__c,
			'expected PriceUom=Daily'
		);
		System.assertEquals(
			150,
			rateCardItems[0].UnitPrice__c,
			'expected new rate card item unit price = 150'
		);
		Test.stopTest();
	}

	@IsTest
	public static void itShouldCreateRateCardItemsMonthPriceUom() {
		Quote__c quote = setup();
		quote.TimePeriod__c = TimePeriodMonth.NAME_PLURAL;
		CRUDUtility.updateRecords(quote);
		String rateCardName = 'Rate Card ' + quote.Id;
		Test.startTest();
		RateCard__c newRateCard = CreateRateCardFromQuoteController.createRateCardFromQuoteId(
			createRateCardFromQuoteArgs(quote, rateCardName)
		);

		List<RateCardItem__c> rateCardItems = [
			SELECT Id, Name, PriceUom__c, UnitPrice__c
			FROM RateCardItem__c
			WHERE RateCardId__c = :newRateCard.Id
		];

		System.assertEquals(1, rateCardItems.size(), 'expected new rate card item created');
		System.assertEquals(
			RateCardItem.PRICEUOM_MONTHLY,
			rateCardItems[0].PriceUom__c,
			'expected PriceUom=Monthly'
		);
		System.assertEquals(
			150,
			rateCardItems[0].UnitPrice__c,
			'expected new rate card item unit price = 150'
		);
		Test.stopTest();
	}

	@IsTest
	public static void itShouldCreateRateCardItemsQuarterPriceUom() {
		Quote__c quote = setup();
		quote.TimePeriod__c = TimePeriodQuarter.NAME_PLURAL;
		CRUDUtility.updateRecords(quote);
		String rateCardName = 'Rate Card ' + quote.Id;
		Test.startTest();
		RateCard__c newRateCard = CreateRateCardFromQuoteController.createRateCardFromQuoteId(
			createRateCardFromQuoteArgs(quote, rateCardName)
		);

		List<RateCardItem__c> rateCardItems = [
			SELECT Id, Name, PriceUom__c, UnitPrice__c
			FROM RateCardItem__c
			WHERE RateCardId__c = :newRateCard.Id
		];

		System.assertEquals(1, rateCardItems.size(), 'expected new rate card item created');
		System.assertEquals(
			RateCardItem.PRICEUOM_MONTHLY,
			rateCardItems[0].PriceUom__c,
			'expected PriceUom=Monthly'
		);
		System.assertEquals(
			50,
			rateCardItems[0].UnitPrice__c,
			'expected new rate card item unit price = 50 (quarter/3)'
		);
		Test.stopTest();
	}

	@IsTest
	public static void itShouldCreateRateCardItemsWeekPriceUom() {
		Quote__c quote = setup();
		quote.TimePeriod__c = TimePeriodWeek.NAME_PLURAL;
		CRUDUtility.updateRecords(quote);
		String rateCardName = 'Rate Card ' + quote.Id;
		Test.startTest();
		RateCard__c newRateCard = CreateRateCardFromQuoteController.createRateCardFromQuoteId(
			createRateCardFromQuoteArgs(quote, rateCardName)
		);

		List<RateCardItem__c> rateCardItems = [
			SELECT Id, Name, PriceUom__c, UnitPrice__c
			FROM RateCardItem__c
			WHERE RateCardId__c = :newRateCard.Id
		];

		System.assertEquals(1, rateCardItems.size(), 'expected new rate card item created');
		System.assertEquals(
			RateCardItem.PRICEUOM_WEEKLY,
			rateCardItems[0].PriceUom__c,
			'expected PriceUom=Weekly'
		);
		System.assertEquals(
			150,
			rateCardItems[0].UnitPrice__c,
			'expected new rate card item unit price = 150'
		);
		Test.stopTest();
	}

	private static RateCardFromQuoteArgs createRateCardFromQuoteArgs(
		Quote__c quote,
		String rateCardName
	) {
		RateCardFromQuoteArgs args = new RateCardFromQuoteArgs();
		args.quoteId = quote.Id;
		args.rateCardName = rateCardName;
		args.effectiveDate = quote.ServiceStartDate__c;
		args.expirationDate = quote.ServiceEndDate__c;
		args.duplicateStrategy = 'Highest';
		return args;
	}
}
