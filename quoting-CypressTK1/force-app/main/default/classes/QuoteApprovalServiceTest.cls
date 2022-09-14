/**
 *  Provus Services Quoting
 *  QuoteApprovalServiceTest
 *  @2022 Provus Inc. All rights reserved.
 */
@IsTest
public class QuoteApprovalServiceTest extends TestBase {
	@TestSetup
	static void setup() {
		User manager = newUser();
		User currentUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
		currentUser.ManagerId = manager.Id;
		CRUDUtility.updateRecords(currentUser);
	}

	@IsTest
	static void shouldCreateApprovalRequestObject() {
		Quote__c quoteSO = newQuote();
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

		Boolean result = QuoteApprovalService.createApprovalRequest(dto);

		System.assert(result == true, 'should be true');

		ApprovalRequestItem__c requestItem = [
			SELECT Id, ApprovalRequestId__c
			FROM ApprovalRequestItem__c
			WHERE QuoteId__c = :quoteSO.Id
		];

		System.assert(requestItem != null, 'should have item created');
	}

	@IsTest
	static void shouldCreateApprovalProcessWorkItemObject() {
		Quote__c quoteSO = newQuote();
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

		Boolean result = QuoteApprovalService.createApprovalRequest(dto);

		System.assert(result == true, 'should be true');

		ApprovalRequestItem__c requestItem = [
			SELECT Id, ApprovalRequestId__c
			FROM ApprovalRequestItem__c
			WHERE QuoteId__c = :quoteSO.Id
		];

		ProcessInstanceWorkitem workItem = QuoteApprovalService.getApprovalWorkItem(
			requestItem.ApprovalRequestId__c
		);

		System.assert(workItem.Id != null, 'should have approval process work item created');
		System.assert(
			workItem.ProcessInstance.Status == 'Pending',
			'should have approval process work item created with Pending Status'
		);
	}

	@IsTest
	static void shouldApproveApprovalProcessWorkItemObject() {
		Quote__c quoteSO = newQuote();
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

		Boolean result = QuoteApprovalService.createApprovalRequest(dto);

		System.assert(result == true, 'should be true');

		ApprovalRequestItem__c requestItem = [
			SELECT Id, ApprovalRequestId__c
			FROM ApprovalRequestItem__c
			WHERE QuoteId__c = :quoteSO.Id
		];

		QuoteApprovalService.approve(requestItem.ApprovalRequestId__c, quoteSO.Id);

		List<ProcessInstance> workItems = [
			SELECT Id, Status
			FROM ProcessInstance
			WHERE TargetObjectId = :requestItem.ApprovalRequestId__c
			WITH SECURITY_ENFORCED
		];

		System.assert(workItems[0].Id != null, 'should have approval process work item created');
		System.assert(
			workItems[0].Status == 'Approved',
			'should have approval process work item updated with Approved Status'
		);
	}

	static void shouldRejectApprovalProcessWorkItemObject() {
		Quote__c quoteSO = newQuote();
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

		Boolean result = QuoteApprovalService.createApprovalRequest(dto);

		System.assert(result == true, 'should be true');

		ApprovalRequestItem__c requestItem = [
			SELECT Id, ApprovalRequestId__c
			FROM ApprovalRequestItem__c
			WHERE QuoteId__c = :quoteSO.Id
		];

		QuoteApprovalService.reject(requestItem.ApprovalRequestId__c, 'Test Rejected');

		List<ProcessInstance> workItems = [
			SELECT Id, Status
			FROM ProcessInstance
			WHERE TargetObjectId = :requestItem.ApprovalRequestId__c
			WITH SECURITY_ENFORCED
		];

		System.assert(workItems[0].Id != null, 'should have approval process work item created');
		System.assert(
			workItems[0].Status == 'Rejected',
			'should have approval process work item updated with Approved Status'
		);
	}

	@IsTest
	static void shouldLockApprovalRequestObject() {
		Quote__c quoteSO = newQuote();
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

		Boolean result = QuoteApprovalService.createApprovalRequest(dto);

		System.assert(result == true, 'should be true');

		ApprovalRequestItem__c requestItem = [
			SELECT Id, ApprovalRequestId__c
			FROM ApprovalRequestItem__c
			WHERE QuoteId__c = :quoteSO.Id
		];

		System.assert(requestItem.Id != null, 'should have item id');
		if (SettingsService.isApexLockUnlockEnabled()) {
			System.assert(Approval.isLocked(requestItem.Id), 'Approval request should be locked');
			System.assert(Approval.isLocked(quoteSO.Id), 'Approval request quote should be locked');
			System.assert(Approval.isLocked(scenario1.Id), 'Approval request scenario should be locked');
		}
	}

