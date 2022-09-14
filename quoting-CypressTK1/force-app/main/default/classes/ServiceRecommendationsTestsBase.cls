/**
 *  Provus Services Quoting
 *  ServiceRecommendationsTestsBase
 *  @2021 Provus Inc. All rights reserved.
 */
public with sharing abstract class ServiceRecommendationsTestsBase extends EstimateTestBase {
	public static void setupData() {
		// price book
		Pricebook2 pricebook = newPriceBook();
		// opportunity
		Opportunity opp = newOpportunity(pricebook);
		// setup products
		Product2 product = newProduct2('Main Product', 'Product');
		CRUDUtility.insertRecords(product);
		Product2 service = newProduct2('Service Product', 'Service');
		service.AssociatedProductId__c = product.Id;
		CRUDUtility.insertRecords(service);

		Id productTypeId = SObjectUtility.getRecordTypeIdbyName(
			Schema.SObjectType.Product__c.getName(),
			'Product'
		);
		Id serviceTypeId = SObjectUtility.getRecordTypeIdbyName(
			Schema.SObjectType.Product__c.getName(),
			'Service'
		);
		Product__c cproduct = newProduct('Main Product', productTypeId);
		cproduct.StandardProductId__c = product.Id;
		CRUDUtility.insertRecords(cproduct);
		Product__c cservice = newProduct('Service Product', serviceTypeId);
		cservice.StandardProductId__c = service.Id;
		cservice.AssociatedProductId__c = cproduct.Id;
		CRUDUtility.insertRecords(cservice);

		// pricebook entries
		Id standardPricebookId = Test.getStandardPricebookId();
		List<PricebookEntry> pricebookEntries = new List<PricebookEntry>{
			newPricebookEntry(standardPricebookId, product.Id),
			newPricebookEntry(standardPricebookId, service.Id),
			newPricebookEntry(pricebook.Id, product.Id),
			newPricebookEntry(pricebook.Id, service.Id)
		};
		CRUDUtility.insertRecords(pricebookEntries);
		// resource roles
		List<Product__c> resourceRoles = createResourceRoles();
		// rate card
		RateCard__c rateCard = newRateCardWithItems(resourceRoles);
		// estimates
		EstimateTemplate__c estimateTemplate = EstimateTemplateTestBase.newEstimateTemplate();
		estimateTemplate.RateCardId__c = rateCard.Id;
		CRUDUtility.updateRecords(estimateTemplate);
		List<ActivityGroupTemplate__c> activityGroupTemplates = EstimateTemplateTestBase.createActivityGroupTemplates(
			estimateTemplate.Id
		);
		List<ActivityTemplate__c> activityTemplates = EstimateTemplateTestBase.createActivityTemplates(
			activityGroupTemplates
		);
		EstimateTemplateTestBase.createTaskTemplates(activityTemplates, resourceRoles);
		Estimate__c estimateSO = CreateEstimateService.createEstimate(estimateTemplate.Id);
		estimateSO.Default__c = true;
		estimateSO.ProductId__c = cproduct.Id;
		estimateSO.ServiceId__c = cservice.Id;
		CRUDUtility.updateRecords(estimateSO);

		// quote
		Quote__c quote = newQuote();
		quote.Name = 'Test Quote';
		quote.EstimateId__c = estimateSO.Id;
		quote.OpportunityId__c = opp.Id;
		quote.Type__c = 'Quote';
		quote.ServiceId__c = cservice.Id;
		CRUDUtility.updateRecords(quote);
		// quote item
		QuoteItem__c quoteItemSO = new QuoteItem__c();
		quoteItemSO.QuoteId__c = quote.Id;
		quoteItemSO.ProductId__c = cservice.Id;
		CRUDUtility.insertRecords(quoteItemSO);
	}

	public static OpportunityLineItem createProductOpportunityLineItem() {
		Opportunity opp = [
			SELECT Id, Name, Pricebook2Id
			FROM Opportunity
			WHERE Name = 'Test'
			WITH SECURITY_ENFORCED
			LIMIT 1
		];
		List<OpportunityLineItem> oppLineItems = [
			SELECT Id
			FROM OpportunityLineItem
			WHERE OpportunityId = :opp.Id
			WITH SECURITY_ENFORCED
		];
		CRUDUtility.deleteRecords(oppLineItems);
		Product2 product = [
			SELECT Id, Name
			FROM Product2
			WHERE Name = 'Main Product'
			WITH SECURITY_ENFORCED
			LIMIT 1
		];
		OpportunityLineItem oppLineItem = new OpportunityLineItem();
		PricebookEntry pricebookEntry = [
			SELECT Id
			FROM PricebookEntry
			WHERE Product2Id = :product.Id AND Pricebook2Id = :opp.Pricebook2Id
			WITH SECURITY_ENFORCED
			LIMIT 1
		];
		ServiceRecommendationsDto.OpportunityLineItemRequest oppLineItemRequest = new ServiceRecommendationsDto.OpportunityLineItemRequest();
		oppLineItemRequest.opportunityLineItems.add(oppLineItem);
		oppLineItemRequest.opportunityId = opp.Id;
		oppLineItemRequest.productId = product.Id;
		oppLineItemRequest.pricebookEntryId = pricebookEntry.Id;
		NamedRange.NamedRangeDO quoteTotalNamedRange = new NamedRange.NamedRangeDO();
		quoteTotalNamedRange.relatedTotal = new NamedRangeTotal.NamedRangeTotalDO();
		quoteTotalNamedRange.relatedTotal.netExtendedAmount = 1000;
		oppLineItemRequest.quoteTotalNamedRange = quoteTotalNamedRange;
		List<OpportunityLineItem> opportunityLineItems = ServiceRecommendationsSupport.upsertOpportunityLineItem(
			oppLineItemRequest
		);
		return opportunityLineItems[0];
	}

	public static OpportunityLineItem createOpportunityLineItem() {
		Opportunity opp = [
			SELECT Id, Name, Pricebook2Id
			FROM Opportunity
			WHERE Name = 'Test'
			WITH SECURITY_ENFORCED
			LIMIT 1
		];
		Product2 product = [
			SELECT Id, Name
			FROM Product2
			WHERE Name = 'Service Product'
			WITH SECURITY_ENFORCED
			LIMIT 1
		];
		PricebookEntry pricebookEntry = [
			SELECT Id
			FROM PricebookEntry
			WHERE Product2Id = :product.Id AND Pricebook2Id = :opp.Pricebook2Id
			WITH SECURITY_ENFORCED
			LIMIT 1
		];
		OpportunityLineItem serviceOpportunityLineItem = newOpportunityLineItem(
			opp.Id,
			product.Id,
			pricebookEntry.Id
		);
		CRUDUtility.insertRecords(serviceOpportunityLineItem);
		return serviceOpportunityLineItem;
	}
}
