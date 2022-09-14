@IsTest
public with sharing class SyncEstimateToQuoteServiceTest extends EstimateTestBase {
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
		Id estimateID = CreateEstimateController.createEstimateFromTemplate(estimateTemplate.Id);
		RuntimeContext.isCreateEstimateMode = false;
		// retrieve tasks and add duration to effectuate duration fields of the parent task role summary records
		List<Task__c> tasks = [SELECT Id FROM Task__c WHERE EstimateId__c = :estimateID];
		for (Task__c task : tasks) {
			task.CalculatedDuration__c = 50;
		}
		CRUDUtility.updateRecords(tasks);
	}

	@IsTest
	static void itShouldNotHaveNullValueforServiceEndDate() {
		Estimate__c estimateObj = [SELECT Id FROM Estimate__c WHERE Name = 'CLM Development Estimate'];

		EndDateArgs endDateArgs = new EndDateArgs();
		endDateArgs.serviceStartDate = System.today();
		endDateArgs.timePeriods = 'Months';
		endDateArgs.calendarAlignment = 'User Defined Calendar';

		Test.startTest();
		Date serviceEndDate = EstimateService.getServiceEndDate(estimateObj.Id, endDateArgs);
		Test.stopTest();

		System.assertNotEquals(serviceEndDate, null, 'ServiceEndDate is NULL');
	}

	@IsTest
	static void itShouldUpdateQuoteCellHeadCountValue() {
		Test.startTest();
		Estimate__c estimateObj = [
			SELECT Id, RateCardId__c
			FROM Estimate__c
			WHERE Name = 'CLM Development Estimate'
		];
		Quote__c quoteSO = createQuoteFromEstimate('Months');
		List<QuoteItemCell__c> quoteItemCellValues = getQuoteCellValues(quoteSO.Id);

		// should be 1
		Integer quoteItemCell = quoteItemCellValues.size();
		System.assertEquals(2, quoteItemCell, 'item cell COUNT should equal 2');

		QuoteItemCell__c quoteItemCellValue1 = quoteItemCellValues[0];
		System.assertEquals(1, quoteItemCellValue1.C001__c, 'item cell 1 value should equal one');
		System.assertEquals(
			0.31250,
			quoteItemCellValue1.C002__c,
			'item cell 2 value should equal null'
		);

		List<TaskRoleSummary__c> roleSummaries = new List<TaskRoleSummary__c>();
		for (TaskRoleSummary__c roleSummary : [
			SELECT Id
			FROM TaskRoleSummary__c
			WHERE SummaryLevel__c = 'Activity Group'
		]) {
			roleSummary.LevelAdjustment__c = 320;
			roleSummaries.add(roleSummary);
		}

		CRUDUtility.updateRecords(roleSummaries);

		SyncEstimateToQuoteService.syncEstimateToQuote(estimateObj.Id);

		List<QuoteItemCell__c> quoteItemCellValuesAfterUpdate = getQuoteCellValues(quoteSO.Id);

		// should be 1
		quoteItemCell = quoteItemCellValuesAfterUpdate.size();
		System.assertEquals(2, quoteItemCell, 'item cell COUNT should equal 2');

		quoteItemCellValue1 = quoteItemCellValuesAfterUpdate[0];
		System.assertEquals(
			1,
			quoteItemCellValue1.C001__c,
			'after update item cell 1 value should equal one'
		);
		System.assertEquals(
			1,
			quoteItemCellValue1.C002__c,
			'after update item cell 2 value should equal one'
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
			roleSummary.LevelAdjustment__c = 160;
			roleSummaries.add(roleSummary);
		}

		CRUDUtility.updateRecords(roleSummaries);
		CreateQuoteFromEstimateService.convertEntitiesFromEstimate(quoteSO);
		return quoteSO;
	}
}
