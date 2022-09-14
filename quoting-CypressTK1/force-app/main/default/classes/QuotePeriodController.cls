/**
 *  Provus Services Quoting
 *  QuotePeriodController
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class QuotePeriodController {
	@InvocableMethod(
		Label='Add Periods to Quote'
		Description='Adds periods to the end of the specified quote'
	)
	public static void addPeriodsToQuote(List<QuoteAddPeriodsArgs> quoteAddPeriodsArgs) {
		for (QuoteAddPeriodsArgs quoteAddPeriodDetail : quoteAddPeriodsArgs) {
			QuotePeriodService.addRemoveQuotePeriods(
				quoteAddPeriodDetail.numberOfPeriodsToAdd,
				quoteAddPeriodDetail.quoteId,
				quoteAddPeriodDetail.timePeriod
			);
		}
	}
}
