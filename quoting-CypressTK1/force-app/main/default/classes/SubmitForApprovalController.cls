/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class SubmitForApprovalController {
	@AuraEnabled
	public static List<Quote__c> getScenariosForApproval(string quoteId) {
		return SubmitForApprovalService.getScenariosForApproval(quoteId);
	}

	@AuraEnabled
	public static void submitScenariosForApproval(List<ApprovalRequestItemDto> approvalRequestItems) {
		ApprovalRequestDto newApprovalRequest = new ApprovalRequestDto();
		newApprovalRequest.items = approvalRequestItems;
		QuoteApprovalService.createApprovalRequest(newApprovalRequest);
	}
}
