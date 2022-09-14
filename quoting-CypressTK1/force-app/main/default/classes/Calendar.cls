/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class Calendar {
	public static Date addWeekdays(Date startDate, Integer daysToAdd) {
		Date endDate = startDate;
		Integer daysRemaining = Math.abs(daysToAdd);
		Integer increment = daysToAdd < 0 ? -1 : 1;
		while (daysRemaining > 0) {
			endDate = endDate.addDays(increment);
			if (isWeekday(endDate)) {
				daysRemaining -= 1;
			}
		}

		return endDate;
	}

	public static Integer weekdaysIn(Date startDate, Date endDate) {
		Integer weekdays = 0;
		for (Date i = startDate; i <= endDate; i = i.addDays(1)) {
			if (isWeekday(i)) {
				weekdays += 1;
			}
		}

		return weekdays;
	}

	public static Integer weekdaysInYear(Integer year) {
		return Calendar.weekdaysIn(Date.valueOf(year + '-1-1'), Date.valueOf(year + '-12-31'));
	}

	public static Datetime toDatetime(Date aDate) {
		Integer d = aDate.day();
		Integer mo = aDate.month();
		Integer yr = aDate.year();

		return Datetime.newInstance(yr, mo, d);
	}

	public static Boolean isWeekday(Date aDate) {
		return dayOfWeekNumber(aDate) != 0 && dayOfWeekNumber(aDate) != 6;
	}

	public static Integer dayOfWeekNumber(Date aDate) {
		return Math.mod(Date.newInstance(1900, 1, 7).daysBetween(aDate), 7);
	}
}
