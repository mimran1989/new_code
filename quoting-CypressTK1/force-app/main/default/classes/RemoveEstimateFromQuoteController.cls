/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class RemoveEstimateFromQuoteController {
	public class RemoveEstimateFromQuoteResponse {
		@AuraEnabled
		public String estimateName;

		@AuraEnabled
		public Boolean success;
	}

	@AuraEnabled
	public static RemoveEstimateFromQuoteResponse removeEstimateFromQuote(Id quoteId) {
		RemoveEstimateFromQuoteResponse response = new RemoveEstimateFromQuoteResponse();
		Estimate__c estimateSO = [
			SELECT Id, Name, IsSyncChangesToQuote__c, QuoteId__c
			FROM Estimate__c
			WHERE Id IN (SELECT EstimateId__c FROM Quote__c WHERE Id = :quoteId)
			WITH SECURITY_ENFORCED
		];

		response.estimateName = estimateSO.Name;
		estimateSO.IsSyncChangesToQuote__c = false;
		CRUDUtility.updateRecords(estimateSO);

		response.success = true;
		return response;
	}
}
