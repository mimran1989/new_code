/**
 *  Provus Services Quoting
 *  RateCardAttributeGroupService
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class RateCardAttributeGroupService {
	public static Map<Id, List<RateCardAttribute__c>> getAttributesForGroups(
		List<Id> attributeGroupIds
	) {
		Map<Id, List<RateCardAttribute__c>> attributesByGroupId = new Map<Id, List<RateCardAttribute__c>>();
		for (RateCardAttribute__c rateCardAttribute : [
			SELECT Id, Name, FieldAPIName__c, AttributeGroupId__c
			FROM RateCardAttribute__c
			WHERE AttributeGroupId__c IN :attributeGroupIds
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c
		]) {
			List<RateCardAttribute__c> attributesForGroup = attributesByGroupId.get(
				rateCardAttribute.AttributeGroupId__c
			);
			if (attributesForGroup == null) {
				attributesForGroup = new List<RateCardAttribute__c>();
				attributesByGroupId.put(rateCardAttribute.AttributeGroupId__c, attributesForGroup);
			}

			attributesForGroup.add(rateCardAttribute);
		}
		return attributesByGroupId;
	}
}
