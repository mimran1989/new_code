/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class QuoteCompareController {
	@AuraEnabled
	public static List<QuoteOverviewDto> getQuoteOverviewsForRequest(Id requestId) {
		List<Id> quoteIds = new List<Id>();
		Map<Id, String> submissionCommentsByQuoteId = new Map<Id, String>();
		for (ApprovalRequestItem__c item : [
			SELECT QuoteId__c, ApprovalSubmissionComments__c
			FROM ApprovalRequestItem__c
			WHERE ApprovalRequestId__c = :requestId AND ApprovalRequestId__r.Status__c = 'Submitted'
			WITH SECURITY_ENFORCED
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		]) {
			quoteIds.add(item.QuoteId__c);
			submissionCommentsByQuoteId.put(item.QuoteId__c, item.ApprovalSubmissionComments__c);
		}

		List<QuoteOverviewDto> overviews = getQuoteOverviews(quoteIds);
		for (QuoteOverviewDto overviewDto : overviews) {
			overviewDto.approvalSubmissionComments = submissionCommentsByQuoteId.get(overviewDto.id);
		}

		return overviews;
	}

	public static List<QuoteOverviewDto> getQuoteOverviews(List<Id> quoteIds) {
		List<QuoteOverviewDto> overviewDtos = new List<QuoteOverviewDto>();
		for (Quote__c quoteSo : [
			SELECT
				Id,
				Name,
				CreatedBy.Name,
				CreatedDate,
				TotalAmount__c,
				TimePeriod__c,
				DiscountAmount__c,
				MarginPercent__c,
				TotalCost__c,
				(SELECT Id FROM QuotePeriods__r)
			FROM Quote__c
			WHERE Id IN :quoteIds
			WITH SECURITY_ENFORCED
		]) {
			QuoteOverviewDto overviewDto = new QuoteOverviewDto(quoteSo);
			overviewDtos.add(overviewDto);

			for (QuoteSummaryDO summaryDto : QuoteSummaryService.getQuoteSummaries(quoteSo.Id)) {
				if (summaryDto.type == QuoteSummary.SUMMARYTYPE_LOCATION) {
					overviewDto.headcountByLocation.put(summaryDto.rowName, summaryDto.totalQuantity);
				}
			}
		}

		return overviewDtos;
	}

	@AuraEnabled
	public static void rejectQuotes(Id requestId, String rejectComments) {
		QuoteApprovalService.reject(requestId, rejectComments);
	}

	@AuraEnabled
	public static void approveQuote(Id requestId, Id quoteId) {
		QuoteApprovalService.approve(requestId, quoteId);
	}
}
