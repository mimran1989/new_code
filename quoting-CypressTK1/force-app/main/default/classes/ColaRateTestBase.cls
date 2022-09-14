/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
@IsTest
public with sharing class ColaRateTestBase extends TestBase {
	public static ColaRate__c newColaRate(Id rateSheetId) {
		ColaRate__c rate = new ColaRate__c(
			RateSheetId__c = rateSheetId,
			ServiceYear__c = Date.today().year(),
			YearOverYearRate__c = 1
		);
		CRUDUtility.insertRecords(rate);
		return rate;
	}
}
