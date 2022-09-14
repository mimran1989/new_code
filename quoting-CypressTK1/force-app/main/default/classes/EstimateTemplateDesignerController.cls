/**
 *  Provus Services Quoting
 *  EstimateTemplateController
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class EstimateTemplateDesignerController {
	@AuraEnabled
	public static List<ActivityGroupTemplate__c> getActivityGroupsForPhase(Id phaseTemplateId) {
		return [
			SELECT Id, IsActive__c, Sequence__c, Guidance__c, Name, EstimateTemplateId__c
			FROM ActivityGroupTemplate__c
			WHERE PhaseTemplateId__c = :phaseTemplateId
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c ASC
		];
	}

	@AuraEnabled
	public static List<ActivityGroupTemplate__c> getActivityGroups(Id estimateId) {
		return [
			SELECT Id, IsActive__c, Sequence__c, Guidance__c, Name, EstimateTemplateId__c
			FROM ActivityGroupTemplate__c
			WHERE EstimateTemplateId__c = :estimateId
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c ASC
		];
	}
}
