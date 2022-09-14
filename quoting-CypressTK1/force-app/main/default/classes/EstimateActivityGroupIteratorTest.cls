/**
 *  Provus Services Quoting
 *  EstimateQuoteGroupIteratorTest
 *  @2022 Provus Inc. All rights reserved.
 */
@IsTest
public with sharing class EstimateActivityGroupIteratorTest {
	@TestSetup
	static void setup() {
		Estimate__c estimate = new Estimate__c(
			Name = 'TEST_ESTIMATE_W_RESOURCE_SPLIT_NAME',
			IsActive__c = true
		);
		CRUDUtility.insertRecords(estimate);

		List<TaskSummary__c> taskSummaries = new List<TaskSummary__c>();
		TaskSummary__c taskSumm1 = new TaskSummary__c();
		taskSummaries.add(taskSumm1);
		CRUDUtility.insertRecords(taskSummaries);

		List<ActivityGroup__c> activityGroups = new List<ActivityGroup__c>();
		ActivityGroup__c activityGroup1 = new ActivityGroup__c();
		activityGroup1.Name = 'activity group 1';
		activityGroup1.EstimateId__c = estimate.Id;
		activityGroups.add(activityGroup1);
		ActivityGroup__c activityGroup2 = new ActivityGroup__c();
		activityGroup2.Name = 'activity group 2';
		activityGroup2.EstimateId__c = estimate.Id;
		activityGroups.add(activityGroup2);
		ActivityGroup__c activityGroup3 = new ActivityGroup__c();
		activityGroup3.Name = 'activity group 3';
		activityGroup3.EstimateId__c = estimate.Id;
		activityGroups.add(activityGroup3);
		ActivityGroup__c activityGroup4 = new ActivityGroup__c();
		activityGroup4.Name = 'activity group 4';
		activityGroup4.EstimateId__c = estimate.Id;
		activityGroups.add(activityGroup4);
		CRUDUtility.insertRecords(activityGroups);

		List<TaskRoleSummary__c> taskRoleSummaries = new List<TaskRoleSummary__c>();
		TaskRoleSummary__c taskRole1 = new TaskRoleSummary__c();
		taskRole1.ActivityGroupId__c = activityGroup1.Id;
		taskRole1.SummaryId__c = taskSumm1.Id;
		taskRoleSummaries.add(taskRole1);
		TaskRoleSummary__c taskRole2 = new TaskRoleSummary__c();
		taskRole2.ActivityGroupId__c = activityGroup3.Id;
		taskRole2.SummaryId__c = taskSumm1.Id;
		taskRoleSummaries.add(taskRole2);
		CRUDUtility.insertRecords(taskRoleSummaries);
	}

	@IsTest
	static void itShouldIterateTwoTimesWhen4ActivityGroupsExistForWhichOnlyTwoHaveAssociatedTaskRoleSummaryRecords() {
		List<ActivityGroup__c> groups = [
			SELECT Id, Name, Sequence__c, (SELECT Id FROM RoleSummaries__r)
			FROM ActivityGroup__c
		];

		EstimateActivityGroupIterator activityGrpIterator = new EstimateActivityGroupIterator(groups);

		System.assertEquals(true, activityGrpIterator.hasNext(), 'has next is true');

		ActivityGroup__c group1 = activityGrpIterator.next();
		System.assertEquals('activity group 1', group1.Name, 'first activity group returned');

		System.assertEquals(true, activityGrpIterator.hasNext(), 'has next is true');

		ActivityGroup__c group2 = activityGrpIterator.next();
		System.assertEquals('activity group 3', group2.Name, 'third activity group returned');

		System.assertEquals(false, activityGrpIterator.hasNext(), 'has next is false');
	}

	@IsTest
	static void itShouldIterateTwoTimesWhen3ActivityGroupsExistAndOneHasNoAssociatedTaskRoleSummaries() {
		List<ActivityGroup__c> groups = [
			SELECT Id, Name, Sequence__c, (SELECT Id FROM RoleSummaries__r)
			FROM ActivityGroup__c
		];

		EstimateActivityGroupIterator activityGrpIterator = new EstimateActivityGroupIterator(groups);

		List<ActivityGroup__c> activityGroups = new List<ActivityGroup__c>();

		while (activityGrpIterator.hasNext()) {
			ActivityGroup__c actGrp = activityGrpIterator.next();
			activityGroups.add(actGrp);
		}

		System.assertEquals(2, activityGroups.size(), '2 activity groups should be added');
	}
}
