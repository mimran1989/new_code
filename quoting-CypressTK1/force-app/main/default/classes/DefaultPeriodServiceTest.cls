/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

@IsTest
private class DefaultPeriodServiceTest extends TestBase {
	@IsTest
	static void shouldCreateDaysInWeekSingle() {
		// creation of quote will trigger a call to DefaultPeriodService.generatePeriods for new quote
		Quote__c quoteSO = newQuote();
		quoteSO.ServiceStartDate__c = Date.parse('1/1/2022');
		quoteSO.ServiceEndDate__c = Date.parse('1/7/2022');
		quoteSO.TimePeriod__c = TimePeriodDay.NAME_PLURAL;
		quoteSO.TimePeriodsGroupMethod__c = TimePeriodWeek.NAME;
		CRUDUtility.updateRecords(quoteSO);

		Test.startTest();
		List<QuotePeriodGroup__c> periodGroups = [
			SELECT Id
			FROM QuotePeriodGroup__c
			WHERE QuoteId__c = :quoteSO.Id
		];
		System.assertEquals(1, periodGroups.size(), 'should contain 1 week');
		Integer daysPerWeek = DurationCalcs.numberOfPeriodsInAGroup(
			quoteSO.TimePeriod__c,
			quoteSO.TimePeriodsGroupMethod__c
		);

		Set<Id> periodGroupIds = new Set<Id>();
		for (QuotePeriodGroup__c periodGroup : periodGroups) {
			periodGroupIds.add(periodGroup.Id);
		}
		List<QuotePeriod__c> periods = [
			SELECT Id
			FROM QuotePeriod__c
			WHERE QuotePeriodGroupId__c IN :periodGroupIds
		];
		System.assertEquals(daysPerWeek, periods.size(), 'week should contain ' + daysPerWeek + 'days');
		Test.stopTest();
	}

