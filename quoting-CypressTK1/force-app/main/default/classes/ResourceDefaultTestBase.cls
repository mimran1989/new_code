/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

@IsTest
public class ResourceDefaultTestBase {
	public static ResourceDefault__c newResourceDefault(Id productId, Id rateCardItemId) {
		ResourceDefault__c defaultSo = new ResourceDefault__c(
			ProductId__c = productId,
			RateCardItemId__c = rateCardItemId
		);
		CRUDUtility.insertRecords(defaultSo);
		return defaultSo;
	}
}
