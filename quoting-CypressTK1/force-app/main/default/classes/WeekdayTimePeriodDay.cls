/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class WeekdayTimePeriodDay implements IWeekdayTimePeriod {
	public Date calculatePeriodEndDate(Date startDate) {
		return startDate;
	}

	public String generatePeriodName(Date startDate, Date endDate) {
		return startDate.format();
	}

	public Decimal calculateTerm(Date startDate, Date endDate) {
		return 1.0;
	}

	public Date toStartOfPeriod(Date startDate) {
		return startDate;
	}

	public Decimal periodHours(Date startDate) {
		return SettingsService.getScheduleSettings().standardDayHours;
	}
}
