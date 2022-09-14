/**
 *  Provus Services Quoting
 *  TimePeriodQuarterTest
 *  @2022 Provus Inc. All rights reserved.
 */
@IsTest
private class TimePeriodQuarterTest {
	@IsTest
	static void itshouldRequire4Periods() {
		Date startDate = Date.newInstance(2022, 1, 1);
		Date endDate = Date.newInstance(2022, 12, 31);

		Test.startTest();
		TimePeriodQuarter periodCalculator = new TimePeriodQuarter();
		Integer numberOfPeriods = periodCalculator.numberOfPeriods(startDate, endDate);
		System.assertEquals(4, numberOfPeriods, 'should require 4 periods');
	}

	@IsTest
	static void itShouldGenerateNameAsDayPlusSequenceNumber() {
		Test.startTest();
		TimePeriodQuarter periodCalculator = new TimePeriodQuarter();
		System.assertEquals(
			'Quarter 1',
			periodCalculator.generatePeriodName(null, null, 1),
			'should format the period as Quarter 1'
		);
		System.assertEquals(
			'Quarter 2',
			periodCalculator.generatePeriodName(null, null, 2),
			'should format the period as Quarter 2'
		);
		System.assertEquals(
			'Quarter 10',
			periodCalculator.generatePeriodName(null, null, 10),
			'should format the period as Quarter 10'
		);
	}

	static void itShouldAlignEndDateToLastDayOfTargetMonth() {
		Date startDate = Date.newInstance(2022, 1, 31);

		Test.startTest();
		TimePeriodQuarter periodCalculator = new TimePeriodQuarter();
		Date calculatedEndDate = periodCalculator.calculatePeriodEndDate(startDate, startDate, 1);
		System.assertEquals(
			Date.newInstance(2022, 4, 29),
			calculatedEndDate,
			'should calculate end date of 4/29/2022'
		);
	}

	static void itShouldCalculateStartPeriodAsServiceStartPlusSequenceQuarters() {
		Date serviceStartDate = Date.newInstance(2022, 1, 30);

		Test.startTest();
		TimePeriodQuarter periodCalculator = new TimePeriodQuarter();
		Date calculatedStartDate = periodCalculator.nextStartDate(serviceStartDate, null, 1);
		System.assertEquals(
			Date.newInstance(2022, 4, 30),
			calculatedStartDate,
			'should calculate start date of 4/30/2022'
		);
	}
}
