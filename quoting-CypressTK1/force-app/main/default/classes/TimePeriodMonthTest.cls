/**
 *  Provus Services Quoting
 *  TimePeriodMonthTest
 *  @2022 Provus Inc. All rights reserved.
 */
@IsTest
private class TimePeriodMonthTest {
	@IsTest
	static void itshouldRequire5Periods() {
		Date startDate = Date.newInstance(2022, 1, 30);
		Date endDate = Date.newInstance(2022, 6, 10);

		Test.startTest();
		TimePeriodMonth periodCalculator = new TimePeriodMonth();
		Integer numberOfPeriods = periodCalculator.numberOfPeriods(startDate, endDate);
		System.assertEquals(5, numberOfPeriods, 'should require 5 periods');
	}

	@IsTest
	static void itshouldRequire1PeriodWhenDatesAreInJanuary() {
		Date startDate = Date.newInstance(2022, 1, 1);
		Date endDate = Date.newInstance(2022, 1, 31);

		Test.startTest();
		TimePeriodMonth periodCalculator = new TimePeriodMonth();
		Integer numberOfPeriods = periodCalculator.numberOfPeriods(startDate, endDate);
		System.assertEquals(1, numberOfPeriods, 'should require 1 period');
	}

	@IsTest
	static void itshouldRequire1PeriodWhenDatesAreInFebruary() {
		Date startDate = Date.newInstance(2022, 2, 1);
		Date endDate = Date.newInstance(2022, 2, 28);

		Test.startTest();
		TimePeriodMonth periodCalculator = new TimePeriodMonth();
		Integer numberOfPeriods = periodCalculator.numberOfPeriods(startDate, endDate);
		System.assertEquals(1, numberOfPeriods, 'should require 1 period');
	}

	@IsTest
	static void itShouldGenerateNameInMMMYYYYFormat() {
		Date startDate = Date.newInstance(2022, 2, 1);
		Date endDate = Date.newInstance(2022, 2, 28);

		Test.startTest();
		TimePeriodMonth periodCalculator = new TimePeriodMonth();
		String periodName = periodCalculator.generatePeriodName(startDate, endDate, 1);
		System.assertEquals('Feb/2022', periodName, 'should format the period in MMM/YYYY format');
	}

	@IsTest
	static void itShouldGenerateNameFromStartToEndMonth() {
		Date startDate = Date.newInstance(2022, 1, 2);
		Date endDate = Date.newInstance(2022, 2, 1);

		Test.startTest();
		TimePeriodMonth periodCalculator = new TimePeriodMonth();
		String periodName = periodCalculator.generatePeriodName(startDate, endDate, 1);
		System.assertEquals(
			'Jan/2022 to Feb/2022',
			periodName,
			'should format the period in MMM/YYYY to MMM/YYYY format'
		);
	}

	static void itShouldCalculateEndPeriodAsPlusOneMonth() {
		Date startDate = Date.newInstance(2022, 1, 2);

		Test.startTest();
		TimePeriodMonth periodCalculator = new TimePeriodMonth();
		Date calculatedEndDate = periodCalculator.calculatePeriodEndDate(startDate, startDate, 1);
		System.assertEquals(
			Date.newInstance(2022, 2, 1),
			calculatedEndDate,
			'should calculate end date of 2/1/2022'
		);
	}

	static void itShouldAlignEndDateToLastDayOfTargetMonth() {
		Date startDate = Date.newInstance(2022, 1, 30);

		Test.startTest();
		TimePeriodMonth periodCalculator = new TimePeriodMonth();
		Date calculatedEndDate = periodCalculator.calculatePeriodEndDate(startDate, startDate, 1);
		System.assertEquals(
			Date.newInstance(2022, 2, 27),
			calculatedEndDate,
			'should calculate end date of 2/27/2022'
		);
	}

	static void itShouldCalculateStartPeriodAsServiceStartPlusSequenceMonths() {
		Date serviceStartDate = Date.newInstance(2022, 1, 30);

		Test.startTest();
		TimePeriodMonth periodCalculator = new TimePeriodMonth();
		Date calculatedStartDate = periodCalculator.nextStartDate(serviceStartDate, null, 1);
		System.assertEquals(
			Date.newInstance(2022, 2, 28),
			calculatedStartDate,
			'should calculate start date of 2/28/2022'
		);

		calculatedStartDate = periodCalculator.nextStartDate(serviceStartDate, null, 2);
		System.assertEquals(
			Date.newInstance(2022, 3, 30),
			calculatedStartDate,
			'should calculate start date of 3/30/2022'
		);
	}
}
