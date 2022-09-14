/**
 *  Provus Services Quoting
 *  QuotePeriodState
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class QuotePeriodState {
	/**
	 * total count of periods in quote
	 */
	public Integer totalCount = 0;
	/**
	 * number of periods in last period group if any
	 */
	public Integer lastGroupCount = 0;
	/**
	 * last quote period group record
	 */
	public QuotePeriodGroup__c previousGroup;
	/**
	 * Period groups and periods exist
	 */
	public Boolean previousExist = false;
}
