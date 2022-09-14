/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class WeekdayTimePeriodQuarter implements IWeekdayTimePeriod {
	public Date calculatePeriodEndDate(Date startDate) {
		return startDate.toStartOfMonth().addMonths(3 - Math.mod(startDate.month() - 1, 3)).addDays(-1);
	}

	public String generatePeriodName(Date startDate, Date endDate) {
		return Calendar.toDatetime(toStartOfPeriod(startDate)).format('MMMM') +
			' - ' +
			Calendar.toDatetime(calculatePeriodEndDate(startDate)).format('MMMM yyyy');
	}

	public Decimal calculateTerm(Date startDate, Date endDate) {
		Decimal numberOfWeekdays = Calendar.weekdaysIn(startDate, endDate);
		Decimal fullTerm = Calendar.weekdaysIn(
			toStartOfPeriod(startDate),
			calculatePeriodEndDate(startDate)
		);
		return numberOfWeekdays / fullTerm;
	}

	public Date toStartOfPeriod(Date startDate) {
		return startDate.toStartOfMonth().addMonths(Math.mod(startDate.month() - 1, 3) * -1);
	}

	public Decimal periodHours(Date startDate) {
		return SettingsService.getScheduleSettings().standardDayHours *
			(Calendar.weekdaysIn(toStartOfPeriod(startDate), calculatePeriodEndDate(startDate)));
	}
}
