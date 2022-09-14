/**
 *  Provus Services Quoting
 *  QuoteTriggers
 *  @2021-2022 Provus Inc. All rights reserved.
 *
 */
public with sharing class QuoteTriggers extends TriggerHandler {
	public static void processTrigger(
		Map<Id, Quote__c> oldMap,
		List<Quote__c> newObjs,
		Boolean isBefore
	) {
		final QuoteTriggers myTrigger = new QuoteTriggers(oldMap, newObjs, isBefore);
		if (isBefore) {
			myTrigger.preventAdditionalQuoteToEstimate();
			// prevent manual changes to object fields
			myTrigger.preventCurrencyChange();
			myTrigger.preventChangeOfLastProposalSync();

			myTrigger.assignCurrencyConversionRatio();
			myTrigger.rollbackQuoteTotalsFromProposal();
			myTrigger.syncTotalsToProposal();

			myTrigger.syncOpportunityLines();
		} else {
			if (RuntimeContext.skipQuoteTrigger) {
				return;
			}
			List<Quote__c> quotes = myTrigger.getQuotesWithChangedDate();
			QuotePeriodService.recreatePeriodsAndPeriodGroupsFor(quotes);
			myTrigger.setupNewQuotes();
		}
	}

	public QuoteTriggers(Map<Id, Quote__c> oldMap, List<Quote__c> newObjs, Boolean isBefore) {
		super(oldMap, newObjs, isBefore);
	}

	public void preventCurrencyChange() {
		if (MultiCurrencyService.isMultiCurrencyEnabled() && isUpdate) {
			MultiCurrencyService.preventCurrencyChange(newObjs, (Map<Id, Quote__c>) oldMap);
		}
	}

	public void preventChangeOfLastProposalSync() {
		if (!isUpdate) {
			return;
		}
		for (Quote__c quote : (List<Quote__c>) newObjs) {
			Quote__c oldQuote = (Quote__c) oldMap.get(quote.Id);
			if (
				oldQuote.LastProposalSync__c != null &&
				isChanged(quote.Id, Schema.Quote__c.LastProposalSync__c)
			) {
				quote.LastProposalSync__c.addError(Label.SystemFieldChangeDisallowed);
			}
		}
	}

	private void assignCurrencyConversionRatio() {
		if (MultiCurrencyService.isMultiCurrencyEnabled() && isInsert) {
			MultiCurrencyService.assignCurrencyConversionRatio(newObjs);
		}
	}

	private void setupNewQuotes() {
		if (isInsert) {
			QuoteService.setupNewQuotes(
				(Map<Id, Quote__c>) SystemUtility.keyByIdType(newObjs, Quote__c.Id)
			);
		}
	}

	private void syncTotalsToProposal() {
		if (isDelete) {
			return;
		}

		QuoteSyncService.syncQuoteTotalsToProposal(
			(List<Quote__c>) newObjs,
			(Map<Id, Quote__c>) oldMap
		);
	}

	private void rollbackQuoteTotalsFromProposal() {
		if (!isDelete) {
			return;
		}

		Set<Id> proposalIds = new Set<Id>();
		List<Quote__c> quotesToRollback = new List<Quote__c>();

		for (Quote__c oldQuote : (List<Quote__c>) oldMap.values()) {
			Id proposalId = oldQuote.ProposalId__c;
			if (proposalId != null) {
				proposalIds.add(proposalId);
				quotesToRollback.add(oldQuote);
			}
		}

		QueryRequest queryRequest = new QueryRequest(Schema.SObjectType.Proposal__c.getName());
		queryRequest.requestedFields = new Set<String>(QuoteSyncService.PROPOSAL_SYNC_FIELDS);
		Map<Id, Proposal__c> proposals = new Map<Id, Proposal__c>(
			(List<Proposal__c>) SOQLUtility.querySObject(queryRequest)
		);

		QuoteSyncService.rollbackQuoteTotalsFromProposal(quotesToRollback, proposals);
		CRUDUtility.updateRecords(proposals.values());
	}

	private void syncOpportunityLines() {
		if (!isUpdate) {
			return;
		}
		List<Quote__c> quotes = newObjs;
		for (Quote__c quoteSO : quotes) {
			// only run this if it has not been created from a quote template
			Quote__c oldQuoteSO = ((Quote__c) oldMap?.get(quoteSO.Id));
			if (quoteSO.Type__c == QuoteService.RECORDTYPE_NAME_QUOTE && quoteSO.TemplateId__c == null) {
				// check scenario as primary flow, so need to update existing opportunity line
				Boolean needUpdateOpportunityLine =
					quoteSO.OpportunityId__c != null &&
					oldQuoteSO.OpportunityId__c == null &&
					oldQuoteSO.DerivedFromId__c != null &&
					RuntimeContext.isMakingScenarioAsPrimaryMode;

				if (needUpdateOpportunityLine) {
					ServiceRecommendationsSupport.updateOpportunityProductServiceQuote(
						quoteSO.Id,
						oldQuoteSO.DerivedFromId__c
					);
				} else {
					ServiceRecommendationsSupport.createOpportunityLineFor(quoteSO, oldQuoteSO);
					QuoteConfiguratorSupport.updateOpportunityLineFor(quoteSO, oldQuoteSO);
				}
			}
		}
	}

	private List<Quote__c> getQuotesWithChangedDate() {
		List<Quote__c> needPeriodsUpdate = new List<Quote__c>();

		if (!isUpdate) {
			return needPeriodsUpdate;
		}
		for (Quote__c quote : (List<Quote__c>) newObjs) {
			if (isChanged(quote.Id, Schema.Quote__c.ServiceEndDate__c)) {
				needPeriodsUpdate.add(quote);
			}
		}

		return needPeriodsUpdate;
	}

	public void preventAdditionalQuoteToEstimate() {
		if (isDelete) {
			return;
		}
		for (Quote__c quoteSO : (List<Quote__c>) newObjs) {
			Quote__c oldQuoteSO = ((Quote__c) oldMap?.get(quoteSO.Id));
			Boolean hasEstimatePopulated =
				oldQuoteSO?.EstimateId__c == null &&
				quoteSO.EstimateId__c != null;
			if (hasEstimatePopulated || quoteSO.Id == null) {
				EstimateTreeService.preventAdditionalQuoteToEstimate(newObjs);
			}
		}
	}
}
