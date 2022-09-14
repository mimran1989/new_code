/**
 *  Provus Services Quoting
 *  CreateQuoteFromEstimateController
 *  @2021 Provus Inc. All rights reserved.
 */
public with sharing class CreateQuoteFromEstimateController {
	@AuraEnabled(Cacheable=true)
	public static QuoteDO getEstimateDetails(String estimateId) {
		//Required Fields from estimate
		Set<String> requiredFields = new Set<String>();
		if (Account.SObjectType.getDescribe().isAccessible()) {
			requiredFields.add(Schema.Estimate__c.AccountId__c + '');
		}
		if (Opportunity.SObjectType.getDescribe().isAccessible()) {
			requiredFields.add(Schema.Estimate__c.OpportunityId__c + '');
		}

		requiredFields.add(Schema.Estimate__c.Description__c + '');
		requiredFields.add(Schema.Estimate__c.RateCardId__c + '');
		requiredFields.add(Schema.Estimate__c.ServiceId__c + '');
		requiredFields.add(
			SystemUtility.getRName(Schema.Estimate__c.ServiceId__c) +
			'.' +
			Schema.Product__c.Practice__c
		);
		requiredFields.add(
			SystemUtility.getRName(Schema.Estimate__c.ServiceId__c) +
			'.' +
			Schema.Product__c.Group__c
		);

		QueryRequest queryRequest = new QueryRequest(Schema.Estimate__c.SObjectType);
		queryRequest.requestedFields = requiredFields;
		queryRequest.setFilterBy(new Map<String, String>{ SObjectUtility.FIELD_ID => estimateId });
		List<Estimate__c> estimates = SOQLUtility.querySObject(queryRequest);

		QuoteDO quoteData;
		if (!estimates.isEmpty()) {
			Estimate__c estimateSO = estimates[0];
			quoteData = CreateQuoteFromEstimateService.getEstimateQuoteDetails(estimateSO);
		}
		return quoteData;
	}

	@AuraEnabled
	public static Date getServiceEndDate(Id estimateId, EndDateArgs endDateArgs) {
		return EstimateService.getServiceEndDate(estimateId, endDateArgs);
	}

	@AuraEnabled
	public static Boolean isValidPeriodCount(
		Date serviceStartDate,
		Date serviceEndDate,
		String timePeriods
	) {
		ITimePeriod timePeriodCalc = TimePeriodFactory.newTimePeriod(timePeriods);
		Decimal periodCount = timePeriodCalc.numberOfPeriods(serviceStartDate, serviceEndDate);

		if (periodCount > QuotePeriodService.MAX_PERIOD_COUNT) {
			return false;
		}

		return true;
	}

	@AuraEnabled
	public static Id createQuote(String quoteDetails) {
		QuoteDO quoteDate = (QuoteDO) JSON.deserialize(quoteDetails, QuoteDO.class);
		Quote__c quoteSO = QuoteDO.getQuoteFromData(quoteDate);
		quoteSO.QuoteDate__c = System.today();
		quoteSO.Version__c = 1;
		quoteSO.Type__c = QuoteService.RECORDTYPE_NAME_QUOTE;
		CRUDUtility.insertRecords(quoteSO);

		CreateQuoteFromEstimateService.convertEntitiesFromEstimate(quoteSO);
		associateQuoteToEstimate(quoteSO);
		return quoteSO.Id;
	}

	public static void associateQuoteToEstimate(Quote__c quote) {
		QueryRequest queryRequest = new QueryRequest(Schema.Estimate__c.SObjectType);

		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(
			Schema.Estimate__c.SObjectType
		);

		queryRequest.setFilterBy(
			new Map<String, String>{ Schema.Estimate__c.Id + '' => quote.EstimateId__c }
		);

		List<Estimate__c> estimate = (List<Estimate__c>) SOQLUtility.querySObject(queryRequest);
		estimate[0].QuoteId__c = quote.Id;
		CRUDUtility.updateRecords(estimate);
	}
}
