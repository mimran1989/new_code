/**
 *  Provus Services Quoting
 *  QuotePeriodGenerator
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class QuotePeriodGenerator implements IQuotePeriodGenerator {
	private Integer totalPeriodCount = 0;
	private ITimePeriod timePeriodCalc;
	private Date serviceStartDate;
	private Date periodStartDate;
	private Date periodEndDate;
	private Id quoteId;
	private QuotePeriodState quotePeriodState;

	public QuotePeriodGenerator(
		ITimePeriod timePeriodCalc,
		Quote__c quote,
		QuotePeriodState quotePeriodState
	) {
		this.timePeriodCalc = timePeriodCalc;
		this.quoteId = quote.Id;
		this.serviceStartDate = quote.ServiceStartDate__c;
		this.periodStartDate = quote.ServiceStartDate__c;
		this.periodEndDate = quote.ServiceEndDate__c;
		if (quotePeriodState.previousExist) {
			this.periodStartDate = periodStartDate = timePeriodCalc.nextStartDate(
				serviceStartDate,
				periodEndDate,
				quotePeriodState.totalCount
			);
			this.totalPeriodCount = quotePeriodState.totalCount;
		}
		this.quotePeriodState = quotePeriodState;
	}

	public List<QuotePeriod__c> newPeriods() {
		Integer numberOfPeriodsToCreate = timePeriodCalc.numberOfPeriods(
			serviceStartDate,
			periodEndDate
		);
		return newPeriods(Math.min(QuotePeriodService.MAX_PERIOD_COUNT, numberOfPeriodsToCreate));
	}

	public List<QuotePeriod__c> newPeriods(Integer numberOfPeriodsToCreate) {
		List<QuotePeriod__c> newPeriods = new List<QuotePeriod__c>();

		for (Integer i = 0; i < numberOfPeriodsToCreate; i++) {
			Integer periodSequence = i + totalPeriodCount + 1;

			periodEndDate = timePeriodCalc.calculatePeriodEndDate(
				serviceStartDate,
				periodStartDate,
				periodSequence
			);

			QuotePeriod__c period = new QuotePeriod__c(
				Name = timePeriodCalc.generatePeriodName(periodStartDate, periodEndDate, periodSequence),
				Sequence__c = periodSequence,
				StartDate__c = periodStartDate,
				QuoteId__c = quoteId,
				EndDate__c = periodEndDate,
				Term__c = 1
			);

			newPeriods.add(period);
			periodStartDate = timePeriodCalc.nextStartDate(
				serviceStartDate,
				periodEndDate,
				periodSequence
			);
		}

		return newPeriods;
	}
}
