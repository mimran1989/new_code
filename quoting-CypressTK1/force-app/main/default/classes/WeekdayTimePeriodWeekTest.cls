/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
@IsTest
private class WeekdayTimePeriodWeekTest {
	@IsTest
	static void shouldGeneratePeriodNameAtStartAndEndOfWeek() {
		WeekdayTimePeriodWeek controller = new WeekdayTimePeriodWeek();

		Test.startTest();
		{
			Date startDate = Date.valueOf('2022-6-6');
			Date endDate = Date.valueOf('2022-6-10');
			System.assertEquals('Jun 5 - Jun 11', controller.generatePeriodName(startDate, endDate));
		}
		Test.stopTest();
	}
}
