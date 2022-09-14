/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class EstimateTemplateCreator {
	@AuraEnabled
	public static Boolean usesProjectPhases(String estimateTemplateId) {
		return [
			SELECT UseProjectPhases__c
			FROM EstimateTemplate__c
			WHERE Id = :estimateTemplateId
			WITH SECURITY_ENFORCED
		]
		.UseProjectPhases__c;
	}

	@AuraEnabled
	public static List<PhaseTemplate__c> getProjectPhase(String estimateTemplateId) {
		List<PhaseTemplate__c> phaseTemplateList = (List<PhaseTemplate__c>) ProjectPhaseFactory.getProjectPhase(
			estimateTemplateId
		);
		return phaseTemplateList;
	}

	@AuraEnabled
	public static List<ActivityTemplate__c> getActivities(String activityGroupTemplateId) {
		return [
			SELECT IsActive__c, Sequence__c, Guidance__c, Name, ActivityGroupTemplateId__c
			FROM ActivityTemplate__c
			WHERE ActivityGroupTemplateId__c = :activityGroupTemplateId
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c ASC
		];
	}

	@AuraEnabled
	public static List<ActivityTemplate__c> getActivitiesForActivityGroups(
		List<Id> activityGroupTemplateIds
	) {
		return [
			SELECT IsActive__c, Sequence__c, Guidance__c, Name, ActivityGroupTemplateId__c
			FROM ActivityTemplate__c
			WHERE ActivityGroupTemplateId__c = :activityGroupTemplateIds
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c ASC
		];
	}

	@AuraEnabled
	public static List<TaskTemplate__c> getTasks(String activityTemplateId) {
		return [
			SELECT IsActive__c, Sequence__c, Guidance__c, Name, ActivityTemplateId__c, ResourceRoleId__c
			FROM TaskTemplate__c
			WHERE ActivityTemplateId__c = :activityTemplateId
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c ASC
		];
	}

	@AuraEnabled
	public static List<TaskTemplate__c> getTasksForActivities(List<Id> activityTemplateIds) {
		return [
			SELECT IsActive__c, Sequence__c, Guidance__c, Name, ActivityTemplateId__c, ResourceRoleId__c
			FROM TaskTemplate__c
			WHERE ActivityTemplateId__c = :activityTemplateIds
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c ASC
		];
	}

	@AuraEnabled
	public static List<TaskParameterTemplate__c> getTaskParams(String taskTemplateId) {
		return [
			SELECT
				IsActive__c,
				Name,
				Sequence__c,
				DataType__c,
				Guidance__c,
				Description__c,
				DeveloperName__c,
				ScopeParameterTemplateId__c,
				TaskTemplateId__c
			FROM TaskParameterTemplate__c
			WHERE TaskTemplateId__c = :taskTemplateId
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c ASC
		];
	}

	@AuraEnabled
	public static List<TaskParameterTemplate__c> getTaskParamTemplates(List<Id> taskTemplateIds) {
		return [
			SELECT
				Id,
				IsActive__c,
				Name,
				Sequence__c,
				DataType__c,
				Guidance__c,
				Description__c,
				ScopeParameterTemplateId__c,
				TaskTemplateId__c
			FROM TaskParameterTemplate__c
			WHERE TaskTemplateId__c = :taskTemplateIds
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c ASC
		];
	}

	@AuraEnabled
	public static List<TaskParameterValueTemplate__c> getTaskParamValues(
		String taskParamsTemplateId
	) {
		return [
			SELECT
				Label__c,
				EstimatedDurationFormula__c,
				PerUnitDuration__c,
				FromValue__c,
				ToValue__c,
				Sequence__c,
				TaskParameterTemplateId__r.DataType__c
			FROM TaskParameterValueTemplate__c
			WHERE TaskParameterTemplateId__c = :taskParamsTemplateId
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c ASC
		];
	}

	@AuraEnabled
	public static List<TaskParameterValueTemplate__c> getTaskParamValueTemplates(
		List<Id> taskParamsTemplateIds
	) {
		return [
			SELECT
				Label__c,
				EstimatedDurationFormula__c,
				PerUnitDuration__c,
				FromValue__c,
				ToValue__c,
				Sequence__c,
				TaskParameterTemplateId__r.DataType__c
			FROM TaskParameterValueTemplate__c
			WHERE TaskParameterTemplateId__c = :taskParamsTemplateIds
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c ASC
		];
	}
	@AuraEnabled
	public static Boolean insertTaskParamsForClonedTasks(String recordString, String objectApiName) {
		try {
			List<TaskTemplateDto> clonedTaskTemplates = (List<TaskTemplateDto>) JSON.deserialize(
				recordString,
				List<TaskTemplateDto>.class
			);
			Map<Id, TaskTemplate__c> clonedTaskTemplateMap = new Map<Id, TaskTemplate__c>();
			for (TaskTemplateDto taskTemplateDtoRec : clonedTaskTemplates) {
				TaskTemplate__c taskTemplateRec = new TaskTemplate__c(
					Id = taskTemplateDtoRec.Id,
					Name = taskTemplateDtoRec.taskName,
					Guidance__c = taskTemplateDtoRec.guidance,
					Sequence__c = decimal.valueof(taskTemplateDtoRec.sequenceNumber),
					ResourceRoleId__c = taskTemplateDtoRec.resourceRole
				);
				clonedTaskTemplateMap.put(taskTemplateRec.Id, taskTemplateRec);
			}
			Map<Id, TaskTemplate__c> taskTemplateMap = new Map<Id, TaskTemplate__c>();
			Map<Id, TaskParameterTemplate__c> taskParameterTemplateMap = new Map<Id, TaskParameterTemplate__c>();
			EstimateTemplateCloner.cloneTaskTemplates(taskTemplateMap, clonedTaskTemplateMap);
			if (!SystemUtility.nullOrEmpty(taskTemplateMap)) {
				//Create Cloned Task Parameter Templates
				EstimateTemplateCloner.cloneTaskParameterTemplates(
					taskParameterTemplateMap,
					taskTemplateMap
				);
			}

			if (!SystemUtility.nullOrEmpty(taskParameterTemplateMap)) {
				//Create Cloned Tasks
				Map<Id, TaskParameterValueTemplate__c> taskParameterValueTemplateMap = new Map<Id, TaskParameterValueTemplate__c>();
				EstimateTemplateCloner.cloneTaskParameterValueTemplates(
					taskParameterValueTemplateMap,
					taskParameterTemplateMap
				);
			}

			return true;
		} catch (Exception e) {
			return false;
		}
	}
	@AuraEnabled
	public static String upsertTaskParamsValues(
		TaskParameterTemplate__c taskParamTemplateRecord,
		List<TaskParameterValueTemplate__c> taskParamValues
	) {
		if (String.valueOf(taskParamTemplateRecord.Id).startsWith(EstimatorConstants.RECORD)) {
			taskParamTemplateRecord.Id = null;
		}
		upsert taskParamTemplateRecord;
		for (TaskParameterValueTemplate__c tpVt : taskParamValues) {
			if (String.valueOf(tpVt.Id).startsWith(EstimatorConstants.RECORD)) {
				tpVt.Id = null;
			}
			tpVt.TaskParameterTemplateId__c = taskParamTemplateRecord.Id;
		}
		CRUDUtility.upsertRecords(taskParamValues);
		return 'Success';
	}

	@AuraEnabled
	public static void deleteRecords(List<Id> removeRecordIds) {
		List<SObject> records = new List<SObject>();
		for (Id removeRecordId : removeRecordIds) {
			records.add(removeRecordId.getSobjectType().newSObject(removeRecordId));
		}
		CRUDUtility.deleteRecords(records);
	}

	@AuraEnabled
	public static List<SObject> saveRecords(String recordString, String objectApiName) {
		List<SObject> recordsToUpdate = (List<SObject>) JSON.deserialize(
			recordString,
			Type.forName('List<' + objectApiName + '>')
		);
		CRUDUtility.upsertRecords(recordsToUpdate);
		return recordsToUpdate;
	}
	@AuraEnabled(Cacheable=true)
	public static List<TemplateElementDto> getTemplateStructure(String estimateId) {
		Boolean useProjectPhases = usesProjectPhases(estimateId);
		List<PhaseTemplate__c> phaseTemplateList = ProjectPhaseFactory.getPhaseTemplateList(estimateId);
		List<ActivityGroupTemplate__c> activityGroupTemplates = new List<ActivityGroupTemplate__c>();
		Map<Id, List<ActivityGroupTemplate__c>> activityGroupTemplatesByPhaseId = new Map<Id, List<ActivityGroupTemplate__c>>();

		Map<Id, ActivityGroupTemplate__c> activityGroupTemplatesById = ProjectPhaseFactory.getActivityGroupTemplateWithActivityMap(
			estimateId,
			activityGroupTemplatesByPhaseId
		);
		activityGroupTemplates = activityGroupTemplatesById.values();

		Map<Id, List<ActivityTemplate__c>> activityTemplatesByActivityGroupId = ProjectPhaseFactory.getActivityTemplatesWithTaskMap(
			activityGroupTemplatesById.keySet()
		);
		List<String> gridExpandedIds = new List<String>();
		List<TemplateElementDto> topLevelElements = new List<TemplateElementDto>();

		if (phaseTemplateList.size() > 0 && useProjectPhases) {
			for (PhaseTemplate__c phaseTemplate : phaseTemplateList) {
				TemplateElementDto phaseElementDto = new TemplateElementDto(phaseTemplate);
				gridExpandedIds.add(phaseTemplate.Id);

				List<ActivityGroupTemplate__c> actGrpTempRelToPhase = activityGroupTemplatesByPhaseId.containsKey(
						phaseTemplate.Id
					)
					? activityGroupTemplatesByPhaseId.get(phaseTemplate.Id)
					: new List<ActivityGroupTemplate__c>();
				List<TemplateElementDto> activityTaskStructure = createActivityGroupTemplates(
					activityTemplatesByActivityGroupId,
					gridExpandedIds,
					actGrpTempRelToPhase
				);
				phaseElementDto.children = activityTaskStructure;
				topLevelElements.add(phaseElementDto);
			}
		} else {
			List<TemplateElementDto> activityTaskStructure = createPhaseActivityGroupTemplates(
				gridExpandedIds,
				activityGroupTemplates,
				activityTemplatesByActivityGroupId
			);

			topLevelElements = activityTaskStructure;
		}
		return finalValues(topLevelElements, gridExpandedIds);
	}

	@TestVisible
	private static List<TemplateElementDto> finalValues(
		List<TemplateElementDto> topLevelElements,
		List<String> gridExpandedIds
	) {
		for (TemplateElementDto obj : topLevelElements) {
			obj.gridExpandedIds = gridExpandedIds;
			break;
		}
		return topLevelElements;
	}

	@TestVisible
	private static List<TemplateElementDto> createPhaseActivityGroupTemplates(
		List<String> gridExpandedIds,
		List<ActivityGroupTemplate__c> activityGroupTemplates,
		Map<Id, List<ActivityTemplate__c>> activityTemplatesByActivityGroupId
	) {
		List<TemplateElementDto> activityTemplateObj = new List<TemplateElementDto>();
		for (ActivityGroupTemplate__c activityGroupTemplateSo : activityGroupTemplates) {
			TemplateElementDto groupTemplateDto = new TemplateElementDto(activityGroupTemplateSo);
			groupTemplateDto.ParentLabel = activityGroupTemplateSo.Name;
			gridExpandedIds.add(activityGroupTemplateSo.Id);
			if (activityTemplatesByActivityGroupId.containsKey(activityGroupTemplateSo.Id)) {
				List<TemplateElementDto> activityTaskStructure = createActivityTemplates(
					activityTemplatesByActivityGroupId.get(activityGroupTemplateSo.Id),
					gridExpandedIds,
					activityGroupTemplateSo
				);
				groupTemplateDto.children = activityTaskStructure;
			}
			activityTemplateObj.add(groupTemplateDto);
		}
		return activityTemplateObj;
	}

	@TestVisible
	private static List<TemplateElementDto> createActivityGroupTemplates(
		Map<Id, List<ActivityTemplate__c>> activityTemplatesByActivityGroupId,
		List<String> gridExpandedIds,
		List<ActivityGroupTemplate__c> activityGroupTemplates
	) {
		List<TemplateElementDto> activityTemplateObj = new List<TemplateElementDto>();
		for (ActivityGroupTemplate__c groupTemplate : activityGroupTemplates) {
			TemplateElementDto groupElementDto = new TemplateElementDto(groupTemplate);
			groupElementDto.ParentLabel = groupTemplate.Name + '/';

			gridExpandedIds.add(groupTemplate.Id);
			if (activityTemplatesByActivityGroupId.containsKey(groupTemplate.Id)) {
				List<TemplateElementDto> activityTaskStructure = createActivityTemplates(
					activityTemplatesByActivityGroupId.get(groupTemplate.Id),
					gridExpandedIds,
					groupTemplate
				);
				groupElementDto.children = activityTaskStructure;
			}
			activityTemplateObj.add(groupElementDto);
		}
		return activityTemplateObj;
	}

	@TestVisible
	private static List<TemplateElementDto> createActivityTemplates(
		List<ActivityTemplate__c> activityTemplates,
		List<String> gridExpandedIds,
		ActivityGroupTemplate__c activityGroupTemplate
	) {
		List<TemplateElementDto> activityElementDtos = new List<TemplateElementDto>();
		for (ActivityTemplate__c activityTemplate : activityTemplates) {
			TemplateElementDto activityElementDto = new TemplateElementDto(activityTemplate);
			activityElementDto.ParentLabel = activityGroupTemplate.Name + '/' + activityTemplate.Name;

			gridExpandedIds.add(activityTemplate.Id);
			List<TemplateElementDto> taskObj = new List<TemplateElementDto>();
			if (activityTemplate.Tasks__r != null) {
				for (TaskTemplate__c taskTemplate : activityTemplate.Tasks__r) {
					TemplateElementDto taskElementDto = new TemplateElementDto(taskTemplate);
					taskElementDto.ParentLabel =
						activityGroupTemplate.Name +
						'/' +
						activityTemplate.Name +
						'/' +
						taskTemplate.Name;
					gridExpandedIds.add(taskTemplate.Id);
					taskObj.add(taskElementDto);
				}
				activityElementDto.children = taskObj;
			}
			activityElementDtos.add(activityElementDto);
		}
		return activityElementDtos;
	}
}
