/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
@IsTest
private class QuoteSummaryDOTest {
	@IsTest
	static void itShouldSortList() {
		QuoteSummaryDO summary1 = new QuoteSummaryDO();
		summary1.sequence = 5;
		QuoteSummaryDO summary2 = new QuoteSummaryDO();
		summary2.sequence = 4;
		QuoteSummaryDO summary3 = new QuoteSummaryDO();
		summary3.sequence = 3;
		QuoteSummaryDO summary4 = new QuoteSummaryDO();
		summary4.sequence = 2;
		QuoteSummaryDO summary5 = new QuoteSummaryDO();
		summary5.sequence = 1;

		List<QuoteSummaryDO> summaries = new List<QuoteSummaryDO>{
			summary1,
			summary2,
			summary3,
			summary4,
			summary5
		};

		Test.startTest();
		summaries.sort();
		System.assert(summaries[0].sequence == 1, 'should be 1');
		System.assert(summaries[1].sequence == 2, 'should be 2');
		System.assert(summaries[2].sequence == 3, 'should be 3');
		System.assert(summaries[3].sequence == 4, 'should be 4');
		System.assert(summaries[4].sequence == 5, 'should be 5');
		Test.stopTest();
	}

	@IsTest
	static void itShouldSortNullsLast() {
		QuoteSummaryDO summary1 = new QuoteSummaryDO();
		summary1.sequence = 3;
		QuoteSummaryDO summary2 = new QuoteSummaryDO();
		QuoteSummaryDO summary3 = new QuoteSummaryDO();
		summary3.sequence = 2;
		QuoteSummaryDO summary4 = new QuoteSummaryDO();
		QuoteSummaryDO summary5 = new QuoteSummaryDO();
		summary5.sequence = 1;

		List<QuoteSummaryDO> summaries = new List<QuoteSummaryDO>{
			summary1,
			summary2,
			summary3,
			summary4,
			summary5
		};

		Test.startTest();
		summaries.sort();
		System.assert(summaries[0].sequence == 1, 'should be 1');
		System.assert(summaries[1].sequence == 2, 'should be 2');
		System.assert(summaries[2].sequence == 3, 'should be 3');
		System.assert(summaries[3].sequence == null, 'should be null');
		System.assert(summaries[4].sequence == null, 'should be null');
		Test.stopTest();
	}
}
