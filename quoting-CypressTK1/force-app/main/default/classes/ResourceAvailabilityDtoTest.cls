/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

@IsTest
private class ResourceAvailabilityDtoTest extends TestBase {
	@IsTest
	static void shouldCreateANewDtoWithTheGivenSObject() {
		TaskRoleSummary__c summarySo = TaskRoleSummaryTestBase.newTaskRoleSummary();
		ResourceAvailability__c availabilitySo = new ResourceAvailability__c(
			TaskRoleSummaryId__c = summarySo.Id,
			AvailabilityPercentage__c = 0.5
		);
		Test.startTest();
		{
			ResourceAvailabilityDto availabilityDto = new ResourceAvailabilityDto(availabilitySo);
			System.assertEquals(0.5, availabilityDto.availabilityPercentage);
			System.assertEquals(summarySo.Id, availabilityDto.taskRoleSummaryId);
		}
		Test.stopTest();
	}
}
