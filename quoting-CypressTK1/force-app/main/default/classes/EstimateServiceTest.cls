/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

@IsTest
private class EstimateServiceTest extends EstimateTestBase {
	@IsTest
	static void shouldCalculateADateBasedOn640Hours() {
		Estimate__c estimateSo = newEstimate();
		ActivityGroup__c groupSo = createNewActivityGroup(estimateSo.Id);
		TaskRoleSummary__c roleSummary1 = TaskRoleSummaryTestBase.newTaskRoleSummary();
		roleSummary1.ActivityGroupId__c = groupSo.Id;
		roleSummary1.EstimateId__c = estimateSo.Id;
		roleSummary1.LevelAdjustment__c = 400;
		TaskRoleSummary__c roleSummary2 = TaskRoleSummaryTestBase.newTaskRoleSummary();
		roleSummary1.ActivityGroupId__c = groupSo.Id;
		roleSummary1.EstimateId__c = estimateSo.Id;
		roleSummary1.LevelAdjustment__c = 1280;
		CRUDUtility.updateRecords(new List<TaskRoleSummary__c>{ roleSummary1, roleSummary2 });

		ResourceSplit__c split1 = new ResourceSplit__c(
			TaskRoleSummaryId__c = roleSummary1.Id,
			SplitPercentage__c = 50
		);
		ResourceSplit__c split2 = new ResourceSplit__c(
			TaskRoleSummaryId__c = roleSummary1.Id,
			SplitPercentage__c = 50
		);
		CRUDUtility.insertRecords(new List<ResourceSplit__c>{ split1, split2 });

		Test.startTest();
		{
			EndDateArgs args = new EndDateArgs();
			args.calendarAlignment = 'User Defined Calendar';
			args.serviceStartDate = Date.valueOf('2022-08-01');
			args.timePeriods = TimePeriodMonth.NAME_PLURAL;
			EstimateService.getServiceEndDate(estimateSo.Id, args);
			System.assertEquals(
				Date.valueOf('2022-11-30'),
				EstimateService.getServiceEndDate(estimateSo.Id, args),
				'it should calculate an end date of 2022-11-30'
			);
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldCalculate160HoursWhenSplit() {
		Estimate__c estimateSo = newEstimate();
		ActivityGroup__c groupSo = createNewActivityGroup(estimateSo.Id);
		TaskRoleSummary__c roleSummary1 = TaskRoleSummaryTestBase.newTaskRoleSummary();
		roleSummary1.ActivityGroupId__c = groupSo.Id;
		roleSummary1.EstimateId__c = estimateSo.Id;
		roleSummary1.LevelAdjustment__c = 160;
		TaskRoleSummary__c roleSummary2 = TaskRoleSummaryTestBase.newTaskRoleSummary();
		roleSummary1.ActivityGroupId__c = groupSo.Id;
		roleSummary1.EstimateId__c = estimateSo.Id;
		roleSummary1.LevelAdjustment__c = 320;
		CRUDUtility.updateRecords(new List<TaskRoleSummary__c>{ roleSummary1, roleSummary2 });

		ResourceSplit__c split = new ResourceSplit__c(
			TaskRoleSummaryId__c = roleSummary1.Id,
			SplitPercentage__c = 50
		);
		CRUDUtility.insertRecords(new List<ResourceSplit__c>{ split });

		Test.startTest();
		{
			Map<Id, Decimal> activityGroupMaxByIds = EstimateService.getActivityGroupMaxDurations(
				estimateSo.Id
			);
			System.assertEquals(
				160,
				activityGroupMaxByIds.get(groupSo.Id),
				'it should calculate 160 hours'
			);
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldCalculate160HoursWhenSplitAndParttime() {
		Estimate__c estimateSo = newEstimate();
		ActivityGroup__c groupSo = createNewActivityGroup(estimateSo.Id);
		TaskRoleSummary__c roleSummary1 = TaskRoleSummaryTestBase.newTaskRoleSummary();
		roleSummary1.ActivityGroupId__c = groupSo.Id;
		roleSummary1.EstimateId__c = estimateSo.Id;
		roleSummary1.LevelAdjustment__c = 400;

		CRUDUtility.updateRecords(new List<TaskRoleSummary__c>{ roleSummary1 });

		ResourceSplit__c split1 = new ResourceSplit__c(
			TaskRoleSummaryId__c = roleSummary1.Id,
			SplitPercentage__c = 20
		);
		ResourceSplit__c split2 = new ResourceSplit__c(
			TaskRoleSummaryId__c = roleSummary1.Id,
			SplitPercentage__c = 20
		);
		ResourceSplit__c split3 = new ResourceSplit__c(
			TaskRoleSummaryId__c = roleSummary1.Id,
			SplitPercentage__c = 20
		);
		ResourceSplit__c split4 = new ResourceSplit__c(
			TaskRoleSummaryId__c = roleSummary1.Id,
			SplitPercentage__c = 20
		);
		ResourceSplit__c split5 = new ResourceSplit__c(
			TaskRoleSummaryId__c = roleSummary1.Id,
			SplitPercentage__c = 20
		);
		ResourceAvailability__c availability = new ResourceAvailability__c(
			TaskRoleSummaryId__c = roleSummary1.Id,
			AvailabilityPercentage__c = 50
		);

		CRUDUtility.insertRecords(new List<ResourceSplit__c>{ split1, split2, split3, split4, split5 });
		CRUDUtility.insertRecords(new List<ResourceAvailability__c>{ availability });

		Test.startTest();
		{
			Map<Id, Decimal> activityGroupMaxByIds = EstimateService.getActivityGroupMaxDurations(
				estimateSo.Id
			);
			System.assertEquals(
				160,
				activityGroupMaxByIds.get(groupSo.Id),
				'it should calculate 160 hours'
			);
		}
		Test.stopTest();
	}
}
