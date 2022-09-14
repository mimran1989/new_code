public with sharing class EstimateTreeService {
	public static void notApplicableForActivity(String recordId, Boolean notApplicable) {
		Activity__c activity = new Activity__c();
		activity.Id = recordId;
		activity.IsNotApplicable__c = notApplicable;
		CRUDUtility.updateRecords(activity);
		Id activityGrpId;
		Id phaseId;
		List<Task__c> tasks = [
			SELECT
				Id,
				ActivityId__r.ActivityGroupId__c,
				ActivityId__r.ActivityGroupId__r.PhaseId__c,
				IsNotApplicable__c,
				CalculatedDuration__c,
				LevelAdjustment__c,
				EstimatedDuration__c
			FROM Task__c
			WHERE ActivityId__c = :recordId
			WITH SECURITY_ENFORCED
		];
		for (Task__c task : tasks) {
			activityGrpId = task.ActivityId__r.ActivityGroupId__c;
			phaseId = task.ActivityId__r.ActivityGroupId__r.PhaseId__c;
			task.IsNotApplicable__c = notApplicable;
			if (notApplicable) {
				task.CalculatedDuration__c = 0;
				task.LevelAdjustment__c = 0;
				task.EstimatedDuration__c = 0;
			}
		}
		CRUDUtility.updateRecords(tasks);
		if (!notApplicable) {
			ActivityGroup__c activityGroup = new ActivityGroup__c();
			activityGroup.Id = activityGrpId;
			activityGroup.IsNotApplicable__c = notApplicable;
			CRUDUtility.updateRecords(activityGroup);
			if (phaseId != null) {
				Phase__c phase = new Phase__c();
				phase.Id = phaseId;
				phase.IsNotApplicable__c = notApplicable;
				CRUDUtility.updateRecords(phase);
			}
		}
		if (notApplicable) {
			List<TaskRoleSummary__c> summaries = [
				SELECT Id, LevelAdjustment__c
				FROM TaskRoleSummary__c
				WHERE ActivityId__c = :recordId
				WITH SECURITY_ENFORCED
			];
			for (TaskRoleSummary__c summary : summaries) {
				summary.LevelAdjustment__c = 0;
			}
			CRUDUtility.updateRecords(summaries);
		}
	}

	public static void notApplicableForActivityGroup(String recordId, Boolean notApplicable) {
		ActivityGroup__c activityGroup = [
			SELECT Id, IsNotApplicable__c, PhaseId__c
			FROM ActivityGroup__c
			WHERE Id = :recordId
			WITH SECURITY_ENFORCED
		];
		activityGroup.IsNotApplicable__c = notApplicable;
		CRUDUtility.updateRecords(activityGroup);
		if (!notApplicable && activityGroup.PhaseId__c != null) {
			Phase__c phase = new Phase__c();
			phase.Id = activityGroup.PhaseId__c;
			phase.IsNotApplicable__c = notApplicable;
			CRUDUtility.updateRecords(phase);
		}
		List<Id> activityGroupIds = new List<Id>();
		activityGroupIds.add(recordId);
		nonApplicableForActivities(activityGroupIds, notApplicable);
		nonApplicableForTasks(activityGroupIds, notApplicable);
		nonApplicableForSummaries(activityGroupIds, notApplicable);
	}

	public static void notApplicableForPhase(String recordId, Boolean notApplicable) {
		Phase__c phase = new Phase__c();
		phase.Id = recordId;
		phase.IsNotApplicable__c = notApplicable;
		CRUDUtility.updateRecords(phase);
		nonApplicableForActivityGroup(recordId, notApplicable);
	}

	private static void nonApplicableForActivityGroup(Id phaseId, Boolean notApplicable) {
		Map<Id, ActivityGroup__c> activityGroupById = new Map<Id, ActivityGroup__c>(
			[
				SELECT Id, IsNotApplicable__c
				FROM ActivityGroup__c
				WHERE PhaseId__c = :phaseId
				WITH SECURITY_ENFORCED
			]
		);
		for (ActivityGroup__c activityGroup : activityGroupById.values()) {
			activityGroup.IsNotApplicable__c = notApplicable;
		}
		CRUDUtility.updateRecords(activityGroupById.values());
		List<Id> activityGroupIds = new List<Id>(activityGroupById.keySet());
		nonApplicableForActivities(activityGroupIds, notApplicable);
		nonApplicableForTasks(activityGroupIds, notApplicable);
		nonApplicableForSummaries(activityGroupIds, notApplicable);
	}

	private static void nonApplicableForActivities(List<Id> activityGroupIds, Boolean notApplicable) {
		List<Activity__c> activities = [
			SELECT Id, IsNotApplicable__c
			FROM Activity__c
			WHERE ActivityGroupId__c IN :activityGroupIds
			WITH SECURITY_ENFORCED
		];
		for (Activity__c activity : activities) {
			activity.IsNotApplicable__c = notApplicable;
		}
		CRUDUtility.updateRecords(activities);
	}

	private static void nonApplicableForTasks(List<Id> activityGroupIds, Boolean notApplicable) {
		List<Task__c> tasks = [
			SELECT Id, IsNotApplicable__c, CalculatedDuration__c, LevelAdjustment__c, EstimatedDuration__c
			FROM Task__c
			WHERE ActivityId__r.ActivityGroupId__c IN :activityGroupIds
			WITH SECURITY_ENFORCED
		];
		for (Task__c task : tasks) {
			task.IsNotApplicable__c = notApplicable;
			if (notApplicable) {
				task.CalculatedDuration__c = 0;
				task.LevelAdjustment__c = 0;
				task.EstimatedDuration__c = 0;
			}
		}
		CRUDUtility.updateRecords(tasks);
	}

	private static void nonApplicableForSummaries(List<Id> activityGroupIds, Boolean notApplicable) {
		if (notApplicable) {
			List<TaskRoleSummary__c> summaries = [
				SELECT Id, LevelAdjustment__c
				FROM TaskRoleSummary__c
				WHERE ActivityGroupId__c IN :activityGroupIds
				WITH SECURITY_ENFORCED
			];
			for (TaskRoleSummary__c summary : summaries) {
				summary.LevelAdjustment__c = 0;
			}
			CRUDUtility.updateRecords(summaries);
			summaries = [
				SELECT Id, LevelAdjustment__c
				FROM TaskRoleSummary__c
				WHERE ActivityId__r.ActivityGroupId__c IN :activityGroupIds
				WITH SECURITY_ENFORCED
			];
			for (TaskRoleSummary__c summary : summaries) {
				summary.LevelAdjustment__c = 0;
			}
			CRUDUtility.updateRecords(summaries);
		}
	}

	public static void preventAdditionalQuoteToEstimate(List<Quote__c> quotes) {
		Set<Id> estimateId = new Set<Id>();
		for (Quote__c quote : quotes) {
			estimateId.add(quote.EstimateId__c);
		}

		Map<Id, Estimate__c> estimateMap = new Map<Id, Estimate__c>(
			[
				SELECT
					Id,
					Name,
					(
						SELECT Id, Name
						FROM Quotes__r
						WHERE
							Status__c != :EstimatorConstants.INACTIVE
							AND Type__c != :QuoteService.RECORDTYPE_NAME_COLLABORATION
					)
				FROM Estimate__c
				WHERE Id IN :estimateId
			]
		);

		for (Quote__c newQuote : quotes) {
			Integer existingQuoteCount = estimateMap.get(newQuote.EstimateId__c)?.Quotes__r?.size();
			if (existingQuoteCount > 0) {
				newQuote.addError(Label.AssociatedEstimateToQuoteAlreadyExisting);
			}
		}
	}
}
