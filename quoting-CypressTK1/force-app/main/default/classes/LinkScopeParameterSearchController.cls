/**
 *  Provus Services Quoting
 *  LinkScopeParameterSearchController
 *
 *  2022 Provus Inc. All rights reserved.
 */
public with sharing class LinkScopeParameterSearchController {
	@AuraEnabled(Cacheable=true)
	public static ScopeParameterSearchGroupDto getSearchGroup(Id taskTemplateId) {
		TaskTemplate__c activityGroupTemplate = [
			SELECT
				Id,
				ActivityTemplateId__c,
				ActivityTemplateId__r.ActivityGroupTemplateId__c,
				ActivityTemplateId__r.ActivityGroupTemplateId__r.EstimateTemplateId__c
			FROM TaskTemplate__c
			WHERE Id = :taskTemplateId
			WITH SECURITY_ENFORCED
		];

		ScopeParameterSearchGroupDto searchGroup = new ScopeParameterSearchGroupDto();
		searchGroup.estimateId = activityGroupTemplate.ActivityTemplateId__r.ActivityGroupTemplateId__r.EstimateTemplateId__c;
		searchGroup.activityGroupId = activityGroupTemplate.ActivityTemplateId__r.ActivityGroupTemplateId__c;
		searchGroup.activityId = activityGroupTemplate.ActivityTemplateId__c;
		return searchGroup;
	}

	public with sharing class ScopeParameterSearchGroupDto {
		@AuraEnabled
		public Id estimateId;
		@AuraEnabled
		public Id activityGroupId;
		@AuraEnabled
		public Id activityId;
	}
}
