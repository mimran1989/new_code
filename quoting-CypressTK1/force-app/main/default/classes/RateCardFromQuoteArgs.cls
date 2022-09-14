public with sharing class RateCardFromQuoteArgs {
	@AuraEnabled
	public Id quoteId { get; set; }
	@AuraEnabled
	public String rateCardName { get; set; }
	@AuraEnabled
	public Date effectiveDate { get; set; }
	@AuraEnabled
	public Date expirationDate { get; set; }
	@AuraEnabled
	public string duplicateStrategy { get; set; }
}
