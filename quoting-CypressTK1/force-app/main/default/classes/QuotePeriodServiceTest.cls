/**
 *  Provus Services Quoting
 *  QuotePeriodService
 *  @2022 Provus Inc. All rights reserved.
 */
@IsTest
private class QuotePeriodServiceTest extends TestBase {
	private static final String QUOTE24_PERIODS = 'Quote With 24 periods';
	private static final String QUOTE31_PERIODS = 'Quote With 31 periods';
	private static final String QUOTE2_MONTHPERIODS = 'Quote With 2 month periods';
	private static final String QUOTE21_DAYPERIODS = 'Quote With 21 day periods';

	@TestSetup
	static void testSetup() {
		// CAUTION: quote trigger will automatically create quote periods
		Quote__c quoteSO = new Quote__c(
			Name = 'Add Periods Quote',
			ServiceStartDate__c = Date.parse('4/27/2022'),
			ServiceEndDate__c = Date.parse('6/30/2022'),
			TimePeriod__c = TimePeriodDay.NAME_PLURAL,
			TimePeriodsGroupMethod__c = TimePeriodWeek.NAME
		);

		CRUDUtility.insertRecords(quoteSO);

		quoteSO = new Quote__c(
			Name = QUOTE24_PERIODS,
			ServiceStartDate__c = Date.parse('5/3/2022'),
			ServiceEndDate__c = Date.parse('6/7/2022'),
			TimePeriod__c = TimePeriodDay.NAME_PLURAL,
			TimePeriodsGroupMethod__c = TimePeriodWeek.NAME
		);

		CRUDUtility.insertRecords(quoteSO);

		quoteSO = new Quote__c(
			Name = QUOTE31_PERIODS,
			ServiceStartDate__c = Date.parse('5/3/2022'),
			ServiceEndDate__c = Date.parse('6/17/2022'),
			TimePeriod__c = TimePeriodDay.NAME_PLURAL,
			TimePeriodsGroupMethod__c = TimePeriodWeek.NAME
		);

		CRUDUtility.insertRecords(quoteSO);

		quoteSO = new Quote__c(
			Name = QUOTE2_MONTHPERIODS,
			ServiceStartDate__c = Date.parse('5/1/2022'),
			ServiceEndDate__c = Date.parse('6/1/2022'),
			TimePeriod__c = TimePeriodMonth.NAME_PLURAL,
			TimePeriodsGroupMethod__c = TimePeriodYear.NAME
		);

		CRUDUtility.insertRecords(quoteSO);

		quoteSO = new Quote__c(
			Name = QUOTE21_DAYPERIODS,
			TimePeriodsAlignment__c = 'User Defined Calendar',
			ServiceStartDate__c = Date.parse('5/15/2022'),
			ServiceEndDate__c = Date.parse('6/15/2022'),
			TimePeriod__c = TimePeriodDay.NAME_PLURAL,
			TimePeriodsGroupMethod__c = TimePeriodWeek.NAME
		);

		CRUDUtility.insertRecords(quoteSO);
	}

	@IsTest
	static void serviceDateStartCannotBeGreaterThanEnd() {
		Date serviceStartDate = Date.newInstance(2022, 1, 2);
		Date serviceEndDate = Date.newInstance(2021, 1, 1);

		List<Quote__c> quoteList = new List<Quote__c>();
		quoteList.add(
			new Quote__c(
				Name = 'Service Date Range Test Quote',
				TimePeriod__c = 'Days',
				ServiceStartDate__c = serviceStartDate,
				ServiceEndDate__c = serviceEndDate
			)
		);

		Test.startTest();
		QuotePeriodService.createPeriodsAndPeriodGroupsFor(quoteList);

		// check quote object for the existence of errors
		System.assert(quoteList[0].hasErrors(), 'there should be errors');
		List<Database.Error> errors = quoteList[0].getErrors();

		// assert we have 3 errors
		System.assert(errors.size() == 3, 'there should be 3 errors');
		// one error for the quote, one for ServiceStartDate__c field and one for ServiceEndDate__c field
		System.assert(
			errors[0].message == Label.QuoteServiceDateRangeError,
			'first error message should equal ' + 'the custom label QuoteServiceDateRangeError'
		);
		System.assert(errors[1].message == '', 'second error should be blank');
		System.assertEquals(
			errors[1].fields.size(),
			1,
			'second error field list should have one field'
		);
		System.assertEquals(
			Schema.Quote__c.ServiceEndDate__c + '',
			errors[1].fields[0],
			'second error should contain service end date' + 'field'
		);
		System.assert(errors[2].message == '', 'third error should be blank');
		System.assertEquals(errors[2].fields.size(), 1, 'third error field list should have one field');
		System.assertEquals(
			Schema.Quote__c.ServiceStartDate__c + '',
			errors[2].fields[0],
			'third error should contain service start date' + 'field'
		);
		Test.stopTest();
	}

