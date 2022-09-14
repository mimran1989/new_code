/**
 *  Provus Services Quoting
 *  QuoteSyncService
 *  @2021 Provus Inc. All rights reserved.
 *
 */
public with sharing abstract class QuoteSyncService {
	public final static List<String> PROPOSAL_SYNC_FIELDS = new List<String>{
		Schema.Quote__c.TotalAmountBeforeDiscount__c + '',
		Schema.Quote__c.TotalAmount__c + '',
		Schema.Quote__c.TotalCost__c + '',
		Schema.Quote__c.DiscountAmount__c + ''
	};

	private static void deltaSyncQuotesToProposal(
		List<Quote__c> quotesToSync,
		Map<Id, Quote__c> oldQuotes,
		Map<Id, Proposal__c> proposals
	) {
		for (Quote__c quote : quotesToSync) {
			Quote__c oldQuote = (Quote__c) oldQuotes.get(quote.Id);
			Proposal__c proposal = proposals.get(quote.ProposalId__c);
			for (String fieldApiName : PROPOSAL_SYNC_FIELDS) {
				Decimal oldValue = SystemUtility.nullToZero((Decimal) proposal.get(fieldApiName));
				Decimal deltaValue = SystemUtility.delta(
					(Decimal) oldQuote.get(fieldApiName),
					(Decimal) quote.get(fieldApiName)
				);
				proposal.put(fieldApiName, oldValue + deltaValue);
			}
		}
	}

	private static Boolean anyProposalSyncFieldChanged(
		Quote__c ctxQuote,
		Map<Id, Quote__c> oldQuotes
	) {
		Boolean anySyncFieldChanged = false;
		for (String syncField : QuoteSyncService.PROPOSAL_SYNC_FIELDS) {
			Object oldValue = oldQuotes?.get(ctxQuote.Id)?.get(syncField);
			Object newValue = ctxQuote.get(syncField);
			if (oldValue != newValue) {
				anySyncFieldChanged = true;
				break;
			}
		}
		return anySyncFieldChanged;
	}

	private static Boolean isProposalPartialSync(Quote__c ctxQuote, Map<Id, Quote__c> oldQuotes) {
		Id quoteId = ctxQuote.Id;
		Boolean isProposalChanged = isProposalChanged(ctxQuote, oldQuotes);
		return ctxQuote.ProposalId__c != null &&
			!isProposalChanged &&
			anyProposalSyncFieldChanged(ctxQuote, oldQuotes);
	}

	private static Boolean isProposalChanged(Quote__c ctxQuote, Map<Id, Quote__c> oldQuotes) {
		Id quoteId = ctxQuote.Id;
		Object oldValue = oldQuotes?.get(quoteId)?.get(Schema.Quote__c.ProposalId__c);
		Object newValue = ctxQuote.get(Schema.Quote__c.ProposalId__c);

		return oldValue != newValue;
	}

	private static Boolean isProposalFullSync(Quote__c ctxQuote, Map<Id, Quote__c> oldQuotes) {
		Id quoteId = ctxQuote.Id;
		Boolean isUpdate = oldQuotes != null;
		Boolean isInsert = !isUpdate;

		Quote__c oldQuote = ((Quote__c) oldQuotes?.get(ctxQuote.Id));
		DateTime oldSyncTime = oldQuote?.LastProposalSync__c;
		Boolean isNeverSynced = isUpdate && oldSyncTime == null;

		Boolean isProposalChanged = isProposalChanged(ctxQuote, oldQuotes);
		return ctxQuote.ProposalId__c != null && (isInsert || isProposalChanged || isNeverSynced);
	}

	private static Boolean isProposalRollback(Quote__c ctxQuote, Map<Id, Quote__c> oldQuotes) {
		Id quoteId = ctxQuote.Id;
		Boolean isProposalChanged = isProposalChanged(ctxQuote, oldQuotes);
		Quote__c oldQuote = ((Quote__c) oldQuotes?.get(quoteId));
		return isProposalChanged && oldQuote?.ProposalId__c != null;
	}

	public static void fullSyncQuotesToProposal(
		List<Quote__c> quotesToSync,
		Map<Id, Proposal__c> proposals
	) {
		for (Quote__c quote : quotesToSync) {
			Proposal__c proposal = proposals.get(quote.ProposalId__c);
			for (String fieldApiName : PROPOSAL_SYNC_FIELDS) {
				Decimal proposalValue = SystemUtility.nullToZero((Decimal) proposal.get(fieldApiName));
				Decimal syncValue = SystemUtility.nullToZero((Decimal) quote.get(fieldApiName));
				proposal.put(fieldApiName, proposalValue + syncValue);
			}
		}
	}

	public static void rollbackQuoteTotalsFromProposal(
		List<Quote__c> oldQuotes,
		Map<Id, Proposal__c> proposals
	) {
		for (Quote__c quote : oldQuotes) {
			if (quote.ProposalId__c != null) {
				Proposal__c proposal = proposals.get(quote.ProposalId__c);
				for (String fieldApiName : PROPOSAL_SYNC_FIELDS) {
					Decimal proposalValue = SystemUtility.nullToZero((Decimal) proposal.get(fieldApiName));
					Decimal syncValue = SystemUtility.nullToZero((Decimal) quote.get(fieldApiName));
					proposal.put(fieldApiName, proposalValue - syncValue);
				}
			}
		}
	}

	public static void syncQuoteTotalsToProposal(
		List<Quote__c> newQuotes,
		Map<Id, Quote__c> oldQuotes
	) {
		ProvusConfiguratorSetting__mdt provusConfigSetting = ProvusConfiguratorSetting__mdt.getInstance(
			'ProvusDefault'
		);
		if (provusConfigSetting.DisableAutomaticOpportunitySync__c) {
			return;
		}

		Set<Id> proposalIdsForSync = new Set<Id>();
		List<Quote__c> quotesToFullSync = new List<Quote__c>();
		List<Quote__c> quotesToDeltaSync = new List<Quote__c>();
		List<Quote__c> quotesToRolback = new List<Quote__c>();

		Datetime syncTime = Datetime.now();
		for (Quote__c quote : newQuotes) {
			Id quoteId = quote.Id;

			Boolean isFullSync = isProposalFullSync(quote, oldQuotes);
			Boolean isPartialSync = isProposalPartialSync(quote, oldQuotes);
			Boolean isRollback = isProposalRollback(quote, oldQuotes);

			if (isFullSync) {
				quote.LastProposalSync__c = syncTime;
				quotesToFullSync.add(quote);
				proposalIdsForSync.add(quote.ProposalId__c);
			} else if (isPartialSync) {
				quote.LastProposalSync__c = syncTime;
				quotesToDeltaSync.add(quote);
				proposalIdsForSync.add(quote.ProposalId__c);
			}

			if (isRollback) {
				Quote__c oldQuote = (Quote__c) oldQuotes.get(quoteId);
				// if we remove the proposal, we clear out the last sync time
				quote.LastProposalSync__c = quote.ProposalId__c == null ? null : quote.LastProposalSync__c;
				quotesToRolback.add(oldQuote);
			}
		}

		QueryRequest queryRequest = new QueryRequest(Schema.SObjectType.Proposal__c.getName());
		queryRequest.requestedFields = new Set<String>(QuoteSyncService.PROPOSAL_SYNC_FIELDS);
		Map<Id, Proposal__c> proposalsToSyncTo = new Map<Id, Proposal__c>(
			(List<Proposal__c>) SOQLUtility.querySObject(queryRequest)
		);
		deltaSyncQuotesToProposal(quotesToDeltaSync, (Map<Id, Quote__c>) oldQuotes, proposalsToSyncTo);
		fullSyncQuotesToProposal(quotesToFullSync, proposalsToSyncTo);
		rollbackQuoteTotalsFromProposal(quotesToRolback, proposalsToSyncTo);

		CRUDUtility.updateRecords(proposalsToSyncTo.values());
	}
}
