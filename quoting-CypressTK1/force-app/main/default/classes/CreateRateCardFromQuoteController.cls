public with sharing class CreateRateCardFromQuoteController {
	@AuraEnabled
	public static List<RateCard__c> getRateCardByQuoteId(Id quoteId) {
		return RateCardQuoteService.getRateCardByQuoteId(quoteId);
	}

	@AuraEnabled
	public static RateCard__c createRateCardFromQuoteId(RateCardFromQuoteArgs request) {
		RateCard__c rateCard = RateCardQuoteService.createRateCard(request);
		RateCardQuoteService.createRateCardItems(request, rateCard);

		return rateCard;
	}
}
