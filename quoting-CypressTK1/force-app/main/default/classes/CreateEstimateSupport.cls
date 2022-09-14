public with sharing class CreateEstimateSupport {
	public static EstimateTemplate__c getEstimateTemplate(Id estimateTemplateId) {
		EstimateTemplate__c estimateTemplate = [
			SELECT
				Id,
				Name,
				Description__c,
				Guidance__c,
				IsActive__c,
				RateCardId__c,
				ProductId__c,
				ServiceId__c,
				UseProjectPhases__c,
				ServiceId__r.Name,
				(
					SELECT Id, Name, Description__c, Guidance__c, Sequence__c, IsActive__c, PhaseTemplateId__c
					FROM ActivityGroups__r
					WHERE IsActive__c = TRUE
				),
				(
					SELECT Id, Name, Description__c, Guidance__c, Sequence__c
					FROM Phases__r
					WHERE IsActive__c = TRUE
				)
			FROM EstimateTemplate__c
			WHERE Id = :estimateTemplateId
			WITH SECURITY_ENFORCED
		];

		return estimateTemplate;
	}

	public static Map<Id, Phase__c> createPhases(
		EstimateTemplate__c estimateTemplate,
		Id estimateId
	) {
		Map<Id, Phase__c> phasesByTemplateId = new Map<Id, Phase__c>();
		if (!estimateTemplate.UseProjectPhases__c) {
			return phasesByTemplateId;
		}

		for (PhaseTemplate__c phaseTemplate : estimateTemplate.Phases__r) {
			if (!phasesByTemplateId.containsKey(phaseTemplate.Id)) {
				Phase__c phase = Phase.newSO(phaseTemplate);
				phase.EstimateId__c = estimateId;
				phasesByTemplateId.put(phaseTemplate.Id, phase);
			}
		}

		CRUDUtility.insertRecords(phasesByTemplateId.values());

		return phasesByTemplateId;
	}

	public static Map<Id, ActivityGroup__c> createActivityGroups(
		List<ActivityGroupTemplate__c> activityGroupTemplates,
		Id estimateId,
		Map<Id, Phase__c> phasesByTemplateId
	) {
		Map<Id, ActivityGroup__c> activityGroupsByTemplateId = new Map<Id, ActivityGroup__c>();

		for (ActivityGroupTemplate__c activityGroupTemplate : activityGroupTemplates) {
			Id phaseId = null;
			if (phasesByTemplateId.containsKey(activityGroupTemplate.PhaseTemplateId__c)) {
				phaseId = phasesByTemplateId.get(activityGroupTemplate.PhaseTemplateId__c).Id;
			}

			if (!activityGroupsByTemplateId.containsKey(activityGroupTemplate.Id)) {
				ActivityGroup__c activityGroup = ActivityGroup.newSO(activityGroupTemplate);
				activityGroup.EstimateId__c = estimateId;
				activityGroup.PhaseId__c = phaseId;
				activityGroupsByTemplateId.put(activityGroupTemplate.Id, activityGroup);
			}
		}

		CRUDUtility.insertRecords(activityGroupsByTemplateId.values());

		return activityGroupsByTemplateId;
	}
}
