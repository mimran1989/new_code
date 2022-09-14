/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
@IsTest
private class WeekdayTimePeriodDayTest {
	@IsTest
	static void shouldHaveMatchingStartAndEndDates() {
		Test.startTest();
		{
			Date startDate = Date.today();
			System.assertEquals(startDate, new WeekdayTimePeriodDay().calculatePeriodEndDate(startDate));
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldReturn1() {
		Test.startTest();
		{
			Date startDate = Date.today();
			Date endDate = Date.today();
			System.assertEquals(1, new WeekdayTimePeriodDay().calculateTerm(startDate, endDate));
		}
		Test.stopTest();
	}
}
