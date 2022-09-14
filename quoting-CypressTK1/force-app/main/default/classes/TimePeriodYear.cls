/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class TimePeriodYear implements ITimePeriod {
	public static final String NAME = 'Year';
	public static final String NAME_PLURAL = 'Years';

	public Date nextStartDate(
		Date serviceStartDate,
		Date periodEndDate,
		Integer periodSequenceNumber
	) {
		return null;
	}

	public Date calculatePeriodEndDate(
		Date serviceStartDate,
		Date periodStartDate,
		Integer periodNumber
	) {
		return null;
	}

	public Integer numberOfPeriods(Date startDate, Date endDate) {
		return 0;
	}

	public String generatePeriodName(Date startDate, Date endDate, Integer sequence) {
		return '';
	}

	public String getPriceUom() {
		return '';
	}

	public Decimal convertUnitValue(Decimal unitValue) {
		return 0.0;
	}
}
