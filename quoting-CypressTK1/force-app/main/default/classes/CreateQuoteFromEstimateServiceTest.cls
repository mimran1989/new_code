/**
 *  Provus Services Quoting
 *  @2021 Provus Inc. All rights reserved.
 */
@IsTest
private class CreateQuoteFromEstimateServiceTest extends EstimateTestBase {
	@TestSetup
	static void setup() {
		List<Product__c> resourceRoles = createResourceRoles();
		RateCard__c rateCard = newRateCardWithItems(resourceRoles);
		EstimateTemplate__c estimateTemplate = EstimateTemplateTestBase.newEstimateTemplate();
		estimateTemplate.RateCardId__c = rateCard.Id;
		update estimateTemplate;
		List<ActivityGroupTemplate__c> activityGroupTemplates = EstimateTemplateTestBase.createActivityGroupTemplates(
			estimateTemplate.Id
		);
		List<ActivityTemplate__c> activityTemplates = EstimateTemplateTestBase.createActivityTemplates(
			activityGroupTemplates
		);

		EstimateTemplateTestBase.createTaskTemplates(activityTemplates, resourceRoles);
		CreateEstimateService.createEstimate(estimateTemplate.Id);

		createDataForSplitQuote(rateCard.Id, resourceRoles);
	}

	@IsTest
	static void itShouldSplitPeriodSpanValueWithRatio40x60WhenSplitOf40And60ExistForResource() {
		// test data creates two 50 hour tasks. To determine the period span we divide 50 / 8 which equal 6.25
		// we then split this by the corresponding resource split percentages
		SplitResourceTestInfo testInfo = getSplitResourceTestInfo();

		Test.startTest();

		CreateQuoteFromEstimateService.createSections(testInfo.quote);

		Test.stopTest();

		List<QuoteItemCell__c> quoteItemCellValues = getQuoteCellValues(testInfo.quote.Id);

		System.assertEquals(4, quoteItemCellValues.size(), 'should create 4 quote item cell records');

		// should be split 40% of 6.25 which equals 2.5
		QuoteItemCell__c quoteItemCell1 = quoteItemCellValues[0];
		System.assertEquals(1, quoteItemCell1.C001__c, 'item cell 1 value should equal one');
		System.assertEquals(1, quoteItemCell1.C002__c, 'item cell 2 value should equal one');
		System.assertEquals(0.5, quoteItemCell1.C003__c, 'item cell 3 value should equal 0.5');

		// should be split 60% of 6.25 which equals 3.75
		QuoteItemCell__c quoteItemCell2 = quoteItemCellValues[1];
		System.assertEquals(1, quoteItemCell2.C001__c, 'item cell 1 value should equal one');
		System.assertEquals(1, quoteItemCell2.C002__c, 'item cell 2 value should equal one');
		System.assertEquals(1, quoteItemCell2.C003__c, 'item cell 3 value should equal one');
		System.assertEquals(0.75, quoteItemCell2.C004__c, 'item cell 4 value should equal 0.75');
	}

	@IsTest
	static void itShouldSplitEvenlyPeriodSpanStartingAtCellPos4WhenCrossingQuoteSectionAndSplitOf50And50ExistForResource() {
		// test data creates two 50 hour tasks. To determine the period span we divide 50 / 8 which equal 6.25
		// we then split this by the corresponding resource split percentages
		SplitResourceTestInfo testInfo = getSplitResourceTestInfo();

		Test.startTest();

		CreateQuoteFromEstimateService.createSections(testInfo.quote);

		Test.stopTest();

		List<QuoteItemCell__c> quoteItemCellValues = getQuoteCellValues(testInfo.quote.Id);

		// should be split 50% of 6.25 which equals 3.125
		QuoteItemCell__c quoteItemCell3 = quoteItemCellValues[2];
		System.assertEquals(0.25, quoteItemCell3.C004__c, 'item cell 4 value should equal 0.25');
		System.assertEquals(1, quoteItemCell3.C005__c, 'item cell 5 value should equal one');
		System.assertEquals(1, quoteItemCell3.C006__c, 'item cell 6 value should equal one');
		System.assertEquals(0.875, quoteItemCell3.C007__c, 'item cell 7 value should equal 0.875');

		// should be split 50% of 6.25 which equals 3.125
		QuoteItemCell__c quoteItemCell4 = quoteItemCellValues[3];
		System.assertEquals(0.25, quoteItemCell4.C004__c, 'item cell 4 value should equal 0.25');
		System.assertEquals(1, quoteItemCell4.C005__c, 'item cell 5 value should equal one');
		System.assertEquals(1, quoteItemCell4.C006__c, 'item cell 6 value should equal one');
		System.assertEquals(0.875, quoteItemCell4.C007__c, 'item cell 7 value should equal 0.875');
	}

	@IsTest
	static void itShouldAssignQuoteItems() {
		Test.startTest();
		Quote__c quoteSO = createQuoteFromEstimate('Months');
		List<QuoteItem__c> quoteItems = [
			SELECT Id, ProductId__r.Name
			FROM QuoteItem__c
			WHERE QuoteId__c = :quoteSO.Id
			ORDER BY Sequence__c
		];
		System.assert(!quoteItems.isEmpty(), 'quote items should exist for quote');
		System.assert(
			quoteItems[0].ProductId__r.Name == 'Software Engineer' &&
			quoteItems[1].ProductId__r.Name == 'Project Manager',
			'quote item creation should follow task order'
		);
		Test.stopTest();
	}

