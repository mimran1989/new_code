/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class ResourceAvailabilityController {
	@AuraEnabled
	public static ResourceAvailabilityDto getResourceAvailability(Id taskRoleSummaryId) {
		ResourceAvailability__c availabilitySo = ResourceAvailabilityService.getResourceAvailability(
			taskRoleSummaryId
		);
		if (availabilitySo == null) {
			availabilitySo = new ResourceAvailability__c(
				TaskRoleSummaryId__c = taskRoleSummaryId,
				AvailabilityPercentage__c = 100
			);
		}

		return new ResourceAvailabilityDto(availabilitySo);
	}

	@AuraEnabled
	public static void saveResourceAvailability(ResourceAvailabilityDto resourceAvailabilityDto) {
		ResourceAvailabilityService.saveResourceAvailability(resourceAvailabilityDto);
	}
}
