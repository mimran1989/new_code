public with sharing class ServiceRecommendationsDto {
	public class OpportunityLineItemRequest {
		public List<OpportunityLineItem> opportunityLineItems;
		public Id opportunityId;
		public Id productId;
		public Id pricebookEntryId;
		public NamedRange.NamedRangeDO quoteTotalNamedRange;
		public Decimal unitPrice;

		public OpportunityLineItemRequest() {
			this.opportunityLineItems = new List<OpportunityLineItem>();
		}
	}

	public class OpportunityProductServiceQuoteRequest {
		public String name;
		public OpportunityLineItem serviceLineItem;
		public OpportunityLineItem productLineItem;
		public Quote__c serviceQuote;
		public Estimate__c serviceEstimate;
	}
}
