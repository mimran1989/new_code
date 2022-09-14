/**
 *  Provus Services Quoting
 *  PeriodUnitTest
 *  @2022 Provus Inc. All rights reserved.
 */
@IsTest
private class PeriodUnitTest {
	@IsTest
	static void fiveDayPeriodConvertToWeekPeriodAmountShouldEqualOneThenBackAmountFiveAgain() {
		PeriodUnits periodUnits = new PeriodUnits(SettingsService.getScheduleSettings());

		Decimal dayPeriods = 5;
		Decimal weekPeriodsExpected = 1;
		String toWeekUnit = 'Week';
		String fromDayUnit = 'Day';
		IPeriodUnit dayPeriodUnit = new PeriodUnitDay(dayPeriods, periodUnits);
		IPeriodUnit weekPeriodUnit = dayPeriodUnit.toPeriodUnit(toWeekUnit);
		System.assertEquals(
			weekPeriodsExpected,
			weekPeriodUnit.getAmount(),
			'Expect ' +
			dayPeriods +
			' ' +
			fromDayUnit.toLowerCase() +
			' periods to equal ' +
			weekPeriodsExpected +
			' ' +
			toWeekUnit.toLowerCase() +
			' period(s)'
		);
		System.assertEquals(
			dayPeriods,
			weekPeriodUnit.toPeriodUnit(fromDayUnit).getAmount(),
			'Expect ' +
			weekPeriodsExpected +
			' ' +
			toWeekUnit.toLowerCase() +
			' period(s) to equal ' +
			dayPeriods +
			' day period(s)'
		);
	}

	@IsTest
	static void fiveDayPeriodConvertToMonthPeriodAmountShouldEqualOneQuarterThenBackToFiveDaysAgain() {
		PeriodUnits periodUnits = new PeriodUnits(SettingsService.getScheduleSettings());

		Decimal dayPeriods = 5;
		Decimal monthPeriodExpected = .25;
		String toMonthPeriodUnit = 'Month';
		String fromDayUnit = 'Day';
		IPeriodUnit dayPeriodUnit = new PeriodUnitDay(dayPeriods, periodUnits);
		IPeriodUnit monthPeriodUnit = dayPeriodUnit.toPeriodUnit(toMonthPeriodUnit);
		System.assertEquals(
			monthPeriodExpected,
			monthPeriodUnit.getAmount(),
			'Expect ' +
			dayPeriods +
			' ' +
			fromDayUnit.toLowerCase() +
			' periods to equal ' +
			monthPeriodExpected +
			' ' +
			toMonthPeriodUnit.toLowerCase() +
			' period(s)'
		);
		System.assertEquals(
			dayPeriods,
			monthPeriodUnit.toPeriodUnit(fromDayUnit).getAmount(),
			'Expect ' +
			monthPeriodExpected +
			' ' +
			toMonthPeriodUnit.toLowerCase() +
			' period(s) to equal ' +
			dayPeriods +
			' day period(s)'
		);
	}

	@IsTest
	static void fiveDayPeriodConvertToQuarterPeriodShouldEqualFractionOfAQuarterThenBackToFiveDayPeriodsAgain() {
		PeriodUnits periodUnits = new PeriodUnits(SettingsService.getScheduleSettings());

		Decimal dayPeriods = 5;
		// dayPeriods / periodUnits.dayPeriodsInAQuarter
		Decimal quarterPeriodAmountExpected = 0.0833333333333333333333333333333333;
		String toQuarterPeriod = 'Quarter';
		String fromDayPeriod = 'Day';
		IPeriodUnit dayPeriodUnit = new PeriodUnitDay(dayPeriods, periodUnits);
		IPeriodUnit quarterPeriodUnit = dayPeriodUnit.toPeriodUnit(toQuarterPeriod);
		System.assertEquals(
			quarterPeriodAmountExpected,
			quarterPeriodUnit.getAmount(),
			'Expect ' +
			dayPeriods +
			' ' +
			fromDayPeriod.toLowerCase() +
			' periods to equal ' +
			quarterPeriodAmountExpected +
			' ' +
			toQuarterPeriod.toLowerCase() +
			' period(s)'
		);
		System.assertEquals(
			dayPeriods,
			quarterPeriodUnit.toPeriodUnit(fromDayPeriod).getAmount(),
			'Expect ' +
			quarterPeriodAmountExpected +
			' ' +
			toQuarterPeriod.toLowerCase() +
			' period(s) to equal ' +
			dayPeriods +
			' day period(s)'
		);
	}

