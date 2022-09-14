/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class TaskDiscoveryController {
	@AuraEnabled
	public static List<TaskDto> getTasks(Id estimateId) {
		Map<Id, TaskParameterValueDto> paramValuesByTaskTemplateId = new Map<Id, TaskParameterValueDto>();
		Map<Id, TaskDto> tasksByTaskTemplateId = new Map<Id, TaskDto>();
		List<TaskDto> tasks = new List<TaskDto>();
		Set<Id> taskTemplateIds = new Set<Id>();
		for (Task__c taskSo : [
			SELECT
				Id,
				CalculatedDuration__c,
				LevelAdjustment__c,
				AdjustmentReason__c,
				EstimatedDuration__c,
				ResourceRoleId__r.Name,
				ActivityGroupId__r.PhaseId__r.Name,
				ActivityGroupId__r.Name,
				ActivityGroupId__c,
				ActivityId__r.Name,
				TemplateId__c,
				IsNotApplicable__c,
				Name,
				(
					SELECT Id, BooleanValue__c, IntegerValue__c, TextValue__c, TemplateId__c
					FROM ParameterValues__r
				)
			FROM Task__c
			WHERE EstimateId__c = :estimateId
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c
		]) {
			TaskDto taskDto = new TaskDto(taskSo);
			tasks.add(taskDto);
			if (!SystemUtility.nullOrEmpty(taskSo.ParameterValues__r)) {
				for (TaskParameterValue__c taskParameterValueSo : taskSo.ParameterValues__r) {
					paramValuesByTaskTemplateId.put(
						taskParameterValueSo.TemplateId__c,
						new TaskParameterValueDto(taskParameterValueSo)
					);
				}
			}
			taskTemplateIds.add(taskSo.TemplateId__c);
			tasksByTaskTemplateId.put(taskSo.TemplateId__c, taskDto);
		}

		for (TaskParameterTemplate__c taskParameterTemplateSo : [
			SELECT
				DataType__c,
				Description__c,
				DeveloperName__c,
				Guidance__c,
				Id,
				IsActive__c,
				Name,
				ScopeParameterTemplateId__c,
				Sequence__c,
				TaskTemplateId__c,
				(
					SELECT
						Id,
						EstimatedDurationFormula__c,
						ToValue__c,
						FromValue__c,
						Label__c,
						PerUnitDuration__c,
						EstimatedDuration__c
					FROM ParameterValues__r
				)
			FROM TaskParameterTemplate__c
			WHERE TaskTemplateId__c IN :taskTemplateIds
			WITH SECURITY_ENFORCED
		]) {
			TaskDto task = tasksByTaskTemplateId.get(taskParameterTemplateSo.TaskTemplateId__c);
			TaskParameterTemplateDto taskParameterTemplate = new TaskParameterTemplateDto(
				taskParameterTemplateSo
			);
			taskParameterTemplate.parameterValue = paramValuesByTaskTemplateId.get(
				taskParameterTemplateSo.Id
			);
			task.parameterTemplates.add(taskParameterTemplate);
		}

		return tasks;
	}

	@AuraEnabled
	public static void saveTasks(List<TaskDto> tasks) {
		List<Task__c> taskSos = new List<Task__c>();
		List<TaskParameterValue__c> taskParameterValueSos = new List<TaskParameterValue__c>();
		for (TaskDto taskDto : tasks) {
			taskSos.add(
				new Task__c(
					Id = taskDto.id,
					CalculatedDuration__c = taskDto.totalCalculatedDuration,
					EstimatedDuration__c = taskDto.totalEstimatedDuration,
					LevelAdjustment__c = taskDto.levelAdjustment,
					AdjustmentReason__c = taskDto.adjustmentReason,
					IsNotApplicable__c = taskDto.isNotApplicable
				)
			);

			if (!SystemUtility.nullOrEmpty(taskDto.parameterTemplates)) {
				for (TaskParameterTemplateDto parameterTemplateDto : taskDto.parameterTemplates) {
					if (parameterTemplateDto.parameterValue != null) {
						taskParameterValueSos.add(
							(TaskParameterValue__c) parameterTemplateDto.parameterValue.refreshSo()
						);
					}
				}
			}
		}

		CRUDUtility.updateRecords(taskSos);
		CRUDUtility.updateRecords(taskParameterValueSos);
	}
}
