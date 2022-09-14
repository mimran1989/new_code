/**
 *  Provus Services Quoting
 *  QuotePeriodControllerTest
 *  @2022 Provus Inc. All rights reserved.
 */
@IsTest
private class QuotePeriodControllerTest {
	private static final String QUOTE20_PERIODS = 'Quote With 20 periods';

	@TestSetup
	static void testSetup() {
		// CAUTION: quote trigger will automatically create quote periods
		Quote__c quoteSO = new Quote__c(
			Name = 'Add Periods Quote',
			TimePeriodsAlignment__c = 'User Defined Calendar',
			ServiceStartDate__c = Date.parse('5/3/2022'),
			ServiceEndDate__c = Date.parse('5/31/2022'),
			TimePeriod__c = TimePeriodDay.NAME_PLURAL,
			TimePeriodsGroupMethod__c = TimePeriodWeek.NAME
		);

		CRUDUtility.insertRecords(quoteSO);

		Quote__c quoteSO2 = new Quote__c(
			Name = QUOTE20_PERIODS,
			TimePeriodsAlignment__c = 'User Defined Calendar',
			ServiceStartDate__c = Date.parse('5/3/2022'),
			ServiceEndDate__c = Date.parse('6/3/2022'),
			TimePeriod__c = TimePeriodDay.NAME_PLURAL,
			TimePeriodsGroupMethod__c = TimePeriodWeek.NAME
		);

		CRUDUtility.insertRecords(quoteSO2);
	}

	@IsTest
	static void quoteWith21PeriodsAdd2PeriodsToQuoteHas23Periods() {
		Quote__c quote = getQuote(QUOTE20_PERIODS);
		Integer expectedPeriodCount = 23;

		QuoteAddPeriodsArgs quoteAddPeriodsArgs = new QuoteAddPeriodsArgs();
		quoteAddPeriodsArgs.timePeriod = 'Days';
		quoteAddPeriodsArgs.quoteId = quote.Id;
		quoteAddPeriodsArgs.numberOfPeriodsToAdd = 2;

		List<QuoteAddPeriodsArgs> quoteAddPeriodsArgsList = new List<QuoteAddPeriodsArgs>();
		quoteAddPeriodsArgsList.add(quoteAddPeriodsArgs);

		Test.startTest();

		QuotePeriodController.addPeriodsToQuote(quoteAddPeriodsArgsList);

		List<QuotePeriod__c> quotePeriods = [
			SELECT Id, Name, Sequence__c, QuotePeriodGroupId__r.Name
			FROM QuotePeriod__c
			WHERE QuoteId__c = :quote.Id
		];

		System.assertEquals(
			expectedPeriodCount,
			quotePeriods.size(),
			'creates ' +
			expectedPeriodCount +
			' quote period records'
		);

		Integer expectedSequenceCount = 1;

		for (Integer i = 0; i < expectedPeriodCount; i++) {
			QuotePeriod__c quotePeriod = quotePeriods[i];
			System.assertEquals(
				expectedSequenceCount,
				quotePeriod.Sequence__c,
				'expected Sequence__c value to equal ' + expectedSequenceCount
			);
			expectedSequenceCount++;
		}

		Test.stopTest();
	}

	@IsTest
	static void quoteWith18PeriodsAdd2PeriodsToQuoteHas20Periods() {
		Quote__c quote = getQuote('Add Periods Quote');
		Integer expectedPeriodCount = 22;

		QuoteAddPeriodsArgs quoteAddPeriodsArgs = new QuoteAddPeriodsArgs();
		quoteAddPeriodsArgs.timePeriod = 'Days';
		quoteAddPeriodsArgs.quoteId = quote.Id;
		quoteAddPeriodsArgs.numberOfPeriodsToAdd = 2;

		List<QuoteAddPeriodsArgs> quoteAddPeriodsArgsList = new List<QuoteAddPeriodsArgs>();
		quoteAddPeriodsArgsList.add(quoteAddPeriodsArgs);

		Test.startTest();

		QuotePeriodController.addPeriodsToQuote(quoteAddPeriodsArgsList);

		List<QuotePeriod__c> quotePeriods = [
			SELECT Id, Name, Sequence__c, QuotePeriodGroupId__r.Name
			FROM QuotePeriod__c
			WHERE QuoteId__c = :quote.Id
		];

		System.assertEquals(
			expectedPeriodCount,
			quotePeriods.size(),
			'creates ' +
			expectedPeriodCount +
			' quote period records'
		);

		Integer expectedSequenceCount = 1;

		for (Integer i = 0; i < expectedPeriodCount; i++) {
			QuotePeriod__c quotePeriod = quotePeriods[i];
			System.assertEquals(
				expectedSequenceCount,
				quotePeriod.Sequence__c,
				'expected Sequence__c value to equal ' + expectedSequenceCount
			);
			expectedSequenceCount++;
		}

		Test.stopTest();
	}

	private static Quote__c getQuote(String quoteName) {
		Quote__c quote = [
			SELECT Id, TimePeriod__c, TimePeriodsGroupMethod__c, ServiceStartDate__c, ServiceEndDate__c
			FROM Quote__c
			WHERE Name = :quoteName
		];

		return quote;
	}
}
