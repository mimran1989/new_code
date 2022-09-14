/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
@IsTest
public with sharing class ResourceAvailabilityServiceTest extends TestBase {
	@IsTest
	static void shouldReturnFullAvailability() {
		TaskRoleSummary__c summarySo = TaskRoleSummaryTestBase.newTaskRoleSummary();
		Test.startTest();
		{
			ResourceAvailability__c availabilitySo = ResourceAvailabilityService.getResourceAvailability(
				summarySo.Id
			);
			System.assertEquals(null, availabilitySo);
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldReturnPartAvailability() {
		TaskRoleSummary__c summarySo = TaskRoleSummaryTestBase.newTaskRoleSummary();
		ResourceAvailability__c availabilitySo = new ResourceAvailability__c(
			TaskRoleSummaryId__c = summarySo.Id,
			AvailabilityPercentage__c = 50
		);
		Test.startTest();
		{
			insert availabilitySo;

			availabilitySo = ResourceAvailabilityService.getResourceAvailability(summarySo.Id);
			System.assertEquals(50, availabilitySo.AvailabilityPercentage__c);
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldSaveResourceAvailability() {
		TaskRoleSummary__c summarySo = TaskRoleSummaryTestBase.newTaskRoleSummary();
		ResourceAvailability__c availabilitySo = new ResourceAvailability__c(
			TaskRoleSummaryId__c = summarySo.Id,
			AvailabilityPercentage__c = 50
		);
		Test.startTest();
		{
			ResourceAvailabilityDto availabilityDto = new ResourceAvailabilityDto(availabilitySo);
			ResourceAvailabilityService.saveResourceAvailability(availabilityDto);

			availabilitySo = ResourceAvailabilityService.getResourceAvailability(summarySo.Id);
			System.assertNotEquals(null, availabilitySo.Id);
		}
		Test.stopTest();
	}
}
