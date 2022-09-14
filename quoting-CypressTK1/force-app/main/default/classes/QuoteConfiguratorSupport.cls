/**
 *  Provus Services Quoting
 *  QuoteConfiguratorSupport
 *  @2021 Provus Inc. All rights reserved.
 */
public with sharing class QuoteConfiguratorSupport {
	/** Gets the quote template for initializing the quote configurator
	 * @param   quoteId Id of the quote
	 * @return  QuoteTemplateDO
	 */
	public static QuoteTemplateDO getQuoteTemplate(Id quoteId) {
		QuoteService qtService = new QuoteService(quoteId);
		return new QuoteTemplateDO(qtService.quoteSO, qtService.rateCardId);
	}

	public static List<QuoteSummaryDO> getQuoteSummaries(Id quoteId) {
		return QuoteSummaryService.getQuoteSummaries(quoteId);
	}

	/**
	 * Gets all valid products for a quote
	 * @param   quoteId Id of the quote
	 * @return  Set<ProductService.ProductStruct>
	 */
	public static Set<ProductService.ProductStruct> getAllProductsForQuote(Id quoteId) {
		return ProductService.getAllProductsForQuote(quoteId);
	}

	/**
	 * Gets all rate card items for a product
	 * @param   quoteId Id of the quote
	 * @param   productId Id of the product
	 * @return  List<RateCardItemService.RateCardItemStruct>
	 */
	public static List<RateCardItemService.RateCardItemStruct> getAllRateCardItemsForProduct(
		Id quoteId,
		Id productId
	) {
		return RateCardItemService.getAllRateCardItemsForProduct(quoteId, productId);
	}

	/**
	 * Gets all quote items for quote
	 * @param   quoteId Id of the quote
	 * @return  List<QuoteItemDO>
	 */
	public static List<QuoteItemDTO> getQuoteItemsForQuote(Id quoteId) {
		return QuoteItemService.getQuoteItemsForQuote(quoteId);
	}

	/**
	 * Commit quote items for quote
	 * @param   quoteId Id of the quote
	 * @param   quoteItemsColData JSON String of the quote item struct collection
	 * @return  Boolean the result of commit
	 */
	public static List<QuoteItemDTO> commitQuoteItems(
		Id quoteId,
		List<QuoteItemDTO> quoteItemsColData
	) {
		return QuoteItemService.commitQuoteItems(quoteId, quoteItemsColData);
	}

	/**
	 * Gets all namedranges for a quote
	 * @param   quoteId Id of the quote
	 * @return  List<NamedRange.NamedRangeDO>
	 */
	public static List<NamedRange.NamedRangeDO> getNamedRangesForQuote(Id quoteId) {
		return NamedRangeService.getNamedRangesForQuote(quoteId);
	}

	/**
	 * @param namedRangeColData named range col data
	 *
	 * @return boolean indicating whether method executed successfully
	 */
	public static Boolean commitNamedRanges(String namedRangeColData) {
		return NamedRangeService.commitNamedRanges(namedRangeColData);
	}

	/**
	 * get project phases for a quote
	 * @param   quoteId Id of the quote
	 * @return  List<ProjectPhaseDO>
	 */
	public static List<ProjectPhaseDO> getProjectPhasesForQuote(Id quoteId) {
		return ProjectPhaseService.getProjectPhasesForQuote(quoteId);
	}

	/**
	 * commit project phases for a quote
	 *
	 * @param projectPhaseColData JSON string of project phase col data
	 *
	 * @return boolean indicating whether method executed sucessfully
	 */
	public static Boolean commitProjectPhases(String projectPhaseColData) {
		return ProjectPhaseService.commitProjectPhases(projectPhaseColData);
	}

	/**
	 * get quote sections for a quote
	 * @param   quoteId Id of the quote
	 * @return  List<QuoteSectionDO>
	 */
	public static List<QuoteSectionDO> getQuoteSectionsForQuote(Id quoteId) {
		return QuoteSectionService.getQuoteSectionsForQuote(quoteId);
	}

	/**
	 * commit quote sections for a quote
	 *
	 * @param quoteId Id of the quote
	 * @param quoteSectionColData JSON string containing quote sections wrappers
	 *
	 * @return Boolean the result of commit
	 */
	public static Boolean commitQuoteSections(Id quoteId, String quoteSectionColData) {
		return QuoteSectionService.commitQuoteSections(quoteId, quoteSectionColData);
	}

	/**
	 * retrieve related opportunity line item and sync it with the quote items
	 * @param   quoteId Id of the quote
	 */
	public static void syncQuoteToOpportunity(Id quoteId) {
		List<OpportunityProductServiceQuote__c> opportunityProductServiceQuotes = [
			SELECT Id, ServiceId__c, ServiceQuoteId__r.OpportunityId__c
			FROM OpportunityProductServiceQuote__c
			WHERE ServiceQuoteId__c = :quoteId AND DisableSync__c = FALSE
			WITH SECURITY_ENFORCED
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		];

		Set<Id> serviceIds = new Set<Id>();
		Id quoteOpportunityId;
		for (
			OpportunityProductServiceQuote__c opportunityProductServiceQuote : opportunityProductServiceQuotes
		) {
			serviceIds.add(opportunityProductServiceQuote.ServiceId__c);
			quoteOpportunityId = opportunityProductServiceQuote.ServiceQuoteId__r.OpportunityId__c;
		}
		if (!serviceIds.isEmpty()) {
			List<OpportunityLineItem> opportunityLineItems = [
				SELECT Id, Quantity, UnitPrice, OpportunityId
				FROM OpportunityLineItem
				WHERE Id IN :serviceIds AND OpportunityId = :quoteOpportunityId
				WITH SECURITY_ENFORCED
				LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
			];
			NamedRange.NamedRangeDO quoteTotalNamedRange = NamedRangeService.getQuoteTotalForQuote(
				quoteId
			);
			ServiceRecommendationsDto.OpportunityLineItemRequest opportunityLineItemRequest = new ServiceRecommendationsDto.OpportunityLineItemRequest();
			opportunityLineItemRequest.opportunityLineItems = opportunityLineItems;
			opportunityLineItemRequest.quoteTotalNamedRange = quoteTotalNamedRange;
			ServiceRecommendationsSupport.upsertOpportunityLineItem(opportunityLineItemRequest);
		}
	}

	/**
	 * retrieve related opportunity line item and update zero
	 * @param   quoteId Id of the quote
	 * @param   opportunityId Id of the quote
	 */
	private static void updateZeroToOpportunityLine(Id quoteId, Id opportunityId) {
		List<OpportunityProductServiceQuote__c> opportunityProductServiceQuotes = ServiceRecommendationsSupport.getOpportunityProductServiceQuotes(
			new Map<String, String>{
				Schema.OpportunityProductServiceQuote__c.ServiceQuoteId__c + '' => quoteId,
				Schema.OpportunityProductServiceQuote__c.OpportunityId__c + '' => opportunityId
			}
		);
		Set<Id> serviceIds = new Set<Id>();
		for (
			OpportunityProductServiceQuote__c opportunityProductServiceQuote : opportunityProductServiceQuotes
		) {
			serviceIds.add(opportunityProductServiceQuote.ServiceId__c);
			opportunityProductServiceQuote.DisableSync__c = true;
		}
		if (!serviceIds.isEmpty()) {
			List<OpportunityLineItem> opportunityLineItems = [
				SELECT Id, Quantity, UnitPrice, OpportunityId
				FROM OpportunityLineItem
				WHERE Id IN :serviceIds AND OpportunityId = :opportunityId
				WITH SECURITY_ENFORCED
				LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
			];
			ServiceRecommendationsDto.OpportunityLineItemRequest opportunityLineItemRequest = new ServiceRecommendationsDto.OpportunityLineItemRequest();
			opportunityLineItemRequest.opportunityLineItems = opportunityLineItems;
			opportunityLineItemRequest.unitPrice = 0;
			ServiceRecommendationsSupport.upsertOpportunityLineItem(opportunityLineItemRequest);
			CRUDUtility.updateRecords(opportunityProductServiceQuotes);
		}
	}

	public static void updateOpportunityLineFor(Quote__c quoteSO, Quote__c oldQuoteSO) {
		Boolean isOpportunityChanged =
			quoteSO.OpportunityId__c != null &&
			oldQuoteSO.OpportunityId__c != null &&
			quoteSO.OpportunityId__c != oldQuoteSO.OpportunityId__c;

		Boolean isOpportunityRemoved =
			isOpportunityChanged ||
			(quoteSO.OpportunityId__c == null &&
			oldQuoteSO.OpportunityId__c != null);

		if (isOpportunityRemoved) {
			updateZeroToOpportunityLine(quoteSO.Id, oldQuoteSO.OpportunityId__c);
		}
	}
}
