/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class WeekdayTimePeriodYear implements IWeekdayTimePeriod {
	public Date calculatePeriodEndDate(Date startDate) {
		return null;
	}

	public String generatePeriodName(Date startDate, Date endDate) {
		return startDate.year() + '';
	}

	public Decimal calculateTerm(Date startDate, Date endDate) {
		return 0.0;
	}

	public Date toStartOfPeriod(Date startDate) {
		return startDate.toStartOfMonth().addMonths(Math.mod(startDate.month() - 1, 12) * -1);
	}

	public Decimal periodHours(Date startDate) {
		return SettingsService.getScheduleSettings().standardDayHours *
			Calendar.weekdaysInYear(startDate.year());
	}
}
