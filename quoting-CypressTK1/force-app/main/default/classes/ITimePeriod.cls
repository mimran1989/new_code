/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public interface ITimePeriod {
	Date nextStartDate(Date serviceStartDate, Date periodEndDate, Integer periodSequenceNumber);
	Date calculatePeriodEndDate(Date serviceStartDate, Date periodStartDate, Integer periodNumber);
	Integer numberOfPeriods(Date startDate, Date endDate);
	String generatePeriodName(Date startDate, Date endDate, Integer sequence);
	String getPriceUom();
	Decimal convertUnitValue(Decimal unitValue);
}
