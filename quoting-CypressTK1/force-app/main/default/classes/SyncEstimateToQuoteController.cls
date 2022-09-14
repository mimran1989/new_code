public with sharing class SyncEstimateToQuoteController {
	@AuraEnabled
	public static String syncEstimateToQuote(String estimateId) {
		return SyncEstimateToQuoteService.syncEstimateToQuote(estimateId);
	}
}
