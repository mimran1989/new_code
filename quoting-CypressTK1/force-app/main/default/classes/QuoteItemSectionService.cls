/**
 *  Provus Services Quoting
 *  QuoteItemCellOperations
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class QuoteItemSectionService {
	/**
	 * Given a section if will shift quote item cell values left/right depending on shiftFactor value
	 *
	 * @param sectionId id of quote section
	 * @param shiftFactor positive/negative shift factor value
	 *
	 * @return returns list of shifted quote item cell records
	 */
	public static List<QuoteItemCell__c> shiftQuoteItemSection(Id sectionId, Integer shiftFactor) {
		if (shiftFactor == 0) {
			return new List<QuoteItemCell__c>();
		}
		List<QuoteItem__c> quoteItems = [
			SELECT Id
			FROM QuoteItem__c
			WHERE QuoteSectionId__c = :sectionId
			WITH SECURITY_ENFORCED
		];

		// get set of quote item Ids
		Set<Id> quoteItemIds = (new Map<Id, QuoteItem__c>(quoteItems)).keySet();
		List<QuoteItemCell__c> quoteItemCells = QuoteItemCellService.getQuoteItemCellsByQuoteItemIds(
			quoteItemIds
		);
		Boolean shiftDirectionLeft = shiftFactor < 0;
		Integer positiveShiftFactor = (shiftDirectionLeft ? (-1 * shiftFactor) : shiftFactor);
		Integer startPos = positiveShiftFactor + 1;

		for (QuoteItemCell__c quoteItemCell : quoteItemCells) {
			for (Integer i = startPos; i < QuotePeriodService.MAX_PERIOD_COUNT; i++) {
				Integer cellNumber = shiftDirectionLeft ? i : QuotePeriodService.MAX_PERIOD_COUNT - i;
				String shiftFromColName = QuoteItemCellService.cellColumnName(cellNumber);
				String shiftToColName = QuoteItemCellService.cellColumnName(cellNumber + shiftFactor);
				Decimal fromValue = (Decimal) quoteItemCell.get(shiftFromColName);
				// empty previous cell
				quoteItemCell.put(shiftFromColName, null);
				// set previous value to next cell
				quoteItemCell.put(shiftToColName, fromValue);
			}
		}

		return quoteItemCells;
	}
}
