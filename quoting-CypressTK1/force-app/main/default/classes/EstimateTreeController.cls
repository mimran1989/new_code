/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class EstimateTreeController {
	//This method is used for fetching the tree structure..
	@AuraEnabled(Cacheable=true)
	public static Object getRecords(String estimateId) {
		Estimate__c estimate = [
			SELECT Id, Name, UseProjectPhases__c
			FROM Estimate__c
			WHERE Id = :estimateId
			WITH SECURITY_ENFORCED
		];

		if (estimate.UseProjectPhases__c) {
			return getPhases(estimateId);
		} else {
			return getActivityGroups(estimateId);
		}
	}

	private static Object getActivityGroups(String estimateId) {
		Map<String, List<ActivityGroup__c>> estimateToActivityGroupMap = new Map<String, List<ActivityGroup__c>>();
		List<ActivityGroup__c> activityGroups = [
			SELECT
				Id,
				Name,
				Sequence__c,
				TotalCalculatedDuration__c,
				TotalAdjustments__c,
				TotalEstimatedDuration__c,
				TotalLevelAdjustments__c,
				IsNotApplicable__c
			FROM ActivityGroup__c
			WHERE EstimateId__c = :estimateId
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c ASC
		];
		estimateToActivityGroupMap.put(estimateId, activityGroups);
		return getActivityGroups(estimateToActivityGroupMap, null, new List<String>());
	}

	private static Object getActivityGroups(
		Map<String, List<ActivityGroup__c>> estimateToActivityGroupMap,
		Phase__c phase,
		List<String> gridExpandedIds
	) {
		String estimateId;
		List<ActivityGroup__c> activityGroups = new List<ActivityGroup__c>();

		for (String estId : estimateToActivityGroupMap.keyset()) {
			estimateId = estId;
			activityGroups = estimateToActivityGroupMap.get(estId);
		}

		//Querying the Activity, Tasks..
		Map<Id, List<Activity__c>> activityGroupActivityMap = mapActivitiesByGroupId(activityGroups);

		//Querying the Summary role records at the Activitygroup level for the Resources..
		Map<Id, String> roleSumMp = roleSummaryMap(estimateId);

		//Forming the JSON structure.
		List<Object> objlst = new List<Object>();
		for (ActivityGroup__c ag : activityGroups) {
			//Building the Activity Groups
			Map<String, Object> aGmp = new Map<String, Object>();
			aGmp.put('Type', EstimateTreeSupport.ACTIVITY_GROUP);
			String sequence = ag.Sequence__c + ' ';
			if (phase != null) {
				sequence = phase.Sequence__c + '.' + ag.Sequence__c + ' ';
			}
			aGmp.put(EstimateTreeSupport.ACTIVITY_GROUP, sequence + ag.Name);
			aGmp.put('ActivityGroupName', ag.Name);
			aGmp.put('ActivityGroupId', ag.Id);
			aGmp.put('EstimatedDuration', ag.TotalEstimatedDuration__c);
			aGmp.put('AdjustedDuration', ag.TotalAdjustments__c);
			aGmp.put('LevelAdjustments', ag.TotalLevelAdjustments__c);
			aGmp.put('CalculatedDuration', ag.TotalCalculatedDuration__c);
			aGmp.put('IconType', 'standard:work_type_group');
			aGmp.put('NotApplicable', ag.IsNotApplicable__c);
			aGmp.put('ActionbuttonTitle', 'Resource Summary');
			aGmp.put('ActionIcon', 'action:share_poll');
			gridExpandedIds.add(ag.Id);
			if (activityGroupActivityMap.containsKey(ag.Id)) {
				aGmp.put(
					'_children',
					EstimateTreeSupport.createActivityAndTask(
						activityGroupActivityMap.get(ag.Id),
						gridExpandedIds,
						roleSumMp
					)
				);
			}
			if (roleSumMp.containsKey(ag.Id)) {
				aGmp.put('Resourcerole', roleSumMp.get(ag.Id));
			}
			objlst.add(aGmp);
		}

		if (phase == null) {
			return finalValues(objlst, gridExpandedIds);
		}
		return objlst;
	}

	private static List<Object> finalValues(List<Object> objlst, List<String> gridExpandedIds) {
		for (object obj : objlst) {
			Map<String, Object> mapRecord = (Map<String, Object>) obj;
			mapRecord.put('gridExpandedIds', gridExpandedIds);
			break;
		}
		return objlst;
	}

	private static Object getPhases(Id estimateId) {
		List<Phase__c> phases = [
			SELECT
				Id,
				Name,
				Description__c,
				Guidance__c,
				Sequence__c,
				IsNotApplicable__c,
				TotalEstimatedDuration__c,
				TotalAdjustments__c,
				TotalLevelAdjustments__c,
				TotalCalculatedDuration__c
			FROM Phase__c
			WHERE EstimateId__c = :estimateId AND IsActive__c = TRUE
			WITH SECURITY_ENFORCED
		];

		Map<Id, List<ActivityGroup__c>> activityGroupByPhaseId = new Map<Id, List<ActivityGroup__c>>();
		for (ActivityGroup__c activityGroup : [
			SELECT
				Id,
				Name,
				Sequence__c,
				PhaseId__c,
				TotalCalculatedDuration__c,
				TotalAdjustments__c,
				TotalEstimatedDuration__c,
				TotalLevelAdjustments__c,
				IsNotApplicable__c
			FROM ActivityGroup__c
			WHERE EstimateId__c = :estimateId
			WITH SECURITY_ENFORCED
			ORDER BY PhaseId__c, Sequence__c ASC
		]) {
			if (!activityGroupByPhaseId.containsKey(activityGroup.PhaseId__c)) {
				activityGroupByPhaseId.put(activityGroup.PhaseId__c, new List<ActivityGroup__c>());
			}

			activityGroupByPhaseId.get(activityGroup.PhaseId__c).add(activityGroup);
		}

		//Querying the Summary role records at the Activitygroup level for the Resources.
		List<String> gridExpandedIds = new List<String>();
		List<Object> objlst = new List<Object>();
		for (Phase__c phase : phases) {
			//Building the Phases
			Map<String, Object> aGmp = new Map<String, Object>();
			aGmp.put('Type', EstimateTreeSupport.PHASE);
			aGmp.put(EstimateTreeSupport.ACTIVITY_GROUP, phase.Sequence__c + ' ' + phase.Name);
			aGmp.put('ActivityGroupName', phase.Name);
			aGmp.put('ActivityGroupId', phase.Id);
			aGmp.put('EstimatedDuration', phase.TotalEstimatedDuration__c);
			aGmp.put('AdjustedDuration', phase.TotalAdjustments__c);
			aGmp.put('LevelAdjustments', phase.TotalLevelAdjustments__c);
			aGmp.put('CalculatedDuration', phase.TotalCalculatedDuration__c);
			aGmp.put('IconType', 'standard:event');
			aGmp.put('NotApplicable', phase.IsNotApplicable__c);
			aGmp.put('ActionbuttonTitle', 'Resource Summary');
			aGmp.put('ActionIcon', 'action:share_poll');
			gridExpandedIds.add(phase.Id);
			Map<string, List<ActivityGroup__c>> estimateToActivityGroupMap = new Map<string, List<ActivityGroup__c>>();
			estimateToActivityGroupMap.put(estimateId, activityGroupByPhaseId.get(phase.Id));
			if (activityGroupByPhaseId.containsKey(phase.Id)) {
				aGmp.put(
					'_children',
					getActivityGroups(estimateToActivityGroupMap, phase, gridExpandedIds)
				);
			}
			objlst.add(aGmp);
		}
		return finalValues(objlst, gridExpandedIds);
	}

	@TestVisible
	private static Map<Id, List<Activity__c>> mapActivitiesByGroupId(
		List<ActivityGroup__c> activityGroups
	) {
		Map<Id, List<Activity__c>> activityGroupActivityMap = new Map<Id, List<Activity__c>>();

		for (Activity__c activity : [
			SELECT
				Id,
				ActivityGroupId__r.Name,
				Path__c,
				IsNotApplicable__c,
				TotalCalculatedDuration__c,
				TotalLevelAdjustments__c,
				TotalAdjustments__c,
				TotalEstimatedDuration__c,
				Name,
				(
					SELECT
						Id,
						Name,
						TemplateId__c,
						Path__c,
						AdjustmentReason__c,
						IsNotApplicable__c,
						LevelAdjustment__c,
						CalculatedDuration__c,
						EstimatedDuration__c,
						ResourceRoleId__r.Name
					FROM Tasks__r
					WHERE IsActive__c = TRUE
					ORDER BY Sequence__c ASC
				)
			FROM Activity__c
			WHERE ActivityGroupId__c IN :activityGroups
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c ASC
		]) {
			List<Activity__c> activities = activityGroupActivityMap.get(activity.ActivityGroupId__r.Id);
			if (activities == null) {
				activities = new List<Activity__c>();
				activityGroupActivityMap.put(activity.ActivityGroupId__r.Id, activities);
			}

			activities.add(activity);
		}

		return activityGroupActivityMap;
	}

	@TestVisible
	private static Map<Id, String> roleSummaryMap(Id estimateId) {
		Map<Id, String> roleByGroupId = new Map<Id, String>();

		for (TaskRoleSummary__c summary : [
			SELECT Id, ActivityGroupId__c, ActivityId__c, ResourceRoleId__r.Name
			FROM TaskRoleSummary__c
			WHERE EstimateId__c = :estimateId
			WITH SECURITY_ENFORCED
		]) {
			putRoleActivityGroup(roleByGroupId, summary);
			putRoleActivity(roleByGroupId, summary);
		}

		return roleByGroupId;
	}

	private static void putRoleActivityGroup(
		Map<Id, String> roleByGroupId,
		TaskRoleSummary__c summary
	) {
		if (!roleByGroupId.containsKey(summary.ActivityGroupId__c)) {
			roleByGroupId.put(summary.ActivityGroupId__c, summary.ResourceRoleId__r.Name);
		} else {
			roleByGroupId.put(
				summary.ActivityGroupId__c,
				roleByGroupId.get(summary.ActivityGroupId__c) +
				',' +
				summary.ResourceRoleId__r.Name
			);
		}
	}

	private static void putRoleActivity(Map<Id, String> roleSumMap, TaskRoleSummary__c rlsum) {
		if (!roleSumMap.containsKey(rlsum.ActivityId__c)) {
			roleSumMap.put(rlsum.ActivityId__c, rlsum.ResourceRoleId__r.Name);
		} else {
			roleSumMap.put(
				rlsum.ActivityId__c,
				roleSumMap.get(rlsum.ActivityId__c) +
				',' +
				rlsum.ResourceRoleId__r.Name
			);
		}
	}

	@AuraEnabled
	public static void updateTasks(List<Task__c> tasks) {
		CRUDUtility.updateRecords(tasks);
	}

	//This method is used for Updating of Task and Value record..
	@AuraEnabled
	public static void updateTask(Task__c tsk, List<TaskParameterValue__c> taskParams) {
		CRUDUtility.updateRecords(tsk);
		if (taskParams != null) {
			CRUDUtility.updateRecords(taskParams);
		}
	}
	//This method is used for getting the Summary by role records at the estimate,Activitygroup and activity level..
	@AuraEnabled
	public static Object getSummaryRecords(String recordId, String type) {
		return EstimateTreeSummarySupport.getSummaryRecords(recordId, type);
	}

	//Query the Scope of the Estimate..
	@AuraEnabled
	public static List<TaskParameterValue__c> getSourceSummary(String estimateId) {
		List<TaskParameterValue__c> tpvLst = [
			SELECT
				Id,
				BooleanValue__c,
				IntegerValue__c,
				TextValue__c,
				TemplateId__r.Name,
				TemplateId__r.DataType__c,
				TaskId__c,
				TaskId__r.IsNotApplicable__c,
				TaskId__r.Name,
				TaskId__r.ActivityId__r.Name,
				TaskId__r.ActivityId__r.ActivityGroupId__r.Name,
				TaskId__r.ActivityGroupId__r.PhaseId__r.Name,
				TaskId__r.EstimatedDuration__c,
				Name
			FROM TaskParameterValue__c
			WHERE TaskId__r.EstimateId__c = :estimateId
			WITH SECURITY_ENFORCED
			ORDER BY TaskId__r.Path__c ASC
		];
		return tpvLst;
	}
	//When UpdateNotApplicable is checked at the ActivityGroup or Activity Level..
	@AuraEnabled
	public static void updateNotApplicableField(String recordId, Boolean notApplicable, String type) {
		if (type == EstimateTreeSupport.ACTIVITY_GROUP) {
			EstimateTreeService.notApplicableForActivityGroup(recordId, notApplicable);
		} else if (type == 'Activity') {
			EstimateTreeService.notApplicableForActivity(recordId, notApplicable);
		} else if (type == EstimateTreeSupport.PHASE) {
			EstimateTreeService.notApplicableForPhase(recordId, notApplicable);
		}
	}

	//This method is invoked when Edit task is invoked from the task row.
	@AuraEnabled
	public static Map<String, Object> getTaskDetails(String taskId) {
		return EstimateTreeTaskSupport.getTaskDetails(taskId);
	}

	//Create a level Summary Record..
	@AuraEnabled
	public static void createSummaryRecords(TaskRoleSummary__c summaryRecord, String typeof) {
		EstimateTreeSummarySupport.createSummaryRecords(summaryRecord, typeof);
	}
}
