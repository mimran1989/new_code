public with sharing class ApprovalRequestDto {
	public String status;
	public String rejectionReason;

	public List<ApprovalRequestItemDto> items;

	public ApprovalRequestDto() {
		this.items = new List<ApprovalRequestItemDto>();
	}

	public ApprovalRequest__c newSO() {
		return new ApprovalRequest__c(
			Status__c = this.status != null ? this.status : QuoteApprovalService.STATUS_SUBMITTED
		);
	}

	public List<ApprovalRequestItem__c> newItemSOs(Id approvalRequestId) {
		List<ApprovalRequestItem__c> itemSOs = new List<ApprovalRequestItem__c>();
		for (ApprovalRequestItemDto item : this.items) {
			ApprovalRequestItem__c itemSO = item.newSO();
			itemSO.ApprovalRequestId__c = approvalRequestId;
			itemSOs.add(itemSO);
		}
		return itemSOs;
	}
}
