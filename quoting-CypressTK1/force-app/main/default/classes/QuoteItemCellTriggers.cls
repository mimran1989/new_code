/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class QuoteItemCellTriggers extends TriggerHandler {
	public static void processTrigger(
		Map<Id, QuoteItemCell__c> oldMap,
		List<QuoteItemCell__c> newObjs,
		Boolean isBefore
	) {
		final QuoteItemCellTriggers myTrigger = new QuoteItemCellTriggers(oldMap, newObjs, isBefore);
		myTrigger.updateDatesForSections();
	}

	public QuoteItemCellTriggers(
		Map<Id, QuoteItemCell__c> oldMap,
		List<QuoteItemCell__c> newObjs,
		Boolean isBefore
	) {
		super(oldMap, newObjs, isBefore);
	}

	private void updateDatesForSections() {
		if (isDelete) {
			return;
		}

		List<Id> cellQuoteItemIds = new List<Id>();
		for (QuoteItemCell__c quoteItemCell : (List<QuoteItemCell__c>) newObjs) {
			cellQuoteItemIds.add(quoteItemCell.QuoteItemId__c);
		}

		// the sections referred to by the changed quote item cells
		List<QuoteSection__c> contextSections = [
			SELECT
				Id,
				QuoteId__c,
				StartDate__c,
				EndDate__c,
				(SELECT Id, StartDate__c, EndDate__c FROM QuoteItems__r)
			FROM QuoteSection__c
			WHERE Id IN (SELECT QuoteSectionId__c FROM QuoteItem__c WHERE Id IN :cellQuoteItemIds)
			WITH SECURITY_ENFORCED
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		];

		// skip processing when working on a quote without sections
		if (SystemUtility.nullOrEmpty(contextSections)) {
			updateQuoteItemDates(cellQuoteItemIds);
			return;
		}

		List<Id> sectionQuoteItemIds = gatherQuoteItemIds(contextSections);
		List<QuoteItemCell__c> cells = QuoteItemCellService.getQuoteItemCellsByQuoteItemIds(
			new Set<Id>(sectionQuoteItemIds)
		);

		List<QuotePeriod> periods = QuotePeriodService.getQuotePeriods(contextSections[0].QuoteId__c);
		Map<Id, QuoteItemCell__c> cellsByQuoteItemId = new Map<Id, QuoteItemCell__c>();

		if (!SystemUtility.nullOrEmpty(cells)) {
			cellsByQuoteItemId = (Map<Id, QuoteItemCell__c>) SystemUtility.keyByIdType(
				cells,
				Schema.QuoteItemCell__c.QuoteItemId__c
			);
		}

		for (QuoteItemCell__c nextCell : (List<QuoteItemCell__c>) newObjs) {
			cellsByQuoteItemId.put(nextCell.QuoteItemId__c, nextCell);
		}

		List<QuoteItem__c> quoteItems = new List<QuoteItem__c>();
		for (QuoteSection__c nextSection : contextSections) {
			if (!SystemUtility.nullOrEmpty(nextSection.QuoteItems__r)) {
				updateDatesForSection(nextSection, cellsByQuoteItemId, periods);
				quoteItems.addAll(nextSection.QuoteItems__r);
			}
		}

		CRUDUtility.updateRecords(contextSections);
		CRUDUtility.updateRecords(quoteItems);
	}

	private class CellRange {
		public Integer min;
		public Integer max;

		public CellRange(Integer min, Integer max) {
			this.min = min;
			this.max = max;
		}
	}

	private void updateQuoteItemDates(List<Id> cellQuoteItemIds) {
		List<QuoteItem__c> quoteItems = [
			SELECT Id, StartDate__c, EndDate__c, QuoteId__c
			FROM QuoteItem__c
			WHERE Id IN :cellQuoteItemIds
			WITH SECURITY_ENFORCED
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		];

		Map<Id, List<QuoteItem__c>> quoteItemByQuoteId = QuoteItemService.getQuoteItemsByQuoteId(
			quoteItems
		);

		List<QuoteItemCell__c> cells = QuoteItemCellService.getQuoteItemCellsByQuoteItemIds(
			new Set<Id>(cellQuoteItemIds)
		);

		Map<Id, QuoteItemCell__c> cellsByQuoteItemId = new Map<Id, QuoteItemCell__c>();
		if (!SystemUtility.nullOrEmpty(cells)) {
			cellsByQuoteItemId = (Map<Id, QuoteItemCell__c>) SystemUtility.keyByIdType(
				cells,
				Schema.QuoteItemCell__c.QuoteItemId__c
			);
		}

		for (QuoteItemCell__c nextCell : (List<QuoteItemCell__c>) newObjs) {
			cellsByQuoteItemId.put(nextCell.QuoteItemId__c, nextCell);
		}

		List<QuoteItem__c> updatedItems = new List<QuoteItem__c>();
		for (Id key : quoteItemByQuoteId.keySet()) {
			List<QuotePeriod> periods = QuotePeriodService.getQuotePeriods(key);

			for (QuoteItem__c nextItem : (List<QuoteItem__c>) quoteItemByQuoteId.get(key)) {
				QuoteItemCell__c cellsForItem = cellsByQuoteItemId.get(nextItem.Id);
				CellRange range = processItemCells(periods, cellsForItem);
				if (calculateQuoteItemDates(nextItem, periods, range)) {
					updatedItems.add(nextItem);
				}
			}
		}
		CRUDUtility.updateRecords(updatedItems);
	}

	private Boolean updateDatesForSection(
		QuoteSection__c section,
		Map<Id, QuoteItemCell__c> cellsByQuoteItemId,
		List<QuotePeriod> periods
	) {
		Integer minIndex;
		Integer maxIndex;
		for (QuoteItem__c nextItem : section.QuoteItems__r) {
			QuoteItemCell__c cellsForItem = cellsByQuoteItemId.get(nextItem.Id);
			CellRange range = processItemCells(periods, cellsForItem);

			if (minIndex == null) {
				minIndex = range.min;
				maxIndex = range.max;
			}

			if (range.min < minIndex) {
				minIndex = range.min;
			}

			if (range.max > maxIndex) {
				maxIndex = range.max;
			}

			calculateQuoteItemDates(nextItem, periods, range);
		}

		Boolean isUpdated = false;
		isUpdated = calculateSectionStart(section, periods, minIndex) || isUpdated;
		isUpdated = calculateSectionEnd(section, periods, maxIndex) || isUpdated;

		return isUpdated;
	}

	private CellRange processItemCells(List<QuotePeriod> periods, QuoteItemCell__c cellsForItem) {
		Integer minIndex;
		Integer maxIndex;

		for (Integer i = 0; i < periods.size(); i++) {
			String cellField = QuoteItemCellService.cellColumnName(i + 1);
			if (cellsForItem.get(cellField) != null) {
				minIndex = (minIndex == null || i < minIndex) ? i : minIndex;
				maxIndex = (maxIndex == null || i > maxIndex) ? i : maxIndex;
			}
		}

		return new CellRange(minIndex, maxIndex);
	}

	private Boolean calculateSectionStart(
		QuoteSection__c section,
		List<QuotePeriod> periods,
		Integer minIndex
	) {
		Date oldValue = section.StartDate__c;
		section.StartDate__c = null; // clear out field if there are no cell values
		if (minIndex != null) {
			section.StartDate__c = periods[minIndex].startDate;
		}

		return oldValue == section.StartDate__c;
	}

	private Boolean calculateSectionEnd(
		QuoteSection__c section,
		List<QuotePeriod> periods,
		Integer maxIndex
	) {
		Date oldValue = section.EndDate__c;
		section.EndDate__c = null; // clear out field if there are no cell values
		if (maxIndex != null) {
			section.EndDate__c = periods[maxIndex].endDate;
		}

		return oldValue == section.EndDate__c;
	}

	private Boolean calculateQuoteItemDates(
		QuoteItem__c item,
		List<QuotePeriod> periods,
		CellRange range
	) {
		Date oldStartValue = item.StartDate__c;
		item.StartDate__c = null; // clear out field if there are no cell values
		if (range.min != null) {
			item.StartDate__c = periods[range.min].startDate;
		}

		Date oldEndValue = item.EndDate__c;
		item.EndDate__c = null; // clear out field if there are no cell values
		if (range.max != null) {
			item.EndDate__c = periods[range.max].endDate;
		}

		return oldStartValue != item.StartDate__c || oldEndValue != item.EndDate__c;
	}

	private List<Id> gatherQuoteItemIds(List<QuoteSection__c> sections) {
		List<Id> quoteItemIds = new List<Id>();
		for (QuoteSection__c nextSection : sections) {
			if (!SystemUtility.nullOrEmpty(nextSection.QuoteItems__r)) {
				for (QuoteItem__c nextItem : nextSection.QuoteItems__r) {
					quoteItemIds.add(nextItem.Id);
				}
			}
		}

		return quoteItemIds;
	}
}
