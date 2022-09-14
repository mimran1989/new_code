import ADJUSTMENTREASON_FIELD from '@salesforce/schema/Task__c.AdjustmentReason__c';
import CALCULATEDDURATION_FIELD from '@salesforce/schema/Task__c.CalculatedDuration__c';
import ESTIMATEEDDURATION_FIELD from '@salesforce/schema/Task__c.EstimatedDuration__c';
import ISNOTAPPLICABLE_FIELD from '@salesforce/schema/Task__c.IsNotApplicable__c';
import LEVELADJUSTMENT_FIELD from '@salesforce/schema/Task__c.LevelAdjustment__c';

import TASKPARAM_TASKID_NAME_FIELD from '@salesforce/schema/TaskParameterValue__c.TaskId__r.Name';
import TASKPARAM_TASKID_ACTIVITY_NAME_FIELD from '@salesforce/schema/TaskParameterValue__c.TaskId__r.ActivityId__r.Name';
import TASKPARAM_TASKID_ACTIVITYGROUP_NAME_FIELD from '@salesforce/schema/TaskParameterValue__c.TaskId__r.ActivityId__r.ActivityGroupId__r.Name';
import TASKPARAM_TASKID_ACTIVITYGROUP_PHASE_NAME_FIELD from '@salesforce/schema/TaskParameterValue__c.TaskId__r.ActivityGroupId__r.PhaseId__r.Name';
import TASKPARAM_TEMPLATE_NAME_FIELD from '@salesforce/schema/TaskParameterValue__c.TemplateId__r.Name';
import TASKPARAM_TEMPLATE_DATATYPE_FIELD from '@salesforce/schema/TaskParameterValue__c.TemplateId__r.DataType__c';
import TASK_NOTAPPPLICABLE_FIELD from '@salesforce/schema/TaskParameterValue__c.TaskId__r.IsNotApplicable__c';
import TASK_ESTIMATEEDDURATION_FIELD from '@salesforce/schema/TaskParameterValue__c.TaskId__r.EstimatedDuration__c';

import BOOLEANVALUE_FIELD from '@salesforce/schema/TaskParameterValue__c.BooleanValue__c';
import INTEGERVALUE_FIELD from '@salesforce/schema/TaskParameterValue__c.IntegerValue__c';
import TEXTVALUE_FIELD from '@salesforce/schema/TaskParameterValue__c.TextValue__c';

import { getPropByString } from 'c/util';
import { HASHTAG_USER_INPUT } from './estimateTreeGridConstants';

const buildScopeSummaryColumns = (isPhasesEnabled) => {
	const sourceColumns = [];
	const types = ['text', 'boolean'];
	const fieldNames = ['ActivityGroup', 'Activity', 'Taskname', 'NotApplicable', 'Taskparams', 'UserInput', 'TaskEstimatedDuration'];
	const labels = ['Activity Group', 'Activity', 'Task', 'N/A', 'Parameter Name', 'User Input', 'Estimated Duration'];
	if (isPhasesEnabled) {
		fieldNames.unshift('Phase');
		labels.unshift('Phase');
	}

	for (let fieldNameIns = 0; fieldNameIns < fieldNames.length; fieldNameIns++) {
		const varIns = {
			type: fieldNames[fieldNameIns] === 'NotApplicable' ? types[1] : types[0],
			fieldName: fieldNames[fieldNameIns],
			label: labels[fieldNameIns],
			sortable: 'true',
			initialWidth: fieldNames[fieldNameIns] === 'NotApplicable' ? 50 : 0,
		};

		sourceColumns.push(varIns);
	}

	return sourceColumns;
};

const buildTaskRecord = (taskDetails) => {
	const task = {};
	task.Id = taskDetails.ActivityGroupId;
	task[ADJUSTMENTREASON_FIELD.fieldApiName] = taskDetails.AdjustmentReason;
	task[CALCULATEDDURATION_FIELD.fieldApiName] = taskDetails.CalculatedDuration;
	task[ESTIMATEEDDURATION_FIELD.fieldApiName] = +taskDetails.CalculatedDuration + +taskDetails.AdjustedDuration;
	task[ISNOTAPPLICABLE_FIELD.fieldApiName] = taskDetails.NotApplicable;
	task[LEVELADJUSTMENT_FIELD.fieldApiName] = taskDetails.AdjustedDuration;

	if (taskDetails.NotApplicable) {
		task[ADJUSTMENTREASON_FIELD.fieldApiName] = '';
		task[CALCULATEDDURATION_FIELD.fieldApiName] = 0;
		task[ESTIMATEEDDURATION_FIELD.fieldApiName] = 0;
		task[LEVELADJUSTMENT_FIELD.fieldApiName] = 0;
	}

	return task;
};

