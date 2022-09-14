/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class WeekdayPeriodGroupBuilder {
	public static Map<QuotePeriodGroup__c, List<QuotePeriod__c>> buildQuotePeriodGroups(
		IWeekdayTimePeriod timePeriodCalc,
		Quote__c quoteSo,
		List<QuotePeriod__c> periodSos
	) {
		String timePeriodsGroupMethod = quoteSo.TimePeriodsGroupMethod__c;

		Map<QuotePeriodGroup__c, List<QuotePeriod__c>> periodsByGroup = new Map<QuotePeriodGroup__c, List<QuotePeriod__c>>();
		Decimal groupSequence = 0;
		Map<Date, QuotePeriodGroup__c> groupMap = new Map<Date, QuotePeriodGroup__c>();

		for (QuotePeriod__c period : periodSos) {
			groupSequence += 1;

			Date groupStartDate = timePeriodCalc.toStartOfPeriod(period.StartDate__c);
			QuotePeriodGroup__c periodGroup = groupMap.get(groupStartDate);

			if (periodGroup == null) {
				periodGroup = new QuotePeriodGroup__c(
					Name = timePeriodCalc.generatePeriodName(groupStartDate, period.EndDate__c),
					QuoteId__c = quoteSo.Id,
					Sequence__c = groupSequence,
					StartDate__c = groupStartDate,
					EndDate__c = period.EndDate__c
				);
			}

			List<QuotePeriod__c> periodsForGroup = periodsByGroup.get(periodGroup);

			if (periodsForGroup == null) {
				periodsForGroup = new List<QuotePeriod__c>();
			}

			periodsForGroup.add(period);
			periodGroup.EndDate__c = period.EndDate__c;
			periodGroup.Name = timePeriodCalc.generatePeriodName(
				periodGroup.StartDate__c,
				periodGroup.EndDate__c
			);
			periodsByGroup.put(periodGroup, periodsForGroup);
			groupMap.put(groupStartDate, periodGroup);
		}

		return periodsByGroup;
	}
}
