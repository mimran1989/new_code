/**
 *  Provus Services Quoting
 *  DurationCalculationHelper
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class DurationCalcs {
	/**
	 * Derives end date based on total estimated duration hours, start date and for given time period preference
	 *
	 * @param totalDuration total estimated duration of time in hours
	 * @param quoteId provus quote id
	 * @param serviceStartDate service start date of quote
	 *
	 * @return returns derived end date
	 */
	public static Date endDate(Decimal totalDuration, Id quoteId, Date serviceStartDate) {
		ScheduleSettingDTO scheduleSetting = SettingsService.getScheduleSettingsForQuote(quoteId);
		PeriodUnits periodUnits = new PeriodUnits(scheduleSetting);
		Decimal durationInMonths = totalDuration / scheduleSetting.standardMonthHours;
		Integer wholeMonths = (Integer) durationInMonths;
		Date serviceEndDate = serviceStartDate.addMonths(wholeMonths);

		Decimal remainderWeeks = (durationInMonths - wholeMonths) * periodUnits.weekPeriodsInAMonth;
		Integer wholeWeeksRemaining = (Integer) remainderWeeks;
		if (wholeWeeksRemaining > 0) {
			serviceEndDate = serviceEndDate.addDays(
				wholeWeeksRemaining * (Integer) periodUnits.calendarDaysPerWeek
			);
		}

		Integer remainderDays = (Integer) Math.ceil(
			(remainderWeeks - wholeWeeksRemaining) * periodUnits.dayPeriodsInAWeek
		);

		if (remainderDays > 0) {
			serviceEndDate = serviceEndDate.addDays(remainderDays);
		}

		if (
			(wholeMonths > 0 || wholeWeeksRemaining > 0) ||
			(wholeMonths == 0 &&
			wholeWeeksRemaining == 0 &&
			remainderDays > 0)
		) {
			serviceEndDate = serviceEndDate.addDays(-1);
		}

		return serviceEndDate;
	}

	public static Date weekdayEndDate(Decimal totalDuration, Date serviceStartDate) {
		ScheduleSettingDTO scheduleSetting = SettingsService.getScheduleSettings();
		Date startDate = Calendar.isWeekday(serviceStartDate)
			? serviceStartDate
			: Calendar.addWeekdays(serviceStartDate, 1);
		return Calendar.addWeekdays(
			startDate,
			(Integer) Math.ceil(totalDuration / scheduleSetting.standardDayHours) - 1
		);
	}

	public static Integer numberOfPeriodsInAGroup(String timePeriod, String timePeriodsGroupMethod) {
		Decimal timePeriodHours = numberOfHoursInPeriod(timePeriod);
		Decimal timePeriodGroupHours = numberOfHoursInPeriod(timePeriodsGroupMethod + 's'); // add the plural suffix
		return (Integer) Math.ceil(timePeriodHours == 0 ? 0 : timePeriodGroupHours / timePeriodHours);
	}

	/**
	 * Gets number of hours defined for a time period using default org schedule settings
	 *
	 * @param timePeriod quote time period type (Days/Weeks/Months/Years)
	 *
	 * @return number of hours defined for the time period type as a Decimal
	 */
	public static Decimal numberOfHoursInPeriod(String timePeriod) {
		return numberOfHoursInPeriod(timePeriod, null);
	}

	/**
	 * Number of hours in period based on schedule setting whether at the quote or the system wide setting level
	 *
	 * @param timePeriod quote time period
	 * @param quoteId quote id
	 *
	 * @return number of hours in period
	 */
	public static Decimal numberOfHoursInPeriod(String timePeriod, Id quoteId) {
		ScheduleSettingDTO scheduleSetting;

		if (quoteId != null) {
			scheduleSetting = SettingsService.getScheduleSettingsForQuote(quoteId);
		}

		if (scheduleSetting == null) {
			scheduleSetting = DefaultPeriodService.scheduleSetting;
		}

		Decimal numberOfHoursInPeriod = 0;

		switch on timePeriod {
			when 'Days' {
				numberOfHoursInPeriod = scheduleSetting.standardDayHours;
			}
			when 'Weeks' {
				numberOfHoursInPeriod = scheduleSetting.standardWeekHours;
			}
			when 'Months' {
				numberOfHoursInPeriod = scheduleSetting.standardMonthHours;
			}
			when 'Quarters' {
				numberOfHoursInPeriod = scheduleSetting.standardMonthHours * 3;
			}
			when 'Years' {
				numberOfHoursInPeriod = scheduleSetting.standardYearHours;
			}
		}
		return numberOfHoursInPeriod;
	}

	/**
	 * Calculates number of time period units for a task
	 * @param timePeriod time period unit
	 * @param itemDuration estimated hours for task
	 *
	 * @return time period units
	 */
	public static Decimal itemPeriodSpan(String timePeriod, Decimal itemDuration) {
		Decimal itemPeriodSpan;
		itemPeriodSpan = (itemDuration / numberOfHoursInPeriod(timePeriod));
		return itemPeriodSpan;
	}

	public static TimelineBreakdown timelineBreakdown(Date startDate, Date endDate) {
		ScheduleSettingDTO scheduleSetting = UserDefinedPeriodService.scheduleSetting;
		PeriodUnits periodUnits = new PeriodUnits(scheduleSetting);
		// dates start at 00:00 hours. In order for calculations to treat last day as a full "day of work" we add 1 day
		Date adjustedEndDate = endDate.addDays(1);

		Integer numberOfMonths = startDate.monthsBetween(adjustedEndDate);
		Integer numberOfAdditionalDays = 0;
		Integer numberOfDays = startDate.daysBetween(adjustedEndDate);
		Decimal numberOfDaysInAMonth = periodUnits.dayPeriodsInAMonth;

		if (numberOfDays < numberOfDaysInAMonth) {
			numberOfMonths = 0;
		}

		Integer dateDiff = startDate.addMonths(numberOfMonths).daysBetween(adjustedEndDate);

		if (dateDiff < 0 && numberOfMonths > 0) {
			numberOfMonths -= 1;
			dateDiff = startDate.addMonths(numberOfMonths).daysBetween(adjustedEndDate);
		}

		if (dateDiff > numberOfDaysInAMonth) {
			numberOfMonths += 1;
		} else if (dateDiff > 0) {
			// date difference is less than one month
			numberOfAdditionalDays = getNumberOfAdditionalDays(periodUnits, numberOfMonths, dateDiff);
		}

		TimelineBreakdown timeline = new TimelineBreakdown();
		timeline.numberOfMonths = numberOfMonths;
		timeline.numberOfAdditionalDays = numberOfAdditionalDays;
		return timeline;
	}

	private static Integer getNumberOfAdditionalDays(
		PeriodUnits periodUnits,
		Integer numberOfMonths,
		Integer dateDiff
	) {
		Integer numberOfAdditionalDays = 0;

		Decimal calenderToScheduleFactor =
			periodUnits.dayPeriodsInAWeek / periodUnits.calendarDaysPerWeek;
		if (numberOfMonths == 0 && dateDiff <= periodUnits.calendarDaysPerWeek) {
			if (dateDiff >= periodUnits.dayPeriodsInAWeek) {
				numberOfAdditionalDays = (Integer) Math.ceil(periodUnits.dayPeriodsInAWeek);
			} else {
				numberOfAdditionalDays = dateDiff;
			}
		} else {
			numberOfAdditionalDays = (Integer) Math.ceil(calenderToScheduleFactor * dateDiff);
		}

		return numberOfAdditionalDays;
	}

	public class TimelineBreakdown {
		public Integer numberOfMonths;
		public Integer numberOfAdditionalDays;
		private TimelineBreakdown() {
		}
	}
}
