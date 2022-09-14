/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class TimePeriodDay implements ITimePeriod {
	public static final String NAME = 'Day';
	public static final String NAME_PLURAL = 'Days';

	private static final Integer SCHEDULE_DAYS_PER_MONTH =
		(Integer) UserDefinedPeriodService.scheduleSetting.standardMonthHours /
		(Integer) UserDefinedPeriodService.scheduleSetting.standardDayHours;

	private static final Integer SCHEDULE_DAYS_PER_WEEK =
		(Integer) UserDefinedPeriodService.scheduleSetting.standardWeekHours /
		(Integer) UserDefinedPeriodService.scheduleSetting.standardDayHours;

	private static final Integer CALENDAR_DAYS_PER_WEEK = 7;

	public Date calculatePeriodEndDate(
		Date serviceStartDate,
		Date periodStartDate,
		Integer periodNumber
	) {
		return periodStartDate;
	}

	public Date nextStartDate(
		Date serviceStartDate,
		Date periodEndDate,
		Integer periodSequenceNumber
	) {
		Date periodStartDate;
		if (isEndOfTheMonthPeriod(periodSequenceNumber)) {
			// align the next periond to the start of the next month
			periodStartDate = serviceStartDate.addMonths(periodSequenceNumber / SCHEDULE_DAYS_PER_MONTH);
		} else if (isEndOfTheWeekPeriod(periodSequenceNumber)) {
			// align the next period to the start of the next week
			periodStartDate = periodEndDate.addDays(CALENDAR_DAYS_PER_WEEK - SCHEDULE_DAYS_PER_WEEK + 1);
		} else {
			periodStartDate = periodEndDate.addDays(1);
		}
		return periodStartDate;
	}

	public Integer numberOfPeriods(Date startDate, Date endDate) {
		DurationCalcs.TimelineBreakdown timeline = DurationCalcs.timelineBreakdown(startDate, endDate);
		return (timeline.numberOfMonths * SCHEDULE_DAYS_PER_MONTH) + timeline.numberOfAdditionalDays;
	}

	private Boolean isEndOfTheWeekPeriod(Integer periodNumber) {
		return Math.mod(periodNumber, SCHEDULE_DAYS_PER_WEEK) == 0;
	}

	private Boolean isEndOfTheMonthPeriod(Integer periodNumber) {
		return Math.mod(periodNumber, SCHEDULE_DAYS_PER_MONTH) == 0;
	}

	public String generatePeriodName(Date startDate, Date endDate, Integer sequence) {
		return 'Day ' + sequence;
	}

	public String getPriceUom() {
		return RateCardItem.PRICEUOM_DAILY;
	}

	public Decimal convertUnitValue(Decimal unitValue) {
		return unitValue;
	}
}
