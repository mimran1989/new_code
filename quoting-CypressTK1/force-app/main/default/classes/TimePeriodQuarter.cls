/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class TimePeriodQuarter implements ITimePeriod {
	public static final String NAME = 'Quarter';
	public static final String NAME_PLURAL = 'Quarters';
	private static final Integer CALENDAR_MONTHS_PER_QUARTER = 3;

	public Date nextStartDate(
		Date serviceStartDate,
		Date periodEndDate,
		Integer periodSequenceNumber
	) {
		TimePeriodMonth timePeriodCalc = new TimePeriodMonth();
		Integer monthOffet = CALENDAR_MONTHS_PER_QUARTER * periodSequenceNumber;
		return timePeriodCalc.nextStartDate(serviceStartDate, periodEndDate, monthOffet);
	}

	public Date calculatePeriodEndDate(
		Date serviceStartDate,
		Date periodStartDate,
		Integer periodNumber
	) {
		Integer monthOffet = CALENDAR_MONTHS_PER_QUARTER * periodNumber;
		TimePeriodMonth timePeriodCalc = new TimePeriodMonth();
		return timePeriodCalc.calculatePeriodEndDate(serviceStartDate, periodStartDate, monthOffet);
	}

	public Integer numberOfPeriods(Date serviceStartDate, Date serviceEndDate) {
		DurationCalcs.TimelineBreakdown timeline = DurationCalcs.timelineBreakdown(
			serviceStartDate,
			serviceEndDate
		);
		Decimal numberOfMonthPeriods =
			timeline.numberOfMonths + (timeline.numberOfAdditionalDays > 0 ? 1 : 0);
		return (Integer) Math.ceil(numberOfMonthPeriods / CALENDAR_MONTHS_PER_QUARTER);
	}

	public String generatePeriodName(Date serviceStartDate, Date serviceEndDate, Integer sequence) {
		return 'Quarter ' + sequence;
	}

	public String getPriceUom() {
		return RateCardItem.PRICEUOM_MONTHLY;
	}

	public Decimal convertUnitValue(Decimal unitValue) {
		return unitValue / 3;
	}
}
