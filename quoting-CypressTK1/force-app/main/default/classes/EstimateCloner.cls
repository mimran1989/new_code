/**
 *  Provus Services Quoting
 *  EstimateCloner : This is controller for EstimateCloner lwc component.
 *  @2021 Provus Inc. All rights reserved.
 */
@SuppressWarnings('PMD.CyclomaticComplexity')
@NamespaceAccessible
public with sharing class EstimateCloner {
	private static final string NAME_SPACE = SystemUtility.getNamespacePrefix();
	public class TaskRequest {
		Map<Id, ActivityGroup__c> activityGroupsById;
		Map<Id, Activity__c> activitiesById;
		Map<Id, Phase__c> phasesById;
		Map<Id, SObject> needSummarySObjects;
		Id estimateId;
		Estimate__c newEstimate;
		Map<Id, TaskRoleSummary__c> taskRoleSummaryById;
	}

	@AuraEnabled
	public static String cloneEstimateToQuote(
		String estimateId,
		String estimateName,
		Id clonedQuoteId
	) {
		Estimate__c newEstimate = cloneEstimate(estimateId, estimateName, clonedQuoteId);
		return newEstimate.Id;
	}

	@NamespaceAccessible
	public static Estimate__c cloneEstimate(
		String estimateId,
		String estimateName,
		Id clonedQuoteId
	) {
		Map<Id, SObject> needSummarySObjects = new Map<Id, SObject>();
		TaskRequest taskRequest = new TaskRequest();
		taskRequest.needSummarySObjects = needSummarySObjects;
		taskRequest.estimateId = estimateId;

		//Create Cloned Estimate
		taskRequest.newEstimate = processEstimate(taskRequest, estimateName, clonedQuoteId);
		taskRequest.phasesById = new Map<Id, Phase__c>();
		if (taskRequest.newEstimate.UseProjectPhases__c) {
			//Create Cloned Phases
			processPhases(taskRequest);
		}
		//Create Cloned ActivityGroup
		taskRequest.activityGroupsById = new Map<Id, ActivityGroup__c>();
		processActivityGroups(taskRequest);

		//Create Cloned Activity
		taskRequest.activitiesById = new Map<Id, Activity__c>();
		processActivities(taskRequest);

		//Create Cloned ScopeParameter for Activity
		Map<Id, ScopeParameter__c> scopeParameterMap = new Map<Id, ScopeParameter__c>();
		cloneScopeParameter(scopeParameterMap, taskRequest.activitiesById);

		//Create Cloned ScopeParameter For Estimate
		Map<Id, ScopeParameter__c> scopeParameterForEstimateMap = new Map<Id, ScopeParameter__c>();
		cloneScopeParameterForEstimate(
			scopeParameterForEstimateMap,
			taskRequest.newEstimate,
			estimateId
		);

		//Create Cloned ScopeParameter for ActivityGroup
		Map<Id, ScopeParameter__c> scopeParameterForActivityGroupMap = new Map<Id, ScopeParameter__c>();
		cloneScopeParameterForActivityGroup(
			scopeParameterForActivityGroupMap,
			taskRequest.activityGroupsById
		);

		//Create and update TaskSummary records
		updateSummaryObjects(taskRequest.needSummarySObjects);
		RuntimeContext.isCreateEstimateMode = true;

		// Inserting Task Role Summary
		Map<String, TaskRoleSummary__c> taskroleSummaryMapping = processTaskRoleSummaries(taskRequest);
		Map<Id, Task__c> taskMap = new Map<Id, Task__c>();
		// Inserting Task Records
		QueryRequest queryRequest = new QueryRequest(Task__c.SObjectType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(Schema.Task__c.SObjectType);
		queryRequest.setFilterBy(
			new Map<String, Set<Id>>{
				Schema.Task__c.ActivityId__c + '' => taskRequest.activitiesById.keySet()
			}
		);
		List<Task__c> tasks = (List<Task__c>) SOQLUtility.querySObject(queryRequest);

		for (Task__c task : tasks) {
			Task__c taskNew = task.clone(false, false, false, false);
			taskNew.ActivityId__c = taskRequest.activitiesById.get(task.ActivityId__c).Id;
			taskNew.ActivityGroupId__c = taskRequest.activityGroupsById.get(task.ActivityGroupId__c)?.Id;
			taskNew.EstimateId__c = taskRequest.newEstimate.Id;
			if (taskRequest.newEstimate.UseProjectPhases__c) {
				taskNew.PhaseId__c = taskRequest.phasesById.get(task.PhaseId__c).Id;
			}
			taskNew.RoleSummaryId__c = taskroleSummaryMapping.get(
					getTaskRoleSummaryKey(taskNew.ActivityId__c, task.ResourceRoleId__c)
				)
				?.Id;
			taskMap.put(task.Id, taskNew);
		}
		CRUDUtility.insertRecords(taskMap.values());

		Map<Id, Id> oldNewTaskRoleSummary = new Map<Id, Id>();
		for (Id taskOld : taskRequest.taskRoleSummaryById.keySet()) {
			oldNewTaskRoleSummary.put(taskOld, taskRequest.taskRoleSummaryById.get(taskOld).Id);
		}
		Set<Id> oldTaskRoleSummaryIds = oldNewTaskRoleSummary.keySet();
		createResourceSplits(oldNewTaskRoleSummary, oldTaskRoleSummaryIds);
		createResourceAvailabilityRecords(oldNewTaskRoleSummary, oldTaskRoleSummaryIds);

		Map<Id, Id> oldNewTasks = new Map<Id, Id>();
		for (Id taskOld : taskMap.keySet()) {
			oldNewTasks.put(taskOld, taskMap.get(taskOld).Id);
		}
		//Calling the Future method to avoid Governor Limits
		createTaskParamsValueInFuture(oldNewTasks);
		return taskRequest.newEstimate;
	}

	private static Map<String, TaskRoleSummary__c> processTaskRoleSummaries(TaskRequest taskRequest) {
		Set<Id> activityIds = taskRequest.activitiesById.keySet();
		Set<Id> activityGroupIds = taskRequest.activityGroupsById.keySet();
		Set<Id> phaseIds = taskRequest.phasesById.keySet();
		Id estimateId = taskRequest.estimateId;
		String taskRoleSummaryQuery =
			'SELECT ' +
			String.join(getObjectFields(NAME_SPACE + 'TaskRoleSummary__c'), ',') +
			' FROM ' +
			NAME_SPACE +
			'TaskRoleSummary__c WHERE ActivityId__c IN :activityIds OR ActivityGroupId__c IN :activityGroupIds OR EstimateId__c = :estimateId OR PhaseId__c IN :phaseIds WITH SECURITY_ENFORCED';
		Map<String, TaskRoleSummary__c> taskroleSummaryMapping = new Map<String, TaskRoleSummary__c>();
		taskRequest.taskRoleSummaryById = new Map<Id, TaskRoleSummary__c>();

		for (
			TaskRoleSummary__c taskRoleSummary : Database.query(
				String.escapeSingleQuotes(taskRoleSummaryQuery)
			)
		) {
			TaskRoleSummary__c taskRoleSummaryNew = taskRoleSummary.clone(false, false, false, false);
			if (taskRoleSummary.SummaryLevel__c == EstimatorConstants.ACTIVITY) {
				taskRoleSummaryNew.ActivityId__c = taskRequest.activitiesById.get(
						taskRoleSummary.ActivityId__c
					)
					.Id;
				taskRoleSummaryNew.SummaryId__c = String.valueof(
					taskRequest.needSummarySObjects.get(taskRoleSummaryNew.ActivityId__c)
						?.get(NAME_SPACE + 'SummaryId__c')
				);
				taskroleSummaryMapping.put(
					getTaskRoleSummaryKey(
						taskRoleSummaryNew.ActivityId__c,
						taskRoleSummary.ResourceRoleId__c
					),
					taskRoleSummaryNew
				);
			} else if (taskRoleSummary.SummaryLevel__c == EstimatorConstants.ACTIVITY_GROUP) {
				taskRoleSummaryNew.ActivityGroupId__c = taskRequest.activityGroupsById.get(
						taskRoleSummary.ActivityGroupId__c
					)
					.Id;
				taskRoleSummaryNew.SummaryId__c = String.valueof(
					taskRequest.needSummarySObjects.get(taskRoleSummaryNew.ActivityGroupId__c)
						?.get(NAME_SPACE + 'SummaryId__c')
				);
				taskroleSummaryMapping.put(
					getTaskRoleSummaryKey(
						taskRoleSummaryNew.ActivityGroupId__c,
						taskRoleSummary.ResourceRoleId__c
					),
					taskRoleSummaryNew
				);
			} else if (taskRoleSummary.SummaryLevel__c == EstimatorConstants.ESTIMATE) {
				taskRoleSummaryNew.EstimateId__c = taskRequest.newEstimate.Id;
				taskRoleSummaryNew.SummaryId__c = String.valueof(
					taskRequest.needSummarySObjects.get(taskRoleSummaryNew.EstimateId__c)
						?.get(NAME_SPACE + 'SummaryId__c')
				);
				taskroleSummaryMapping.put(
					getTaskRoleSummaryKey(
						taskRoleSummaryNew.EstimateId__c,
						taskRoleSummary.ResourceRoleId__c
					),
					taskRoleSummaryNew
				);
			} else if (taskRoleSummary.SummaryLevel__c == EstimateTreeSupport.PHASE) {
				taskRoleSummaryNew.PhaseId__c = taskRequest.phasesById.get(taskRoleSummary.PhaseId__c).Id;
				taskRoleSummaryNew.SummaryId__c = String.valueof(
					taskRequest.needSummarySObjects.get(taskRoleSummaryNew.PhaseId__c)
						?.get(NAME_SPACE + 'SummaryId__c')
				);
				taskroleSummaryMapping.put(
					getTaskRoleSummaryKey(taskRoleSummaryNew.PhaseId__c, taskRoleSummary.ResourceRoleId__c),
					taskRoleSummaryNew
				);
			}

			taskRequest.taskRoleSummaryById.put(taskRoleSummary.Id, taskRoleSummaryNew);
		}

		CRUDUtility.insertRecords(taskroleSummaryMapping.values());

		CreateEstimateService.assignSummaryLineage(
			taskroleSummaryMapping,
			taskRequest.needSummarySObjects
		);

		return taskroleSummaryMapping;
	}

	public static Estimate__c processEstimate(
		TaskRequest taskRequest,
		String clonedEstimateName,
		Id clonedQuoteId
	) {
		QueryRequest queryRequest = new QueryRequest(Estimate__c.SObjectType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(
			Schema.Estimate__c.SObjectType
		);
		queryRequest.setFilterBy(
			new Map<String, String>{ SObjectUtility.FIELD_ID => taskRequest.estimateId }
		);
		List<Estimate__c> estimates = (List<Estimate__c>) SOQLUtility.querySObject(queryRequest);
		Estimate__c existingEstimate = estimates[0];
		Estimate__c newEstimate = existingEstimate.clone(false, false, false, false);
		newEstimate.DerivedFromId__c = existingEstimate.Id;
		newEstimate.QuoteId__c = clonedQuoteId;
		if (clonedEstimateName != null) {
			newEstimate.Name = clonedEstimateName;
		} else {
			newEstimate.Name = 'Clone : ' + newEstimate.Name;
		}

		CRUDUtility.insertRecords(newEstimate);
		taskRequest.needSummarySObjects.put(newEstimate.Id, newEstimate);
		return newEstimate;
	}

	public static void processActivityGroups(TaskRequest taskRequest) {
		QueryRequest queryRequest = new QueryRequest(ActivityGroup__c.SObjectType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(
			Schema.ActivityGroup__c.SObjectType
		);
		queryRequest.setFilterBy(
			new Map<String, String>{
				Schema.ActivityGroup__c.EstimateId__c + '' => taskRequest.estimateId
			}
		);
		List<ActivityGroup__c> activityGroups = (List<ActivityGroup__c>) SOQLUtility.querySObject(
			queryRequest
		);
		for (ActivityGroup__c activityGroup : activityGroups) {
			ActivityGroup__c activityGroupNew = activityGroup.clone(false, false, false, false);
			activityGroupNew.EstimateId__c = taskRequest.newEstimate.Id;
			if (taskRequest.newEstimate.UseProjectPhases__c) {
				activityGroupNew.PhaseId__c = taskRequest.phasesById.get(activityGroupNew.PhaseId__c)?.Id;
			}
			taskRequest.activityGroupsById.put(activityGroup.Id, activityGroupNew);
		}
		CRUDUtility.insertRecords(taskRequest.activityGroupsById.values());
		taskRequest.needSummarySObjects.putAll(taskRequest.activityGroupsById.values());
	}

	public static void processPhases(TaskRequest taskRequest) {
		QueryRequest queryRequest = new QueryRequest(Phase__c.SObjectType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(Schema.Phase__c.SObjectType);
		queryRequest.setFilterBy(
			new Map<String, String>{ Schema.Phase__c.EstimateId__c + '' => taskRequest.estimateId }
		);
		List<Phase__c> phases = (List<Phase__c>) SOQLUtility.querySObject(queryRequest);
		for (Phase__c phase : phases) {
			Phase__c phaseNew = phase.clone(false, false, false, false);
			phaseNew.EstimateId__c = taskRequest.newEstimate.Id;
			taskRequest.phasesById.put(phase.Id, phaseNew);
		}
		CRUDUtility.insertRecords(taskRequest.phasesById.values());
		taskRequest.needSummarySObjects.putAll(taskRequest.phasesById.values());
	}
	public static void processActivities(TaskRequest taskRequest) {
		QueryRequest queryRequest = new QueryRequest(Activity__c.SObjectType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(
			Schema.Activity__c.SObjectType
		);
		queryRequest.setFilterBy(
			new Map<String, Set<Id>>{
				Schema.Activity__c.ActivityGroupId__c + '' => taskRequest.activityGroupsById.KeySet()
			}
		);
		List<Activity__c> activities = (List<Activity__c>) SOQLUtility.querySObject(queryRequest);
		for (Activity__c activity : activities) {
			Activity__c activityNew = activity.clone(false, false, false, false);
			ActivityGroup__c newActivityGroup = taskRequest.activityGroupsById.get(
				activity.ActivityGroupId__c
			);
			activityNew.ActivityGroupId__c = newActivityGroup?.Id;
			activityNew.EstimateId__c = newActivityGroup?.EstimateId__c;
			taskRequest.activitiesById.put(activity.Id, activityNew);
		}
		CRUDUtility.insertRecords(taskRequest.activitiesById.values());
		taskRequest.needSummarySObjects.putAll(taskRequest.activitiesById.values());
	}
	public static void updateSummaryObjects(Map<Id, SObject> needSummarySObjects) {
		List<TaskSummary__c> taskSummaryToInsert = new List<TaskSummary__c>();
		for (Id recordId : needSummarySObjects.keySet()) {
			taskSummaryToInsert.add(new TaskSummary__c());
		}
		CRUDUtility.insertRecords(taskSummaryToInsert);
		Integer i = 0;
		for (Sobject record : needSummarySObjects.values()) {
			record.put(NAME_SPACE + 'SummaryId__c', taskSummaryToInsert[i].Id);
			i++;
		}
		CRUDUtility.updateRecords(needSummarySObjects.values());
	}

	@Future
	public static void createTaskParamsValueInFuture(Map<Id, Id> oldNewTasks) {
		QueryRequest queryRequest = new QueryRequest(TaskParameterValue__c.SObjectType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(
			Schema.TaskParameterValue__c.SObjectType
		);
		queryRequest.setFilterBy(
			new Map<String, Set<Id>>{
				Schema.TaskParameterValue__c.TaskId__c + '' => oldNewTasks.keySet()
			}
		);
		List<TaskParameterValue__c> taskParameters = (List<TaskParameterValue__c>) SOQLUtility.querySObject(
			queryRequest
		);
		Map<Id, TaskParameterValue__c> taskParameterMap = new Map<Id, TaskParameterValue__c>();
		for (TaskParameterValue__c taskParam : taskParameters) {
			TaskParameterValue__c taskParameterNew = taskParam.clone(false, false, false, false);
			taskParameterNew.TemplateId__c = taskParam.TemplateId__c;
			taskParameterNew.TaskId__c = oldNewTasks.get(taskParam.TaskId__c);
			taskParameterMap.put(taskParam.Id, taskParameterNew);
		}
		CRUDUtility.insertRecords(taskParameterMap.values());
	}

	public static void createResourceAvailabilityRecords(
		Map<Id, Id> taskRoleSummaryById,
		Set<Id> taskRoleSummaryIds
	) {
		SObjectType objectType = ResourceAvailability__c.SObjectType;
		QueryRequest queryRequest = new QueryRequest(objectType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(objectType);
		queryRequest.setFilterBy(
			new Map<String, Set<Id>>{
				Schema.ResourceSplit__c.TaskRoleSummaryId__c + '' => taskRoleSummaryIds
			}
		);
		List<ResourceAvailability__c> resourceAvailabilityRecords = (List<ResourceAvailability__c>) SOQLUtility.querySObject(
			queryRequest
		);
		Map<Id, ResourceAvailability__c> resourceAvailabilityMap = new Map<Id, ResourceAvailability__c>();
		for (ResourceAvailability__c resourceAvailability : resourceAvailabilityRecords) {
			ResourceAvailability__c newResourceAvailability = resourceAvailability.clone(
				false,
				false,
				false,
				false
			);
			newResourceAvailability.TaskRoleSummaryId__c = taskRoleSummaryById.get(
				resourceAvailability.TaskRoleSummaryId__c
			);
			resourceAvailabilityMap.put(resourceAvailability.Id, newResourceAvailability);
		}
		CRUDUtility.insertRecords(resourceAvailabilityMap.values());
	}

	public static void createResourceSplits(
		Map<Id, Id> taskRoleSummaryById,
		Set<Id> taskRoleSummaryIds
	) {
		SObjectType objectType = ResourceSplit__c.SObjectType;
		QueryRequest queryRequest = new QueryRequest(objectType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(objectType);
		queryRequest.setFilterBy(
			new Map<String, Set<Id>>{
				Schema.ResourceSplit__c.TaskRoleSummaryId__c + '' => taskRoleSummaryIds
			}
		);
		List<ResourceSplit__c> resourceSplits = (List<ResourceSplit__c>) SOQLUtility.querySObject(
			queryRequest
		);
		Map<Id, ResourceSplit__c> resourceSplitMap = new Map<Id, ResourceSplit__c>();
		for (ResourceSplit__c resourceSplit : resourceSplits) {
			ResourceSplit__c resourceSplitNew = resourceSplit.clone(false, false, false, false);
			resourceSplitNew.TaskRoleSummaryId__c = taskRoleSummaryById.get(
				resourceSplit.TaskRoleSummaryId__c
			);
			resourceSplitMap.put(resourceSplit.Id, resourceSplitNew);
		}
		CRUDUtility.insertRecords(resourceSplitMap.values());
	}

	public static List<String> getObjectFields(string objectApiName) {
		SObjectType contactType = Schema.getGlobalDescribe().get(objectApiName);
		Map<String, Schema.SObjectField> mfields = contactType.getDescribe().fields.getMap();
		List<String> sObjectDetailsList = new List<String>();
		for (String field : mfields.keySet()) {
			if (mfields.get(field).getDescribe().isAccessible()) {
				sObjectDetailsList.add(String.valueOf(mfields.get(field)));
			}
		}
		return sObjectDetailsList;
	}

	private static String getTaskRoleSummaryKey(Id sObjectId, Id resourceRoleId) {
		return (String) sObjectId + '-' + resourceRoleId;
	}

	//clone ScopeParameter for Activity
	public static void cloneScopeParameter(
		Map<Id, ScopeParameter__c> scopeParameterMap,
		Map<Id, Activity__c> activityMap
	) {
		Set<Id> activityOldIds = activityMap.KeySet();
		QueryRequest queryRequest = new QueryRequest(Schema.ScopeParameter__c.SObjectType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(
			Schema.ScopeParameter__c.SObjectType
		);
		queryRequest.setFilterBy(
			new Map<String, Set<Id>>{ Schema.ScopeParameter__c.ActivityId__c + '' => activityOldIds }
		);
		List<ScopeParameter__c> listScopeParameters = (List<ScopeParameter__c>) SOQLUtility.querySObject(
			queryRequest
		);
		for (ScopeParameter__c scopeParameter : listScopeParameters) {
			ScopeParameter__c scopeParameterNew = scopeParameter.clone();
			scopeParameterNew.ActivityId__c = activityMap.get(scopeParameterNew.ActivityId__c).Id;
			scopeParameterMap.put(scopeParameter.Id, scopeParameterNew);
		}
		CRUDUtility.insertRecords(scopeParameterMap.values());
	}
	//clone ScopeParameter for ActivityGroup
	public static void cloneScopeParameterForActivityGroup(
		Map<Id, ScopeParameter__c> scopeParameterForActivityGroupMap,
		Map<Id, ActivityGroup__c> activityGroupMap
	) {
		Set<Id> activityGroupOldIds = activityGroupMap.KeySet();
		QueryRequest queryRequest = new QueryRequest(Schema.ScopeParameter__c.SObjectType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(
			Schema.ScopeParameter__c.SObjectType
		);
		queryRequest.setFilterBy(
			new Map<String, Set<Id>>{
				Schema.ScopeParameter__c.ActivityGroupId__c + '' => activityGroupOldIds
			}
		);
		List<ScopeParameter__c> listScopeParameters = (List<ScopeParameter__c>) SOQLUtility.querySObject(
			queryRequest
		);
		for (ScopeParameter__c scopeParameter : listScopeParameters) {
			ScopeParameter__c scopeParameterNew = scopeParameter.clone();
			scopeParameterNew.ActivityGroupId__c = activityGroupMap.get(
					scopeParameterNew.ActivityGroupId__c
				)
				.Id;
			scopeParameterForActivityGroupMap.put(scopeParameter.Id, scopeParameterNew);
		}
		CRUDUtility.insertRecords(scopeParameterForActivityGroupMap.values());
	}
	//clone ScopeParameter for Estimate
	public static void cloneScopeParameterForEstimate(
		Map<Id, ScopeParameter__c> scopeParameterForEstimateMap,
		Estimate__c newEstimate,
		Id estimateId
	) {
		QueryRequest queryRequest = new QueryRequest(Schema.ScopeParameter__c.SObjectType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(
			Schema.ScopeParameter__c.SObjectType
		);
		queryRequest.setFilterBy(
			new Map<String, String>{ Schema.ScopeParameter__c.EstimateId__c + '' => estimateId }
		);
		List<ScopeParameter__c> listScopeParameters = (List<ScopeParameter__c>) SOQLUtility.querySObject(
			queryRequest
		);
		for (ScopeParameter__c scopeParameter : listScopeParameters) {
			ScopeParameter__c scopeParameterNew = scopeParameter.clone();
			scopeParameterNew.EstimateId__c = newEstimate.Id;
			scopeParameterForEstimateMap.put(scopeParameter.Id, scopeParameterNew);
		}
		CRUDUtility.insertRecords(scopeParameterForEstimateMap.values());
	}
}
