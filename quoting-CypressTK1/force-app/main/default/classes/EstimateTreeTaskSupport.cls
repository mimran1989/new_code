/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class EstimateTreeTaskSupport {
	public static Map<Id, List<TaskParameterValue__c>> getTaskParameterValuesById(List<Id> taskIds) {
		List<TaskParameterValue__c> taskParameterValues = [
			SELECT
				Id,
				TemplateId__c,
				BooleanValue__c,
				IntegerValue__c,
				TextValue__c,
				TemplateId__r.Sequence__c,
				TaskId__r.Name,
				TaskId__r.ActivityId__r.Name,
				TaskId__r.ActivityId__r.ActivityGroupId__r.Name
			FROM TaskParameterValue__c
			WHERE TaskId__c IN :taskIds
			WITH SECURITY_ENFORCED
			ORDER BY TemplateId__r.Sequence__c ASC
		];

		Map<Id, List<TaskParameterValue__c>> taskParameterValuesByTaskId = new Map<Id, List<TaskParameterValue__c>>();
		for (TaskParameterValue__c taskParameterValue : taskParameterValues) {
			List<TaskParameterValue__c> taskParamValues = new List<TaskParameterValue__c>();
			if (taskParameterValuesByTaskId.containsKey(taskParameterValue.TaskId__c)) {
				taskParamValues = taskParameterValuesByTaskId.get(taskParameterValue.TaskId__c);
			}
			taskParamValues.add(taskParameterValue);
			taskParameterValuesByTaskId.put(taskParameterValue.TaskId__c, taskParamValues);
		}

		return taskParameterValuesByTaskId;
	}

	public static Map<Id, Map<Id, TaskParameterValue__c>> getTaskParameterValuesByTaskId(
		List<Id> taskIds
	) {
		Map<Id, List<TaskParameterValue__c>> taskParameterValuesByTaskId = getTaskParameterValuesById(
			taskIds
		);
		List<TaskParameterValue__c> taskParameterValues = new List<TaskParameterValue__c>();
		Map<Id, Map<Id, TaskParameterValue__c>> taskParameterValueMap = new Map<Id, Map<Id, TaskParameterValue__c>>();
		for (Id taskId : taskIds) {
			if (taskParameterValuesByTaskId.containsKey(taskId)) {
				taskParameterValues = taskParameterValuesByTaskId.get(taskId);
			}

			Map<Id, TaskParameterValue__c> taskParamByTemplateId = new Map<Id, TaskParameterValue__c>();
			if (!taskParameterValues.isEmpty()) {
				taskParamByTemplateId = (Map<Id, TaskParameterValue__c>) SystemUtility.keyByIdType(
					taskParameterValues,
					Schema.TaskParameterValue__c.TemplateId__c
				);
			}
			taskParameterValueMap.put(taskId, taskParamByTemplateId);
		}

		return taskParameterValueMap;
	}

	public static Map<Id, TaskParameterValue__c> getTaskParameterValueMap(Id taskId) {
		Map<Id, List<TaskParameterValue__c>> taskParameterValuesByTaskId = getTaskParameterValuesById(
			new List<Id>{ taskId }
		);
		List<TaskParameterValue__c> taskParameterValues = new List<TaskParameterValue__c>();
		if (taskParameterValuesByTaskId.containsKey(taskId)) {
			taskParameterValues = taskParameterValuesByTaskId.get(taskId);
		}

		Map<Id, TaskParameterValue__c> taskParameterValueMap = new Map<Id, TaskParameterValue__c>();
		if (!taskParameterValues.isEmpty()) {
			taskParameterValueMap = (Map<Id, TaskParameterValue__c>) SystemUtility.keyByIdType(
				taskParameterValues,
				Schema.TaskParameterValue__c.TemplateId__c
			);
		}

		return taskParameterValueMap;
	}

	public static Map<String, Object> getTaskDetails(String taskId) {
		Map<String, Object> finalMp = new Map<String, Object>();
		List<Object> dataFields = new List<Object>();
		Map<Id, TaskParameterValue__c> taskParameterValueMap = getTaskParameterValueMap(taskId);

		//Querying the taskparameters..it contains the field definition info
		for (TaskParameterTemplate__c taskParameterTemplate : [
			SELECT
				Id,
				TaskTemplateId__c,
				DataType__c,
				Name,
				Guidance__c,
				(
					SELECT Id, Name, Label__c, PerUnitDuration__c, FromValue__c, ToValue__c
					FROM ParameterValues__r
					ORDER BY Sequence__c ASC
				)
			FROM TaskParameterTemplate__c
			WHERE Id IN :taskParameterValueMap.keySet() AND IsActive__c = TRUE
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c ASC
		]) {
			dataFields.add(createTaskParams(taskParameterTemplate, taskParameterValueMap));
		}
		//taskId
		finalMp.put('TaskDetails', taskDetails(taskId));
		finalMp.put('TaskParams', dataFields);
		return finalMp;
	}

	private static Map<String, Object> createTaskParams(
		TaskParameterTemplate__c taskParameterTemplate,
		Map<Id, TaskParameterValue__c> taskParameterValueMap
	) {
		Map<String, Object> mapObject = new Map<String, Object>();
		mapObject.put(EstimatorConstants.DATA_TYPE, taskParameterTemplate.DataType__c);
		EstimateTreeSupport.processObject(taskParameterTemplate, mapObject, taskParameterValueMap);
		mapObject.put('FieldId', taskParameterTemplate.Id);
		mapObject.put('FieldName', taskParameterTemplate.Name);
		mapObject.put('Description', taskParameterTemplate.Guidance__c);
		mapObject.put(
			'PicklistValue',
			taskParameterValueMap.get(taskParameterTemplate.Id).TextValue__c
		);
		mapObject.put(
			'isIntegerTiers',
			taskParameterTemplate.DataType__c == 'Integer Tiers' ? true : false
		);
		mapObject.put('isNumberField', taskParameterTemplate.DataType__c == 'Integer' ? true : false);
		mapObject.put('isPickList', taskParameterTemplate.DataType__c == 'Picklist' ? true : false);
		mapObject.put('isBoolean', taskParameterTemplate.DataType__c == 'Checkbox' ? true : false);
		if (taskParameterTemplate.ParameterValues__r != null) {
			processTemplateValues(
				taskParameterTemplate.ParameterValues__r,
				mapObject,
				taskParameterTemplate
			);
		}
		return mapObject;
	}

	@TestVisible
	private static Map<String, Object> taskDetails(String taskId) {
		Task__c tk = [
			SELECT Id, Path__c, EstimateId__c
			FROM Task__c
			WHERE Id = :taskId
			WITH SECURITY_ENFORCED
		];
		Integer agSeq = Integer.valueof(tk.Path__c.split('\\.')[0]);
		Integer prvSeq = agSeq - 2;
		Integer nxtSeq = agSeq + 2;
		Map<Id, Task__c> activityTasks = new Map<Id, Task__c>(
			[
				SELECT
					Id,
					Path__c,
					Name,
					TemplateId__c,
					ActivityId__r.Name,
					ActivityId__r.ActivityGroupId__r.Name,
					IsNotApplicable__c,
					CalculatedDuration__c,
					LevelAdjustment__c,
					EstimatedDuration__c,
					ResourceRoleId__r.Name,
					AdjustmentReason__c
				FROM Task__c
				WHERE
					EstimateId__c = :tk.EstimateId__c
					AND ActivityId__r.ActivityGroupId__r.Sequence__c >= :prvSeq
					AND ActivityId__r.ActivityGroupId__r.Sequence__c <= :nxtSeq
				WITH SECURITY_ENFORCED
				ORDER BY Path__c ASC
			]
		);
		List<Id> tskIIds = new List<Id>(activityTasks.keySet());
		Map<String, Object> mpTask = new Map<String, Object>();
		Integer indx = tskIIds.indexOf(Id.valueOf(taskId));
		if (indx == 0) {
			mpTask = EstimateTreeSupport.taskDetailObject(activityTasks.get(taskId));
			mpTask.put('beforeExists', false);
			mpTask.put('afterExists', tskIIds.size() == 1 ? false : true);
			mpTask.put('beforeTaskId', '');
			mpTask.put('afterTaskId', tskIIds.size() == 1 ? '' : tskIIds[indx + 1]);
		} else if (indx == tskIIds.size() - 1) {
			mpTask = EstimateTreeSupport.taskDetailObject(activityTasks.get(taskId));
			mpTask.put('beforeExists', true);
			mpTask.put('afterExists', false);
			mpTask.put('beforeTaskId', tskIIds[indx - 1]);
			mpTask.put('afterTaskId', '');
		} else {
			mpTask = EstimateTreeSupport.taskDetailObject(activityTasks.get(taskId));
			mpTask.put('beforeExists', true);
			mpTask.put('afterExists', true);
			mpTask.put('beforeTaskId', tskIIds[indx - 1]);
			mpTask.put('afterTaskId', tskIIds[indx + 1]);
		}
		return mpTask;
	}

	private static void processTemplateValues(
		List<TaskParameterValueTemplate__c> taskParamRecords,
		Map<String, Object> mps,
		TaskParameterTemplate__c tp
	) {
		List<Object> tpaLst = new List<Object>();
		Map<String, String> picklistLabelValues = new Map<String, String>();
		for (TaskParameterValueTemplate__c tpv : taskParamRecords) {
			if (tp.DataType__c == 'Picklist') {
				Map<String, String> mpval = new Map<String, String>();
				mpval.put('label', tpv.Label__c);
				mpval.put('value', String.valueOf(tpv.PerUnitDuration__c));
				tpaLst.add(mpval);
				picklistLabelValues.put(tpv.Label__c, String.valueOf(tpv.PerUnitDuration__c));
			} else if (tp.DataType__c == 'Integer' || tp.DataType__c == 'Checkbox') {
				mps.put('Multiplier', tpv.PerUnitDuration__c);
			} else if (tp.DataType__c == 'Integer Tiers') {
				mps.put('IntegerTiers', tp.ParameterValues__r);
			}
		}
		if (tp.DataType__c == 'Picklist') {
			mps.put(
				'selectedValue',
				picklistLabelValues.containsKey(String.valueOf(mps.get('PicklistValue')))
					? picklistLabelValues.get(String.valueOf(mps.get('PicklistValue')))
					: ''
			);
		}
		mps.put('PicklistValues', tpaLst);
	}

	private static Map<Id, List<ScopeParameterValueTemplate__c>> getScopeParamValuesByScopeId(
		List<Id> scopeParamTemplateIds
	) {
		Map<Id, List<ScopeParameterValueTemplate__c>> scopeValuesByScopeId = new Map<Id, List<ScopeParameterValueTemplate__c>>();
		List<ScopeParameterValueTemplate__c> scopeValueTemplates = [
			SELECT Id, FromValue__c, ToValue__c, Label__c, Sequence__c, ScopeParameterTemplateId__c
			FROM ScopeParameterValueTemplate__c
			WHERE ScopeParameterTemplateId__c IN :scopeParamTemplateIds
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		];

		for (ScopeParameterValueTemplate__c nextScopeValueTemplateSo : scopeValueTemplates) {
			List<ScopeParameterValueTemplate__c> scopeValuesForScopeId = scopeValuesByScopeId.get(
				nextScopeValueTemplateSo.ScopeParameterTemplateId__c
			);
			if (scopeValuesForScopeId == null) {
				scopeValuesForScopeId = new List<ScopeParameterValueTemplate__c>();
				scopeValuesByScopeId.put(
					nextScopeValueTemplateSo.ScopeParameterTemplateId__c,
					scopeValuesForScopeId
				);
			}

			scopeValuesForScopeId.add(nextScopeValueTemplateSo);
		}

		return scopeValuesByScopeId;
	}

	public static void copyScopeParameterValueTemplates(
		List<TaskParameterTemplate__c> scopeChangedTemplates,
		List<Id> scopeChangedTemplateIds,
		List<Id> scopeParamTemplateIds
	) {
		Map<Id, List<ScopeParameterValueTemplate__c>> scopeValuesByScopeId = getScopeParamValuesByScopeId(
			scopeParamTemplateIds
		);

		List<TaskParameterValueTemplate__c> newParamValues = new List<TaskParameterValueTemplate__c>();
		for (TaskParameterTemplate__c nextChangedTemplate : scopeChangedTemplates) {
			List<ScopeParameterValueTemplate__c> contextScopeParamValues = scopeValuesByScopeId.get(
				nextChangedTemplate.ScopeParameterTemplateId__c
			);
			if (!SystemUtility.nullOrEmpty(contextScopeParamValues)) {
				for (ScopeParameterValueTemplate__c nextScopeParamValue : contextScopeParamValues) {
					newParamValues.add(
						new TaskParameterValueTemplate__c(
							TaskParameterTemplateId__c = nextChangedTemplate.Id,
							Sequence__c = nextScopeParamValue.Sequence__c,
							FromValue__c = nextScopeParamValue.FromValue__c,
							ToValue__c = nextScopeParamValue.ToValue__c,
							Label__c = nextScopeParamValue.Label__c
						)
					);
				}
			}
		}

		CRUDUtility.insertRecords(newParamValues);
	}
}
