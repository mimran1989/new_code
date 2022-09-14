/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class ResourceAvailabilityService {
	public static ResourceAvailability__c getResourceAvailability(Id taskRoleSummaryId) {
		List<ResourceAvailability__c> availabilitySos = [
			SELECT TaskRoleSummaryId__c, AvailabilityPercentage__c
			FROM ResourceAvailability__c
			WHERE TaskRoleSummaryId__c = :taskRoleSummaryId
			WITH SECURITY_ENFORCED
			LIMIT 1
		];

		ResourceAvailability__c availabilitySo;
		if (!availabilitySos.isEmpty()) {
			availabilitySo = availabilitySos[0];
		}

		return availabilitySo;
	}

	public static void saveResourceAvailability(ResourceAvailabilityDto resourceAvailabilityDto) {
		ResourceAvailability__c resourceAvailabilitySo = (ResourceAvailability__c) resourceAvailabilityDto.refreshSo();
		CRUDUtility.upsertRecords(resourceAvailabilitySo);
	}
}
