/**
 *  Provus Services Quoting
 *  QuotePeriodBuilder
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class QuotePeriodGroupBuilder {
	private Id quoteId;
	private Date groupStartDate;
	private String timePeriodsGroupMethod;
	private Boolean previousExist;
	private QuotePeriodGroup__c previousGroup;
	private Integer currentGroupPeriodCount = 0;
	private Decimal startingGroupSequence = 1;

	/**
	 * Class which groups list of new quote periods into period groups
	 *
	 * @param quote the quote record
	 * @param quotePeriodState current quote's period state (if quote already has periods existing)
	 */
	public QuotePeriodGroupBuilder(Quote__c quote, QuotePeriodState quotePeriodState) {
		this.timePeriodsGroupMethod = quote.TimePeriodsGroupMethod__c;
		this.quoteId = quote.Id;
		this.previousExist = quotePeriodState.previousExist;
		this.previousGroup = quotePeriodState.previousGroup;
		this.groupStartDate = quote.ServiceStartDate__c;

		if (this.previousExist) {
			this.startingGroupSequence = quotePeriodState.previousGroup.Sequence__c;
			this.currentGroupPeriodCount = quotePeriodState.lastGroupCount;
			this.groupStartDate = quote.ServiceEndDate__c.addDays(1);
		}
	}

	/**
	 * Builds quote period groups given set of new periods and group size boundary
	 *
	 * @param newPeriods new periods to add
	 * @param groupSize group size upper boundary
	 *
	 * @return map containing period groups and periods for commit
	 */
	public Map<QuotePeriodGroup__c, List<QuotePeriod__c>> buildQuotePeriodGroups(
		List<QuotePeriod__c> newPeriods,
		Integer groupSize
	) {
		if (newPeriods.isEmpty()) {
			return new Map<QuotePeriodGroup__c, List<QuotePeriod__c>>();
		}

		Map<QuotePeriodGroup__c, List<QuotePeriod__c>> periodsByGroup = new Map<QuotePeriodGroup__c, List<QuotePeriod__c>>();
		QuotePeriodIterator periodIterator = new QuotePeriodIterator(
			newPeriods,
			currentGroupPeriodCount,
			groupSize
		);

		Decimal groupSequence = startingGroupSequence;
		QuotePeriodGroup__c periodGroup;

		while (periodIterator.hasNext()) {
			List<QuotePeriod__c> periodsForGroup = periodIterator.next();

			if (previousExist && previousGroup != null) {
				periodGroup = previousGroup;
				previousExist = false;
			} else {
				periodGroup = new QuotePeriodGroup__c(
					Name = timePeriodsGroupMethod + ' ' + groupSequence,
					QuoteId__c = quoteId,
					Sequence__c = groupSequence,
					StartDate__c = groupStartDate
				);
			}

			Integer periodsForGroupCount = periodsForGroup.size();
			if (periodsForGroupCount > 0) {
				QuotePeriod__c lastQuotePeriod = periodsForGroup[periodsForGroupCount - 1];
				periodGroup.EndDate__c = lastQuotePeriod.EndDate__c;
				periodsByGroup.put(periodGroup, periodsForGroup);
				groupStartDate = lastQuotePeriod.EndDate__c.addDays(1);
			}

			groupSequence += 1;
		}

		return periodsByGroup;
	}
}
