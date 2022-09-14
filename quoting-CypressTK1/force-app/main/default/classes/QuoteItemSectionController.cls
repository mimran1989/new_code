/**
 *  Provus Services Quoting
 *  QuoteItemSectionController
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class QuoteItemSectionController {
	/**
	 * Shift quote item cell values left/right based on shift factor value and persist to SF database
	 *
	 * @param sectionId section id
	 * @param shiftFactor positive or negative shift factor
	 *
	 * @return returns list of shifted quote item cells
	 */
	@AuraEnabled
	public static Map<Id, Map<String, Decimal>> shiftQuoteItemSection(
		Id sectionId,
		Integer shiftFactor
	) {
		List<QuoteItemCell__c> quoteItemCellRecords = QuoteItemSectionService.shiftQuoteItemSection(
			sectionId,
			shiftFactor
		);

		CRUDUtility.upsertRecords(quoteItemCellRecords);

		return QuoteItemCellService.convertToPeriodValueMaps(quoteItemCellRecords);
	}
}
