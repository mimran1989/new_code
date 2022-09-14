/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class TimePeriodWeek implements ITimePeriod {
	public static final String NAME = 'Week';
	public static final String NAME_PLURAL = 'Weeks';
	private static final Decimal SCHEDULE_WEEKS_PER_MONTH =
		UserDefinedPeriodService.scheduleSetting.standardMonthHours /
		UserDefinedPeriodService.scheduleSetting.standardWeekHours;
	private static final Decimal SCHEDULE_DAYS_PER_WEEK =
		UserDefinedPeriodService.scheduleSetting.standardWeekHours /
		UserDefinedPeriodService.scheduleSetting.standardDayHours;
	private static final Integer CALENDAR_DAYS_PER_WEEK = 7;

	public Date nextStartDate(
		Date serviceStartDate,
		Date periodEndDate,
		Integer periodSequenceNumber
	) {
		return periodEndDate.addDays(1);
	}

	public Date calculatePeriodEndDate(
		Date serviceStartDate,
		Date periodStartDate,
		Integer periodNumber
	) {
		Date periodEndDate = periodStartDate.addMonths(1).addDays(-1);
		if (isEndOfTheMonthPeriod(periodNumber)) {
			// we align this periods end date to equal month ends
			periodEndDate = serviceStartDate.addMonths(periodNumber / (Integer) SCHEDULE_WEEKS_PER_MONTH)
				.addDays(-1);
		} else {
			periodEndDate = periodStartDate.addDays(CALENDAR_DAYS_PER_WEEK).addDays(-1);
		}

		return periodEndDate;
	}

	public Integer numberOfPeriods(Date startDate, Date endDate) {
		DurationCalcs.TimelineBreakdown timeline = DurationCalcs.timelineBreakdown(startDate, endDate);

		Integer numberOfMonthPeriods = timeline.numberOfMonths;
		Decimal numberOfWholeWeeks = numberOfMonthPeriods * SCHEDULE_WEEKS_PER_MONTH;
		Decimal numberOfAdditionalWeeks = timeline.numberOfAdditionalDays / SCHEDULE_DAYS_PER_WEEK;
		return (Integer) Math.ceil(numberOfWholeWeeks + numberOfAdditionalWeeks);
	}

	private Boolean isEndOfTheMonthPeriod(Integer periodNumber) {
		return Math.mod(periodNumber, (Integer) SCHEDULE_WEEKS_PER_MONTH) == 0;
	}

	public String generatePeriodName(Date startDate, Date endDate, Integer sequence) {
		return 'Week ' + sequence;
	}

	public String getPriceUom() {
		return RateCardItem.PRICEUOM_WEEKLY;
	}

	public Decimal convertUnitValue(Decimal unitValue) {
		return unitValue;
	}
}
