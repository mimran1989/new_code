/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class WeekdayTimePeriodMonth implements IWeekdayTimePeriod {
	public Date calculatePeriodEndDate(Date startDate) {
		return startDate.toStartOfMonth().addMonths(1).addDays(-1);
	}

	public String generatePeriodName(Date startDate, Date endDate) {
		return Calendar.toDatetime(startDate).format('MMMM/YYYY');
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
		return startDate.toStartOfMonth();
	}

	public Decimal periodHours(Date startDate) {
		return SettingsService.getScheduleSettings().standardDayHours *
			(Calendar.weekdaysIn(toStartOfPeriod(startDate), calculatePeriodEndDate(startDate)));
	}
}
