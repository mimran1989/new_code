/**
 *  Provus Services Quoting
 *  ProjectPhaseFactory
 *  @2021 Provus Inc. All rights reserved.
 */
public with sharing abstract class ProjectPhaseFactory {
	public static List<ProjectPhase__c> getProjectPhasesForQuote(Id quoteId) {
		return [
			SELECT
				Id,
				Description__c,
				EndDate__c,
				Name,
				QuoteId__c,
				Sequence__c,
				StartDate__c,
				(SELECT Id, Sequence__c, QuoteId__c FROM QuotePeriods__r ORDER BY Sequence__c ASC)
			FROM ProjectPhase__c
			WHERE QuoteId__c = :quoteId
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c ASC
		];
	}

	public static List<PhaseTemplate__c> getPhaseTemplateList(Id estimateId) {
		return [
			SELECT Id, IsActive__c, Sequence__c, Name
			FROM PhaseTemplate__c
			WHERE EstimateTemplateId__c = :estimateId
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c ASC
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		];
	}

	public static List<PhaseTemplate__c> getProjectPhase(Id estimateTemplateId) {
		return [
			SELECT Id, IsActive__c, Sequence__c, Guidance__c, Name, EstimateTemplateId__c
			FROM PhaseTemplate__c
			WHERE EstimateTemplateId__c = :estimateTemplateId
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c ASC
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		];
	}

	public static Map<Id, List<ActivityTemplate__c>> getActivityTemplatesWithTaskMap(
		Set<Id> activityGroupTemplateList
	) {
		List<ActivityTemplate__c> activityTemplates = [
			SELECT
				Id,
				Name,
				ActivityGroupTemplateId__c,
				Path__c,
				(SELECT Id, Name, Path__c, ResourceRoleId__r.Name FROM Tasks__r ORDER BY Path__c ASC)
			FROM ActivityTemplate__c
			WHERE ActivityGroupTemplateId__c IN :activityGroupTemplateList
			WITH SECURITY_ENFORCED
			ORDER BY Path__c ASC
		];

		Map<Id, List<ActivityTemplate__c>> activityTemplatesWithTaskMap = new Map<Id, List<ActivityTemplate__c>>();
		for (ActivityTemplate__c at : activityTemplates) {
			if (!activityTemplatesWithTaskMap.containsKey(at.ActivityGroupTemplateId__c)) {
				activityTemplatesWithTaskMap.put(
					at.ActivityGroupTemplateId__c,
					new List<ActivityTemplate__c>()
				);
			}
			activityTemplatesWithTaskMap.get(at.ActivityGroupTemplateId__c).add(at);
		}
		return activityTemplatesWithTaskMap;
	}

	public static Map<Id, ActivityGroupTemplate__c> getActivityGroupTemplateWithActivityMap(
		String estimateId,
		Map<Id, List<ActivityGroupTemplate__c>> activityGroupTemplatesMap
	) {
		Map<Id, ActivityGroupTemplate__c> activityGroupTemplateList = new Map<Id, ActivityGroupTemplate__c>();
		for (ActivityGroupTemplate__c activityGrpTempIns : [
			SELECT Id, IsActive__c, Sequence__c, Name, PhaseTemplateId__c, Path__c
			FROM ActivityGroupTemplate__c
			WHERE EstimateTemplateId__c = :estimateId
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c ASC
		]) {
			if (!activityGroupTemplatesMap.containsKey(activityGrpTempIns.PhaseTemplateId__c)) {
				activityGroupTemplatesMap.put(
					activityGrpTempIns.PhaseTemplateId__c,
					new List<ActivityGroupTemplate__c>()
				);
			}
			activityGroupTemplatesMap.get(activityGrpTempIns.PhaseTemplateId__c).add(activityGrpTempIns);
			activityGroupTemplateList.put(activityGrpTempIns.Id, activityGrpTempIns);
		}

		return activityGroupTemplateList;
	}
}
