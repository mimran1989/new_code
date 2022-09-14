/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

@IsTest
private class QuoteCompareControllerTest extends TestBase {
	@IsTest
	static void shouldReturnQuotesForRequest() {
		/*Quote__c quoteSO = newQuote();
		Quote__c scenario1 = newQuote();

		ApprovalRequestDto dto = new ApprovalRequestDto();
		dto.items = new List<ApprovalRequestItemDto>();
		ApprovalRequestItemDto item1 = new ApprovalRequestItemDto();
		item1.quoteId = quoteSO.Id;
		item1.submittedComments = 'Test approval';
		dto.items.add(item1);

		ApprovalRequestItemDto item2 = new ApprovalRequestItemDto();
		item2.quoteId = scenario1.Id;
		item2.submittedComments = 'Test approval 1';
		dto.items.add(item2);

		QuoteApprovalService.createApprovalRequest(dto);

		ApprovalRequestItem__c requestItem = [
			SELECT Id, ApprovalRequestId__c
			FROM ApprovalRequestItem__c
			WHERE QuoteId__c = :quoteSO.Id
		];

		Test.startTest();
		{
			System.assertEquals(
				2,
				QuoteCompareController.getQuoteOverviewsForRequest(requestItem.ApprovalRequestId__c).size()
			);
		}
		Test.stopTest();*/
	}

	@IsTest
	static void shouldSetQuoteStatuses() {
		/*Quote__c quoteSO = newQuote();
		Quote__c scenario1 = newQuote();

		ApprovalRequestDto dto = new ApprovalRequestDto();
		dto.items = new List<ApprovalRequestItemDto>();
		ApprovalRequestItemDto item1 = new ApprovalRequestItemDto();
		item1.quoteId = quoteSO.Id;
		item1.submittedComments = 'Test approval';
		dto.items.add(item1);

		ApprovalRequestItemDto item2 = new ApprovalRequestItemDto();
		item2.quoteId = scenario1.Id;
		item2.submittedComments = 'Test approval 1';
		dto.items.add(item2);

		QuoteApprovalService.createApprovalRequest(dto);

		ApprovalRequestItem__c requestItem = [
			SELECT Id, ApprovalRequestId__c
			FROM ApprovalRequestItem__c
			WHERE QuoteId__c = :quoteSO.Id
		];

		Test.startTest();
		{
			QuoteCompareController.approveQuote(requestItem.ApprovalRequestId__c, quoteSO.Id);

			Map<Id, Quote__c> quotes = new Map<Id, Quote__c>(
				[
					SELECT Id, Status__c
					FROM Quote__c
					WHERE Id IN :new List<Id>{ quoteSO.Id, scenario1.Id }
					WITH SECURITY_ENFORCED
				]
			);

			System.assertEquals(QuoteService.STATUS_APPROVED, quotes.get(quoteSO.Id).Status__c);
			System.assertEquals(QuoteService.STATUS_INACTIVE, quotes.get(scenario1.Id).Status__c);
		}
		Test.stopTest();*/
	}
}