	private static Quote__c createQuoteFromEstimate(String timePeriod) {
		Estimate__c estimateObj = [
			SELECT Id, RateCardId__c
			FROM Estimate__c
			WHERE Name = 'CLM Development Estimate'
		];
		QuoteDO quoteResult = CreateQuoteFromEstimateController.getEstimateDetails(estimateObj.Id);

		quoteResult.serviceStartDate = System.today();
		quoteResult.serviceEndDate = System.today().addYears(1);
		quoteResult.timePeriod = timePeriod;
		quoteResult.timePeriodsGroupMethod = TimePeriodYear.NAME;
		quoteResult.timePeriodsAlignment = 'User Defined Calendar';

		Quote__c quoteSO = QuoteDO.getQuoteFromData(quoteResult);
		quoteSO.QuoteDate__c = System.today();
		quoteSO.Version__c = 1;
		quoteSO.Type__c = QuoteService.RECORDTYPE_NAME_QUOTE;
		CRUDUtility.insertRecords(quoteSO);
		List<TaskRoleSummary__c> roleSummaries = new List<TaskRoleSummary__c>();
		for (TaskRoleSummary__c roleSummary : [
			SELECT Id
			FROM TaskRoleSummary__c
			WHERE SummaryLevel__c = 'Activity Group'
		]) {
			roleSummary.LevelAdjustment__c = 1;
			roleSummaries.add(roleSummary);
		}

		CRUDUtility.updateRecords(roleSummaries);
		CreateQuoteFromEstimateService.convertEntitiesFromEstimate(quoteSO);
		return quoteSO;
	}

	@IsTest
	static void itShouldReturn3ResourceRolesWhenOneTaskRoleSummaryHasZeroEstimateDuration() {
		SplitResourceTestInfo testInfo = getSplitResourceTestInfo();

		Test.startTest();

		Set<Id> resourceRoles = EstimateService.getOrderedResourceRoles(testInfo.quote.EstimateId__c);

		Test.stopTest();

		System.assertEquals(2, resourceRoles.size(), 'resource roles');
	}

	@IsTest
	static void itShouldSetQuoteItemCellsForMonths() {
		Test.startTest();
		Quote__c quoteSO = createQuoteFromEstimate('Months');
		List<QuoteItem__c> quoteItems = [
			SELECT Id, (SELECT C001__c FROM QuoteItemCells__r)
			FROM QuoteItem__c
			WHERE QuoteId__c = :quoteSO.Id
		];
		System.assert(
			quoteItems[0].QuoteItemCells__r[0].C001__c > 0,
			'quote item cell should be non-zero'
		);
		Test.stopTest();
	}

	@IsTest
	static void itShouldSetQuoteItemCellsForDays() {
		Test.startTest();
		Quote__c quoteSO = createQuoteFromEstimate('Days');
		List<QuoteItem__c> quoteItems = [
			SELECT Id, (SELECT C001__c FROM QuoteItemCells__r)
			FROM QuoteItem__c
			WHERE QuoteId__c = :quoteSO.Id
		];
		System.assert(
			quoteItems[0].QuoteItemCells__r[0].C001__c > 0,
			'quote item cell should be non-zero'
		);
		Test.stopTest();
	}

	@IsTest
	static void itShouldSetQuoteItemCellsForWeeks() {
		Test.startTest();
		Quote__c quoteSO = createQuoteFromEstimate('Weeks');
		List<QuoteItem__c> quoteItems = [
			SELECT Id, (SELECT C001__c FROM QuoteItemCells__r)
			FROM QuoteItem__c
			WHERE QuoteId__c = :quoteSO.Id
		];
		System.assert(
			quoteItems[0].QuoteItemCells__r[0].C001__c > 0,
			'quote item cell should be non-zero'
		);
		Test.stopTest();
	}

	static SplitResourceTestInfo getSplitResourceTestInfo() {
		SplitResourceTestInfo testInfo = new SplitResourceTestInfo();
		Id resourceRoleTypeId = SObjectUtility.getRecordTypeIdbyName(
			Schema.SObjectType.Product__c.getName(),
			'Resource Role'
		);

		testInfo.quote = [
			SELECT Id, EstimateId__c, TimePeriod__c, TimePeriodsAlignment__c, LaborUnits__c
			FROM Quote__c
			WHERE Name = :EstimateTestBase.TEST_SPLIT_QUOTE
			LIMIT 1
		];

		ResourceRolePreference resourceRolePref = new ResourceRolePreference();
		resourceRolePref.skillLevel = 'L1';
		resourceRolePref.location = 'United States/California';

		for (Product__c product : [
			SELECT Id
			FROM Product__c
			WHERE RecordTypeId = :resourceRoleTypeId
		]) {
			testInfo.rolePreferencesById.put(product.Id, resourceRolePref);
		}

		return testInfo;
	}

	class SplitResourceTestInfo {
		Quote__c quote;
		Map<Id, ResourceRolePreference> rolePreferencesById = new Map<Id, ResourceRolePreference>();
	}
}
