@IsTest
private class QuoteCloneServiceTest extends TestBase {
	@IsTest
	static void shouldAssignSectionsToQuoteItems() {
		Quote__c quoteSO = newQuote();
		QuoteSection__c sectionSO1 = newQuoteSection(quoteSO.Id);
		QuoteSection__c sectionSO2 = newQuoteSection(quoteSO.Id);

		QuoteItem__c quoteItemSO1 = new QuoteItem__c(
			QuoteId__c = quoteSO.Id,
			QuoteSectionId__c = sectionSO1.Id
		);
		QuoteItem__c quoteItemSO2 = new QuoteItem__c(
			QuoteId__c = quoteSO.Id,
			QuoteSectionId__c = sectionSO2.Id
		);
		CRUDUtility.insertRecords(new List<QuoteItem__c>{ quoteItemSO1, quoteItemSO2 });

		Test.startTest();
		String clonedQuote = QuoteCloneService.cloneQuote((String) quoteSO.Id, 'Test Clone Quote');
		List<QuoteItem__c> items = [
			SELECT Id, QuoteSectionId__c
			FROM QuoteItem__c
			WHERE QuoteId__c = :clonedQuote
		];
		List<Id> sectionIds = new List<Id>();
		for (QuoteItem__c item : items) {
			sectionIds.add(item.QuoteSectionId__c);
		}

		System.assert(sectionIds.size() == 2, 'should have each section assigned to the quote items');
		Test.stopTest();
	}
}
