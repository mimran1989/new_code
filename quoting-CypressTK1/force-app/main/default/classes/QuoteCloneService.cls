/**
 *  Provus Services Quoting
 *  QuoteCloneService : This is controller for QuoteCloneService lwc component.
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class QuoteCloneService {
	@AuraEnabled
	public static Id cloneQuote(String quoteId, String quoteName) {
		Quote__c newQuote = cloneQuote(quoteId, null, quoteName);
		return newQuote.Id;
	}

	public static Quote__c cloneQuote(
		Id sourceQuoteId,
		Set<Id> quoteSectionIds,
		String newQuoteName
	) {
		SObjectType quoteType = Schema.Quote__c.SObjectType;
		QueryRequest queryRequest = new QueryRequest(quoteType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(quoteType);
		queryRequest.setFilterBy(new Map<String, String>{ SObjectUtility.FIELD_ID => sourceQuoteId });
		List<Quote__c> sourceQuotes = (List<Quote__c>) SOQLUtility.querySObject(queryRequest);
		Quote__c clonedQuote;
		if (sourceQuotes.size() > 0) {
			Quote__c sourceQuote = sourceQuotes[0];
			clonedQuote = sourceQuote.clone(false, true);
			clonedQuote.DerivedFromId__c = sourceQuote.Id;
			clonedQuote.EstimateId__c = null;
			clonedQuote.TemplateId__c = null;
			clonedQuote.ServiceId__c = sourceQuote.ServiceId__c;
			if (newQuoteName != null) {
				clonedQuote.Name = newQuoteName;
			}
			CRUDUtility.insertRecords(clonedQuote);
			if (sourceQuote.EstimateId__c != null) {
				clonedQuote.EstimateId__c = EstimateCloner.cloneEstimateToQuote(
					sourceQuote.EstimateId__c,
					null,
					clonedQuote.Id
				);
			}
			QuoteCloneService.copyQuoteChildEntities(sourceQuote.Id, clonedQuote.Id, quoteSectionIds);
			QuoteCloneService.cloneMilestones(sourceQuote.Id, clonedQuote.Id);
		}

		return clonedQuote;
	}

	public static Quote__c cloneQuote(Id sourceQuoteId, Set<Id> quoteSectionIds) {
		return cloneQuote(sourceQuoteId, quoteSectionIds, null);
	}
	public static Quote__c cloneQuote(Id sourceQuoteId) {
		return cloneQuote(sourceQuoteId, null, null);
	}

	private static Map<Id, Map<Id, SObject>> copyNamedRangeTotals(
		Map<Id, Set<Id>> oldQuoteToNewQuotes,
		Map<Id, Id> newItemIdBySourceItemId
	) {
		List<NamedRangeTotal__c> namedRangeTotals = [
			SELECT
				Id,
				Name,
				QuoteId__c,
				BaseExtendedAmount__c,
				MarginPercent__c,
				NamedRangeId__c,
				NetExtendedAmount__c,
				NetExtendedCost__c,
				QuantityUOM__c,
				Quantity__c,
				BaseExtendedCost__c,
				AdjustedBaseAmount__c
			FROM NamedRangeTotal__c
			WHERE
				Id IN (
					SELECT NamedRangeTotalId__c
					FROM NamedRange__c
					WHERE
						(Type__c = 'Quote'
						OR Type__c = 'Quote Labor'
						OR Type__c = 'Quote Ancillaries')
						AND QuoteId__c IN :oldQuoteToNewQuotes.keySet()
				)
			WITH SECURITY_ENFORCED
		];

		Map<Id, Map<Id, SObject>> namedRangeTotalsById = SystemUtility.cloneChildEntities(
			namedRangeTotals,
			NamedRangeTotal.FIELD_NAME_QUOTE_ID,
			oldQuoteToNewQuotes
		);

		List<NamedRangeTotal__c> namedRangeTotalsToInsert = getNamedRangeTotalsToInsert(
			namedRangeTotalsById
		);
		CRUDUtility.insertRecords(namedRangeTotalsToInsert);

		List<NamedRange__c> namedRangesToInsert = copyNamedRanges(
			oldQuoteToNewQuotes,
			namedRangeTotalsById,
			newItemIdBySourceItemId
		);
		CRUDUtility.insertRecords(namedRangesToInsert);

		return namedRangeTotalsById;
	}

	private static List<NamedRange__c> copyNamedRanges(
		Map<Id, Set<Id>> oldQuoteToNewQuotes,
		Map<Id, Map<Id, SObject>> namedRangeTotals,
		Map<Id, Id> newItemIdBySourceItemId
	) {
		List<NamedRange__c> namedRangesToInsert = new List<NamedRange__c>();
		List<NamedRange__c> namedRanges = [
			SELECT
				Id,
				Name,
				QuoteId__c,
				NamedRangeTotalId__c,
				ProjectPhaseId__c,
				QuoteItemId__c,
				QuotePeriodGroupId__c,
				QuotePeriodId__c,
				QuoteSectionId__c,
				RangeSpecJSON__c,
				Type__c
			FROM NamedRange__c
			WHERE
				(Type__c = 'Quote'
				OR Type__c = 'Quote Labor'
				OR Type__c = 'Quote Ancillaries')
				AND QuoteId__c IN :oldQuoteToNewQuotes.keySet()
			WITH SECURITY_ENFORCED
		];
		Map<Id, Map<Id, SObject>> namedRangesById = SystemUtility.cloneChildEntities(
			namedRanges,
			Schema.NamedRange__c.QuoteId__c + '',
			oldQuoteToNewQuotes
		);

		if (namedRangesById.size() > 0) {
			for (Id oldParentId : namedRangesById.keySet()) {
				for (Id oldNamedRangeId : namedRangesById.get(oldParentId).keySet()) {
					NamedRange__c namedRange = (NamedRange__c) namedRangesById.get(oldParentId)
						.get(oldNamedRangeId);
					NamedRangeTotal__c namedRangeTotal = (NamedRangeTotal__c) namedRangeTotals.get(
							oldParentId
						)
						.get(namedRange.NamedRangeTotalId__c);

					namedRange.QuoteItemId__c = newItemIdBySourceItemId.get(namedRange.QuoteItemId__c);
					namedRange.NamedRangeTotalId__c = namedRangeTotal.Id;
					namedRangesToInsert.add(namedRange);
				}
			}
		}
		return namedRangesToInsert;
	}

	public static void copyQuoteChildEntities(Id fromQuote, Id toQuote, Set<Id> quoteSectionIds) {
		copyQuoteChildEntities(
			new Map<Id, Set<Id>>{ fromQuote => new Set<Id>{ toQuote } },
			quoteSectionIds
		);
	}

	//Adding milestone to cloned quote
	public static void cloneMilestones(Id sourceQuoteId, Id clonedQuoteId) {
		List<ProjectMilestone__c> cloneMilestones = new List<ProjectMilestone__c>();
		QueryRequest projectMilestoneQueryRequest = new QueryRequest(
			Schema.ProjectMilestone__c.SObjectType
		);
		projectMilestoneQueryRequest.requestedFields = SObjectUtility.getFieldsForSObject(
			Schema.ProjectMilestone__c.SObjectType
		);
		projectMilestoneQueryRequest.setFilterBy(
			new Map<String, String>{ Schema.ProjectMilestone__c.QuoteId__c + '' => sourceQuoteId }
		);
		for (
			ProjectMilestone__c milestone : (List<ProjectMilestone__c>) SOQLUtility.querySObject(
				projectMilestoneQueryRequest
			)
		) {
			ProjectMilestone__c milestoneClone = milestone.clone(false, true);
			milestoneClone.QuoteId__c = clonedQuoteId;
			cloneMilestones.add(milestoneClone);
		}

		if (cloneMilestones.size() > 0) {
			CRUDUtility.insertRecords(cloneMilestones);
		}
	}

	public static void copyQuoteChildEntities(
		Map<Id, Set<Id>> oldQuoteToNewQuotes,
		Set<Id> quoteSectionIds
	) {
		Map<Id, Map<Id, SObject>> mapQuoteSectionSO = copyQuoteSections(
			oldQuoteToNewQuotes,
			quoteSectionIds
		);

		Map<Id, Map<Id, SObject>> mapQuoteItemSO = copyQuoteItems(
			oldQuoteToNewQuotes,
			mapQuoteSectionSO,
			quoteSectionIds
		);

		Map<Id, Id> newItemIdBySourceItemId = new Map<Id, Id>();
		for (Map<Id, SObject> itemBySourceId : mapQuoteItemSO.values()) {
			for (Id sourceId : itemBySourceId.keySet()) {
				newItemIdBySourceItemId.put(sourceId, itemBySourceId.get(sourceId).Id);
			}
		}
		copyNamedRangeTotals(oldQuoteToNewQuotes, newItemIdBySourceItemId);

		AdjustmentService.AdjustmentCloneInfo adjCloneInfo = new AdjustmentService.AdjustmentCloneInfo(
			mapQuoteItemSO
		);
		Map<Id, Adjustment__c> adjustmentsToInsert = AdjustmentService.getAdjustmentsToInsert(
			adjCloneInfo
		);
		CRUDUtility.insertRecords(adjustmentsToInsert.values());

		AdjustmentService.updateAdjustmentIdOnQuoteItems(adjustmentsToInsert);
		List<QuoteItemCell__c> quoteItemCellsToInsert = AdjustmentService.getQuoteItemCellsToInsert(
			adjCloneInfo
		);
		CRUDUtility.insertRecords(quoteItemCellsToInsert);
	}

	private static Map<Id, Map<Id, SObject>> copyQuoteSections(
		Map<Id, Set<Id>> oldQuoteToNewQuotes,
		Set<Id> quoteSectionIds
	) {
		// TODO: Define a Setting for all applicable objects
		// STEP I - Clone the quote sections from the template to the new quote
		Map<Id, Map<Id, SObject>> newQuoteSections = SystemUtility.cloneChildEntities(
			Schema.QuoteSection__c.SObjectType,
			QuoteSectionService.RELATED_QUOTE_ID,
			oldQuoteToNewQuotes
		);

		List<QuoteSection__c> quoteSectionsToInsert = getQuoteSectionsToInsert(
			newQuoteSections,
			quoteSectionIds
		);

		CRUDUtility.insertRecords(quoteSectionsToInsert);

		return newQuoteSections;
	}

	private static List<QuoteSection__c> getQuoteSectionsToInsert(
		Map<Id, Map<Id, SObject>> newQuoteSections,
		Set<Id> quoteSectionIds
	) {
		List<QuoteSection__c> quoteSectionsToInsert = new List<QuoteSection__c>();
		for (Id targetQuoteId : newQuoteSections.keySet()) {
			for (Id sourceSectionId : newQuoteSections.get(targetQuoteId).keySet()) {
				QuoteSection__c targetSection = (QuoteSection__c) newQuoteSections.get(targetQuoteId)
					.get(sourceSectionId);
				targetSection.DerivedFromId__c = sourceSectionId;

				if (quoteSectionIds != null) {
					if (quoteSectionIds.contains(sourceSectionId)) {
						quoteSectionsToInsert.add(targetSection);
					}
				} else {
					quoteSectionsToInsert.add(targetSection);
				}
			}
		}
		return quoteSectionsToInsert;
	}

	private static Map<Id, Map<Id, SObject>> copyQuoteItems(
		Map<Id, Set<Id>> oldQuoteToNewQuotes,
		Map<Id, Map<Id, SObject>> mapQuoteSectionSO,
		Set<Id> quoteSectionIds
	) {
		Map<String, Set<Id>> filterSetByFieldName = new Map<String, Set<Id>>{
			Schema.QuoteItem__c.QuoteId__c + '' => oldQuoteToNewQuotes.keySet()
		};

		if (quoteSectionIds != null && !quoteSectionIds.isEmpty()) {
			filterSetByFieldName.put(Schema.QuoteItem__c.QuoteSectionId__c + '', quoteSectionIds);
		}

		QueryRequest queryRequest = new QueryRequest(QuoteItem__c.SObjectType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(QuoteItem__c.SObjectType);
		queryRequest.setFilterBy(filterSetByFieldName);

		// STEP II - Clone the quote line items
		Map<Id, Map<Id, SObject>> newQuoteItems = SystemUtility.cloneChildEntities(
			SOQLUtility.querySObject(queryRequest),
			Schema.QuoteItem__c.QuoteId__c + '',
			oldQuoteToNewQuotes
		);

		for (Map<Id, SObject> clonedItemBySourceId : newQuoteItems.values()) {
			for (Id sourceId : clonedItemBySourceId.keySet()) {
				QuoteItem__c clonedItem = (QuoteItem__c) clonedItemBySourceId.get(sourceId);
				clonedItem.DerivedFromId__c = sourceId;
			}
		}

		List<QuoteItem__c> quoteItemsToInsert = getQuoteItemsToInsert(newQuoteItems, mapQuoteSectionSO);
		CRUDUtility.insertRecords(quoteItemsToInsert);

		return newQuoteItems;
	}

	private static List<NamedRangeTotal__c> getNamedRangeTotalsToInsert(
		Map<Id, Map<Id, SObject>> namedRangeTotals
	) {
		List<NamedRangeTotal__c> namedRangeTotalsToInsert = new List<NamedRangeTotal__c>();
		for (Map<Id, SObject> namedRangeTotalsByOldId : namedRangeTotals.values()) {
			namedRangeTotalsToInsert.addAll((List<NamedRangeTotal__c>) namedRangeTotalsByOldId.values());
		}
		return namedRangeTotalsToInsert;
	}

	private static List<QuoteItem__c> getQuoteItemsToInsert(
		Map<Id, Map<Id, SObject>> newQuoteItems,
		Map<Id, Map<Id, SObject>> newQuoteSections
	) {
		// STEP III - Update the quote section id
		Map<Id, Id> newSectionIdBySourceId = new Map<Id, Id>();
		for (Map<Id, SObject> quoteSectionsById : newQuoteSections.values()) {
			for (SObject sectionSO : quoteSectionsById.values()) {
				newSectionIdBySourceId.put(((QuoteSection__c) sectionSO).DerivedFromId__c, sectionSO.Id);
			}
		}
		List<QuoteItem__c> quoteItemsToInsert = new List<QuoteItem__c>();
		for (Map<Id, SObject> quoteItemsByOldId : newQuoteItems.values()) {
			for (Id oldItemId : quoteItemsByOldId.keySet()) {
				QuoteItem__c quoteItem = (QuoteItem__c) quoteItemsByOldId.get(oldItemId);
				quoteItem.QuoteSectionId__c = newSectionIdBySourceId.get(quoteItem.QuoteSectionId__c);
				quoteItemsToInsert.add(quoteItem);
			}
		}
		return quoteItemsToInsert;
	}
}
