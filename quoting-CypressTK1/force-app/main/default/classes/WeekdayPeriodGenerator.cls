/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class WeekdayPeriodGenerator implements IQuotePeriodGenerator {
	private IWeekdayTimePeriod timePeriodCalc;
	private Quote__c quoteSo;

	public WeekdayPeriodGenerator(IWeekdayTimePeriod timePeriodCalc, Quote__c quoteSo) {
		this.timePeriodCalc = timePeriodCalc;
		this.quoteSo = quoteSo;
	}

	public List<QuotePeriod__c> newPeriods() {
		List<QuotePeriod__c> periods = new List<QuotePeriod__c>();

		String timePeriod = this.quoteSo.TimePeriod__c;
		String timePeriodsGroupMethod = this.quoteSo.TimePeriodsGroupMethod__c;
		Date periodStartDate = Calendar.isWeekday(this.quoteSo.ServiceStartDate__c)
			? this.quoteSo.ServiceStartDate__c
			: Calendar.addWeekdays(this.quoteSo.ServiceStartDate__c, 1);
		Integer periodSequence = 0;

		while (
			periodStartDate <= this.quoteSo.ServiceEndDate__c &&
			periodSequence < QuotePeriodService.MAX_PERIOD_COUNT
		) {
			periodSequence += 1;
			Date periodEndDate = timePeriodCalc.calculatePeriodEndDate(periodStartDate);
			if (periodEndDate > this.quoteSo.ServiceEndDate__c) {
				periodEndDate = this.quoteSo.ServiceEndDate__c;
			}

			Boolean isSamePeriodGroup = isSamePeriodGroup(
				timePeriodsGroupMethod,
				periodStartDate,
				periodEndDate
			);

			// split the week into two
			if (
				this.quoteSo.TimePeriodsAlignment__c ==
				QuoteService.TIMEPERIODSALIGNMENT_WEEKDAY_CALENDAR &&
				timePeriod == TimePeriodWeek.NAME_PLURAL &&
				!isSamePeriodGroup
			) {
				Date firstHalfEndDate = periodStartDate.toStartOfMonth().addMonths(1).addDays(-1);
				QuotePeriod__c firstHalf = new QuotePeriod__c(
					Name = timePeriodCalc.generatePeriodName(periodStartDate, periodEndDate),
					Sequence__c = periodSequence,
					StartDate__c = periodStartDate,
					QuoteId__c = this.quoteSo.Id,
					EndDate__c = firstHalfEndDate,
					Term__c = 1
				);

				periods.add(firstHalf);
				periodSequence += 1;

				Date secondHalfStartDate = firstHalfEndDate.addDays(1);
				QuotePeriod__c secondHalf = new QuotePeriod__c(
					Name = timePeriodCalc.generatePeriodName(periodStartDate, periodEndDate),
					Sequence__c = periodSequence,
					StartDate__c = secondHalfStartDate,
					QuoteId__c = this.quoteSo.Id,
					EndDate__c = periodEndDate,
					Term__c = 1
				);

				periods.add(secondHalf);
			} else {
				QuotePeriod__c period = new QuotePeriod__c(
					Name = timePeriodCalc.generatePeriodName(periodStartDate, periodEndDate),
					Sequence__c = periodSequence,
					StartDate__c = periodStartDate,
					QuoteId__c = this.quoteSo.Id,
					EndDate__c = periodEndDate,
					Term__c = 1
				);

				periods.add(period);
			}

			periodStartDate = Calendar.addWeekdays(periodEndDate, 1);
		}

		return periods;
	}

	public List<QuotePeriod__c> newPeriods(Integer numberOfPeriodsToCreate) {
		return null;
	}

	private static Boolean isSamePeriodGroup(
		String timePeriodsGroupMethod,
		Date startDate,
		Date endDate
	) {
		if (timePeriodsGroupMethod == TimePeriodMonth.NAME) {
			return startDate.month() == endDate.month();
		} else if (timePeriodsGroupMethod == TimePeriodQuarter.NAME) {
			Integer startDateQuarterMonth = startDate.month() - Math.mod(startDate.month() - 1, 3);
			Integer endDateQuarterMonth = endDate.month() - Math.mod(endDate.month() - 1, 3);
			return startDateQuarterMonth == endDateQuarterMonth;
		} else if (timePeriodsGroupMethod == TimePeriodYear.NAME) {
			return startDate.year() == endDate.year();
		}

		return false;
	}
}
