/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class ResourceDefaultService {
	public static Map<Id, Id> getRateCardItemIdByRoleId(Id estimateTemplateId) {
		Map<Id, Id> rateCardItemIdByRoleId = new Map<Id, Id>();
		for (ResourceDefault__c resourceDefault : [
			SELECT ProductId__c, RateCardItemId__c
			FROM ResourceDefault__c
			WHERE EstimateTemplateId__c = :estimateTemplateId
			WITH SECURITY_ENFORCED
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		]) {
			rateCardItemIdByRoleId.put(resourceDefault.ProductId__c, resourceDefault.RateCardItemId__c);
		}

		return rateCardItemIdByRoleId;
	}
}
