/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class TimePeriodMonth implements ITimePeriod {
	public static final String NAME = 'Month';
	public static final String NAME_PLURAL = 'Months';

	public Date nextStartDate(
		Date serviceStartDate,
		Date periodEndDate,
		Integer periodSequenceNumber
	) {
		return serviceStartDate.addMonths(periodSequenceNumber);
	}

	public Date calculatePeriodEndDate(
		Date serviceStartDate,
		Date periodStartDate,
		Integer periodNumber
	) {
		Date periodEndDate = periodStartDate.addMonths(1).addDays(-1);
		if (periodEndDate.daysBetween(serviceStartDate.addMonths(periodNumber)) > 1) {
			// consume the remainder of dangling months
			periodEndDate = serviceStartDate.addMonths(periodNumber).addDays(-1);
		}

		return periodEndDate;
	}

	public Integer numberOfPeriods(Date startDate, Date endDate) {
		DurationCalcs.TimelineBreakdown timeline = DurationCalcs.timelineBreakdown(startDate, endDate);
		return timeline.numberOfMonths + (timeline.numberOfAdditionalDays > 0 ? 1 : 0);
	}

	public String generatePeriodName(Date startDate, Date endDate, Integer sequence) {
		Datetime periodStart = Datetime.newInstance(startDate, Time.newInstance(0, 0, 0, 1)); // start of the day
		Datetime periodEnd = Datetime.newInstance(endDate, Time.newInstance(23, 59, 59, 999)); // end of the day
		String periodName;
		if (periodStart.month() == periodEnd.month()) {
			periodName = periodStart.format('MMM') + '/' + periodStart.format('yyyy');
		} else {
			periodName =
				periodStart.format('MMM') +
				'/' +
				periodStart.format('yyyy') +
				' to ' +
				periodEnd.format('MMM') +
				'/' +
				periodEnd.format('yyyy');
		}

		return periodName;
	}

	public String getPriceUom() {
		return RateCardItem.PRICEUOM_MONTHLY;
	}

	public Decimal convertUnitValue(Decimal unitValue) {
		return unitValue;
	}
}
