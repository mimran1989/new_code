/**
 *  Provus Services Quoting
 *  PeriodUnits
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class PeriodUnits {
	public Decimal dayPeriodsInAMonth;
	public Decimal weekPeriodsInAMonth;
	public Decimal dayPeriodsInAWeek;
	public Decimal dayPeriodsInAQuarter;
	public Decimal weekPeriodsInAQuarter;
	public Integer calendarDaysPerWeek = 7;

	public PeriodUnits(ScheduleSettingDTO scheduleSetting) {
		dayPeriodsInAMonth = scheduleSetting.standardMonthHours / scheduleSetting.standardDayHours;
		dayPeriodsInAQuarter = dayPeriodsInAMonth * 3;
		weekPeriodsInAMonth = scheduleSetting.standardMonthHours / scheduleSetting.standardWeekHours;
		dayPeriodsInAWeek = scheduleSetting.standardWeekHours / scheduleSetting.standardDayHours;
		weekPeriodsInAQuarter =
			scheduleSetting.standardMonthHours *
			3 /
			scheduleSetting.standardWeekHours;
	}

	public static IPeriodUnit getPeriodUnit(
		Decimal periods,
		PeriodUnits periodUnits,
		String timePeriodType
	) {
		IPeriodUnit periodUnit;

		if (timePeriodType.contains(TimePeriodDay.NAME)) {
			periodUnit = new PeriodUnitDay(periods, periodUnits);
		} else if (timePeriodType.contains(TimePeriodWeek.NAME)) {
			periodUnit = new PeriodUnitWeek(periods, periodUnits);
		} else if (timePeriodType.contains(TimePeriodMonth.NAME)) {
			periodUnit = new PeriodUnitMonth(periods, periodUnits);
		} else if (timePeriodType.contains(TimePeriodQuarter.NAME)) {
			periodUnit = new PeriodUnitQuarter(periods, periodUnits);
		} else if (timePeriodType.contains(TimePeriodYear.NAME)) {
			periodUnit = new PeriodUnitYear(periods, periodUnits);
		}

		return periodUnit;
	}
}
