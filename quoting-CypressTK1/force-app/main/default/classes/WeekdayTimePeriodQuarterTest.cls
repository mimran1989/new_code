/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

@IsTest
private class WeekdayTimePeriodQuarterTest {
	@IsTest
	static void shouldGenerateNameInSameYearAsStart() {
		Test.startTest();
		{
			WeekdayTimePeriodQuarter x = new WeekdayTimePeriodQuarter();
			String periodName = x.generatePeriodName(Date.valueOf('2023-10-02'), null);
			System.assertEquals('October - December 2023', periodName);
		}
		Test.stopTest();
	}
}
