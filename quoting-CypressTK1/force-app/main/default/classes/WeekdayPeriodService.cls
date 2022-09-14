/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class WeekdayPeriodService {
	public static Map<QuotePeriodGroup__c, List<QuotePeriod__c>> generatePeriods(Quote__c quoteSo) {
		IWeekdayTimePeriod timePeriodCalc = WeekdayTimePeriodFactory.newTimePeriod(
			quoteSo.TimePeriod__c
		);
		IWeekdayTimePeriod timePeriodGroupCalc = WeekdayTimePeriodFactory.newTimePeriod(
			quoteSo.TimePeriodsGroupMethod__c
		);
		IQuotePeriodGenerator periodGenerator = new WeekdayPeriodGenerator(timePeriodCalc, quoteSo);
		List<QuotePeriod__c> newPeriods = periodGenerator.newPeriods();
		return WeekdayPeriodGroupBuilder.buildQuotePeriodGroups(
			timePeriodGroupCalc,
			quoteSo,
			newPeriods
		);
	}
}
