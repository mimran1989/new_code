/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
@IsTest
private class ResourceSplitServiceTest {
	@IsTest
	static void itShouldReturnSplitsForSummary() {
		TaskRoleSummary__c roleSummary = TaskRoleSummaryTestBase.newTaskRoleSummary();
		List<ResourceSplit__c> splits = new List<ResourceSplit__c>();
		splits.add(
			new ResourceSplit__c(
				Name = 'Test Role',
				TaskRoleSummaryId__c = roleSummary.Id,
				SplitPercentage__c = 100
			)
		);
		CRUDUtility.insertRecords(splits);
		Test.startTest();
		System.assert(
			ResourceSplitService.getSplitsForRoleSummary(roleSummary.Id).size() == 1,
			'should return resource splits for the role summary'
		);
		Test.stopTest();
	}
}
