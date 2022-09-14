/*
 *  Provus Services Quoting
 *  @2021 Provus Inc. All rights reserved.
 */
public with sharing class CollaborationRequestService {
	/**
	 * Returns the outstanding collaboration requests for the given quote ID. An outstanding
	 * request is neither Merged nor Revoked.
	 * @param quoteId A quote ID
	 *
	 * @return A list of outstanding requests
	 */
	public static List<CollaborationRequestDto> getOutstandingRequestsFor(Id quoteId) {
		List<Id> sectionIds = new List<Id>();
		Map<Id, CollaborationRequestDto> requestsBySectionId = new Map<Id, CollaborationRequestDto>();
		for (CollaborationRequest__c requestSo : [
			SELECT
				Id,
				Name,
				SectionId__c,
				SectionId__r.DerivedFromId__c,
				SectionId__r.Name,
				QuoteId__c,
				QuoteId__r.Type__c,
				Status__c,
				CollaboratorUserId__r.Name
			FROM CollaborationRequest__c
			WHERE QuoteId__c = :quoteId AND Status__c != :CollaborationRequest.STATUS_MERGED
			WITH SECURITY_ENFORCED
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		]) {
			CollaborationRequestDto requestDto = new CollaborationRequestDto(requestSo);
			sectionIds.add(requestDto.sectionId);
			requestsBySectionId.put(requestDto.sectionId, requestDto);
		}

		for (QuoteSection__c sectionSo : [
			SELECT QuoteId__c, QuoteId__r.Name, DerivedFromId__c
			FROM QuoteSection__c
			WHERE DerivedFromId__c IN :sectionIds
			WITH SECURITY_ENFORCED
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		]) {
			CollaborationRequestDto requestDto = requestsBySectionId.get(sectionSo.DerivedFromId__c);
			requestDto.collaborationQuoteName = sectionSo.QuoteId__r.Name;
			requestDto.collaborationQuoteId = sectionSo.QuoteId__c;
		}

		return requestsBySectionId.values();
	}

	public static List<CollaborationRequest__c> getAssignedRequestsFor(Id quoteId) {
		return [
			SELECT
				Id,
				Name,
				SectionId__c,
				SectionId__r.DerivedFromId__c,
				SectionId__r.QuoteId__c,
				SectionId__r.QuoteId__r.Type__c,
				SectionId__r.Name,
				Status__c,
				CollaboratorUserId__r.Name
			FROM CollaborationRequest__c
			WHERE QuoteId__c = :quoteId AND Status__c = :CollaborationRequest.STATUS_ASSIGNED
			WITH SECURITY_ENFORCED
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		];
	}

	public static List<CollaborationRequest__c> getRevocableRequestsFor(
		Id quoteId,
		List<Id> sectionIds
	) {
		return [
			SELECT
				Id,
				Name,
				SectionId__c,
				SectionId__r.DerivedFromId__c,
				SectionId__r.QuoteId__c,
				SectionId__r.QuoteId__r.Type__c,
				SectionId__r.Name,
				Status__c,
				CollaboratorUserId__r.Name
			FROM CollaborationRequest__c
			WHERE
				QuoteId__c = :quoteId
				AND SectionId__c IN :sectionIds
				AND Status__c IN :CollaborationRequest.REVOCABLE_STATUSES
			WITH SECURITY_ENFORCED
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		];
	}

	/**
	 * Marks the collaboration requests for the given quote ID
	 * as Ready to Merge.
	 * @param sectionIds A list of section IDs
	 */
	public static void markForMerge(List<Id> sectionIds) {
		List<CollaborationRequest__c> updatedRequests = new List<CollaborationRequest__c>();
		for (CollaborationRequest__c collabSO : [
			SELECT Id
			FROM CollaborationRequest__c
			WHERE SectionId__c IN :sectionIds
			WITH SECURITY_ENFORCED
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		]) {
			collabSO.Status__c = CollaborationRequest.STATUS_READY_TO_MERGE;
			updatedRequests.add(collabSO);
		}

		CRUDUtility.updateRecords(updatedRequests);
	}

	/**
	 * Marks the collaboration requests for the given quote ID
	 * as Merged.
	 * @param sectionIds A list of section IDs
	 */
	public static void markAsMerged(List<Id> sectionIds) {
		List<CollaborationRequest__c> updatedRequests = new List<CollaborationRequest__c>();
		for (CollaborationRequest__c collabSO : [
			SELECT Id
			FROM CollaborationRequest__c
			WHERE SectionId__c IN :sectionIds
			WITH SECURITY_ENFORCED
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		]) {
			collabSO.Status__c = CollaborationRequest.STATUS_MERGED;
			updatedRequests.add(collabSO);
		}

		CRUDUtility.updateRecords(updatedRequests);
	}
}
