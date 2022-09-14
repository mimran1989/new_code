/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
@IsTest
public with sharing class ResourceAvailabilityControllerTest extends TestBase {
	@IsTest
	static void shouldReturnFullAvailability() {
		TaskRoleSummary__c summarySo = TaskRoleSummaryTestBase.newTaskRoleSummary();
		Test.startTest();
		{
			ResourceAvailabilityDto availabilityDto = ResourceAvailabilityController.getResourceAvailability(
				summarySo.Id
			);
			System.assertEquals(100, availabilityDto.availabilityPercentage);
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

			ResourceAvailabilityDto availabilityDto = ResourceAvailabilityController.getResourceAvailability(
				summarySo.Id
			);
			System.assertEquals(50, availabilityDto.availabilityPercentage);
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldSaveResourceAvailability() {
		TaskRoleSummary__c summarySo = TaskRoleSummaryTestBase.newTaskRoleSummary();
		ResourceAvailability__c availabilitySo = new ResourceAvailability__c(
			TaskRoleSummaryId__c = summarySo.Id,
			AvailabilityPercentage__c = 25
		);
		Test.startTest();
		{
			ResourceAvailabilityDto availabilityDto = new ResourceAvailabilityDto(availabilitySo);
			ResourceAvailabilityService.saveResourceAvailability(availabilityDto);

			availabilityDto = ResourceAvailabilityController.getResourceAvailability(summarySo.Id);
			System.assertNotEquals(null, availabilityDto.id);
			System.assertEquals(25, availabilityDto.availabilityPercentage);
		}
		Test.stopTest();
	}
}
