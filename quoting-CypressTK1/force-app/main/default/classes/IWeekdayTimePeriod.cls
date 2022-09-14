/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public interface IWeekdayTimePeriod {
	Date calculatePeriodEndDate(Date startDate);
	String generatePeriodName(Date startDate, Date endDate);
	Decimal calculateTerm(Date startDate, Date endDate);
	Date toStartOfPeriod(Date startDate);
	Decimal periodHours(Date startDate);
}
