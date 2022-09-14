/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class DefaultPeriodService {
	public static ScheduleSettingDTO scheduleSetting;
	static {
		scheduleSetting = SettingsService.getScheduleSettings();
	}

	public static Map<QuotePeriodGroup__c, List<QuotePeriod__c>> generatePeriods(Quote__c quote) {
		return generatePeriods(quote, new QuotePeriodState());
	}

	public static Map<QuotePeriodGroup__c, List<QuotePeriod__c>> generatePeriods(
		Quote__c quote,
		QuotePeriodState quotePeriodState
	) {
		ITimePeriod timePeriodCalc = TimePeriodFactory.newTimePeriod(quote.TimePeriod__c);

		IQuotePeriodGenerator periodGenerator = new QuotePeriodGenerator(
			timePeriodCalc,
			quote,
			quotePeriodState
		);

		List<QuotePeriod__c> periodsForQuote = periodGenerator.newPeriods();

		Integer numberOfPeriodsInGroup = DurationCalcs.numberOfPeriodsInAGroup(
			quote.TimePeriod__c,
			quote.TimePeriodsGroupMethod__c
		);

		return new QuotePeriodGroupBuilder(quote, quotePeriodState)
			.buildQuotePeriodGroups(periodsForQuote, numberOfPeriodsInGroup);
	}
}