	@IsTest
	static void shouldCreateDaysInWeeksMultiple() {
		Quote__c quoteSO = newQuote();
		quoteSO.ServiceStartDate__c = Date.parse('1/1/2022');
		quoteSO.ServiceEndDate__c = Date.parse('12/31/2022');
		quoteSO.TimePeriod__c = TimePeriodDay.NAME_PLURAL;
		quoteSO.TimePeriodsGroupMethod__c = TimePeriodWeek.NAME;
		quoteSO.TimePeriodsAlignment__c = 'User Defined Calendar';
		CRUDUtility.updateRecords(quoteSO);

		Test.startTest();
		Map<QuotePeriodGroup__c, List<QuotePeriod__c>> periodsByGroup = DefaultPeriodService.generatePeriods(
			quoteSO
		);

		Integer weeksInYear = DurationCalcs.numberOfPeriodsInAGroup(
			TimePeriodWeek.NAME_PLURAL,
			TimePeriodYear.NAME
		);
		System.assertEquals(
			weeksInYear,
			periodsByGroup.size(),
			'should contain ' +
			weeksInYear +
			' weeks'
		);

		Integer daysInWeeks = DurationCalcs.numberOfPeriodsInAGroup(
			quoteSO.TimePeriod__c,
			quoteSO.TimePeriodsGroupMethod__c
		);
		for (List<QuotePeriod__c> periods : periodsByGroup.values()) {
			System.assertEquals(
				daysInWeeks,
				periods.size(),
				'weeks should contain ' +
				daysInWeeks +
				' days'
			);
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldCreateQuartersInYearSingle() {
		Quote__c quoteSO = newQuote();
		quoteSO.ServiceStartDate__c = Date.parse('1/1/2022');
		quoteSO.ServiceEndDate__c = Date.parse('12/31/2022');
		quoteSO.TimePeriod__c = TimePeriodQuarter.NAME_PLURAL;
		quoteSO.TimePeriodsGroupMethod__c = TimePeriodYear.NAME;
		quoteSO.TimePeriodsAlignment__c = 'User Defined Calendar';
		CRUDUtility.updateRecords(quoteSO);

		Test.startTest();
		Map<QuotePeriodGroup__c, List<QuotePeriod__c>> periodsByGroup = DefaultPeriodService.generatePeriods(
			quoteSO
		);
		System.assertEquals(1, periodsByGroup.size(), 'should contain 1 year');
		Integer quartersInYears = DurationCalcs.numberOfPeriodsInAGroup(
			quoteSO.TimePeriod__c,
			quoteSO.TimePeriodsGroupMethod__c
		);
		for (List<QuotePeriod__c> periods : periodsByGroup.values()) {
			System.assertEquals(
				quartersInYears,
				periods.size(),
				'year should contain ' +
				quartersInYears +
				'quarters'
			);
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldCreateQuartersInYearsMultiple() {
		Quote__c quoteSO = newQuote();
		quoteSO.ServiceStartDate__c = Date.parse('1/1/2022');
		quoteSO.ServiceEndDate__c = Date.parse('12/31/2031');
		quoteSO.TimePeriod__c = TimePeriodQuarter.NAME_PLURAL;
		quoteSO.TimePeriodsGroupMethod__c = TimePeriodYear.NAME;
		quoteSO.TimePeriodsAlignment__c = 'User Defined Calendar';
		CRUDUtility.updateRecords(quoteSO);

		Test.startTest();
		Map<QuotePeriodGroup__c, List<QuotePeriod__c>> periodsByGroup = DefaultPeriodService.generatePeriods(
			quoteSO
		);
		System.assertEquals(10, periodsByGroup.size(), 'should contain 10 years');
		Integer quartersInYears = DurationCalcs.numberOfPeriodsInAGroup(
			quoteSO.TimePeriod__c,
			quoteSO.TimePeriodsGroupMethod__c
		);
		for (List<QuotePeriod__c> periods : periodsByGroup.values()) {
			System.assertEquals(
				quartersInYears,
				periods.size(),
				'years should contain ' +
				quartersInYears +
				'quarters'
			);
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldCreateWeeksInYearSingle() {
		Quote__c quoteSO = newQuote();
		quoteSO.ServiceStartDate__c = Date.parse('1/1/2022');
		quoteSO.ServiceEndDate__c = Date.parse('12/31/2022');
		quoteSO.TimePeriod__c = TimePeriodWeek.NAME_PLURAL;
		quoteSO.TimePeriodsGroupMethod__c = TimePeriodYear.NAME;
		quoteSO.TimePeriodsAlignment__c = 'User Defined Calendar';
		CRUDUtility.updateRecords(quoteSO);

		Test.startTest();
		Map<QuotePeriodGroup__c, List<QuotePeriod__c>> periodsByGroup = DefaultPeriodService.generatePeriods(
			quoteSO
		);
		System.assertEquals(1, periodsByGroup.size(), 'should contain 1 year');
		Integer weeksInAYear = DurationCalcs.numberOfPeriodsInAGroup(
			quoteSO.TimePeriod__c,
			quoteSO.TimePeriodsGroupMethod__c
		);
		for (List<QuotePeriod__c> periods : periodsByGroup.values()) {
			System.assertEquals(
				weeksInAYear,
				periods.size(),
				'years should contain ' +
				weeksInAYear +
				' weeks'
			);
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldCreateWeeksInYearMultipleOffset() {
		Quote__c quoteSO = new Quote__c();
		quoteSO.ServiceStartDate__c = Date.parse('2/15/2022');
		quoteSO.ServiceEndDate__c = Date.parse('2/29/2024');
		quoteSO.TimePeriod__c = TimePeriodWeek.NAME_PLURAL;
		quoteSO.TimePeriodsGroupMethod__c = TimePeriodYear.NAME;
		quoteSO.TimePeriodsAlignment__c = 'User Defined Calendar';
		CRUDUtility.insertRecords(quoteSO);

		Test.startTest();
		List<QuotePeriodGroup__c> quotePeriodGroups = [
			SELECT Id
			FROM QuotePeriodGroup__c
			WHERE QuoteId__c = :quoteSO.Id
		];

		List<QuotePeriod__c> quotePeriodsList1 = [
			SELECT Id
			FROM QuotePeriod__c
			WHERE QuotePeriodGroupId__c = :quotePeriodGroups[0].Id
		];
		List<QuotePeriod__c> quotePeriodsList2 = [
			SELECT Id
			FROM QuotePeriod__c
			WHERE QuotePeriodGroupId__c = :quotePeriodGroups[1].Id
		];
		List<QuotePeriod__c> quotePeriodsList3 = [
			SELECT Id
			FROM QuotePeriod__c
			WHERE QuotePeriodGroupId__c = :quotePeriodGroups[2].Id
		];

		System.assertEquals(3, quotePeriodGroups.size(), 'should contain 3 years');
		System.assertEquals(48, quotePeriodsList1.size(), 'year 1 should contain 48 weeks'); // 2/15/2022 => 2/14/2023
		System.assertEquals(48, quotePeriodsList2.size(), 'year 2 should contain 48 weeks'); // 2/15/2023 => 2/14/2024
		System.assertEquals(3, quotePeriodsList3.size(), 'year 3 should contain 3 weeks'); // 2/15/2024 => 2/29/2024
		Test.stopTest();
	}
}
