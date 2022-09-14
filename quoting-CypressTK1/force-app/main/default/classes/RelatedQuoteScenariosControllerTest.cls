/**
 *  Provus Services Quoting
 *  RelatedQuoteScenariosControllerTest
 *  @2021 Provus Inc. All rights reserved.
 */
@isTest
private class RelatedQuoteScenariosControllerTest extends TestBase {
	@testSetup
	static void setup() {
		Quote__c quote = newQuote();
		quote.Name = 'Base Quote';
		quote.TotalAmount__c = 400000;
		quote.MarginPercent__c = 15;
		CRUDUtility.updateRecords(quote);

		// create first scenario
		CreateNewScenarioController.QuoteAdjustment quoteAdjustment = new CreateNewScenarioController.QuoteAdjustment();
		String scenarioName = 'Moderate Revenue Adjustment';
		quoteAdjustment.type = 'Revenue Adjustment';
		quoteAdjustment.value = 500000;
		String adjustment = JSON.serialize(quoteAdjustment);
		CreateNewScenarioController.cloneQuoteToScenario(quote.Id, adjustment, scenarioName);

		// create second scenario
		scenarioName = 'Large Revenue Adjustment';
		quoteAdjustment.value = 800000;
		adjustment = JSON.serialize(quoteAdjustment);
		CreateNewScenarioController.cloneQuoteToScenario(quote.Id, adjustment, scenarioName);
	}

	@isTest
	static void itShouldGetRelatedScenarios() {
		Test.startTest();
		Quote__c quote = [
			SELECT Id, Name
			FROM Quote__c
			WHERE Name = 'Large Revenue Adjustment'
			LIMIT 1
		];
		List<Quote__c> relatedScenarios = RelatedQuoteScenariosController.getScenarios(quote.Id);
		System.assertEquals(
			2,
			relatedScenarios.size(),
			'should have retrieved 2 quotes (original quote and 1 related scenario)'
		);
		Test.stopTest();
	}
}
