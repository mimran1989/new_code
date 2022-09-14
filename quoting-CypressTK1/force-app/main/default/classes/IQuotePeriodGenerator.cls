/**
 *  Provus Services Quoting
 *  IQuotePeriodGenerator
 *  @2022 Provus Inc. All rights reserved.
 */
public interface IQuotePeriodGenerator {
	List<QuotePeriod__c> newPeriods();
	List<QuotePeriod__c> newPeriods(Integer numberOfPeriodsToCreate);
}
