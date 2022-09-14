/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
@IsTest
private class FilterByTest extends TestBase {
	@IsTest
	static void shouldSupportMultipleConditionTypes() {
		RateCard__c rateCard = newRateCard();
		FilterBy filter = new FilterBy();
		filter.addFilterBy('TestField1', 'test');
		filter.addFilterBy('TestField2', new Set<Id>{ rateCard.Id });
		filter.addFilterBy('TestField3', true);
		Test.startTest();
		{
			System.assert(
				filter.getWhereClause().contains('TestField1'),
				'should return a where clause matching against string'
			);
			System.assert(
				filter.getWhereClause().contains('TestField2'),
				'should return a where clause matching against record set'
			);
			System.assert(
				filter.getWhereClause().contains('TestField3'),
				'should return a where clause matching against boolean'
			);
		}
		Test.stopTest();
	}
}
