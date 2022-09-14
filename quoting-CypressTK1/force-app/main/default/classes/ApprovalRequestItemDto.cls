public with sharing class ApprovalRequestItemDto {
	@AuraEnabled
	public String submittedComments { get; set; }
	@AuraEnabled
	public String quoteId { get; set; }
	@AuraEnabled
	public String status { get; set; }
	@AuraEnabled
	public Boolean isPrimaryItem { get; set; }

	public ApprovalRequestItemDto() {
		this.isPrimaryItem = false;
	}

	public ApprovalRequestItem__c newSO() {
		return new ApprovalRequestItem__c(
			ApprovalSubmissionComments__c = this.submittedComments,
			QuoteId__c = this.quoteId,
			Status__c = this.status,
			IsPrimaryItem__c = this.isPrimaryItem
		);
	}
}
