/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class EstimateTreeSupport {
	public static final String ACTIVITY_GROUP = 'ActivityGroup';
	public static final String PHASE = 'Phase';

	public class FormulaDto {
		@AuraEnabled
		public String formula { get; set; }
		@AuraEnabled
		public Decimal selectedValue { get; set; }
		@AuraEnabled
		public Decimal perUnitDuration { get; set; }
		@AuraEnabled
		public String dataType { get; set; }
	}

	public static Object createActivityAndTask(
		List<Activity__c> activityList,
		List<String> gridExpandedIds,
		Map<Id, String> roleSumMp
	) {
		List<Object> activityGroupChildren = new List<Object>();

		List<Task__c> allTasks = new List<Task__c>();
		for (Activity__c activity : activityList) {
			if (activity.Tasks__r != null) {
				allTasks.addAll(activity.Tasks__r);
			}
		}
		Map<Id, Map<Id, FormulaDto>> durationFormulaByTaskId = getDurationFormulaByTaskId(allTasks);
		for (Activity__c activity : activityList) {
			Map<String, Object> activityMap = processActivity(activity, gridExpandedIds);
			List<Object> taskObj = new List<Object>();
			if (activity.Tasks__r != null) {
				for (Task__c task : activity.Tasks__r) {
					//Building the Task
					taskObj.add(processTask(task, gridExpandedIds, durationFormulaByTaskId));
				}
			}
			if (roleSumMp.containsKey(activity.Id)) {
				activityMap.put('Resourcerole', roleSumMp.get(activity.Id));
			}
			activityMap.put('_children', taskObj);
			activityGroupChildren.add(activityMap);
		}
		return activityGroupChildren;
	}

	public static Map<Id, Map<Id, FormulaDto>> getDurationFormulaByTaskId(List<Task__c> tasks) {
		Map<Id, Map<Id, FormulaDto>> taskParamDurationFormulaByTaskId = new Map<Id, Map<Id, FormulaDto>>();
		Map<Id, Id> taskIdByTaskTemplateId = new Map<Id, Id>();
		List<Id> taskIds = new List<Id>();
		for (Task__c task : tasks) {
			taskIdByTaskTemplateId.put(task.TemplateId__c, task.Id);
			taskIds.add(task.Id);
		}
		Map<Id, Map<Id, TaskParameterValue__c>> taskParameterValuesByTaskId = EstimateTreeTaskSupport.getTaskParameterValuesByTaskId(
			taskIds
		);

		List<TaskParameterValueTemplate__c> taskParameterValueTemplates = [
			SELECT
				Id,
				PerUnitDuration__c,
				EstimatedDurationFormula__c,
				TaskParameterTemplateId__c,
				TaskParameterTemplateId__r.DataType__c,
				TaskParameterTemplateId__r.TaskTemplateId__c
			FROM TaskParameterValueTemplate__c
			WHERE TaskParameterTemplateId__r.TaskTemplateId__c IN :taskIdByTaskTemplateId.keySet()
			WITH SECURITY_ENFORCED
		];

		for (TaskParameterValueTemplate__c taskParameterValueTemplate : taskParameterValueTemplates) {
			Id taskId = taskIdByTaskTemplateId.get(
				taskParameterValueTemplate.TaskParameterTemplateId__r.TaskTemplateId__c
			);
			Map<Id, TaskParameterValue__c> taskParameterValuesByTemplateId = taskParameterValuesByTaskId.get(
				taskId
			);
			Map<Id, FormulaDto> taskParamDurationFormulaForTaskId = taskParamDurationFormulaByTaskId.get(
				taskId
			);
			if (taskParamDurationFormulaForTaskId == null) {
				taskParamDurationFormulaForTaskId = new Map<Id, FormulaDto>();
				taskParamDurationFormulaByTaskId.put(taskId, taskParamDurationFormulaForTaskId);
			}

			FormulaDto formulaDto = new FormulaDto();
			formulaDto.formula = taskParameterValueTemplate.EstimatedDurationFormula__c;
			formulaDto.selectedValue = taskParameterValuesByTemplateId.get(
					taskParameterValueTemplate.TaskParameterTemplateId__c
				)
				?.IntegerValue__c;
			formulaDto.dataType = taskParameterValueTemplate.TaskParameterTemplateId__r.DataType__c;
			formulaDto.perUnitDuration = taskParameterValueTemplate.PerUnitDuration__c;
			taskParamDurationFormulaForTaskId.put(
				taskParameterValueTemplate.TaskParameterTemplateId__c,
				formulaDto
			);
		}

		return taskParamDurationFormulaByTaskId;
	}

	private static Map<String, Object> processActivity(
		Activity__c activity,
		List<String> gridExpanedIds
	) {
		Map<String, Object> activityMap = new Map<String, Object>();
		//Building the Activities
		activityMap.put('Type', 'Activity');
		activityMap.put(ACTIVITY_GROUP, activity.Path__c + ' ' + activity.Name);
		activityMap.put('ActivityGroupName', activity.Name);
		activityMap.put('ActivityGroupId', activity.Id);
		activityMap.put('EstimatedDuration', activity.TotalEstimatedDuration__c);
		activityMap.put('AdjustedDuration', activity.TotalAdjustments__c);
		activityMap.put('LevelAdjustments', activity.TotalLevelAdjustments__c);
		activityMap.put('CalculatedDuration', activity.TotalCalculatedDuration__c);
		activityMap.put('IconType', 'standard:work_type');
		activityMap.put('NotApplicable', activity.IsNotApplicable__c);
		activityMap.put('ActionbuttonTitle', 'Resource Summary');
		activityMap.put('ActionIcon', 'action:share_poll');
		gridExpanedIds.add(activity.Id);
		return activityMap;
	}

	private static Map<String, Object> processTask(
		Task__c task,
		List<String> gridExpandedIds,
		Map<Id, Map<Id, FormulaDto>> taskParamDurationFormulaByTaskId
	) {
		Map<String, Object> taskMap = new Map<String, Object>();
		taskMap.put('Type', 'Task');
		taskMap.put(ACTIVITY_GROUP, task.Path__c + ' ' + task.Name);
		taskMap.put('ActivityGroupName', task.Name);
		taskMap.put('ActivityGroupId', task.Id);
		taskMap.put('AdjustmentReason', task.AdjustmentReason__c);
		taskMap.put(
			'EstimatedDuration',
			task.EstimatedDuration__c != null ? task.EstimatedDuration__c : 0
		);
		taskMap.put('EstimatedDurationFormula', taskParamDurationFormulaByTaskId.get(task.Id));
		taskMap.put('AdjustedDuration', task.LevelAdjustment__c != null ? task.LevelAdjustment__c : 0);
		taskMap.put('LevelAdjustments', task.LevelAdjustment__c != null ? task.LevelAdjustment__c : 0);
		taskMap.put(
			'CalculatedDuration',
			task.CalculatedDuration__c != null ? task.CalculatedDuration__c : 0
		);
		taskMap.put('Resourcerole', task.ResourceRoleId__r.Name);
		taskMap.put('IconType', 'standard:task');
		taskMap.put('NotTouched', task.EstimatedDuration__c == 0 ? 'utility:warning' : '');
		if (task.IsNotApplicable__c) {
			taskMap.put('NotTouched', '');
		}
		taskMap.put('TaskTemplateId', task.TemplateId__c);
		taskMap.put('NotApplicable', task.IsNotApplicable__c);
		taskMap.put('ActionbuttonTitle', 'Edit Task');
		taskMap.put('ActionIcon', 'action:edit');
		gridExpandedIds.add(task.Id);
		return taskMap;
	}

	public static Map<String, Object> taskDetailObject(Task__c tk) {
		Map<Id, Map<Id, FormulaDto>> durationFormulaByTaskId = getDurationFormulaByTaskId(
			new List<Task__c>{ tk }
		);
		Map<String, Object> tskMp = new Map<String, Object>();
		tskMp.put('Type', 'Task');
		tskMp.put(EstimateTreeSupport.ACTIVITY_GROUP, tk.Path__c + ' ' + tk.Name);
		tskMp.put('ActivityGroupName', tk.Name);
		tskMp.put('ActivityGroupId', tk.Id);
		tskMp.put('AdjustmentReason', tk.AdjustmentReason__c);
		tskMp.put('EstimatedDurationFormula', durationFormulaByTaskId.get(tk.Id));
		tskMp.put('EstimatedDuration', tk.EstimatedDuration__c != null ? tk.EstimatedDuration__c : 0);
		tskMp.put('AdjustedDuration', tk.LevelAdjustment__c != null ? tk.LevelAdjustment__c : 0);
		tskMp.put(
			'CalculatedDuration',
			tk.CalculatedDuration__c != null ? tk.CalculatedDuration__c : 0
		);
		tskMp.put('Resourcerole', tk.ResourceRoleId__r.Name);
		tskMp.put('TaskTemplateId', tk.TemplateId__c);
		tskMp.put('NotApplicable', tk.IsNotApplicable__c);
		tskMp.put('Level2', tk.ActivityId__r.Name);
		tskMp.put('Level1', tk.ActivityId__r.ActivityGroupId__r.Name);
		return tskMp;
	}

	public static void processObject(
		TaskParameterTemplate__c taskParameterTemplate,
		Map<String, Object> mapObject,
		Map<Id, TaskParameterValue__c> taskParameterValueMap
	) {
		if (taskParameterValueMap.containsKey(taskParameterTemplate.Id)) {
			mapObject.put('TaskParameterValueId', taskParameterValueMap.get(taskParameterTemplate.Id).Id);
			if (taskParameterTemplate.DataType__c == EstimatorConstants.INTEGER_DATATYPE) {
				mapObject.put(
					'selectedValue',
					taskParameterValueMap.get(taskParameterTemplate.Id).IntegerValue__c != null
						? taskParameterValueMap.get(taskParameterTemplate.Id).IntegerValue__c
						: 0
				);
			}
			if (taskParameterTemplate.DataType__c == 'checkbox') {
				mapObject.put(
					'selectedValue',
					taskParameterValueMap.get(taskParameterTemplate.Id).BooleanValue__c
				);
			}
			if (taskParameterTemplate.DataType__c == 'Integer Tiers') {
				mapObject.put(
					'selectedValue',
					taskParameterValueMap.get(taskParameterTemplate.Id).IntegerValue__c
				);
			}
			mapObject.put('TaskName', taskParameterValueMap.get(taskParameterTemplate.Id).TaskId__r.Name);
			mapObject.put(
				'ActivityName',
				taskParameterValueMap.get(taskParameterTemplate.Id).TaskId__r.ActivityId__r.Name
			);
			mapObject.put(
				'ActivityGroupName',
				taskParameterValueMap.get(taskParameterTemplate.Id)
					.TaskId__r.ActivityId__r.ActivityGroupId__r.Name
			);
		}
	}
}
