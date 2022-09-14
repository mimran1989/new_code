/**
 *  Provus Services Quoting
 *  TimePeriodDayTest
 *  @2022 Provus Inc. All rights reserved.
 */
@IsTest
private class TimePeriodDayTest {
	@IsTest
	static void itshouldRequire240PeriodsForYear() {
		Date startDate = Date.newInstance(2022, 1, 1);
		Date endDate = Date.newInstance(2022, 12, 31);

		Test.startTest();
		TimePeriodDay periodCalculator = new TimePeriodDay();
		Integer numberOfPeriods = periodCalculator.numberOfPeriods(startDate, endDate);
		System.assertEquals(240, numberOfPeriods, 'should require 240 periods');
	}

	@IsTest
	static void itshouldRequire20PeriodsForMonth() {
		Date startDate = Date.newInstance(2022, 1, 1);
		Date endDate = Date.newInstance(2022, 1, 31);

		Test.startTest();
		TimePeriodDay periodCalculator = new TimePeriodDay();
		Integer numberOfPeriods = periodCalculator.numberOfPeriods(startDate, endDate);
		System.assertEquals(20, numberOfPeriods, 'should require 20 periods');
	}

	@IsTest
	static void itshouldRequire5PeriodsForWeek() {
		Date startDate = Date.newInstance(2022, 1, 1);
		Date endDate = Date.newInstance(2022, 1, 6);

		Test.startTest();
		TimePeriodDay periodCalculator = new TimePeriodDay();
		Integer numberOfPeriods = periodCalculator.numberOfPeriods(startDate, endDate);
		System.assertEquals(5, numberOfPeriods, 'should require 5 periods');
	}

	@IsTest
	static void itShouldReturn2Periods() {
		Date startDate = Date.newInstance(2022, 6, 8);
		Date endDate = Date.newInstance(2022, 6, 9);

		Test.startTest();
		TimePeriodDay periodCalculator = new TimePeriodDay();
		Integer numberOfPeriods = periodCalculator.numberOfPeriods(startDate, endDate);
		System.assertEquals(2, numberOfPeriods, 'should require 2 periods');
	}

	@IsTest
	static void itShouldReturn43Periods() {
		Integer expectedPeriodCount = 43;
		Date startDate = Date.newInstance(2022, 4, 27);
		Date endDate = Date.newInstance(2022, 6, 30);

		Test.startTest();
		TimePeriodDay periodCalculator = new TimePeriodDay();
		Integer numberOfPeriods = periodCalculator.numberOfPeriods(startDate, endDate);
		System.assertEquals(
			expectedPeriodCount,
			numberOfPeriods,
			'should require ' +
			expectedPeriodCount +
			' periods'
		);
	}

	@IsTest
	static void itshouldRequire22Periods() {
		Date startDate = Date.newInstance(2022, 1, 1);
		Date endDate = Date.newInstance(2022, 2, 2);

		Test.startTest();
		TimePeriodDay periodCalculator = new TimePeriodDay();
		Integer numberOfPeriods = periodCalculator.numberOfPeriods(startDate, endDate);
		System.assertEquals(22, numberOfPeriods, 'should require 22 periods');
	}

	@IsTest
	static void itshouldRequire1PeriodWhenDatesAreInFebruary() {
		Date startDate = Date.newInstance(2022, 2, 1);
		Date endDate = Date.newInstance(2022, 3, 2);

		Test.startTest();
		TimePeriodDay periodCalculator = new TimePeriodDay();
		Integer numberOfPeriods = periodCalculator.numberOfPeriods(startDate, endDate);
		System.assertEquals(22, numberOfPeriods, 'should require 22 periods');
	}

	@IsTest
	static void itShouldGenerateNameAsDayPlusSequenceNumber() {
		Test.startTest();
		TimePeriodDay periodCalculator = new TimePeriodDay();
		System.assertEquals(
			'Day 1',
			periodCalculator.generatePeriodName(null, null, 1),
			'should format the period as Day 1'
		);
		System.assertEquals(
			'Day 2',
			periodCalculator.generatePeriodName(null, null, 2),
			'should format the period as Day 2'
		);
		System.assertEquals(
			'Day 10',
			periodCalculator.generatePeriodName(null, null, 10),
			'should format the period as Day 10'
		);
	}

	@IsTest
	static void itShouldCalculateTheEndPeriodAsTheSameAsTheStartPeriod() {
		Date periodStartDate = Date.newInstance(2022, 1, 2);

		Test.startTest();
		TimePeriodDay periodCalculator = new TimePeriodDay();
		Date calculatedEndDate = periodCalculator.calculatePeriodEndDate(null, periodStartDate, 1);
		System.assertEquals(
			periodStartDate,
			calculatedEndDate,
			'should calculate end date of 2/1/2022'
		);

		// advance out 10 days and re-check
		periodStartDate.addDays(10);
		calculatedEndDate = periodCalculator.calculatePeriodEndDate(null, periodStartDate, 9);
		System.assertEquals(
			periodStartDate,
			calculatedEndDate,
			'should calculate end date of 2/11/2022'
		);
	}

	@IsTest
	static void itShouldAddOneDayToEndDate() {
		Date serviceStartDate = Date.newInstance(2022, 2, 1);
		Date periodStartDate = Date.newInstance(2022, 2, 1);
		Integer sequenceNumber = 1;

		Test.startTest();
		TimePeriodDay periodCalculator = new TimePeriodDay();
		Date calculatedStartDate = periodCalculator.nextStartDate(
			serviceStartDate,
			periodStartDate,
			sequenceNumber
		);
		System.assertEquals(
			Date.newInstance(2022, 2, 2),
			calculatedStartDate,
			'should calculate start date of 2/2/2022'
		);
	}

	@IsTest
	static void itShouldAlignStartDateToWeekStart() {
		Date serviceStartDate = Date.newInstance(2022, 2, 1);
		Date periodStartDate = Date.newInstance(2022, 2, 5);
		Integer sequenceNumber = 5; // default schedule setting days per week 5 5, so week end is on day 5

		Test.startTest();
		TimePeriodDay periodCalculator = new TimePeriodDay();
		Date calculatedStartDate = periodCalculator.nextStartDate(
			serviceStartDate,
			periodStartDate,
			sequenceNumber
		);
		System.assertEquals(
			Date.newInstance(2022, 2, 8),
			calculatedStartDate,
			'should calculate start date of 2/8/2022'
		);
	}

	@IsTest
	static void itShouldAlignStartDateToMonthStart() {
		Date serviceStartDate = Date.newInstance(2022, 2, 1);
		Date periodStartDate = Date.newInstance(2022, 2, 26);
		Integer sequenceNumber = 20; // default schedule setting days per month is 20, so month end is on day 20

		Test.startTest();
		TimePeriodDay periodCalculator = new TimePeriodDay();
		Date calculatedStartDate = periodCalculator.nextStartDate(
			serviceStartDate,
			periodStartDate,
			sequenceNumber
		);
		System.assertEquals(
			Date.newInstance(2022, 3, 1),
			calculatedStartDate,
			'should calculate start date of 3/1/2022'
		);
	}
}
