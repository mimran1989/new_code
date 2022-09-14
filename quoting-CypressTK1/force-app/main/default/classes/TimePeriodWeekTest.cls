/**
 *  Provus Services Quoting
 *  TimePeriodWeekTest
 *  @2022 Provus Inc. All rights reserved.
 */
@IsTest
private class TimePeriodWeekTest {
	@IsTest
	static void itshouldRequire23Periods() {
		Date startDate = Date.newInstance(2022, 1, 1);
		Date endDate = Date.newInstance(2022, 6, 16);

		Test.startTest();
		TimePeriodWeek periodCalculator = new TimePeriodWeek();
		Integer numberOfPeriods = periodCalculator.numberOfPeriods(startDate, endDate);
		System.assertEquals(23, numberOfPeriods, 'should require 23 periods');
	}

	@IsTest
	static void itshouldRequire4PeriodsWhenDurationIsWithinOneMonth() {
		Date startDate = Date.newInstance(2022, 1, 10);
		Date endDate = Date.newInstance(2022, 2, 9);

		Test.startTest();
		TimePeriodWeek periodCalculator = new TimePeriodWeek();
		Integer numberOfPeriods = periodCalculator.numberOfPeriods(startDate, endDate);
		System.assertEquals(4, numberOfPeriods, 'should require 4 periods');
	}

	@IsTest
	static void itShouldGenerateNameAsWeekPlusSequenceNumber() {
		Test.startTest();
		TimePeriodWeek periodCalculator = new TimePeriodWeek();
		System.assertEquals(
			'Week 1',
			periodCalculator.generatePeriodName(null, null, 1),
			'should format the period as Week 1'
		);
		System.assertEquals(
			'Week 2',
			periodCalculator.generatePeriodName(null, null, 2),
			'should format the period as Week 2'
		);
		System.assertEquals(
			'Week 10',
			periodCalculator.generatePeriodName(null, null, 10),
			'should format the period as Week 10'
		);
	}

	@IsTest
	static void itShouldCalculateTheEndPeriodAsSevenDaysOut() {
		Date periodStartDate = Date.newInstance(2022, 1, 10);

		Test.startTest();
		TimePeriodWeek periodCalculator = new TimePeriodWeek();
		Date calculatedEndDate = periodCalculator.calculatePeriodEndDate(null, periodStartDate, 1);
		System.assertEquals(
			Date.newInstance(2022, 1, 16),
			calculatedEndDate,
			'should calculate end date of 1/16/2022'
		);
	}

	@IsTest
	static void itShouldAlignEndDateToMonthsEnd() {
		Date serviceStartDate = Date.newInstance(2022, 1, 10);
		Date periodStartDate = Date.newInstance(2022, 1, 31);
		Integer sequenceNumber = 4; // default schedule setting weeks per month is 4, so month end is on week 4

		Test.startTest();
		TimePeriodWeek periodCalculator = new TimePeriodWeek();
		Date calculatedEndDate = periodCalculator.calculatePeriodEndDate(
			serviceStartDate,
			periodStartDate,
			sequenceNumber
		);
		System.assertEquals(
			Date.newInstance(2022, 2, 9),
			calculatedEndDate,
			'should calculate period end date of 2/9/2022'
		);
	}

	@IsTest
	static void itShouldCalculateStartDateAsOneDayAfterPeriodEndDate() {
		Date periodEndDate = Date.newInstance(2022, 2, 1);
		Integer sequenceNumber = 1;

		Test.startTest();
		TimePeriodWeek periodCalculator = new TimePeriodWeek();
		Date calculatedStartDate = periodCalculator.nextStartDate(null, periodEndDate, sequenceNumber);
		System.assertEquals(
			Date.newInstance(2022, 2, 2),
			calculatedStartDate,
			'should calculate start date of 2/2/2022'
		);
	}
}
