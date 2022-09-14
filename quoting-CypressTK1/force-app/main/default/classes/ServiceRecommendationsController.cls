/**
 *  Provus Services Quoting
 *  ServiceRecommendationsController
 *  @2021 Provus Inc. All rights reserved.
 */
@namespaceAccessible
public with sharing class ServiceRecommendationsController {
	public class ServiceRecommendation {
		@AuraEnabled
		public Product2 service;
		@AuraEnabled
		public Product2 product;
		@AuraEnabled
		public Decimal serviceUnitPrice;
		@AuraEnabled
		public Boolean hasEstimate;
		@AuraEnabled
		public String currencyCode;

		public ServiceRecommendation() {
			this.hasEstimate = false;
		}
	}

	public class ServiceOpportunity {
		@AuraEnabled
		public Boolean success;
		@AuraEnabled
		public String stackTrace;
		@AuraEnabled
		public String errorMsg;
		@AuraEnabled
		public OpportunityProductServiceQuote__c opportunityProductServiceQuote;
	}

	@AuraEnabled
	public static Map<Id, ServiceRecommendation> getServiceRecommendations(String opportunityId) {
		Map<Id, ServiceRecommendation> serviceRecommendationsByServiceId = new Map<Id, ServiceRecommendation>();

		// products from opportunites
		Set<Id> opportunityProductIds = ServiceRecommendationsSupport.getOpportunityProductIds(
			opportunityId
		);

		if (opportunityProductIds.isEmpty()) {
			return serviceRecommendationsByServiceId;
		}

		// retrieve related services
		List<Product__c> serviceProducts = [
			SELECT
				Id,
				Name,
				AssociatedProductId__c,
				AssociatedProductId__r.Name,
				AssociatedProductId__r.StandardProductId__c,
				StandardProductId__c
			FROM Product__c
			WHERE
				AssociatedProductId__r.StandardProductId__c IN :opportunityProductIds
				AND RecordType.Name = :ProductService.RECORDTYPE_NAME_SERVICE
			WITH SECURITY_ENFORCED
		];
		Set<Id> serviceProductIds = (new Map<Id, SObject>(serviceProducts)).keySet();
		// retrieve prices for services
		QueryRequest queryRequest = new QueryRequest(Schema.SObjectType.PricebookEntry.getName());
		queryRequest.requestedFields = new Set<String>{
			Schema.PricebookEntry.UnitPrice + '',
			Schema.PricebookEntry.Product2Id + ''
		};
		queryRequest.setFilterBy(
			new Map<String, Set<Id>>{ Schema.PricebookEntry.Product2Id + '' => serviceProductIds }
		);
		List<PricebookEntry> priceEntries = (List<PricebookEntry>) SOQLUtility.querySObject(
			queryRequest
		);
		Map<Id, PricebookEntry> unitPriceByProductId = new Map<Id, PricebookEntry>();
		for (PricebookEntry priceEntry : priceEntries) {
			unitPriceByProductId.put(priceEntry.Product2Id, priceEntry);
		}
		// retrieve estimates for related services
		List<Estimate__c> estimates = ServiceRecommendationsSupport.getEstimatesForServiceProducts(
			serviceProductIds
		);
		Map<Id, List<Estimate__c>> estimatesByServiceId = new Map<Id, List<Estimate__c>>();
		for (Estimate__c estimate : estimates) {
			List<Estimate__c> currentEstimates = estimatesByServiceId.get(estimate.ServiceId__c);
			if (currentEstimates == null) {
				currentEstimates = new List<Estimate__c>();
			}
			currentEstimates.add(estimate);
			estimatesByServiceId.put(estimate.ServiceId__c, currentEstimates);
		}
		Set<Id> serviceProduct2Ids = new Set<Id>();
		for (Product__c serviceProduct : serviceProducts) {
			serviceProduct2Ids.add(serviceProduct.StandardProductId__c);
			serviceProduct2Ids.add(serviceProduct.AssociatedProductId__r.StandardProductId__c);
		}

		Map<Id, Product2> serviceProduct2s = new Map<Id, Product2>(
			[SELECT Id, Name FROM Product2 WHERE Id IN :serviceProduct2Ids WITH SECURITY_ENFORCED]
		);

		for (Product__c serviceProduct : serviceProducts) {
			if (!opportunityProductIds.contains(serviceProduct.StandardProductId__c)) {
				// exclude services that are already added to the opportunity
				ServiceRecommendation serviceRecommendation = new ServiceRecommendation();
				serviceRecommendation.service = serviceProduct2s.get(
					ID.valueOf(serviceProduct.StandardProductId__c)
				);
				serviceRecommendation.product = serviceProduct2s.get(
					ID.valueOf(serviceProduct.AssociatedProductId__r.StandardProductId__c)
				);
				serviceRecommendation.hasEstimate = estimatesByServiceId.get(serviceProduct.Id) != null;
				serviceRecommendation.currencyCode = UserInfo.getDefaultCurrency();
				serviceRecommendationsByServiceId.put(
					serviceRecommendation.service.Id,
					serviceRecommendation
				);
			}
		}

		return serviceRecommendationsByServiceId;
	}

	@AuraEnabled
	public static ServiceOpportunity addServiceToOpportunity(
		Id opportunityId,
		Id serviceId,
		Id productId
	) {
		ServiceOpportunity serviceOpportunityResponse = new ServiceOpportunity();
		Boolean success = false;
		String errorMsg = '';
		String stackTrace = '';
		Estimate__c serviceEstimate = null;
		Product2 serviceProduct2 = getServiceProduct(serviceId);
		Product__c serviceProduct = ServiceRecommendationsSupport.getProvusServiceProductByProduct2Id(
			serviceId
		);

		// look for quote templates if any exist, otherwise look for estimates
		List<Quote__c> quotes = new List<Quote__c>();
		Id quoteTemplateId = getQuoteId(QuoteService.RECORDTYPE_NAME_TEMPLATE, serviceProduct.Id);
		Savepoint sp = Database.setSavepoint();

		// there will either be an existing quote template, or an estimate to create a quote from
		List<Estimate__c> estimates = ServiceRecommendationsSupport.getEstimatesForServiceProducts(
			new Set<Id>{ serviceProduct.Id }
		);

		if (!estimates.isEmpty()) {
			serviceEstimate = estimates[0];
			String serviceEstimateId = serviceEstimate.Id;
			Estimate__c clonedEstimate = EstimateCloner.cloneEstimate(
				serviceEstimateId,
				serviceEstimate.Name,
				null
			);
			clonedEstimate.ServiceId__r = serviceEstimate.ServiceId__r;
			clonedEstimate.Default__c = false;

			CRUDUtility.updateRecords(clonedEstimate);
			serviceEstimate = clonedEstimate;
			// check if we have any quotes already configured
			quotes.addAll(getQuotesForEstimate(clonedEstimate, serviceProduct));
		} else {
			errorMsg = System.Label.NoEstimateForServiceProduct + serviceId;
		}

		if (!quotes.isEmpty()) {
			Quote__c serviceQuote = quotes[0];
			try {
				Opportunity opp = getOpportunity(opportunityId);
				serviceQuote.ProposalId__c = opp.ProposalId__c;
				serviceQuote.OpportunityId__c = opportunityId;
				serviceQuote.AccountId__c = opp.AccountId;
				CRUDUtility.updateRecords(serviceQuote);
				success = true;
			} catch (Exception e) {
				success = false;
				errorMsg = e.getMessage();
				stackTrace = e.getStackTraceString();
				// undo any record creation we did up to this point if we have some exception
				// so that we don't have lingering bad data in the org
				Database.rollback(sp);
			}
		} else {
			errorMsg = System.Label.NoQuotesGeneratedForServiceRecommendations;
			Database.rollback(sp);
			// undo any record creation we did up to this point if we have some exception
			// so that we don't have lingering bad data in the org
		}

		serviceOpportunityResponse.errorMsg = errorMsg; // internal error. no translation needed
		serviceOpportunityResponse.stackTrace = stackTrace;
		serviceOpportunityResponse.success = success;
		return serviceOpportunityResponse;
	}

	private static Id getQuoteId(String quoteType, Id serviceProductId) {
		QueryRequest queryRequest = new QueryRequest(Schema.SObjectType.Quote__c.getName());
		queryRequest.requestedFields = new Set<String>{
			SObjectUtility.FIELD_ID,
			Schema.Quote__c.Type__c + '',
			Schema.Quote__c.ServiceId__c + '',
			Schema.Quote__c.CreatedDate + ''
		};
		queryRequest.setFilterBy(
			new Map<String, String>{
				Schema.Quote__c.Type__c + '' => quoteType,
				Schema.Quote__c.ServiceId__c + '' => serviceProductId
			}
		);
		queryRequest.fieldBySortOrder = new Map<String, String>{
			Schema.Quote__c.CreatedDate + '' => SOQLConstants.SORT_DESC
		};
		queryRequest.querySize = 1;

		Id quoteTemplateId = null;
		List<Quote__c> quotes = (List<Quote__c>) SOQLUtility.querySObject(queryRequest);
		if (!quotes.isEmpty()) {
			quoteTemplateId = quotes[0].Id;
		}
		return quoteTemplateId;
	}

	private static Opportunity getOpportunity(Id opportunityId) {
		QueryRequest opportunityQueryRequest = new QueryRequest(
			Schema.SObjectType.Opportunity.getName()
		);
		opportunityQueryRequest.requestedFields = new Set<String>{
			Schema.Opportunity.Amount + '',
			Schema.Opportunity.Pricebook2Id + '',
			Schema.Opportunity.ProposalId__c + '',
			Schema.Opportunity.AccountId + ''
		};
		opportunityQueryRequest.setFilterBy(
			new Map<String, String>{ SObjectUtility.FIELD_ID => opportunityId }
		);
		List<Opportunity> opps = (List<Opportunity>) SOQLUtility.querySObject(opportunityQueryRequest);
		Opportunity opp = opps[0];
		return opp;
	}

	private static Product2 getServiceProduct(Id serviceId) {
		QueryRequest productQueryRequest = new QueryRequest(Schema.SObjectType.Product2.getName());
		productQueryRequest.requestedFields = new Set<String>{
			SObjectUtility.FIELD_ID,
			Schema.Product2.ProductCode + ''
		};
		productQueryRequest.setFilterBy(
			new Map<String, String>{ SObjectUtility.FIELD_ID => serviceId }
		);
		List<Product2> products = (List<Product2>) SOQLUtility.querySObject(productQueryRequest);
		Product2 serviceProduct = products[0];
		return serviceProduct;
	}

	private static List<Quote__c> getQuotesForEstimate(
		Estimate__c serviceEstimate,
		Product__c serviceProduct
	) {
		List<Quote__c> quotes = new List<Quote__c>();
		Quote__c quote = createQuote(serviceEstimate, serviceProduct);
		quotes.add(quote);

		return quotes;
	}

	@namespaceAccessible
	public static Quote__c createQuote(Estimate__c serviceEstimate, Product__c serviceProduct) {
		// general quote from estimate
		QuoteDO quoteDate = CreateQuoteFromEstimateService.getEstimateQuoteDetails(serviceEstimate);
		Quote__c quote = QuoteDO.getQuoteFromData(quoteDate);
		quote.Name = 'Quote for ' + serviceEstimate.Name;
		quote.ServiceStartDate__c = System.today();
		EndDateArgs endDateArgs = new EndDateArgs();
		endDateArgs.calendarAlignment = QuoteService.TIMEPERIODSALIGNMENT_USER_DEFINED;
		endDateArgs.serviceStartDate = System.today();
		quote.ServiceEndDate__c = CreateQuoteFromEstimateController.getServiceEndDate(
			serviceEstimate.Id,
			endDateArgs
		);
		quote.TimePeriod__c = TimePeriodMonth.NAME_PLURAL;
		quote.TimePeriodsGroupMethod__c = TimePeriodYear.NAME;
		quote.TimePeriodsAlignment__c = QuoteService.TIMEPERIODSALIGNMENT_USER_DEFINED;
		quote.Practice__c = serviceProduct.Practice__c;
		quote.Group__c = serviceProduct.Group__c;
		quote.QuoteDate__c = System.today();
		quote.Version__c = 1;
		quote.Type__c = QuoteService.RECORDTYPE_NAME_QUOTE;
		quote.LaborUnits__c = QuoteService.LABORUNITS_HEADCOUNT;
		quote.TotalAmount__c = serviceEstimate.TotalEstimatedAmount__c;
		quote.TotalCost__c = serviceEstimate.TotalEstimatedCost__c;

		CRUDUtility.insertRecords(quote);

		CreateQuoteFromEstimateService.convertEntitiesFromEstimate(quote);
		return quote;
	}
}
