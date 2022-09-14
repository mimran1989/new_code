/**
 *  Provus Services Quoting
 *  QuotePeriodRangeArgs
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class QuotePeriodRangeArgs {
	public Date serviceStartDate { get; set; }
	public Date serviceEndDate { get; set; }
	public String timePeriod { get; set; }
	public String timePeriodsGroupMethod { get; set; }

	/**
	 * Build quote period range args from an existing quote object
	 *
	 * @param quoteSO quote object
	 */
	public QuotePeriodRangeArgs(Quote__c quoteSO) {
		this(quoteSO, false);
	}

	public QuotePeriodRangeArgs(Quote__c quoteSO, Boolean hasExistingPeriods) {
		if (hasExistingPeriods) {
			this.serviceStartDate = quoteSO.ServiceEndDate__c.addDays(1);
		} else {
			this.serviceStartDate = quoteSO.ServiceStartDate__c;
			this.serviceEndDate = quoteSO.ServiceEndDate__c;
		}
		this.timePeriod = quoteSO.TimePeriod__c;
		this.timePeriodsGroupMethod = quoteSO.TimePeriodsGroupMethod__c;
	}
}
