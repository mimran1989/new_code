/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

@IsTest
private class WeekdayPeriodServiceTest extends TestBase {
	@IsTest
	static void shouldSplitWeekAcrossMonthBoundary() {
		Quote__c quoteSO = new Quote__c();
		quoteSO.ServiceStartDate__c = Date.parse('5/30/2022');
		quoteSO.ServiceEndDate__c = Date.parse('6/3/2022');
		quoteSO.TimePeriodsAlignment__c = QuoteService.TIMEPERIODSALIGNMENT_WEEKDAY_CALENDAR;
		quoteSO.TimePeriod__c = TimePeriodWeek.NAME_PLURAL;
		quoteSO.TimePeriodsGroupMethod__c = TimePeriodMonth.NAME;
		CRUDUtility.insertRecords(quoteSO);

		Test.startTest();
		{
			List<QuotePeriodGroup__c> periodGroups = [
				SELECT Id
				FROM QuotePeriodGroup__c
				WHERE QuoteId__c = :quoteSO.Id
			];
			System.assertEquals(2, periodGroups.size(), 'should contain 2 month period groups');

			List<QuotePeriod__c> periods = [SELECT Id FROM QuotePeriod__c WHERE QuoteId__c = :quoteSO.Id];
			System.assertEquals(
				2,
				periods.size(),
				'should split week into 2 periods when weeks spans across months'
			);
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldNotSplitWeekAcrossMonthBoundaryWhenUsingQuarterGroup() {
		Quote__c quoteSO = new Quote__c();
		quoteSO.ServiceStartDate__c = Date.parse('5/30/2022');
		quoteSO.ServiceEndDate__c = Date.parse('6/3/2022');
		quoteSO.TimePeriodsAlignment__c = QuoteService.TIMEPERIODSALIGNMENT_WEEKDAY_CALENDAR;
		quoteSO.TimePeriod__c = TimePeriodWeek.NAME_PLURAL;
		quoteSO.TimePeriodsGroupMethod__c = TimePeriodQuarter.NAME;
		CRUDUtility.insertRecords(quoteSO);

		Test.startTest();
		{
			List<QuotePeriodGroup__c> periodGroups = [
				SELECT Id
				FROM QuotePeriodGroup__c
				WHERE QuoteId__c = :quoteSO.Id
			];
			System.assertEquals(1, periodGroups.size(), 'should contain 1 quarter period group');

			List<QuotePeriod__c> periods = [SELECT Id FROM QuotePeriod__c WHERE QuoteId__c = :quoteSO.Id];
			System.assertEquals(
				1,
				periods.size(),
				'should contain 1 period group for a week that spans across months'
			);
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldSplitWeekAcrossQuarterBoundary() {
		Quote__c quoteSO = new Quote__c();
		quoteSO.ServiceStartDate__c = Date.parse('3/27/2022');
		quoteSO.ServiceEndDate__c = Date.parse('4/2/2022');
		quoteSO.TimePeriodsAlignment__c = QuoteService.TIMEPERIODSALIGNMENT_WEEKDAY_CALENDAR;
		quoteSO.TimePeriod__c = TimePeriodWeek.NAME_PLURAL;
		quoteSO.TimePeriodsGroupMethod__c = TimePeriodQuarter.NAME;
		CRUDUtility.insertRecords(quoteSO);

		Test.startTest();
		{
			List<QuotePeriodGroup__c> periodGroups = [
				SELECT Id
				FROM QuotePeriodGroup__c
				WHERE QuoteId__c = :quoteSO.Id
			];
			System.assertEquals(2, periodGroups.size(), 'should contain 2 quarter period groups');

			List<QuotePeriod__c> periods = [SELECT Id FROM QuotePeriod__c WHERE QuoteId__c = :quoteSO.Id];
			System.assertEquals(
				2,
				periods.size(),
				'should split week into 2 periods when weeks spans across months'
			);
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldSplitWeekAcrossYearBoundary() {
		Quote__c quoteSO = new Quote__c();
		quoteSO.ServiceStartDate__c = Date.parse('12/30/2024');
		quoteSO.ServiceEndDate__c = Date.parse('1/3/2025');
		quoteSO.TimePeriodsAlignment__c = QuoteService.TIMEPERIODSALIGNMENT_WEEKDAY_CALENDAR;
		quoteSO.TimePeriod__c = TimePeriodWeek.NAME_PLURAL;
		quoteSO.TimePeriodsGroupMethod__c = TimePeriodYear.NAME;
		CRUDUtility.insertRecords(quoteSO);

		Test.startTest();
		{
			List<QuotePeriodGroup__c> periodGroups = [
				SELECT Id
				FROM QuotePeriodGroup__c
				WHERE QuoteId__c = :quoteSO.Id
			];
			System.assertEquals(2, periodGroups.size(), 'should contain 2 year period groups');

			List<QuotePeriod__c> periods = [SELECT Id FROM QuotePeriod__c WHERE QuoteId__c = :quoteSO.Id];
			System.assertEquals(
				2,
				periods.size(),
				'should split week into 2 periods when weeks spans across years'
			);
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldContain12MonthsInAYear() {
		Quote__c quoteSO = new Quote__c();
		quoteSO.ServiceStartDate__c = Date.parse('1/1/2022');
		quoteSO.ServiceEndDate__c = Date.parse('12/31/2022');
		quoteSO.TimePeriodsAlignment__c = QuoteService.TIMEPERIODSALIGNMENT_WEEKDAY_CALENDAR;
		quoteSO.TimePeriod__c = TimePeriodMonth.NAME_PLURAL;
		quoteSO.TimePeriodsGroupMethod__c = TimePeriodYear.NAME;
		CRUDUtility.insertRecords(quoteSO);

		Test.startTest();
		{
			List<QuotePeriodGroup__c> periodGroups = [
				SELECT Id
				FROM QuotePeriodGroup__c
				WHERE QuoteId__c = :quoteSO.Id
			];
			System.assertEquals(1, periodGroups.size(), 'should contain 1 year period group');

			List<QuotePeriod__c> periods = [SELECT Id FROM QuotePeriod__c WHERE QuoteId__c = :quoteSO.Id];
			System.assertEquals(12, periods.size(), 'should contain 12 months for the year');
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldContain4QuartersInAYear() {
		Quote__c quoteSO = new Quote__c();
		quoteSO.ServiceStartDate__c = Date.parse('1/1/2022');
		quoteSO.ServiceEndDate__c = Date.parse('12/31/2022');
		quoteSO.TimePeriodsAlignment__c = QuoteService.TIMEPERIODSALIGNMENT_WEEKDAY_CALENDAR;
		quoteSO.TimePeriod__c = TimePeriodQuarter.NAME_PLURAL;
		quoteSO.TimePeriodsGroupMethod__c = TimePeriodYear.NAME;
		CRUDUtility.insertRecords(quoteSO);

		Test.startTest();
		{
			List<QuotePeriodGroup__c> periodGroups = [
				SELECT Id
				FROM QuotePeriodGroup__c
				WHERE QuoteId__c = :quoteSO.Id
			];
			System.assertEquals(1, periodGroups.size(), 'should contain 1 year period group');

			List<QuotePeriod__c> periods = [SELECT Id FROM QuotePeriod__c WHERE QuoteId__c = :quoteSO.Id];
			System.assertEquals(4, periods.size(), 'should contain 4 quarters for the year');
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldContain5WeekdaysInAWeek() {
		Quote__c quoteSO = new Quote__c();
		quoteSO.ServiceStartDate__c = Date.parse('1/2/2022');
		quoteSO.ServiceEndDate__c = Date.parse('1/8/2022');
		quoteSO.TimePeriodsAlignment__c = QuoteService.TIMEPERIODSALIGNMENT_WEEKDAY_CALENDAR;
		quoteSO.TimePeriod__c = TimePeriodDay.NAME_PLURAL;
		quoteSO.TimePeriodsGroupMethod__c = TimePeriodWeek.NAME;
		CRUDUtility.insertRecords(quoteSO);

		Test.startTest();
		{
			List<QuotePeriodGroup__c> periodGroups = [
				SELECT Id
				FROM QuotePeriodGroup__c
				WHERE QuoteId__c = :quoteSO.Id
			];
			System.assertEquals(1, periodGroups.size(), 'should contain 1 week period group');

			List<QuotePeriod__c> periods = [SELECT Id FROM QuotePeriod__c WHERE QuoteId__c = :quoteSO.Id];
			System.assertEquals(5, periods.size(), 'should contain 5 day periods for the week');
		}
		Test.stopTest();
	}
}
