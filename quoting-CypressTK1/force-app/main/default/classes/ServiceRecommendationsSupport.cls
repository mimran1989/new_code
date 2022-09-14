/**
 *  Provus Services Quoting
 *  ServiceRecommendationsSupport
 *  @2021 Provus Inc. All rights reserved.
 */
public with sharing class ServiceRecommendationsSupport {
	public static Set<Id> getOpportunityProductIds(Id opportunityId) {
		List<OpportunityLineItem> opportunityProducts = getOpportunityProducts(opportunityId);
		Map<Id, OpportunityLineItem> opportunityProductsByProductId = new Map<Id, OpportunityLineItem>();
		for (OpportunityLineItem opportunityProduct : opportunityProducts) {
			opportunityProductsByProductId.put(opportunityProduct.Product2Id, opportunityProduct);
		}
		return opportunityProductsByProductId.keySet();
	}

	private static List<OpportunityLineItem> getOpportunityProducts(Id opportunityId) {
		QueryRequest queryRequest = new QueryRequest(Schema.SObjectType.OpportunityLineItem.getName());
		queryRequest.requestedFields = new Set<String>{ Schema.OpportunityLineItem.Product2Id + '' };
		queryRequest.setFilterBy(
			new Map<String, String>{ Schema.OpportunityLineItem.OpportunityId + '' => opportunityId }
		);
		return (List<OpportunityLineItem>) SOQLUtility.querySObject(queryRequest);
	}

	public static List<Estimate__c> getEstimatesForServiceProducts(Set<Id> serviceProducts) {
		Map<String, String> orderBy = new Map<String, String>{
			Schema.Estimate__c.Default__c + '' => SOQLConstants.SORT_DESC,
			Schema.Estimate__c.CreatedDate + '' => SOQLConstants.SORT_DESC
		};
		QueryRequest queryRequest = new QueryRequest(Schema.SObjectType.Estimate__c.getName());
		queryRequest.requestedFields = new Set<String>{
			SObjectUtility.FIELD_NAME,
			Schema.Estimate__c.ServiceId__c + '',
			Schema.Estimate__c.RateCardId__c + '',
			Schema.Estimate__c.AccountId__c + '',
			Schema.Estimate__c.Description__c + '',
			Schema.Estimate__c.OpportunityId__c + '',
			Schema.Estimate__c.RateCardId__c + '',
			Schema.Estimate__c.TotalEstimatedAmount__c + '',
			Schema.Estimate__c.TotalEstimatedCost__c + '',
			SystemUtility.getRName(Schema.Estimate__c.ServiceId__c) +
			'.' +
			Schema.Product__c.Practice__c,
			SystemUtility.getRName(Schema.Estimate__c.ServiceId__c) +
			'.' +
			Schema.Product__c.Group__c
		};
		queryRequest.setFilterBy(
			new Map<String, Set<Id>>{ Schema.Estimate__c.ServiceId__c + '' => serviceProducts }
		);
		queryRequest.filterBy.addFilterBy(Schema.Estimate__c.Default__c + '', true);
		queryRequest.fieldBySortOrder = orderBy;
		return (List<Estimate__c>) SOQLUtility.querySObject(queryRequest);
	}

	public static OpportunityProductServiceQuote__c insertOpportunityProductServiceQuote(
		ServiceRecommendationsDto.OpportunityProductServiceQuoteRequest opportunityProductServiceQuoteRequest
	) {
		OpportunityProductServiceQuote__c opportunityProductServiceQuote = new OpportunityProductServiceQuote__c();
		opportunityProductServiceQuote.Name = opportunityProductServiceQuoteRequest.Name;
		Id productId = null;
		if (opportunityProductServiceQuoteRequest.productLineItem != null) {
			productId = opportunityProductServiceQuoteRequest.productLineItem.Id;
		}
		opportunityProductServiceQuote.ProductId__c = productId;
		opportunityProductServiceQuote.ServiceId__c = opportunityProductServiceQuoteRequest.serviceLineItem.Id;
		opportunityProductServiceQuote.Service__c = getProvusServiceProductByProduct2Id(
				opportunityProductServiceQuoteRequest.serviceLineItem.Product2Id
			)
			.Id;
		opportunityProductServiceQuote.ServiceQuoteId__c = opportunityProductServiceQuoteRequest.serviceQuote.Id;
		opportunityProductServiceQuote.OpportunityId__c = opportunityProductServiceQuoteRequest.serviceQuote.OpportunityId__c;
		if (opportunityProductServiceQuoteRequest.serviceEstimate != null) {
			// if there is an estimate, but there does not have to be one if we have a quote template
			opportunityProductServiceQuote.EstimateId__c = opportunityProductServiceQuoteRequest.serviceEstimate.Id;
		}
		return (OpportunityProductServiceQuote__c) CRUDUtility.insertRecords(
			opportunityProductServiceQuote
		);
	}

	public static List<OpportunityLineItem> upsertOpportunityLineItem(
		ServiceRecommendationsDto.OpportunityLineItemRequest opportunityLineItemRequest
	) {
		List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
		for (
			OpportunityLineItem opportunityLineItem : opportunityLineItemRequest.opportunityLineItems
		) {
			Id opportunityId = opportunityLineItemRequest.opportunityId;
			Id productId = opportunityLineItemRequest.productId;
			Id pricebookEntryId = opportunityLineItemRequest.pricebookEntryId;
			if (opportunityId != null) {
				opportunityLineItem.OpportunityId = opportunityId;
			}
			if (productId != null) {
				opportunityLineItem.Product2Id = productId;
			}
			if (pricebookEntryId != null) {
				opportunityLineItem.PricebookEntryId = pricebookEntryId;
			}
			opportunityLineItem.Quantity = 1;
			if (opportunityLineItemRequest.unitPrice == null) {
				Decimal totalAmount = 0;
				if (
					opportunityLineItemRequest.quoteTotalNamedRange != null &&
					opportunityLineItemRequest.quoteTotalNamedRange.relatedTotal != null &&
					opportunityLineItemRequest.quoteTotalNamedRange.relatedTotal.netExtendedAmount != null
				) {
					totalAmount = opportunityLineItemRequest.quoteTotalNamedRange.relatedTotal.netExtendedAmount;
				}
				opportunityLineItem.UnitPrice = totalAmount;
			} else {
				opportunityLineItem.UnitPrice = opportunityLineItemRequest.unitPrice;
			}

			opportunityLineItems.add(opportunityLineItem);
		}
		return (List<OpportunityLineItem>) CRUDUtility.upsertRecords(opportunityLineItems);
	}

	public static List<OpportunityProductServiceQuote__c> getOpportunityProductServiceQuotes(
		Map<String, String> fieldValues
	) {
		Set<String> requestedFields = new Set<String>{
			Schema.OpportunityProductServiceQuote__c.OpportunityId__c + '',
			Schema.OpportunityProductServiceQuote__c.ServiceId__c + '',
			Schema.OpportunityProductServiceQuote__c.ProductId__c + '',
			SystemUtility.getRName(Schema.OpportunityProductServiceQuote__c.ServiceQuoteId__c) +
			'.' +
			Schema.Quote__c.OpportunityId__c
		};
		QueryRequest queryRequest = new QueryRequest(
			Schema.SObjectType.OpportunityProductServiceQuote__c.getName()
		);
		queryRequest.requestedFields = requestedFields;
		queryRequest.setFilterBy(fieldValues);
		List<OpportunityProductServiceQuote__c> opportunityProductServiceQuotes = (List<OpportunityProductServiceQuote__c>) SOQLUtility.querySObject(
			queryRequest
		);
		return opportunityProductServiceQuotes;
	}

	public static OpportunityProductServiceQuote__c getOpportunityProductServiceQuote(
		Map<String, String> fieldValues
	) {
		List<OpportunityProductServiceQuote__c> opportunityProductServiceQuotes = getOpportunityProductServiceQuotes(
			fieldValues
		);

		OpportunityProductServiceQuote__c opportunityProductServiceQuote = null;
		if (!opportunityProductServiceQuotes.isEmpty()) {
			opportunityProductServiceQuote = opportunityProductServiceQuotes[0];
		}
		return opportunityProductServiceQuote;
	}

	public static void deleteOpportunityProductServiceQuote(
		List<OpportunityLineItem> opportunityLineItems
	) {
		Map<Id, OpportunityLineItem> opportunityLineItemById = new Map<Id, OpportunityLineItem>(
			opportunityLineItems
		);
		List<OpportunityProductServiceQuote__c> recordsToDelete = new List<OpportunityProductServiceQuote__c>();

		// services
		QueryRequest serviceQueryRequest = new QueryRequest(
			Schema.SObjectType.OpportunityProductServiceQuote__c.getName()
		);
		serviceQueryRequest.setFilterBy(
			new Map<String, Set<Id>>{
				Schema.OpportunityProductServiceQuote__c.ServiceId__c +
				'' => opportunityLineItemById.keySet()
			}
		);
		recordsToDelete.addAll(
			(List<OpportunityProductServiceQuote__c>) SOQLUtility.querySObject(serviceQueryRequest)
		);

		// products
		QueryRequest productQueryRequest = new QueryRequest(
			Schema.SObjectType.OpportunityProductServiceQuote__c.getName()
		);
		productQueryRequest.setFilterBy(
			new Map<String, Set<Id>>{
				Schema.OpportunityProductServiceQuote__c.ProductId__c +
				'' => opportunityLineItemById.keySet()
			}
		);
		recordsToDelete.addAll(
			(List<OpportunityProductServiceQuote__c>) SOQLUtility.querySObject(productQueryRequest)
		);

		CRUDUtility.deleteRecords(recordsToDelete);
	}

	public static void updateOpportunityProductServiceQuote(Id newQuoteId, Id oldQuoteId) {
		OpportunityProductServiceQuote__c opportunityQuote = getOpportunityProductServiceQuote(
			new Map<String, String>{
				Schema.OpportunityProductServiceQuote__c.ServiceQuoteId__c + '' => oldQuoteId
			}
		);

		opportunityQuote.ServiceQuoteId__c = newQuoteId;
		CRUDUtility.updateRecords(opportunityQuote);
	}

	public static Product__c getProvusServiceProductByProduct2Id(Id serviceId) {
		QueryRequest productQueryRequest = new QueryRequest(Schema.SObjectType.Product__c.getName());
		productQueryRequest.requestedFields = new Set<String>{
			SObjectUtility.FIELD_ID,
			Schema.Product__c.ProductCode__c + '',
			Schema.Product__c.Practice__c + '',
			Schema.Product__c.Group__c + '',
			Schema.Product__c.StandardProductId__c + ''
		};
		productQueryRequest.setFilterBy(
			new Map<String, String>{ Schema.Product__c.StandardProductId__c + '' => serviceId }
		);
		List<Product__c> products = (List<Product__c>) SOQLUtility.querySObject(productQueryRequest);
		Product__c serviceProduct = products[0];
		return serviceProduct;
	}

	private static Estimate__c getServiceEstimate(Id estimateId) {
		Estimate__c serviceEstimate = null;
		if (estimateId != null) {
			serviceEstimate = [
				SELECT Id, ProductId__c, ProductId__r.StandardProductId__c, TotalEstimatedAmount__c
				FROM Estimate__c
				WHERE Id = :estimateId
				WITH SECURITY_ENFORCED
			];
		}
		return serviceEstimate;
	}

	public static OpportunityProductServiceQuote__c createOpportunityLines(Quote__c serviceQuote) {
		try {
			Estimate__c serviceEstimate = getServiceEstimate(serviceQuote.EstimateId__c);
			Opportunity opp = [
				SELECT Pricebook2Id, Id
				FROM Opportunity
				WHERE Id = :serviceQuote.OpportunityId__c
				WITH SECURITY_ENFORCED
			];
			if (opp.Pricebook2Id == null) {
				return null;
			}
			if (serviceQuote.ServiceId__c == null) {
				return null;
			}

			Product__c serviceProductSO = [
				SELECT
					StandardProductId__c,
					AssociatedProductId__c,
					AssociatedProductId__r.StandardProductId__c
				FROM Product__c
				WHERE Id = :serviceQuote.ServiceId__c
				WITH SECURITY_ENFORCED
			];

			Product__c productSO = null;
			if (serviceEstimate != null && serviceEstimate.ProductId__c != null) {
				productSO = [
					SELECT StandardProductId__c
					FROM Product__c
					WHERE Id = :serviceEstimate.ProductId__c
					WITH SECURITY_ENFORCED
				];
			}
			Id serviceProductId = serviceProductSO.StandardProductId__c;
			Id productId = productSO != null
				? productSO.StandardProductId__c
				: serviceProductSO.AssociatedProductId__r.StandardProductId__c;
			Id opportunityId = opp.Id;
			// create opportunity line item for service line
			PricebookEntry pricebookEntry = getPricebookEntry(serviceProductId, opp.Pricebook2Id);
			NamedRange.NamedRangeDO quoteTotalNamedRange = NamedRangeService.getQuoteTotalForQuote(
				serviceQuote.Id
			);
			ServiceRecommendationsDto.OpportunityLineItemRequest opportunityLineItemRequest = new ServiceRecommendationsDto.OpportunityLineItemRequest();
			opportunityLineItemRequest.opportunityLineItems.add(new OpportunityLineItem());
			opportunityLineItemRequest.opportunityId = opportunityId;
			opportunityLineItemRequest.productId = serviceProductId;
			opportunityLineItemRequest.pricebookEntryId = pricebookEntry.Id;
			opportunityLineItemRequest.quoteTotalNamedRange = quoteTotalNamedRange;
			opportunityLineItemRequest.unitPrice = serviceEstimate?.TotalEstimatedAmount__c;
			List<OpportunityLineItem> serviceLineItems = upsertOpportunityLineItem(
				opportunityLineItemRequest
			);
			OpportunityLineItem serviceLineItem = serviceLineItems[0];

			// store into junction object
			OpportunityLineItem productLineItem = getProductLineItem(productId);
			ServiceRecommendationsDto.OpportunityProductServiceQuoteRequest opportunityProductServiceQuoteRequest = new ServiceRecommendationsDto.OpportunityProductServiceQuoteRequest();
			List<Product2> associatedProducts = [
				SELECT Name
				FROM Product2
				WHERE Id = :productId
				WITH SECURITY_ENFORCED
				LIMIT 1
			];
			// from quote view - we might not have an associated product line so we'll default it as blank
			String productName = '';
			if (!associatedProducts.isEmpty()) {
				// from opportunity view - we will have an associated product line so we'll default it to the product name
				productName = associatedProducts[0].Name;
			}
			opportunityProductServiceQuoteRequest.Name = productName;
			opportunityProductServiceQuoteRequest.serviceLineItem = serviceLineItem;
			opportunityProductServiceQuoteRequest.productLineItem = productLineItem;
			opportunityProductServiceQuoteRequest.serviceQuote = new Quote__c(
				Id = serviceQuote.Id,
				OpportunityId__c = opportunityId
			);
			opportunityProductServiceQuoteRequest.serviceEstimate = serviceEstimate;
			OpportunityProductServiceQuote__c opportunityProductServiceQuote = insertOpportunityProductServiceQuote(
				opportunityProductServiceQuoteRequest
			);
			return opportunityProductServiceQuote;
		} catch (Exception e) {
			throw new ApplicationException(e.getMessage());
		}
	}

	private static PricebookEntry getPricebookEntry(Id serviceId, Id pricebookId) {
		QueryRequest pricebookEntryQueryRequest = new QueryRequest(
			Schema.SObjectType.PricebookEntry.getName()
		);
		pricebookEntryQueryRequest.requestedFields = new Set<String>{
			SObjectUtility.FIELD_ID,
			Schema.PricebookEntry.UnitPrice + ''
		};
		pricebookEntryQueryRequest.setFilterBy(
			new Map<String, String>{
				Schema.PricebookEntry.Product2Id + '' => serviceId,
				Schema.Opportunity.Pricebook2Id + '' => pricebookId
			}
		);
		List<PricebookEntry> pricebookEntries = (List<PricebookEntry>) SOQLUtility.querySObject(
			pricebookEntryQueryRequest
		);
		PricebookEntry pricebookEntry = pricebookEntries[0];
		return pricebookEntry;
	}

	private static OpportunityLineItem getProductLineItem(Id productId) {
		OpportunityLineItem productLineItem = null;
		if (productId == null) {
			return productLineItem;
		}

		QueryRequest oppLineItemQueryRequest = new QueryRequest(
			Schema.SObjectType.OpportunityLineItem.getName()
		);
		oppLineItemQueryRequest.setFilterBy(
			new Map<String, String>{ Schema.OpportunityLineItem.Product2Id + '' => productId }
		);
		List<OpportunityLineItem> opportunityLineItems = (List<OpportunityLineItem>) SOQLUtility.querySObject(
			oppLineItemQueryRequest
		);
		if (!opportunityLineItems.isEmpty()) {
			productLineItem = opportunityLineItems[0];
		}
		return productLineItem;
	}

	public static void createOpportunityLineFor(Quote__c quoteSO, Quote__c oldQuoteSO) {
		Boolean isOpportunityChanged =
			quoteSO.OpportunityId__c != null &&
			oldQuoteSO.OpportunityId__c != null &&
			quoteSO.OpportunityId__c != oldQuoteSO.OpportunityId__c;
		Boolean hasOpportunityPopulated =
			isOpportunityChanged ||
			(quoteSO.OpportunityId__c != null &&
			oldQuoteSO.OpportunityId__c == null);

		if (hasOpportunityPopulated) {
			createOpportunityLines(quoteSO);
		}
	}
}
