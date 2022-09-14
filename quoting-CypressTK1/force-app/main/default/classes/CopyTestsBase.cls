/**
 *  Provus Services Quoting
 *  CopyTestsBase
 *  @2021 Provus Inc. All rights reserved.
 */
public with sharing abstract class CopyTestsBase extends TestBase {
	public static Quote__c newTemplate() {
		Quote__c newQuote = new Quote__c(
			ServiceStartDate__c = Date.today(),
			ServiceEndDate__c = Date.today().addDays(7),
			TimePeriod__c = TimePeriodDay.NAME_PLURAL,
			TimePeriodsGroupMethod__c = TimePeriodWeek.NAME
		);

		newQuote.Type__c = QuoteService.RECORDTYPE_NAME_TEMPLATE;
		CRUDUtility.insertRecords(newQuote);
		return newQuote;
	}
}