const buildTaskParameterValueRecord = (ele, isPhasesEnabled) => {
	const rec = {};

	rec.Taskname = getPropByString(ele, TASKPARAM_TASKID_NAME_FIELD.fieldApiName);
	rec.Id = ele.Id;

	if (isPhasesEnabled) {
		rec.Phase = getPropByString(ele, TASKPARAM_TASKID_ACTIVITYGROUP_PHASE_NAME_FIELD.fieldApiName);
	}

	rec.ActivityGroup = getPropByString(ele, TASKPARAM_TASKID_ACTIVITYGROUP_NAME_FIELD.fieldApiName);
	rec.Activity = getPropByString(ele, TASKPARAM_TASKID_ACTIVITY_NAME_FIELD.fieldApiName);
	rec.Taskparams = getPropByString(ele, TASKPARAM_TEMPLATE_NAME_FIELD.fieldApiName);
	rec.TaskEstimatedDuration = getPropByString(ele, TASK_ESTIMATEEDDURATION_FIELD.fieldApiName);

	if (getPropByString(ele, TASKPARAM_TEMPLATE_DATATYPE_FIELD.fieldApiName) === 'Integer'
		|| getPropByString(ele, TASKPARAM_TEMPLATE_DATATYPE_FIELD.fieldApiName) === 'Integer Tiers') {
		rec.UserInput = getPropByString(ele, INTEGERVALUE_FIELD.fieldApiName);
	} else if (getPropByString(ele, TASKPARAM_TEMPLATE_DATATYPE_FIELD.fieldApiName) === 'Checkbox') {
		rec.UserInput = getPropByString(ele, BOOLEANVALUE_FIELD.fieldApiName) ? 'Yes' : 'No';
	} else if (getPropByString(ele, TASKPARAM_TEMPLATE_DATATYPE_FIELD.fieldApiName) === 'Picklist') {
		rec.UserInput = getPropByString(ele, TEXTVALUE_FIELD.fieldApiName);
	}

	rec.NotApplicable = getPropByString(ele, TASK_NOTAPPPLICABLE_FIELD.fieldApiName);

	return rec;
};

const isUserInputFormula = (formula) => (
	formula.toLowerCase().indexOf(HASHTAG_USER_INPUT) > -1
);

const getTasksToUpdate = (gridData) => {
	let tasksToUpdate = [];
	gridData.forEach((activityGroup) => {
		const activities = activityGroup._children || [];
		activities.forEach((activity) => {
			const tasks = activity._children || [];
			tasks.forEach((task) => {
				// only process if there are any formulas
				if (task.EstimatedDurationFormula) {
					// if there are formulas, then we want to save the tasks
					// except with we are looking for user input
					let hasUserFormula = false;
					const formulaDtos = Object.values(task.EstimatedDurationFormula);
					for (let i = 0; i < formulaDtos.length; i++) {
						const formulaDto = formulaDtos[i];
						if (formulaDto.dataType === 'Integer' && formulaDto.formula) {
							const ctxIsUserInputFormula = isUserInputFormula(formulaDto.formula);
							if (ctxIsUserInputFormula) {
								hasUserFormula = true;
								break;
							}
						} else {
							// treat non integer types as user formula
							// because it requires user input
							hasUserFormula = true;
						}
					}

					if (Object.keys(task.EstimatedDurationFormula).length > 0 && !hasUserFormula) {
						tasksToUpdate = tasksToUpdate.concat(buildTaskRecord(task));
					}
				}
			});
		});
	});
	return tasksToUpdate;
};

export {
	buildTaskRecord,
	buildScopeSummaryColumns,
	buildTaskParameterValueRecord,
	getTasksToUpdate,
	isUserInputFormula,
};
