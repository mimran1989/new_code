/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class SubmitForApprovalService {
	public static List<Quote__c> getScenariosForApproval(Id quoteId) {
		List<Quote__c> quoteRecords = new List<Quote__c>();

		Quote__c currentRecord = [
			SELECT
				Id,
				Name,
				Type__c,
				AccountId__r.Name,
				AccountId__c,
				IsPrimary__c,
				MarginPercent__c,
				TotalAmount__c,
				DerivedFromId__c,
				TotalCost__c,
				CreatedDate
			FROM Quote__c
			WHERE Id = :quoteId
			WITH SECURITY_ENFORCED
		];

		Id queryValue;

		if (
			currentRecord.Type__c == QuoteService.RECORDTYPE_NAME_QUOTE ||
			currentRecord.Type__c == QuoteService.RECORDTYPE_NAME_COLLABORATION
		) {
			queryValue = quoteId;
		} else if (currentRecord.Type__c == QuoteService.RECORDTYPE_NAME_SCENARIO) {
			queryValue = currentRecord.DerivedFromId__c;
			Quote__c originalQuote = [
				SELECT
					Id,
					Name,
					Type__c,
					AccountId__r.Name,
					AccountId__c,
					IsPrimary__c,
					MarginPercent__c,
					TotalAmount__c,
					DerivedFromId__c,
					TotalCost__c,
					CreatedDate
				FROM Quote__c
				WHERE Id = :currentRecord.DerivedFromId__c
				WITH SECURITY_ENFORCED
			];
			quoteRecords.add(originalQuote);
		} else {
			throw new ApplicationException(
				'Quote Type: ' +
				currentRecord.Type__c +
				', does not support scenarios.'
			);
		}
		quoteRecords.AddAll(
			[
				SELECT
					Id,
					Name,
					Type__c,
					AccountId__r.Name,
					AccountId__c,
					IsPrimary__c,
					MarginPercent__c,
					TotalAmount__c,
					DerivedFromId__c,
					TotalCost__c,
					CreatedDate
				FROM Quote__c
				WHERE
					DerivedFromId__c = :queryValue
					AND Id != :quoteId
					AND Status__c = :QuoteService.STATUS_ACTIVE
				WITH SECURITY_ENFORCED
				ORDER BY CreatedDate DESC
			]
		);
		quoteRecords.add(currentRecord);
		return quoteRecords;
	}
}
