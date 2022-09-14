/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class EstimateTemplateCopyPasteService {
	@AuraEnabled
	public static void copyTaskIntoActivity(
		String taskTemplateId,
		String activityTemplateId,
		Decimal sequence
	) {
		List<TaskTemplate__c> taskTemplateData = [
			SELECT IsActive__c, Sequence__c, Guidance__c, Name, ActivityTemplateId__c, ResourceRoleId__c
			FROM TaskTemplate__c
			WHERE ActivityTemplateId__c = :activityTemplateId OR Id = :taskTemplateId
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c ASC
		];

		TaskTemplate__c taskToCopy = null;
		for (TaskTemplate__c task : taskTemplateData) {
			if (task.Id == taskTemplateId) {
				taskToCopy = task;
			}
		}

		TaskTemplate__c copiedTask = taskToCopy.clone(false, true);
		copiedTask.ActivityTemplateId__c = activityTemplateId;
		copiedTask.Sequence__c = sequence + 1;
		copiedTask.Name = taskToCopy.Name;

		for (TaskTemplate__c currTaskTemplate : taskTemplateData) {
			if (
				currTaskTemplate.ActivityTemplateId__c == activityTemplateId &&
				currTaskTemplate.Sequence__c > sequence
			) {
				currTaskTemplate.Sequence__c += 1;
			}
		}

		taskTemplateData.add(copiedTask);
		CRUDUtility.upsertRecords(taskTemplateData);

		Map<Id, TaskTemplate__c> idToTaskMap = new Map<Id, TaskTemplate__c>();
		idToTaskMap.put(taskTemplateId, copiedTask);
		Map<Id, TaskParameterTemplate__c> idsToTaskParamsMap = copyTaskParamsIntoTasks(idToTaskMap);
		copyTaskParamValuesIntoTaskParams(idsToTaskParamsMap);
	}

	@AuraEnabled
	public static void copyActivityIntoActivityGroup(
		String activityTemplateId,
		String activityGroupTemplateId,
		Decimal sequence
	) {
		List<ActivityTemplate__c> activityTemplateData = [
			SELECT IsActive__c, Sequence__c, Guidance__c, Name, ActivityGroupTemplateId__c
			FROM ActivityTemplate__c
			WHERE ActivityGroupTemplateId__c = :activityGroupTemplateId OR Id = :activityTemplateId
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c ASC
		];

		ActivityTemplate__c activityToCopy = null;
		for (ActivityTemplate__c activity : activityTemplateData) {
			if (activity.Id == activityTemplateId) {
				activityToCopy = activity;
			}
		}

		ActivityTemplate__c copiedActivity = activityToCopy.clone(false, true);
		copiedActivity.ActivityGroupTemplateId__c = activityGroupTemplateId;
		copiedActivity.Sequence__c = sequence + 1;
		copiedActivity.Name = copiedActivity.Name;

		for (ActivityTemplate__c currActivity : activityTemplateData) {
			if (
				currActivity.ActivityGroupTemplateId__c == activityGroupTemplateId &&
				currActivity.Sequence__c > sequence
			) {
				currActivity.Sequence__c += 1;
			}
		}

		activityTemplateData.add(copiedActivity);
		CRUDUtility.upsertRecords(activityTemplateData);

		Map<Id, ActivityTemplate__c> idsToActivitiesMap = new Map<Id, ActivityTemplate__c>();
		idsToActivitiesMap.put(activityTemplateId, copiedActivity);
		copyScopeParamsIntoActivities(idsToActivitiesMap);
		Map<Id, TaskTemplate__c> idsToTasksMap = copyTasksIntoActivities(idsToActivitiesMap);
		Map<Id, TaskParameterTemplate__c> idsToTaskParamsMap = copyTaskParamsIntoTasks(idsToTasksMap);
		copyTaskParamValuesIntoTaskParams(idsToTaskParamsMap);
	}

	@AuraEnabled
	public static void copyActivityGroupIntoEstimateTemplate(
		String activityGroupTemplateId,
		String estimateTemplateId,
		Decimal sequence
	) {
		List<ActivityGroupTemplate__c> activityGroupTemplateData = [
			SELECT IsActive__c, Sequence__c, Guidance__c, Name, EstimateTemplateId__c, PhaseTemplateId__c
			FROM ActivityGroupTemplate__c
			WHERE EstimateTemplateId__c = :estimateTemplateId OR Id = :activityGroupTemplateId
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c ASC
		];

		ActivityGroupTemplate__c activityGroupToCopy = null;
		for (ActivityGroupTemplate__c activityGroup : activityGroupTemplateData) {
			if (activityGroup.Id == activityGroupTemplateId) {
				activityGroupToCopy = activityGroup;
			}
		}

		ActivityGroupTemplate__c copiedActivityGroup = activityGroupToCopy.clone(false, true);
		copiedActivityGroup.EstimateTemplateId__c = estimateTemplateId;
		copiedActivityGroup.Sequence__c = sequence + 1;
		copiedActivityGroup.Name = activityGroupToCopy.Name;

		for (ActivityGroupTemplate__c currActivityGroup : activityGroupTemplateData) {
			if (
				currActivityGroup.EstimateTemplateId__c == estimateTemplateId &&
				currActivityGroup.Sequence__c > sequence
			) {
				currActivityGroup.Sequence__c += 1;
			}
		}

		activityGroupTemplateData.add(copiedActivityGroup);
		CRUDUtility.upsertRecords(activityGroupTemplateData);

		Map<Id, ActivityGroupTemplate__c> idsToActivityGroupsMap = new Map<Id, ActivityGroupTemplate__c>();
		idsToActivityGroupsMap.put(activityGroupTemplateId, copiedActivityGroup);
		copyScopeParamsIntoActivityGroups(idsToActivityGroupsMap);
		Map<Id, ActivityTemplate__c> idsToActivitiesMap = copyActivitiesIntoActivityGroup(
			idsToActivityGroupsMap
		);
		copyScopeParamsIntoActivities(idsToActivitiesMap);
		Map<Id, TaskTemplate__c> idsToTasksMap = copyTasksIntoActivities(idsToActivitiesMap);
		Map<Id, TaskParameterTemplate__c> idsToTaskParamsMap = copyTaskParamsIntoTasks(idsToTasksMap);
		copyTaskParamValuesIntoTaskParams(idsToTaskParamsMap);
	}

	private static Map<Id, ActivityTemplate__c> copyActivitiesIntoActivityGroup(
		Map<Id, ActivityGroupTemplate__c> idsToActivityGroupsMap
	) {
		List<ActivityTemplate__c> oldActivities = EstimateTemplateCreator.getActivitiesForActivityGroups(
			new List<Id>(idsToActivityGroupsMap.keySet())
		);
		Map<Id, ActivityTemplate__c> copiedActivitiesMap = new Map<Id, ActivityTemplate__c>();

		for (ActivityTemplate__c activity : oldActivities) {
			ActivityTemplate__c copiedActivity = activity.clone(false, true);
			ActivityGroupTemplate__c copiedActivityGroup = idsToActivityGroupsMap.get(
				activity.ActivityGroupTemplateId__c
			);
			copiedActivity.ActivityGroupTemplateId__c = copiedActivityGroup.Id;
			copiedActivitiesMap.put(activity.Id, copiedActivity);
		}

		CRUDUtility.upsertRecords(copiedActivitiesMap.values());
		return copiedActivitiesMap;
	}

	private static Map<Id, TaskTemplate__c> copyTasksIntoActivities(
		Map<Id, ActivityTemplate__c> idsToActivitiesMap
	) {
		List<TaskTemplate__c> oldTaskTemplateData = EstimateTemplateCreator.getTasksForActivities(
			new List<Id>(idsToActivitiesMap.keySet())
		);
		Map<Id, TaskTemplate__c> copiedTaskMap = new Map<Id, TaskTemplate__c>();

		for (TaskTemplate__c taskTemplate : oldTaskTemplateData) {
			TaskTemplate__c copiedTask = taskTemplate.clone(false, true);
			ActivityTemplate__c copiedActivity = idsToActivitiesMap.get(
				taskTemplate.ActivityTemplateId__c
			);
			copiedTask.ActivityTemplateId__c = copiedActivity.Id;
			copiedTaskMap.put(taskTemplate.Id, copiedTask);
		}

		CRUDUtility.upsertRecords(copiedTaskMap.values());
		return copiedTaskMap;
	}

	private static Map<Id, TaskParameterTemplate__c> copyTaskParamsIntoTasks(
		Map<Id, TaskTemplate__c> idsToTasksMap
	) {
		List<TaskParameterTemplate__c> oldTaskParamTemplates = EstimateTemplateCreator.getTaskParamTemplates(
			new List<Id>(idsToTasksMap.keySet())
		);
		Map<Id, TaskParameterTemplate__c> copiedTaskParamMap = new Map<Id, TaskParameterTemplate__c>();

		for (TaskParameterTemplate__c taskParamTemplate : oldTaskParamTemplates) {
			TaskParameterTemplate__c copiedTaskParamTemplate = taskParamTemplate.clone(false, true);
			TaskTemplate__c copiedTaskTemplate = idsToTasksMap.get(taskParamTemplate.TaskTemplateId__c);
			copiedTaskParamTemplate.TaskTemplateId__c = copiedTaskTemplate.Id;
			copiedTaskParamMap.put(taskParamTemplate.Id, copiedTaskParamTemplate);
		}

		CRUDUtility.upsertRecords(copiedTaskParamMap.values());
		return copiedTaskParamMap;
	}

	private static Map<Id, TaskParameterValueTemplate__c> copyTaskParamValuesIntoTaskParams(
		Map<Id, TaskParameterTemplate__c> idsToTaskParamsMap
	) {
		List<TaskParameterValueTemplate__c> oldTaskParamValues = EstimateTemplateCreator.getTaskParamValueTemplates(
			new List<Id>(idsToTaskParamsMap.keySet())
		);
		Map<Id, TaskParameterValueTemplate__c> copiedTaskParamMap = new Map<Id, TaskParameterValueTemplate__c>();

		for (TaskParameterValueTemplate__c taskParamValue : oldTaskParamValues) {
			TaskParameterValueTemplate__c copiedTaskParamValue = taskParamValue.clone(false, true);
			TaskParameterTemplate__c copiedTaskParamTemplate = idsToTaskParamsMap.get(
				taskParamValue.TaskParameterTemplateId__c
			);
			copiedTaskParamValue.TaskParameterTemplateId__c = copiedTaskParamTemplate.Id;
			copiedTaskParamMap.put(taskParamValue.Id, copiedTaskParamValue);
		}

		CRUDUtility.upsertRecords(copiedTaskParamMap.values());
		return copiedTaskParamMap;
	}

	private static List<ScopeParameterTemplate__c> getScopeParameterTemplates(
		Set<Id> scopeParamsParentIds
	) {
		return [
			SELECT
				Id,
				Name,
				DeveloperName__c,
				Sequence__c,
				Guidance__c,
				DataType__c,
				EstimateTemplateId__c,
				ActivityGroupTemplateId__c,
				ActivityTemplateId__c,
				AllowedValues__c,
				(
					SELECT Id, Sequence__c, FromValue__c, ToValue__c, Label__c
					FROM ScopeParameterValueTemplates__r
					ORDER BY Sequence__c
				)
			FROM ScopeParameterTemplate__c
			WHERE
				ActivityGroupTemplateId__c = :scopeParamsParentIds
				OR ActivityTemplateId__c = :scopeParamsParentIds
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c
		];
	}

	private static List<ScopeParameterValueTemplate__c> getScopeParameterValueTemplates(
		Set<Id> scopeParamIds
	) {
		return [
			SELECT Id, ScopeParameterTemplateId__c, Sequence__c, FromValue__c, ToValue__c, Label__c
			FROM ScopeParameterValueTemplate__c
			WHERE ScopeParameterTemplateId__c = :scopeParamIds
			WITH SECURITY_ENFORCED
		];
	}

	private static void copyScopeParamsIntoActivityGroups(
		Map<Id, ActivityGroupTemplate__c> idsToActivityGroupsMap
	) {
		List<ScopeParameterTemplate__c> scopeParamTemplates = getScopeParameterTemplates(
			idsToActivityGroupsMap.keySet()
		);
		Map<Id, ScopeParameterTemplate__c> copiedScopeParams = new Map<Id, ScopeParameterTemplate__c>();

		for (ScopeParameterTemplate__c scopeParam : scopeParamTemplates) {
			ScopeParameterTemplate__c copiedScopeParam = scopeParam.clone(false, true);
			ActivityGroupTemplate__c copiedActivityGroup = idsToActivityGroupsMap.get(
				scopeParam.ActivityGroupTemplateId__c
			);
			copiedScopeParam.ActivityGroupTemplateId__c = copiedActivityGroup.Id;
			copiedScopeParams.put(scopeParam.Id, copiedScopeParam);
		}

		CRUDUtility.upsertRecords(copiedScopeParams.values());
		copyScopeParamValuesIntoScopeParams(copiedScopeParams);
	}

	private static void copyScopeParamsIntoActivities(
		Map<Id, ActivityTemplate__c> idsToActivitiesMap
	) {
		List<ScopeParameterTemplate__c> scopeParamTemplates = getScopeParameterTemplates(
			idsToActivitiesMap.keySet()
		);
		Map<Id, ScopeParameterTemplate__c> copiedScopeParams = new Map<Id, ScopeParameterTemplate__c>();

		for (ScopeParameterTemplate__c scopeParam : scopeParamTemplates) {
			ScopeParameterTemplate__c copiedScopeParam = scopeParam.clone(false, true);
			ActivityTemplate__c copiedActivityGroup = idsToActivitiesMap.get(
				scopeParam.ActivityTemplateId__c
			);
			copiedScopeParam.ActivityTemplateId__c = copiedActivityGroup.Id;
			copiedScopeParams.put(scopeParam.Id, copiedScopeParam);
		}

		CRUDUtility.upsertRecords(copiedScopeParams.values());
		copyScopeParamValuesIntoScopeParams(copiedScopeParams);
	}

	private static void copyScopeParamValuesIntoScopeParams(
		Map<Id, ScopeParameterTemplate__c> idsToScopeParamsMap
	) {
		List<ScopeParameterValueTemplate__c> scopeParamValues = getScopeParameterValueTemplates(
			idsToScopeParamsMap.keySet()
		);
		List<ScopeParameterValueTemplate__c> copiedScopeParamValues = new List<ScopeParameterValueTemplate__c>();

		for (ScopeParameterValueTemplate__c scopeParamVal : scopeParamValues) {
			ScopeParameterValueTemplate__c copiedScopeParamVal = scopeParamVal.clone(false, true);
			ScopeParameterTemplate__c copiedScopeParamTemplate = idsToScopeParamsMap.get(
				scopeParamVal.ScopeParameterTemplateId__c
			);
			copiedScopeParamVal.ScopeParameterTemplateId__c = copiedScopeParamTemplate.Id;
			copiedScopeParamValues.add(copiedScopeParamVal);
		}

		CRUDUtility.upsertRecords(copiedScopeParamValues);
	}
}
