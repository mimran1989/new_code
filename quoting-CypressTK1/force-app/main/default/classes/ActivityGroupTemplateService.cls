/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class ActivityGroupTemplateService {
	public static List<ActivityTemplate__c> getActivityTemplates(Set<Id> groupTemplateIds) {
		return [
			SELECT
				Id,
				Name,
				Description__c,
				Guidance__c,
				Sequence__c,
				ActivityGroupTemplateId__c,
				(
					SELECT
						Id,
						Name,
						Description__c,
						Guidance__c,
						Sequence__c,
						ResourceRoleId__c,
						ActivityTemplateId__c
					FROM Tasks__r
					WHERE IsActive__c = TRUE
				)
			FROM ActivityTemplate__c
			WHERE ActivityGroupTemplateId__c IN :groupTemplateIds AND IsActive__c = TRUE
			WITH SECURITY_ENFORCED
		];
	}
	@AuraEnabled
	public static object getActivityGroupsByPhaseTemplateId(String phaseTemplateId) {
		return [
			SELECT
				Id,
				IsActive__c,
				Sequence__c,
				Guidance__c,
				Name,
				EstimateTemplateId__c,
				PhaseTemplateId__c
			FROM ActivityGroupTemplate__c
			WHERE PhaseTemplateId__c = :phaseTemplateId
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c ASC
		];
	}
}