	@IsTest
	static void fourWeekPeriodsConvertToMonthPeriodsShouldEqualOneMonthThenBackToFourWeekPeriodsAgain() {
		PeriodUnits periodUnits = new PeriodUnits(SettingsService.getScheduleSettings());

		Decimal weekPeriods = 4;
		Decimal monthPeriodAmountExpected = 1;
		String toMonthPeriod = 'Month';
		String fromWeekPeriod = 'Week';
		IPeriodUnit weekPeriodUnit = new PeriodUnitWeek(weekPeriods, periodUnits);
		IPeriodUnit monthPeriodUnit = weekPeriodUnit.toPeriodUnit(toMonthPeriod);
		System.assertEquals(
			monthPeriodAmountExpected,
			monthPeriodUnit.getAmount(),
			'Expect ' +
			weekPeriods +
			' ' +
			fromWeekPeriod.toLowerCase() +
			' periods to equal ' +
			monthPeriodAmountExpected +
			' ' +
			toMonthPeriod.toLowerCase() +
			' period(s)'
		);
		System.assertEquals(
			weekPeriods,
			monthPeriodUnit.toPeriodUnit(fromWeekPeriod).getAmount(),
			'Expect ' +
			monthPeriodAmountExpected +
			' ' +
			toMonthPeriod.toLowerCase() +
			' period(s) to equal ' +
			weekPeriods +
			' day period(s)'
		);
	}

	@IsTest
	static void fourWeekPeriodConvertToQuarterPeriodsShouldEqualOneThirdFractionThenBackToFourWeekPeriodsAgain() {
		PeriodUnits periodUnits = new PeriodUnits(SettingsService.getScheduleSettings());

		Decimal weekPeriods = 4;
		Decimal quarterPeriodsExpected = 0.333333333333333333333333333333333; // = 4 / periodUnits.weekPeriodsInAQuarter
		String toQuarterPeriod = 'Quarter';
		String fromWeekPeriod = 'Week';
		IPeriodUnit weekPeriodUnit = new PeriodUnitWeek(weekPeriods, periodUnits);
		IPeriodUnit quarterPeriodUnit = weekPeriodUnit.toPeriodUnit(toQuarterPeriod);
		System.assertEquals(
			quarterPeriodsExpected,
			quarterPeriodUnit.getAmount(),
			'Expect ' +
			weekPeriods +
			' ' +
			fromWeekPeriod.toLowerCase() +
			' periods to equal ' +
			quarterPeriodsExpected +
			' ' +
			toQuarterPeriod.toLowerCase() +
			' period(s)'
		);
		System.assertEquals(
			weekPeriods,
			quarterPeriodUnit.toPeriodUnit(fromWeekPeriod).getAmount(),
			'Expect ' +
			quarterPeriodsExpected +
			' ' +
			toQuarterPeriod.toLowerCase() +
			' period(s) to equal ' +
			weekPeriods +
			' day period(s)'
		);
	}

	@IsTest
	static void threeMonthPeriodConvertToQuarterPeriodsShouldEqualOneQuarterThenBackToThreeMonthPeriods() {
		PeriodUnits periodUnits = new PeriodUnits(SettingsService.getScheduleSettings());

		Decimal monthPeriods = 3;
		Decimal quarterPeriodsExpected = 1;
		String toQuarterPeriod = 'Quarter';
		String fromMonthPeriod = 'Month';
		IPeriodUnit monthPeriodUnit = new PeriodUnitMonth(monthPeriods, periodUnits);
		IPeriodUnit quarterPeriodUnit = monthPeriodUnit.toPeriodUnit(toQuarterPeriod);
		System.assertEquals(
			quarterPeriodsExpected,
			quarterPeriodUnit.getAmount(),
			'Expect ' +
			monthPeriods +
			' ' +
			fromMonthPeriod.toLowerCase() +
			' periods to equal ' +
			quarterPeriodsExpected +
			' ' +
			toQuarterPeriod.toLowerCase() +
			' period(s)'
		);
		System.assertEquals(
			monthPeriods,
			quarterPeriodUnit.toPeriodUnit(fromMonthPeriod).getAmount(),
			'Expect ' +
			quarterPeriodsExpected +
			' ' +
			toQuarterPeriod.toLowerCase() +
			' period(s) to equal ' +
			monthPeriods +
			' day period(s)'
		);
	}
}
