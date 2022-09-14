/**
 *  Provus Services Quoting
 *  @2021 Provus Inc. All rights reserved.
 */
public with sharing class CreateEstimateService {
	public class TaskRequest {
		Map<Id, ActivityGroup__c> activityGroupsById;
		Map<Id, Activity__c> activitiesByTemplateId;
		Map<Id, TaskTemplate__c> taskTemplatesById;
		Map<Id, List<Id>> rolesByLevelIds;
		Map<Id, SObject> needSummarySObjects;
		List<ActivityTemplate__c> activityTemplates;
		Id estimateId;
	}

	public static Estimate__c createEstimate(Id estimateTemplateId) {
		Map<Id, SObject> needSummarySObjects = new Map<Id, SObject>();

		EstimateTemplate__c estimateTemplate = CreateEstimateSupport.getEstimateTemplate(
			estimateTemplateId
		);
		Estimate__c estimateSO = Estimate.newSO(estimateTemplate);
		CRUDUtility.insertRecords(estimateSO);
		Map<Id, Id> rateCardItemIdByRoleId = ResourceDefaultService.getRateCardItemIdByRoleId(
			estimateTemplateId
		);
		needSummarySObjects.put(estimateSO.Id, estimateSO);

		Map<Id, Phase__c> phasesByTemplateId = CreateEstimateSupport.createPhases(
			estimateTemplate,
			estimateSO.Id
		);
		Map<Id, ActivityGroup__c> activityGroupsByTemplateId = CreateEstimateSupport.createActivityGroups(
			estimateTemplate.ActivityGroups__r,
			estimateSO.Id,
			phasesByTemplateId
		);

		needSummarySObjects.putAll(phasesByTemplateId.values());
		needSummarySObjects.putAll(activityGroupsByTemplateId.values());

		List<ActivityTemplate__c> activityTemplates = ActivityGroupTemplateService.getActivityTemplates(
			activityGroupsByTemplateId.keySet()
		);

		Map<Id, Activity__c> activitiesByTemplateId = createActivities(
			estimateSO.Id,
			activityTemplates,
			activityGroupsByTemplateId
		);

		TaskRequest taskRequest = new TaskRequest();
		taskRequest.activityGroupsById = new Map<Id, ActivityGroup__c>(
			activityGroupsByTemplateId.values()
		);
		taskRequest.activitiesByTemplateId = activitiesByTemplateId;
		taskRequest.estimateId = estimateSO.Id;
		taskRequest.needSummarySObjects = needSummarySObjects;
		taskRequest.activityTemplates = activityTemplates;
		List<ScopeParameter__c> scopeParams = ScopeParameterService.createScopeParametersForEstimate(
			activitiesByTemplateId,
			activityGroupsByTemplateId,
			estimateTemplateId
		);
		createTasks(taskRequest, scopeParams, rateCardItemIdByRoleId);
		return estimateSO;
	}

	private static void createTasks(
		TaskRequest taskRequest,
		List<ScopeParameter__c> scopeParams,
		Map<Id, Id> rateCardItemIdByRoleId
	) {
		Map<Id, TaskTemplate__c> taskTemplatesById = new Map<Id, TaskTemplate__c>();
		for (ActivityTemplate__c activityTemplateSO : taskRequest.activityTemplates) {
			// consolidating all the Task Templates
			if (!activityTemplateSO.Tasks__r.isEmpty()) {
				taskTemplatesById.putAll(activityTemplateSO.Tasks__r);
			}
		}

		taskRequest.needSummarySObjects.putAll(taskRequest.activitiesByTemplateId.values());

		// inserts TaskSummary__c records
		Map<Id, TaskSummary__c> summariesByParentId = TaskSummarySupport.createTaskSummaries(
			taskRequest.needSummarySObjects
		);

		if (!taskTemplatesById.values().isEmpty()) {
			Map<Id, List<Id>> rolesByLevelIds = new Map<Id, List<Id>>();
			taskRequest.taskTemplatesById = taskTemplatesById;
			taskRequest.rolesByLevelIds = rolesByLevelIds;
			List<Task__c> tasks = createTasksFromTemplate(taskRequest);

			Map<String, TaskRoleSummary__c> taskRoleSummaries = createTaskRoleSummaries(
				rolesByLevelIds,
				summariesByParentId
			);

			for (TaskRoleSummary__c roleSummary : taskRoleSummaries.values()) {
				if (roleSummary.SummaryLevel__c == TaskRoleSummary.SUMMARYLEVEL_ESTIMATE) {
					roleSummary.RateCardItemId__c = rateCardItemIdByRoleId.get(roleSummary.ResourceRoleId__c);
				}
			}

			assignSummaryLineage(taskRoleSummaries, taskRequest.needSummarySObjects);

			for (Task__c task : tasks) {
				String taskRoleSummaryToken = getTaskRoleSummaryKey(
					task.ActivityId__c,
					task.ResourceRoleId__c
				);
				TaskRoleSummary__c taskRoleSummary = taskRoleSummaries.get(taskRoleSummaryToken);
				task.RoleSummaryId__c = taskRoleSummary?.Id;
			}
			CRUDUtility.insertRecords(tasks);

			List<TaskParameterValue__c> taskParameters = createTaskParameters(
				tasks,
				taskTemplatesById.keySet(),
				scopeParams
			);
			CRUDUtility.insertRecords(taskParameters);
		}
	}

	public static void assignSummaryLineage(
		Map<String, TaskRoleSummary__c> taskRoleSummaries,
		Map<Id, SObject> needSummarySObjects
	) {
		for (TaskRoleSummary__c summary : taskRoleSummaries.values()) {
			Id roleId = summary.ResourceRoleId__c;
			Id parentId;
			if (summary.SummaryLevel__c == EstimatorConstants.ACTIVITY) {
				parentId = (Id) needSummarySObjects.get(summary.ActivityId__c)
					?.get(Schema.Activity__c.ActivityGroupId__c + '');
			} else if (summary.SummaryLevel__c == EstimatorConstants.ACTIVITY_GROUP) {
				parentId = (Id) needSummarySObjects.get(summary.ActivityGroupId__c)
					?.get(Schema.ActivityGroup__c.PhaseId__c + '');
				if (parentId == null) {
					parentId = (Id) needSummarySObjects.get(summary.ActivityGroupId__c)
						?.get(Schema.ActivityGroup__c.EstimateId__c + '');
				}
			} else if (summary.SummaryLevel__c == EstimatorConstants.PHASE) {
				parentId = (Id) needSummarySObjects.get(summary.PhaseId__c)
					?.get(Schema.Activity__c.EstimateId__c + '');
			}
			if (parentId != null) {
				summary.TaskRoleSummaryId__c = taskRoleSummaries.get(
						getTaskRoleSummaryKey(parentId, roleId)
					)
					?.Id;
			}
		}

		RuntimeContext.isCreateEstimateMode = true;
		CRUDUtility.updateRecords(taskRoleSummaries.values());
	}

	private static Map<Id, Activity__c> createActivities(
		Id estimateId,
		List<ActivityTemplate__c> activityTemplates,
		Map<Id, ActivityGroup__c> activityGroupsByTemplateId
	) {
		Map<Id, Activity__c> activitiesByTemplateId = new Map<Id, Activity__c>();

		for (ActivityTemplate__c activityTemplate : activityTemplates) {
			Activity__c activity = Activity.newSO(activityTemplate);
			activity.ActivityGroupId__c = activityGroupsByTemplateId.get(
					activityTemplate.ActivityGroupTemplateId__c
				)
				?.Id;
			activitiesByTemplateId.put(activityTemplate.Id, activity);
		}

		for (Activity__c activitySO : activitiesByTemplateId.values()) {
			activitySO.EstimateId__c = estimateId;
		}

		CRUDUtility.insertRecords(activitiesByTemplateId.values());
		return activitiesByTemplateId;
	}

	private static List<Task__c> createTasksFromTemplate(TaskRequest request) {
		List<Task__c> tasks = new List<Task__c>();

		for (TaskTemplate__c taskTemplate : request.taskTemplatesById.values()) {
			Task__c task = Task.newSO(taskTemplate);
			task.ActivityId__c = request.activitiesByTemplateId.get(taskTemplate.ActivityTemplateId__c)
				?.Id;
			task.ActivityGroupId__c = request.activitiesByTemplateId.get(
					taskTemplate.ActivityTemplateId__c
				)
				?.ActivityGroupId__c;
			task.PhaseId__c = request.activityGroupsById.get(task.ActivityGroupId__c)?.PhaseId__c;
			task.EstimateId__c = request.estimateId;
			tasks.add(task);

			populateSummaryDetails(task, request.rolesByLevelIds);
		}

		return tasks;
	}

	private static Map<String, TaskRoleSummary__c> createTaskRoleSummaries(
		Map<Id, List<Id>> roleSummariesByLevel,
		Map<Id, TaskSummary__c> summariesByParentId
	) {
		Map<String, TaskRoleSummary__c> summariesByProductAndParentId = new Map<String, TaskRoleSummary__c>();

		for (Id parentId : roleSummariesByLevel.keySet()) {
			for (Id roleId : roleSummariesByLevel.get(parentId)) {
				TaskRoleSummary__c roleSummary = new TaskRoleSummary__c();
				roleSummary.ResourceRoleId__c = roleId;
				roleSummary.SummaryId__c = summariesByParentId.get(parentId)?.Id;

				Schema.SObjectType parentType = parentId.getSObjectType();
				if (parentType == Activity__c.SObjectType) {
					roleSummary.ActivityId__c = parentId;
					roleSummary.SummaryLevel__c = EstimatorConstants.ACTIVITY;
				} else if (parentType == ActivityGroup__c.SObjectType) {
					roleSummary.ActivityGroupId__c = parentId;
					roleSummary.SummaryLevel__c = EstimatorConstants.ACTIVITY_GROUP;
				} else if (parentType == Estimate__c.SObjectType) {
					roleSummary.EstimateId__c = parentId;
					roleSummary.SummaryLevel__c = EstimatorConstants.ESTIMATE;
				} else if (parentType == Phase__c.SObjectType) {
					roleSummary.PhaseId__c = parentId;
					roleSummary.SummaryLevel__c = EstimatorConstants.PHASE;
				}

				summariesByProductAndParentId.put(getTaskRoleSummaryKey(parentId, roleId), roleSummary);
			}
		}

		CRUDUtility.insertRecords(summariesByProductAndParentId.values());

		return summariesByProductAndParentId;
	}

	private static List<TaskParameterValue__c> createTaskParameters(
		List<Task__c> tasks,
		Set<Id> taskTemplateIds,
		List<ScopeParameter__c> scopeParams
	) {
		List<TaskParameterValue__c> taskParameterValues = new List<TaskParameterValue__c>();
		Map<Id, TaskTemplate__c> taskParameterMap = new Map<Id, TaskTemplate__c>(
			[
				SELECT Id, (SELECT Id, ScopeParameterTemplateId__c FROM Parameters__r)
				FROM TaskTemplate__c
				WHERE Id IN :taskTemplateIds
				WITH SECURITY_ENFORCED
			]
		);

		Map<Id, Id> scopeParameterTemplateToScopeParamId = new Map<Id, Id>();
		for (ScopeParameter__c scopeParam : scopeParams) {
			scopeParameterTemplateToScopeParamId.put(scopeParam.TemplateId__c, scopeParam.Id);
		}

		for (Task__c task : tasks) {
			if (
				taskParameterMap.containsKey(task.TemplateId__c) &&
				taskParameterMap.get(task.TemplateId__c).Parameters__r != null
			) {
				for (
					TaskParameterTemplate__c taskParameterTemplate : taskParameterMap.get(task.TemplateId__c)
						.Parameters__r
				) {
					TaskParameterValue__c taskParameterValue = new TaskParameterValue__c();
					taskParameterValue.TaskId__c = task.Id;
					taskParameterValue.TemplateId__c = taskParameterTemplate.Id;
					taskParameterValue.ScopeParameterId__c = scopeParameterTemplateToScopeParamId.get(
						taskParameterTemplate.ScopeParameterTemplateId__c
					);
					taskParameterValues.add(taskParameterValue);
				}
			}
		}

		return taskParameterValues;
	}

	private static void populateSummaryDetails(Task__c task, Map<Id, List<Id>> rolesByLevelIds) {
		if (!rolesByLevelIds.containsKey(task.ActivityId__c)) {
			rolesByLevelIds.put(task.ActivityId__c, new List<Id>());
		}
		rolesByLevelIds.get(task.ActivityId__c).add(task.ResourceRoleId__c);

		if (!rolesByLevelIds.containsKey(task.ActivityGroupId__c)) {
			rolesByLevelIds.put(task.ActivityGroupId__c, new List<Id>());
		}
		rolesByLevelIds.get(task.ActivityGroupId__c).add(task.ResourceRoleId__c);

		if (!rolesByLevelIds.containsKey(task.EstimateId__c)) {
			rolesByLevelIds.put(task.EstimateId__c, new List<Id>());
		}
		rolesByLevelIds.get(task.EstimateId__c).add(task.ResourceRoleId__c);
		if (task.PhaseId__c != null) {
			if (!rolesByLevelIds.containsKey(task.PhaseId__c)) {
				rolesByLevelIds.put(task.PhaseId__c, new List<Id>());
			}
			rolesByLevelIds.get(task.PhaseId__c).add(task.ResourceRoleId__c);
		}
	}

	private static String getTaskRoleSummaryKey(Id sObjectId, Id resourceRoleId) {
		return (String) sObjectId + '-' + resourceRoleId;
	}
}