	@IsTest
	static void shouldUnlockAfterApprove() {
		Quote__c quoteSO = newQuote();
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

		Boolean result = QuoteApprovalService.createApprovalRequest(dto);

		System.assert(result == true, 'should be true');

		ApprovalRequestItem__c requestItem = [
			SELECT Id, ApprovalRequestId__c
			FROM ApprovalRequestItem__c
			WHERE QuoteId__c = :quoteSO.Id
		];

		QuoteApprovalService.approve(requestItem.ApprovalRequestId__c, quoteSO.Id);

		System.assert(requestItem.Id != null, 'should have item id');
		if (SettingsService.isApexLockUnlockEnabled()) {
			System.assert(
				Approval.isLocked(requestItem.Id) == false,
				'Approval request should be unlocked'
			);
			System.assert(
				Approval.isLocked(quoteSO.Id) == false,
				'Approval request quote should be unlocked'
			);
			System.assert(
				Approval.isLocked(scenario1.Id) == false,
				'Approval request scenario should be unlocked'
			);
		}
	}

	@IsTest
	static void shouldUnlockAfterReject() {
		Quote__c quoteSO = newQuote();
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

		Boolean result = QuoteApprovalService.createApprovalRequest(dto);

		System.assert(result == true, 'should be true');

		ApprovalRequestItem__c requestItem = [
			SELECT Id, ApprovalRequestId__c
			FROM ApprovalRequestItem__c
			WHERE QuoteId__c = :quoteSO.Id
		];

		QuoteApprovalService.reject(requestItem.ApprovalRequestId__c, 'Test Rejected');

		System.assert(requestItem.Id != null, 'should have item id');
		if (SettingsService.isApexLockUnlockEnabled()) {
			System.assert(
				Approval.isLocked(requestItem.Id) == false,
				'Approval request should be unlocked'
			);
			System.assert(
				Approval.isLocked(quoteSO.Id) == false,
				'Approval request quote should be unlocked'
			);
			System.assert(
				Approval.isLocked(scenario1.Id) == false,
				'Approval request scenario should be unlocked'
			);
		}
	}

	@IsTest
	static void shouldSetQuoteStatusesOnApprove() {
		Quote__c quoteSO = newQuote();
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
			QuoteApprovalService.approve(requestItem.ApprovalRequestId__c, quoteSO.Id);
			List<ApprovalRequestItem__c> approvalRequestItems = [
				SELECT Status__c, QuoteId__r.Status__c
				FROM ApprovalRequestItem__c
				WHERE QuoteId__c IN :new List<Id>{ quoteSO.Id, scenario1.Id }
				WITH SECURITY_ENFORCED
			];

			System.assertEquals(QuoteService.STATUS_APPROVED, approvalRequestItems[0].Status__c);
			System.assertEquals(
				QuoteService.STATUS_APPROVED,
				approvalRequestItems[0].QuoteId__r.Status__c
			);
			System.assertEquals(QuoteService.STATUS_REJECTED, approvalRequestItems[1].Status__c);
			System.assertEquals(
				QuoteService.STATUS_INACTIVE,
				approvalRequestItems[1].QuoteId__r.Status__c
			);
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldSetQuoteStatusesOnReject() {
		Quote__c quoteSO = newQuote();
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
			QuoteApprovalService.reject(requestItem.ApprovalRequestId__c, 'test rejection');
			List<ApprovalRequestItem__c> approvalRequestItems = [
				SELECT Status__c, QuoteId__r.Status__c
				FROM ApprovalRequestItem__c
				WHERE QuoteId__c IN :new List<Id>{ quoteSO.Id, scenario1.Id }
				WITH SECURITY_ENFORCED
			];

			System.assertEquals(QuoteService.STATUS_REJECTED, approvalRequestItems[0].Status__c);
			System.assertEquals(
				QuoteService.STATUS_REJECTED,
				approvalRequestItems[0].QuoteId__r.Status__c
			);
			System.assertEquals(QuoteService.STATUS_REJECTED, approvalRequestItems[1].Status__c);
			System.assertEquals(
				QuoteService.STATUS_REJECTED,
				approvalRequestItems[1].QuoteId__r.Status__c
			);
		}
		Test.stopTest();
	}
	@IsTest
	static void shouldSetApprovalRequestStatusOnReject() {
		Quote__c quoteSO = newQuote();
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
			QuoteApprovalService.reject(requestItem.ApprovalRequestId__c, 'test rejection');
			List<ApprovalRequest__c> approvalRequestItems = [
				SELECT Status__c
				FROM ApprovalRequest__c
				WHERE Id = :requestItem.ApprovalRequestId__c
				WITH SECURITY_ENFORCED
			];

			System.assertEquals(QuoteService.STATUS_REJECTED, approvalRequestItems[0].Status__c);
		}
		Test.stopTest();
	}
}
