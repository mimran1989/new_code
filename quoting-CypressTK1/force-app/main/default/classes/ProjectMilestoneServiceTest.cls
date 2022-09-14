/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
@IsTest
private class ProjectMilestoneServiceTest extends TestBase {
	@IsTest
	static void itShouldReturnMilestonesForQuote() {
		Quote__c quoteSO = newQuote();
		ProjectMilestone__c milestoneSO = new ProjectMilestone__c(
			Name = 'Test',
			QuoteId__c = quoteSO.Id
		);
		insert milestoneSO;

		Test.startTest();
		System.assertEquals(
			1,
			ProjectMilestoneService.getMilestonesForQuote(quoteSO.Id).size(),
			'should return the created milestone'
		);
		Test.stopTest();
	}
}
