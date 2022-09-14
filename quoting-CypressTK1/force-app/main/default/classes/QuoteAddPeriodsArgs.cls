/**
 *  Provus Services Quoting
 *  QuoteAddPeriodsArgs
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class QuoteAddPeriodsArgs {
	@InvocableVariable(Label='Quote Id' Description='Quote record id' Required=true)
	public Id quoteId;

	@InvocableVariable(
		Label='Time Period Type'
		Description='Time period type used to determine duration in hours of specified number of periods'
		Required=true
	)
	public String timePeriod;

	@InvocableVariable(
		Label='Number of Periods'
		Description='Number of periods to add to quote'
		Required=true
	)
	public Decimal numberOfPeriodsToAdd;
}
