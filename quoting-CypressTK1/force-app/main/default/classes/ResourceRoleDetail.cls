/**
 *  Provus Services Quoting
 *  EstimateResources
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class ResourceRoleDetail {
	@AuraEnabled
	public String roleName;
	@AuraEnabled
	public Map<String, List<String>> skillMap;
	@AuraEnabled
	public String skill;
	@AuraEnabled
	public String location;
	@AuraEnabled
	public Integer sequence;

	@AuraEnabled
	public String skillId;
	@AuraEnabled
	public String locationId;

	public ResourceRoleDetail() {
	}

	public ResourceRoleDetail(RateCardItem__c rateCardItem) {
		roleName = rateCardItem.ProductId__r.Name;
		skillMap = new Map<String, List<String>>{
			rateCardItem.SkillLevel__c => new List<String>{ rateCardItem.LocationDisplayName__c }
		};
	}
}
