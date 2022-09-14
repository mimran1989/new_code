/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

@IsTest
private class SplitResourceDialogControllerTest {
	@IsTest
	static void itShouldSaveResourceSplits() {
		TaskRoleSummary__c roleSummarySO = TaskRoleSummaryTestBase.newTaskRoleSummary();
		ResourceSplitDTO splitDto = new ResourceSplitDTO();
		splitDto.Name = 'Test';
		splitDto.splitPercentage = 100;
		splitDto.taskRoleSummaryId = roleSummarySO.Id;

		Test.startTest();
		SplitResourceDialogController.saveSplits(
			roleSummarySO.Id,
			new List<ResourceSplitDTO>{ splitDto }
		);
		System.assertEquals(
			1,
			SplitResourceDialogController.getSplitsForRoleSummary(roleSummarySO.Id).size(),
			'should return the saved split DTO'
		);
		Test.stopTest();
	}
}