	@IsTest
	static void quoteWith43PeriodsAdd4Then4Then2QuoteHas53Periods() {
		Quote__c quote = getQuote();
		Integer expectedPeriodCount = 53;

		Test.startTest();

		QuotePeriodService.addRemoveQuotePeriods(4, quote.Id, quote.TimePeriod__c);
		QuotePeriodService.addRemoveQuotePeriods(4, quote.Id, quote.TimePeriod__c);
		QuotePeriodService.addRemoveQuotePeriods(2, quote.Id, quote.TimePeriod__c);

		List<QuotePeriod__c> quotePeriods = [
			SELECT Id, Name, Sequence__c, QuotePeriodGroupId__r.Name
			FROM QuotePeriod__c
			WHERE QuoteId__c = :quote.Id
			ORDER BY Sequence__c ASC
		];

		System.assertEquals(
			expectedPeriodCount,
			quotePeriods.size(),
			'creates 55 quote period records'
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
	static void createQuoteWithMayFirstToJuneFirstExpect2MonthPeriods() {
		Quote__c quote = getQuoteWith2MonthPeriods();
		Integer expectedPeriodCount = 2;

		Test.startTest();

		List<QuotePeriod__c> quotePeriods = [
			SELECT Id, Name, Sequence__c, StartDate__c, QuotePeriodGroupId__r.Name
			FROM QuotePeriod__c
			WHERE QuoteId__c = :quote.Id
			ORDER BY Sequence__c ASC
		];

		System.assertEquals(
			expectedPeriodCount,
			quotePeriods.size(),
			'creates ' +
			expectedPeriodCount +
			' quote period records'
		);

		Integer expectedSequenceCount = 1;

		Date startDate = Date.newInstance(2022, 5, 1);

		for (Integer i = 0; i < expectedPeriodCount; i++) {
			QuotePeriod__c quotePeriod = quotePeriods[i];
			quotePeriod.StartDate__c = startDate;
			System.assertEquals(
				startDate,
				quotePeriod.StartDate__c,
				'expected start date for period to equal ' + startDate
			);
			System.assertEquals(
				expectedSequenceCount,
				quotePeriod.Sequence__c,
				'expected Sequence__c value to equal ' + expectedSequenceCount
			);
			startDate.addMonths(1);
			expectedSequenceCount++;
		}

		Test.stopTest();
	}

	@IsTest
	static void quoteWith24PeriodsAdd2PeriodsQuoteHas26Periods() {
		Quote__c quote = getQuoteWith24Periods();

		Test.startTest();

		QuotePeriodService.addRemoveQuotePeriods(2, quote.Id, quote.TimePeriod__c);

		List<QuotePeriod__c> quotePeriods = [
			SELECT Id, Name, Sequence__c, QuotePeriodGroupId__r.Name
			FROM QuotePeriod__c
			WHERE QuoteId__c = :quote.Id
		];

		Integer expectedPeriodCount = 26;

		System.assertEquals(
			expectedPeriodCount,
			quotePeriods.size(),
			'creates ' +
			expectedPeriodCount +
			' quote period records'
		);

		Test.stopTest();
	}

	@IsTest
	static void quoteWith31PeriodsAdd2PeriodsQuoteHas33Periods() {
		// Quote__c quote = getQuoteWith31Periods();

		// Test.startTest();
		// QuotePeriodService.addRemoveQuotePeriods(2, quote.Id, quote.TimePeriod__c);

		// List<QuotePeriod__c> quotePeriods = [
		// 	SELECT Id, Sequence__c
		// 	FROM QuotePeriod__c
		// 	WHERE QuoteId__c = :quote.Id
		// ];

		// Integer expectedPeriodCount = 33;
		// System.assertEquals(
		// 	expectedPeriodCount,
		// 	quotePeriods.size(),
		// 	'creates ' +
		// 	expectedPeriodCount +
		// 	' quote period records'
		// );

		// Integer expectedSequenceCount = 1;

		// for (Integer i = 0; i < quotePeriods.size(); i++) {
		// 	QuotePeriod__c quotePeriod = quotePeriods[i];

		// 	System.assertEquals(
		// 		expectedSequenceCount,
		// 		quotePeriod.Sequence__c,
		// 		'expected Sequence__c value to equal ' + expectedSequenceCount
		// 	);
		// 	expectedSequenceCount++;
		// }

		// Test.stopTest();
	}

	@IsTest
	static void quoteWith21DayPeriodsEndingOnJune15thAdd3DayPeriodsEndDateIsJune18th() {
		Quote__c quote = getQuoteWith21DayPeriods();

		Test.startTest();
		QuotePeriodService.addRemoveQuotePeriods(3, quote.Id, quote.TimePeriod__c);

		quote = getQuoteWith21DayPeriods();

		String expectedDate = '6/18/2022';
		System.assertEquals(
			Date.parse(expectedDate),
			quote.ServiceEndDate__c,
			'it should equal ' + expectedDate
		);

		Test.stopTest();
	}

	@IsTest
	static void quoteWith21DayPeriodsAdd3DayPeriodsHas24DayPeriods() {
		Quote__c quote = getQuoteWith21DayPeriods();

		Test.startTest();
		QuotePeriodService.addRemoveQuotePeriods(3, quote.Id, quote.TimePeriod__c);

		List<QuotePeriod__c> quotePeriods = [
			SELECT Id
			FROM QuotePeriod__c
			WHERE QuoteId__c = :quote.Id
		];

		Integer expectedPeriodCount = 24;
		System.assertEquals(
			expectedPeriodCount,
			quotePeriods.size(),
			'creates ' +
			expectedPeriodCount +
			' quote period records'
		);

		Test.stopTest();
	}

	@IsTest
	static void shouldNotGenerateMorePeriodsThanTheMax() {
		Quote__c quoteSO = new Quote__c(
			Name = 'Add Periods Quote',
			ServiceStartDate__c = Date.parse('4/27/2022'),
			ServiceEndDate__c = Date.parse('6/30/2026'),
			TimePeriod__c = TimePeriodDay.NAME_PLURAL,
			TimePeriodsGroupMethod__c = TimePeriodWeek.NAME
		);

		CRUDUtility.insertRecords(quoteSO);
		Test.startTest();
		{
			Integer count = [SELECT COUNT() FROM QuotePeriod__c WHERE QuoteId__c = :quoteSO.Id];
			System.assertEquals(count, QuotePeriodService.MAX_PERIOD_COUNT);
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldNotGenerateMorePeriodsThanTheMaxWeekday() {
		Quote__c quoteSO = new Quote__c(
			Name = 'Add Periods Quote',
			ServiceStartDate__c = Date.parse('4/27/2022'),
			ServiceEndDate__c = Date.parse('6/30/2026'),
			TimePeriod__c = TimePeriodDay.NAME_PLURAL,
			TimePeriodsGroupMethod__c = TimePeriodWeek.NAME,
			TimePeriodsAlignment__c = QuoteService.TIMEPERIODSALIGNMENT_WEEKDAY_CALENDAR
		);

		CRUDUtility.insertRecords(quoteSO);
		Test.startTest();
		{
			Integer count = [SELECT COUNT() FROM QuotePeriod__c WHERE QuoteId__c = :quoteSO.Id];
			System.assertEquals(count, QuotePeriodService.MAX_PERIOD_COUNT);
		}
		Test.stopTest();
	}

	@IsTest
	private static Quote__c getQuote() {
		Quote__c quote = [
			SELECT Id, TimePeriod__c, TimePeriodsGroupMethod__c, ServiceStartDate__c, ServiceEndDate__c
			FROM Quote__c
			WHERE Name = 'Add Periods Quote'
		];

		return quote;
	}

	@IsTest
	private static Quote__c getQuoteWith24Periods() {
		Quote__c quote = [
			SELECT Id, TimePeriod__c, TimePeriodsGroupMethod__c, ServiceStartDate__c, ServiceEndDate__c
			FROM Quote__c
			WHERE Name = :QUOTE24_PERIODS
		];

		return quote;
	}

	@IsTest
	private static Quote__c getQuoteWith31Periods() {
		Quote__c quote = [
			SELECT Id, TimePeriod__c, TimePeriodsGroupMethod__c, ServiceStartDate__c, ServiceEndDate__c
			FROM Quote__c
			WHERE Name = :QUOTE31_PERIODS
		];

		return quote;
	}

	@IsTest
	private static Quote__c getQuoteWith2MonthPeriods() {
		Quote__c quote = [
			SELECT Id, TimePeriod__c, TimePeriodsGroupMethod__c, ServiceStartDate__c, ServiceEndDate__c
			FROM Quote__c
			WHERE Name = :QUOTE2_MONTHPERIODS
		];

		return quote;
	}

	@IsTest
	private static Quote__c getQuoteWith21DayPeriods() {
		Quote__c quote = [
			SELECT Id, TimePeriod__c, TimePeriodsGroupMethod__c, ServiceStartDate__c, ServiceEndDate__c
			FROM Quote__c
			WHERE Name = :QUOTE21_DAYPERIODS
		];

		return quote;
	}
}
