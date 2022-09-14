/**
 *  Provus Services Quoting
 *  QuoteTotalsService
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class QuoteTotalsService {
	/**
	 * Create and insert summary total records for the quote
	 * Note: This code will insert empty totals ($ 0). Hence
	 *
	 * @param quoteIds the quote id to perform the operation on
	 */
	public static void createQuoteLevelTotalsFor(List<Id> quoteIds) {
		Map<Id, List<NamedRangeTotal__c>> namedRangeTotalsByQuoteId = new Map<Id, List<NamedRangeTotal__c>>();
		List<NamedRangeTotal__c> namedRangeTotalsToInsert = new List<NamedRangeTotal__c>();
		for (Id quoteId : quoteIds) {
			NamedRangeTotal__c quoteLaborTotal = new NamedRangeTotal__c(QuoteId__c = quoteId);
			NamedRangeTotal__c quoteAddOnsTotal = new NamedRangeTotal__c(QuoteId__c = quoteId);
			NamedRangeTotal__c quoteTotal = new NamedRangeTotal__c(QuoteId__c = quoteId);

			List<NamedRangeTotal__c> namedRangeTotalsForQuote = new List<NamedRangeTotal__c>{
				quoteLaborTotal,
				quoteAddOnsTotal,
				quoteTotal
			};

			namedRangeTotalsByQuoteId.put(quoteId, namedRangeTotalsForQuote);
			namedRangeTotalsToInsert.addAll(namedRangeTotalsForQuote);
		}

		CRUDUtility.insertRecords(namedRangeTotalsToInsert);

		List<NamedRange__c> namedRangesToInsert = new List<NamedRange__c>();
		for (Id quoteId : quoteIds) {
			// the order of these named ranges is implied by the loop above
			List<NamedRangeTotal__c> namedRangeTotalsForQuote = namedRangeTotalsByQuoteId.get(quoteId);
			NamedRangeTotal__c quoteLaborTotal = namedRangeTotalsForQuote[0];
			NamedRangeTotal__c quoteAddOnsTotal = namedRangeTotalsForQuote[1];
			NamedRangeTotal__c quoteTotal = namedRangeTotalsForQuote[2];

			NamedRange__c quoteLaborTotalNamedRange = new NamedRange__c(
				QuoteId__c = quoteId,
				NamedRangeTotalId__c = quoteLaborTotal.Id,
				Type__c = NamedRange.TYPE_QUOTE_LABOR,
				Name = NamedRange.LABOR_AMOUNT_NAME
			);
			NamedRange__c quoteAddOnsTotalNamedRange = new NamedRange__c(
				QuoteId__c = quoteId,
				NamedRangeTotalId__c = quoteAddOnsTotal.Id,
				Type__c = NamedRange.TYPE_QUOTE_ADDONS,
				Name = NamedRange.ADDON_AMOUNT_NAME
			);
			NamedRange__c quoteTotalNamedRange = new NamedRange__c(
				QuoteId__c = quoteId,
				NamedRangeTotalId__c = quoteTotal.Id,
				Type__c = NamedRange.TYPE_QUOTE,
				Name = NamedRange.QUOTE_TOTALS_NAME
			);

			namedRangesToInsert.addAll(
				new List<NamedRange__c>{
					quoteLaborTotalNamedRange,
					quoteAddOnsTotalNamedRange,
					quoteTotalNamedRange
				}
			);
		}

		CRUDUtility.insertRecords(namedRangesToInsert);
	}
}
