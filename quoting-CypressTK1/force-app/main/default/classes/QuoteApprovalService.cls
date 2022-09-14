/**
 *  Provus Services Quoting
 *  QuoteApprovalService
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class QuoteApprovalService {
	public static final String STATUS_SUBMITTED = 'Submitted';
	public static final String APPROVE_ACTION = 'Approve';
	public static final String REJECT_ACTION = 'Reject';

	public static Boolean createApprovalRequest(ApprovalRequestDto requestDto) {
		ApprovalRequest__c requestSO = requestDto.newSO();
		CRUDUtility.insertRecords(requestSO);

		List<ApprovalRequestItem__c> itemSOs = requestDto.newItemSOs(requestSO.Id);
		CRUDUtility.insertRecords(itemSOs);

		// set the primary quote item record on the approval request so that formula
		// fields can be used to derive the e-mail template body
		for (ApprovalRequestItem__c item : itemSOs) {
			if (item.IsPrimaryItem__c) {
				requestSO.PrimaryItemId__c = item.Id;
				CRUDUtility.updateRecords(requestSO);
				break;
			}
		}

		if (SettingsService.isApexLockUnlockEnabled()) {
			List<Id> lockList = new List<Id>();
			lockList.add(requestSO.Id);
			for (ApprovalRequestItem__c item : itemSOs) {
				lockList.add(item.Id);
				lockList.add(item.QuoteId__c);
			}

			Approval.lock(lockList, false);
		}

		return submitForApproval(requestSO, requestDto.items[0].submittedComments);
	}

	public static Boolean submitForApproval(SObject obj, String comments) {
		ProvusSetupDTO provusSetup = SettingsService.getProvusSetup();

		// Create an approval request for given object (Quote)
		Approval.ProcessSubmitRequest submitRequest = new Approval.ProcessSubmitRequest();
		submitRequest.setComments(comments);
		submitRequest.setObjectId(obj.id);

		// Submit the record to specific approval process if specified
		if (!String.isBlank(provusSetup.sO.QuoteApprovalProcess__c)) {
			submitRequest.setProcessDefinitionNameOrId(provusSetup.sO.QuoteApprovalProcess__c);
			submitRequest.setSkipEntryCriteria(true);
		}

		// Submit the approval request
		Approval.ProcessResult result = Approval.process(submitRequest);

		return result.isSuccess();
	}

	public static void approve(Id recordId, Id approvedQuoteId) {
		processApprovalRequest(recordId, '', APPROVE_ACTION);
		unlockRecords(recordId);
		updateApprovalEntitiesForApproval(recordId, approvedQuoteId);
	}

	private static void updateApprovalEntitiesForApproval(Id requestId, Id approvedQuoteId) {
		List<Quote__c> quotes = new List<Quote__c>();
		List<ApprovalRequestItem__c> approvalRequestItems = [
			SELECT Id, QuoteId__c, IsPrimaryItem__c, QuoteId__r.OpportunityId__c, QuoteId__r.Type__c
			FROM ApprovalRequestItem__c
			WHERE ApprovalRequestId__c = :requestId
			WITH SECURITY_ENFORCED
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		];

		ApprovalRequestItem__c primaryRequestItem = findPrimaryRequestItem(approvalRequestItems);
		Id primaryOpportunityId = primaryRequestItem?.QuoteId__r.OpportunityId__c;

		for (ApprovalRequestItem__c item : approvalRequestItems) {
			Quote__c quote = new Quote__c(Id = item.QuoteId__c);
			Boolean isApprovedRequestItem = item.QuoteId__c == approvedQuoteId;
			if (isApprovedRequestItem) {
				item.Status__c = QuoteService.STATUS_APPROVED;
				quote.Status__c = QuoteService.STATUS_APPROVED;
				quote.Type__c = QuoteService.TYPE_QUOTE;
			} else {
				item.Status__c = QuoteService.STATUS_REJECTED;
				quote.Status__c = QuoteService.STATUS_INACTIVE;
				quote.Type__c = item.QuoteId__r.Type__c;
				quote.OpportunityId__c = null;
			}
			quote.IsPrimary__c = isApprovedRequestItem;
			quotes.add(quote);
		}

		CRUDUtility.updateRecords(quotes);
		CRUDUtility.updateRecords(approvalRequestItems);
	}

	public static void reject(Id recordId, String comments) {
		// set the rejection reason before rejecting
		CRUDUtility.updateRecords(
			new ApprovalRequest__c(
				Id = recordId,
				RejectionReason__c = comments,
				Status__c = QuoteService.STATUS_REJECTED
			)
		);

		processApprovalRequest(recordId, comments, REJECT_ACTION);
		unlockRecords(recordId);
		updateApprovalEntitiesForRejection(recordId, comments);
	}

	private static void updateApprovalEntitiesForRejection(Id requestId, String comments) {
		List<ApprovalRequestItem__c> approvalRequestItems = new List<ApprovalRequestItem__c>();
		List<Quote__c> quotes = new List<Quote__c>();
		for (ApprovalRequestItem__c item : [
			SELECT Id, QuoteId__c
			FROM ApprovalRequestItem__c
			WHERE ApprovalRequestId__c = :requestId
			WITH SECURITY_ENFORCED
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		]) {
			Quote__c quote = new Quote__c(Id = item.QuoteId__c);
			quote.Status__c = QuoteService.STATUS_REJECTED;
			item.Status__c = QuoteService.STATUS_REJECTED;
			approvalRequestItems.add(item);
			quotes.add(quote);
		}

		CRUDUtility.updateRecords(quotes);
		CRUDUtility.updateRecords(approvalRequestItems);
	}

	private static Boolean processApprovalRequest(Id recordId, String comments, String action) {
		// invoke approve/reject action for given object associated approval request
		Approval.ProcessWorkitemRequest workItemRequest = new Approval.ProcessWorkitemRequest();
		workItemRequest.setComments(comments);
		workItemRequest.setAction(action);
		ProcessInstanceWorkitem workItem = getApprovalWorkItem(recordId);

		if (workItem == null) {
			throw new ApplicationException('Approval process is not found for this object');
		} else {
			workItemRequest.setWorkitemId(workItem.Id);
		}

		// Submit the approval request
		Approval.ProcessResult result = Approval.process(workItemRequest);

		return result.isSuccess();
	}

	private static ApprovalRequestItem__c findPrimaryRequestItem(
		List<ApprovalRequestItem__c> approvalRequestItems
	) {
		ApprovalRequestItem__c primaryRequestItem;
		for (ApprovalRequestItem__c item : approvalRequestItems) {
			if (item.IsPrimaryItem__c) {
				primaryRequestItem = item;
				break;
			}
		}

		return primaryRequestItem;
	}

	public static ProcessInstanceWorkitem getApprovalWorkItem(Id recordId) {
		ProcessInstanceWorkitem currentWorkItem = null;
		for (ProcessInstanceWorkitem workItem : [
			SELECT Id, ActorId, ProcessInstance.Status
			FROM ProcessInstanceWorkitem
			WHERE ProcessInstance.TargetObjectId = :recordId
			WITH SECURITY_ENFORCED
		]) {
			currentWorkItem = workItem;
		}
		return currentWorkItem;
	}

	private static void unlockRecords(Id recordId) {
		if (SettingsService.isApexLockUnlockEnabled()) {
			ApprovalRequest__c requestItem = [
				SELECT Id, (SELECT Id, QuoteId__c FROM ApprovalRequestItems__r)
				FROM ApprovalRequest__c
				WHERE Id = :recordId
				WITH SECURITY_ENFORCED
			];

			List<Id> lockList = new List<Id>();
			lockList.add(requestItem.Id);
			for (ApprovalRequestItem__c item : requestItem.ApprovalRequestItems__r) {
				lockList.add(item.Id);
				lockList.add(item.QuoteId__c);
			}

			Approval.unlock(lockList, false);
		}
	}
}
