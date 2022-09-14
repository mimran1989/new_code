public with sharing class QuoteDiscountController {
	@AuraEnabled
	public static void updateAdjustments(List<Adjustment__c> adjustments) {
		CRUDUtility.upsertRecords(adjustments);
	}
}
