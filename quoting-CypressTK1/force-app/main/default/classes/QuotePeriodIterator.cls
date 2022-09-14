/**
 *  Provus Services Quoting
 *  QuotePeriodIterator
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class QuotePeriodIterator {
	private List<QuotePeriod__c> quotePeriods;
	private Integer startingIndex;
	private Integer currentGroupCount;
	private Integer maxGroupCount;

	public QuotePeriodIterator(
		List<QuotePeriod__c> quotePeriods,
		Integer currentGroupCount,
		Integer maxGroupCount
	) {
		this.quotePeriods = quotePeriods;
		this.startingIndex = -1;
		this.currentGroupCount = currentGroupCount;
		this.maxGroupCount = maxGroupCount;
	}

	/**
	 * @return true if there is another activity group to be returned
	 */
	public Boolean hasNext() {
		return startingIndex < quotePeriods.size() - 1;
	}

	/**
	 * @return returns next available activity group record if one exists
	 */
	public List<QuotePeriod__c> next() {
		List<QuotePeriod__c> groupPeriods = new List<QuotePeriod__c>();
		while (hasNext() && currentGroupCount < maxGroupCount) {
			startingIndex++;
			groupPeriods.add(quotePeriods[startingIndex]);
			currentGroupCount++;
		}

		currentGroupCount = 0;
		return groupPeriods;
	}
}
