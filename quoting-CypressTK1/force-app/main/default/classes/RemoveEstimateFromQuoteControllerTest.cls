/**
 *  Provus Services Quoting
 *  @2021 Provus Inc. All rights reserved.
 */
@IsTest
private with sharing class RemoveEstimateFromQuoteControllerTest extends EstimateTestBase {
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
	static void itShouldRemoveEstimateFromQuote() {
		Test.startTest();
		{
			Quote__c quoteSO = createQuoteFromEstimate('Months');
			Id quoteId = quoteSO.Id;
			RemoveEstimateFromQuoteController.RemoveEstimateFromQuoteResponse response = RemoveEstimateFromQuoteController.removeEstimateFromQuote(
				quoteId
			);
			System.assert(response.success, 'it should have removed estimate successfully');
		}
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
			WHERE SummaryLevel__c = :TaskRoleSummary.SUMMARYLEVEL_ACTIVITY_GROUP
		]) {
			roleSummary.LevelAdjustment__c = 1;
			roleSummaries.add(roleSummary);
		}

		CRUDUtility.updateRecords(roleSummaries);
		CreateQuoteFromEstimateService.convertEntitiesFromEstimate(quoteSO);
		return quoteSO;
	}
}
