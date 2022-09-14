/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public class PicklistMetadataService {
	public class PicklistValue {
		public String label;
		public String fullName;
		public Boolean isActive = true;
		public Boolean isDefault = false;
	}

	/**
	 * Add and activate a picklist value to an existing picklist
	 *
	 * @param sObjectType the sObject type of the context sObject
	 * @param picklistField the field schema of the context field
	 * @param newPicklistValue the new picklist value entry
	 *
	 * @return the metdata save results
	 */
	public static void addPicklistValue(
		SObjectType sObjectType,
		Schema.SObjectField picklistField,
		PicklistValue newPicklistValue
	) {
		addPicklistValue(
			UserInfo.getSessionId(),
			'' + sObjectType,
			'' + picklistField,
			newPicklistValue.label,
			newPicklistValue.fullName,
			newPicklistValue.isActive,
			newPicklistValue.isDefault
		);
	}

	/**
	 * Add and activate a picklist value to an existing picklist
	 *
	 * @param userInfoId the user info id of the logged in user
	 * @param fieldInfo the picklists info (sobject type & sobjectField type)
	 * @param newPicklistValue the new picklist value entry
	 *
	 * @return the metdata save results
	 */
	@future(callout=true)
	@SuppressWarnings(
		'PMD.ExcessiveParameterList'
	) // future methods only accept primitive types so we must pass a long parameter list
	public static void addPicklistValue(
		String userInfoId,
		String sObjectType,
		String picklistField,
		String label,
		String fullName,
		Boolean isActive,
		Boolean isDefault
	) {
		String picklistApiName = sObjectType + '.' + picklistField;
		MetadataPort service = MetadataServiceSuport.createService(userInfoId);

		CustomField contextPicklistField = (CustomField) service.readMetadata(
				'CustomField',
				new List<String>{ picklistApiName }
			)
			.getRecords()[0];
		List<CustomValue> existingPicklistValues = contextPicklistField.valueSet.valueSetDefinition.value;

		Boolean hasExistingValue = false;
		for (CustomValue picklistValue : existingPicklistValues) {
			if (picklistValue.fullName == fullName) {
				hasExistingValue = true;
				break;
			}
		}

		if (!hasExistingValue) {
			// create a new picklist value
			CustomValue newValue = new CustomValue();
			newValue.label = label;
			newValue.fullName = fullName;
			newValue.isActive = isActive;
			newValue.default_x = isDefault;
			existingPicklistValues.add(newValue);
		}

		service.updateMetadata(new List<Metadata>{ contextPicklistField });
	}
}
