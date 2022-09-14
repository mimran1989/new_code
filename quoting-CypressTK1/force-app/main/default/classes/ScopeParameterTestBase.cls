/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
@IsTest
public class ScopeParameterTestBase {
	public static ScopeParameter__c newIntegerScopeParameter(Id estimateId) {
		ScopeParameter__c scopeParameterSo = new ScopeParameter__c(
			EstimateId__c = estimateId,
			DataType__c = ScopeParameterService.DATATYPE_INTEGER
		);
		CRUDUtility.insertRecords(scopeParameterSo);
		return scopeParameterSo;
	}
}
