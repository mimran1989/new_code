/**
 *  Provus Services Quoting
 *  DurationCalculationHelperTest
 *  @2022 Provus Inc. All rights reserved.
 */
@IsTest
private class DurationCalcsTest {
	@IsTest
	static void itShouldAddThreeMonthsAndThreeDaysToStartDate() {
		// 500 hours = 3.125 months
		// .125 months = 2.5 days
		// 3 months and 2.5 days
		Date serviceEndDate = DurationCalcs.endDate(500, null, Date.valueOf('2021-5-5'));

		System.assertEquals(
			Date.valueOf('2021-08-07'),
			serviceEndDate,
			'service end date should equal \'2021-08-07\''
		);
	}

	@IsTest
	static void itShouldAddThreeMonthsTwoWeeksAndTwoDaysToStartDate() {
		Date serviceEndDate = DurationCalcs.endDate(576, null, Date.valueOf('2021-5-5'));

		System.assertEquals(
			Date.valueOf('2021-08-20'),
			serviceEndDate,
			'service end date should equal \'2021-08-20\''
		);
	}

	@IsTest
	static void twoDayHoursShouldAddOneDayToStartDate() {
		String expectedDate = '2022-01-02';

		Date serviceEndDate = DurationCalcs.endDate(16, null, Date.valueOf('2022-1-1'));

		System.assertEquals(
			Date.valueOf(expectedDate),
			serviceEndDate,
			'service end date should equal \'' +
			expectedDate +
			'\''
		);
	}

	@IsTest
	static void fiveAndAHalfDaysHoursShouldAddEightDayToStartDate() {
		String expectedDate = '2022-01-08';

		Date serviceEndDate = DurationCalcs.endDate(45, null, Date.valueOf('2022-1-1'));

		System.assertEquals(
			Date.valueOf(expectedDate),
			serviceEndDate,
			'service end date should equal \'' +
			expectedDate +
			'\''
		);
	}

	@IsTest
	static void fiveDayHoursShouldAddFiveDaysToStartDate() {
		String expectedDate = '2022-06-25';

		Date serviceEndDate = DurationCalcs.endDate(40, null, Date.valueOf('2022-6-19'));

		System.assertEquals(
			Date.valueOf(expectedDate),
			serviceEndDate,
			'service end date should equal \'' +
			expectedDate +
			'\''
		);
	}

	@IsTest
	static void threeDayHoursShouldAdd3DayToStartDate() {
		String expectedDate = '2022-06-18';

		Date serviceEndDate = DurationCalcs.endDate(24, null, Date.valueOf('2022-6-16'));

		System.assertEquals(
			Date.valueOf(expectedDate),
			serviceEndDate,
			'service end date should equal \'' +
			expectedDate +
			'\''
		);
	}

	@IsTest
	static void whenStartDateIsAug1stDurationIsOneMonthInHoursThenEndDateShouldBeLastDayOfMonthOfAugust() {
		String expectedDate = '2022-08-31';

		Date serviceEndDate = DurationCalcs.endDate(160, null, Date.valueOf('2022-8-1'));

		System.assertEquals(
			Date.valueOf(expectedDate),
			serviceEndDate,
			'service end date should equal \'' +
			expectedDate +
			'\''
		);
	}
}
