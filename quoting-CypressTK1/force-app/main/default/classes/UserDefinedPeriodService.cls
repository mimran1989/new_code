public with sharing class UserDefinedPeriodService {
	public static ScheduleSettingDTO scheduleSetting;
	static {
		scheduleSetting = SettingsService.getScheduleSettings();
	}

	public Date calculatePeriodEndDate(Date startDate, Date serviceEndDate, String periodType) {
		Date endDate;

		switch on periodType {
			when 'Months' {
				endDate = startDate.toStartOfMonth().addMonths(1).addDays(-1);
			}
			when 'Days' {
				endDate = startDate.addDays(1).addDays(-1);
			}
			when 'Weeks' {
				endDate = startDate.toStartOfWeek().addDays(7).addDays(-1);
			}
			when 'Quarters' {
				endDate = startDate.toStartOfMonth().addMonths(3).addDays(-1);
			}
		}

		if (endDate > serviceEndDate) {
			endDate = serviceEndDate;
		}

		return endDate;
	}
}
