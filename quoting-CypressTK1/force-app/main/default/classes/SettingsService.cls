/**
 *  Provus Services Quoting
 *  ProjectPhaseTest
 *  @2021 Provus Inc. All rights reserved.
 */
public with sharing class SettingsService {
	public static final String FIELDNAME_SDAY_HOURS = 'StandardDayHours__c';
	public static final String FIELDNAME_SWEEK_HOURS = 'StandardWeekHours__c';
	public static final String FIELDNAME_SMONTH_HOURS = 'StandardMonthHours__c';
	public static final String FIELDNAME_SYEAR_HOURS = 'StandardYearHours__c';

	private static final Set<String> EXCLUDED_PRODUCT_MAPPINGS = new Set<String>{
		'Group',
		'Practice'
	};

	/**
	 * @return returns Provus Setup DTO object for consumption by client
	 */
	public static ProvusSetupDTO getProvusSetup() {
		ProvusSetup__mdt setupRecord = ProvusSetup__mdt.getInstance('Standard');
		return new ProvusSetupDTO(setupRecord);
	}

	/**
	 * @return returns Product Sync fields
	 */
	public static List<ProvusProductMappingDTO> getProvusProductMapping() {
		List<ProvusProductMappingDTO> mappingDTOs = new List<ProvusProductMappingDTO>();
		for (ProvusProductMapping__mdt productMapping : ProvusProductMapping__mdt.getAll().values()) {
			if (!EXCLUDED_PRODUCT_MAPPINGS.contains(productMapping.DeveloperName)) {
				mappingDTOs.add(new ProvusProductMappingDTO(productMapping));
			}
		}
		return mappingDTOs;
	}

	public static Boolean isApexLockUnlockEnabled() {
		// Organization org = [
		// 	SELECT Id, PreferencesApexApprovalLockUnlock
		// 	FROM Organization
		// 	WITH SECURITY_ENFORCED
		// ];
		// return org.PreferencesApexApprovalLockUnlock;
		return false;
	}

	/**
	 * @return returns Schedule Settings DTO object for consumption by client
	 */
	public static ScheduleSettingDTO getScheduleSettings() {
		return getScheduleSettingsForQuote(null);
	}

	/**
	 * Gets schedule setting standard hour values based on
	 *
	 * @param quoteId id of quote if quote exists
	 *
	 * @return schedule setting object containing standard hour values
	 */
	public static ScheduleSettingDTO getScheduleSettingsForQuote(Id quoteId) {
		ScheduleSettingDTO scheduleSetting = new ScheduleSettingDTO();

		if (quoteId == null) {
			ScheduleSetting__mdt scheduleSettingMdt = ScheduleSetting__mdt.getInstance(
				'StandardSchedule'
			);
			scheduleSetting.standardDayHours = scheduleSettingMdt.StandardDayHours__c;
			scheduleSetting.standardWeekHours = scheduleSettingMdt.StandardWeekHours__c;
			scheduleSetting.standardMonthHours = scheduleSettingMdt.StandardMonthHours__c;
			scheduleSetting.standardYearHours = scheduleSettingMdt.StandardYearHours__c;
		} else {
			String objectApiName = SystemUtility.getNamespacePrefix() + 'ScheduleSetting__mdt';
			ObjectOverrideDTO objectOverrideDto = ObjectOverrideController.getObjectOverride(
				quoteId,
				objectApiName
			);

			for (ValueOverrideDTO valueOverrideDto : objectOverrideDto.valueOverrides) {
				// has override value different from default value
				if (valueOverrideDto.fieldApiName.contains(FIELDNAME_SDAY_HOURS)) {
					scheduleSetting.standardDayHours = getFieldValue(valueOverrideDto);
				} else if (valueOverrideDto.fieldApiName.contains(FIELDNAME_SWEEK_HOURS)) {
					scheduleSetting.standardWeekHours = getFieldValue(valueOverrideDto);
				} else if (valueOverrideDto.fieldApiName.contains(FIELDNAME_SMONTH_HOURS)) {
					scheduleSetting.standardMonthHours = getFieldValue(valueOverrideDto);
				} else if (valueOverrideDto.fieldApiName.contains(FIELDNAME_SYEAR_HOURS)) {
					scheduleSetting.standardYearHours = getFieldValue(valueOverrideDto);
				}
			}

			Quote__c quoteSo = [
				SELECT ServiceStartDate__c, TimePeriodsAlignment__c
				FROM Quote__c
				WHERE Id = :quoteId
				WITH SECURITY_ENFORCED
			];

			if (quoteSo.TimePeriodsAlignment__c == QuoteService.TIMEPERIODSALIGNMENT_WEEKDAY_CALENDAR) {
				Integer weekdaysInYear = Calendar.weekdaysIn(
					Date.valueOf(quoteSo.ServiceStartDate__c.year() + '-1-1'),
					Date.valueOf(quoteSo.ServiceStartDate__c.year() + '-12-31')
				);
				Decimal hoursPerMonth = (weekdaysInYear * scheduleSetting.standardDayHours) / 12.0;
				scheduleSetting.standardMonthHours = hoursPerMonth;
				scheduleSetting.standardYearHours = weekdaysInYear * 8;
			}
		}
		return scheduleSetting;
	}

	private static Decimal getFieldValue(ValueOverrideDTO valueOverrideDto) {
		String hoursValue = '0';

		// if an override value exists use it instead
		if (
			valueOverrideDto.defaultFieldValue != null &&
			valueOverrideDto.fieldValue != null &&
			valueOverrideDto.fieldValue != valueOverrideDto.defaultFieldValue
		) {
			hoursValue = valueOverrideDto.fieldValue;
		} else if (valueOverrideDto.defaultFieldValue != null) {
			hoursValue = valueOverrideDto.defaultFieldValue;
		}

		return Decimal.valueOf(hoursValue);
	}
}
