/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class WeekdayTimePeriodWeek implements IWeekdayTimePeriod {
	public String generatePeriodName(Date startDate, Date endDate) {
		return Calendar.toDatetime(startDate.toStartOfWeek()).format('MMM d') +
			' - ' +
			Calendar.toDatetime(endDate.toStartOfWeek().addDays(6)).format('MMM d');
	}

	public Date calculatePeriodEndDate(Date startDate) {
		return Calendar.addWeekdays(startDate.toStartOfWeek().addDays(1), 4);
	}

	public Decimal calculateTerm(Date startDate, Date endDate) {
		return Calendar.weekdaysIn(startDate, endDate) / 5.0;
	}

	public Date toStartOfPeriod(Date startDate) {
		return startDate.toStartOfWeek().addDays(1);
	}

	public Decimal periodHours(Date startDate) {
		return SettingsService.getScheduleSettings().standardDayHours * 5;
	}
}
