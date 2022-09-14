/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing abstract class WeekdayTimePeriodFactory {
	private static Map<String, Type> timePeriodTypes;
	static {
		timePeriodTypes = new Map<String, Type>();
		timePeriodTypes.put(TimePeriodDay.NAME.toLowerCase(), WeekdayTimePeriodDay.class);
		timePeriodTypes.put(TimePeriodDay.NAME_PLURAL.toLowerCase(), WeekdayTimePeriodDay.class);
		timePeriodTypes.put(TimePeriodWeek.NAME.toLowerCase(), WeekdayTimePeriodWeek.class);
		timePeriodTypes.put(TimePeriodWeek.NAME_PLURAL.toLowerCase(), WeekdayTimePeriodWeek.class);
		timePeriodTypes.put(TimePeriodMonth.NAME.toLowerCase(), WeekdayTimePeriodMonth.class);
		timePeriodTypes.put(TimePeriodMonth.NAME_PLURAL.toLowerCase(), WeekdayTimePeriodMonth.class);
		timePeriodTypes.put(TimePeriodQuarter.NAME.toLowerCase(), WeekdayTimePeriodQuarter.class);
		timePeriodTypes.put(
			TimePeriodQuarter.NAME_PLURAL.toLowerCase(),
			WeekdayTimePeriodQuarter.class
		);
		timePeriodTypes.put(TimePeriodYear.NAME.toLowerCase(), WeekdayTimePeriodYear.class);
		timePeriodTypes.put(TimePeriodYear.NAME_PLURAL.toLowerCase(), WeekdayTimePeriodYear.class);
	}

	public static IWeekdayTimePeriod newTimePeriod(String timePeriod) {
		Type timePeriodType = timePeriodTypes.get(timePeriod?.toLowerCase());
		return timePeriodType != null ? (IWeekdayTimePeriod) timePeriodType.newInstance() : null;
	}
}
