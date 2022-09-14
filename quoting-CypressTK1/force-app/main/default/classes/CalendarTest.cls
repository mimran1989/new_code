/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
@IsTest
private class CalendarTest {
	@IsTest
	static void shouldAdd5DaysExcludingWeekend() {
		Test.startTest();
		{
			System.assertEquals(
				Date.parse('6/20/2022'),
				Calendar.addWeekdays(Date.parse('6/13/2022'), 5),
				'adding 5 weekdays should be equal to a standard week'
			);
		}
		Test.stopTest();
	}
}
