import copyPasteEstimateTemplates from '@salesforce/customPermission/CopyPasteEstimateTemplates';

import FIELD_SCOPE_PARAMETER_TEMPLATE from '@salesforce/schema/TaskParameterTemplate__c.ScopeParameterTemplateId__c';
import FIELD_DATA_TYPE from '@salesforce/schema/TaskParameterTemplate__c.DataType__c';
import DEVELOPER_NAME_FIELD from '@salesforce/schema/TaskParameterTemplate__c.DeveloperName__c';
import FIELD_SEQUENCE from '@salesforce/schema/ActivityTemplate__c.Sequence__c';
import FIELD_GUIDANCE from '@salesforce/schema/ActivityGroupTemplate__c.Guidance__c';
import FIELD_ESTIMATE_TEMPLATE from '@salesforce/schema/ActivityGroupTemplate__c.EstimateTemplateId__c';
import FIELD_PER_UNIT_DURATION from '@salesforce/schema/TaskParameterValueTemplate__c.PerUnitDuration__c';
import FIELD_FROM_VALUE from '@salesforce/schema/TaskParameterValueTemplate__c.FromValue__c';
import FIELD_TO_VALUE from '@salesforce/schema/TaskParameterValueTemplate__c.ToValue__c';
import FIELD_LABEL from '@salesforce/schema/TaskParameterValueTemplate__c.Label__c';
import FIELD_RESOURCE_ROLE from '@salesforce/schema/TaskTemplate__c.ResourceRoleId__c';
import FIELD_TASK_TEMPLATE from '@salesforce/schema/TaskParameterTemplate__c.TaskTemplateId__c';
import OBJECT_ACTIVITY_GROUP_TEMPLATE from '@salesforce/schema/ActivityGroupTemplate__c';
import OBJECT_PHASE_TEMPLATE from '@salesforce/schema/PhaseTemplate__c';
import OBJECT_ACTIVITY_TEMPLATE from '@salesforce/schema/ActivityTemplate__c';
import OBJECT_TASK_TEMPLATE from '@salesforce/schema/TaskTemplate__c';
import OBJECT_TASK_PARAMETER_TEMPLATE from '@salesforce/schema/TaskParameterTemplate__c';
import FIELD_PHASE_TEMPLATE from '@salesforce/schema/ActivityGroupTemplate__c.PhaseTemplateId__c';
import FIELD_ACTIVITY_GROUP_TEMPLATE from '@salesforce/schema/ActivityTemplate__c.ActivityGroupTemplateId__c';
import FIELD_ACTIVITY_TEMPLATE_ID from '@salesforce/schema/TaskTemplate__c.ActivityTemplateId__c';
import FIELD_TASK_PARAMETER_TEMPLATE from '@salesforce/schema/TaskParameterValueTemplate__c.TaskParameterTemplateId__c';
import FIELD_IS_ACTIVE from '@salesforce/schema/ActivityGroupTemplate__c.IsActive__c';
import FIELD_ESTIMATED_DURATION_FORMULA from '@salesforce/schema/TaskParameterValueTemplate__c.EstimatedDurationFormula__c';
import LinkedTaskParameterGuidance from '@salesforce/label/c.LinkedToScopeParameterGuidance';

export default class EstimateTemplateDataService {
	static copyPasteEstimateTemplates = copyPasteEstimateTemplates;

	static templateTypes = {
		ActivityGroupTemplates: OBJECT_ACTIVITY_GROUP_TEMPLATE.objectApiName,
		PhaseTemplates: OBJECT_PHASE_TEMPLATE.objectApiName,
		ActivityTemplates: OBJECT_ACTIVITY_TEMPLATE.objectApiName,
		TaskTemplates: OBJECT_TASK_TEMPLATE.objectApiName,
		TaskParameters: OBJECT_TASK_PARAMETER_TEMPLATE.objectApiName,
	}

	static getViewModel(data) {
		const formattedData = JSON.parse(JSON.stringify(data));
		EstimateTemplateDataService.transformChildren(formattedData);

		const hasActivityGroup = formattedData.length > 0;

		const newViewModel = {
			hasActivityGroups: hasActivityGroup,
			tree: formattedData,
			gridExpandedRows: hasActivityGroup ? formattedData[0].gridExpandedIds : [],
		};

		return newViewModel;
	}

	static transformChildren(data) {
		data.forEach((nextDatum) => {
			const datum = nextDatum;
			datum._children = datum.children;
			delete datum.children;

			if (datum._children?.length) {
				EstimateTemplateDataService.transformChildren(datum._children);
			}
		});
	}

	static isNewRecord(recordId) {
		let newRecordId = false;
		if (recordId !== undefined && recordId.includes('Record')) {
			newRecordId = true;
		}

		return newRecordId;
	}

	static prepareTaskParamForLinking(rowIdx, scopeParameter, activityGroupData) {
		const taskParameter = activityGroupData.find((taskParameterTemplate) => +taskParameterTemplate.Sequence_field === rowIdx);
		taskParameter.Name = scopeParameter.Name;
		taskParameter[FIELD_SCOPE_PARAMETER_TEMPLATE.fieldApiName] = scopeParameter.Id;
		taskParameter.scopeParameterId = scopeParameter.Id;
		taskParameter[FIELD_DATA_TYPE.fieldApiName] = scopeParameter[FIELD_DATA_TYPE.fieldApiName];
		taskParameter.Datatype_field = scopeParameter[FIELD_DATA_TYPE.fieldApiName];
		taskParameter.developerName = scopeParameter[DEVELOPER_NAME_FIELD.fieldApiName];
		taskParameter[DEVELOPER_NAME_FIELD.fieldApiName] = scopeParameter[DEVELOPER_NAME_FIELD.fieldApiName];
		taskParameter.Guidance_field = LinkedTaskParameterGuidance;
		taskParameter.isLinked = !!scopeParameter.Id;

		if (EstimateTemplateDataService.isNewRecord(taskParameter.Id)) {
			delete taskParameter.Id;
		}

		return taskParameter;
	}

	static transformTaskParamValues(type,
		recordType,
		dataToTransform) {
		if (type === 'taskParamValues') {
			EstimateTemplateDataService.getTaskParamViewModel(dataToTransform);
		} else if (type === 'activityGroupData' || type === 'phasesGroupData') {
			dataToTransform.forEach((ele) => {
				const element = ele;
				if (type === 'activityGroupData') {
					EstimateTemplateDataService.getActivityGroupViewModel(element,
						recordType);
				}

				// map common shared fields among various entities
				EstimateTemplateDataService.transformGuidanceAndSequenceField(element);
			});
		}
	}

	static getTaskParamViewModel(paramValues) {
		paramValues.forEach((ele) => {
			const element = ele;
			element.Sequence_field = ele[FIELD_SEQUENCE.fieldApiName];
			element.PerUnitDuration_field = ele[FIELD_PER_UNIT_DURATION.fieldApiName];
			element.Fromvalue_field = ele[FIELD_FROM_VALUE.fieldApiName];
			element.Tovalue_field = ele[FIELD_TO_VALUE.fieldApiName];
			element.Label_field = ele[FIELD_LABEL.fieldApiName];
			element.EstimatedDurationFormula_field = ele[FIELD_ESTIMATED_DURATION_FORMULA.fieldApiName];
		});
	}

	static getActivityGroupViewModel(ele,
		recordType) {
		const element = ele;
		element.ResourceroleId_field = ele[FIELD_RESOURCE_ROLE.fieldApiName];
		element.Datatype_field = element[FIELD_DATA_TYPE.fieldApiName];
		element.taskParameterId = element[FIELD_TASK_TEMPLATE.fieldApiName];
		element.scopeParameterId = element[FIELD_SCOPE_PARAMETER_TEMPLATE.fieldApiName];
		element.developerName = element[DEVELOPER_NAME_FIELD.fieldApiName];
		element.isLinked = !!element.scopeParameterId;
		element.isTaskParameter = !!element.taskParameterId;

		const { templateTypes } = EstimateTemplateDataService;
		// if current entity has an Id, and the Id does not contain the string "Record" and  the current type matches
		// a valid template type for allowing copy/paste then set flag true
		if (copyPasteEstimateTemplates && !EstimateTemplateDataService.isNewRecord(element.Id)
			&& (recordType === templateTypes.ActivityGroupTemplates
				|| recordType === templateTypes.ActivityTemplates
				|| recordType === templateTypes.TaskTemplates)) {
			element.canCopyPaste = true;
		}
	}

	static transformGuidanceAndSequenceField(estimateActivityGroup) {
		const activityGroup = estimateActivityGroup;
		activityGroup.Sequence_field = estimateActivityGroup[FIELD_SEQUENCE.fieldApiName];
		activityGroup.Guidance_field = activityGroup.isLinked ? LinkedTaskParameterGuidance : estimateActivityGroup[FIELD_GUIDANCE.fieldApiName];
		activityGroup.estimateTemplateId = estimateActivityGroup[FIELD_ESTIMATE_TEMPLATE.fieldApiName];
	}

	static getParentRecordId(type, isProjectPhasesEnabled) {
		let parentRecordId;
		const { templateTypes } = EstimateTemplateDataService;
		if (type === templateTypes.ActivityGroupTemplates) {
			parentRecordId = isProjectPhasesEnabled ? FIELD_PHASE_TEMPLATE.fieldApiName : FIELD_ESTIMATE_TEMPLATE.fieldApiName;
		} else if (type === templateTypes.ActivityTemplates) {
			parentRecordId = FIELD_ACTIVITY_GROUP_TEMPLATE.fieldApiName;
		} else if (type === templateTypes.TaskParameters) {
			parentRecordId = FIELD_TASK_TEMPLATE.fieldApiName;
		} else if (type === templateTypes.PhaseTemplates) {
			parentRecordId = FIELD_ESTIMATE_TEMPLATE.fieldApiName;
		} else {
			parentRecordId = FIELD_ACTIVITY_TEMPLATE_ID.fieldApiName;
		}

		return parentRecordId;
	}

	static buildParamData(selectedRecord) {
		return {
			taskTemplateParameter: selectedRecord,
			isLinked: !!selectedRecord.scopeParameterId,
			isCheckbox: (selectedRecord[FIELD_DATA_TYPE.fieldApiName] === 'Checkbox'),
			isInteger: (selectedRecord[FIELD_DATA_TYPE.fieldApiName] === 'Integer'),
			isPicklist: (selectedRecord[FIELD_DATA_TYPE.fieldApiName] === 'Picklist'),
			IntegerTiers: (selectedRecord[FIELD_DATA_TYPE.fieldApiName] === 'Integer Tiers'),
		};
	}

	/**
	 * Retrieves param value records of matching data type that have not been deleted already then maps SO fields to VM
	 * object fields
	 *
	 * @param selectedRecord parent activity group record object
	 * @param paramValues current parameter value records
	 * @param deleteRecords current removed parameter value records
	 * @param type current record type being edited
	 * @returns {[]}
	 */
	static getParamValues(selectedRecord, paramValues, deleteRecords, type) {
		let newParamValues = [];
		const newDeletedRecords = deleteRecords;
		const taskParameterRField = FIELD_TASK_PARAMETER_TEMPLATE.fieldApiName.replace('__c', '__r');
		const isSameType = paramValues[0]?.[taskParameterRField][FIELD_DATA_TYPE.fieldApiName] === selectedRecord[FIELD_DATA_TYPE.fieldApiName];
		if (isSameType) {
			// filter out deleted param values
			newParamValues = paramValues.filter((paramValue) => newDeletedRecords.indexOf(paramValue.Id) === -1);
			EstimateTemplateDataService.transformTaskParamValues('taskParamValues',
				type,
				paramValues);
		} else {
			newDeletedRecords.push(...paramValues.map((paramValue) => paramValue.Id));
		}

		return newParamValues;
	}

	static buildNewIntegerTierValueRow(recordId, rowIndex, previousRecord) {
		const newRow = {
			Id: `RecordPicklist${(rowIndex + 1).toString()}`,
			IsMultiplier__c: false,
		};

		newRow[FIELD_PER_UNIT_DURATION.fieldApiName] = 0;
		newRow[FIELD_TASK_PARAMETER_TEMPLATE.fieldApiName] = recordId;
		newRow[FIELD_FROM_VALUE.fieldApiName] = +previousRecord[FIELD_TO_VALUE.fieldApiName] + +1;
		newRow.minvalue = +previousRecord[FIELD_TO_VALUE.fieldApiName] + +2;
		newRow[FIELD_TO_VALUE.fieldApiName] = '';

		return newRow;
	}

	static buildNewPicklistTierRow(rowIndex, recordId) {
		const newRow = {
			Id: `RecordPicklist${(rowIndex + 1).toString()}`,
		};

		newRow[FIELD_LABEL.fieldApiName] = '';
		newRow[FIELD_PER_UNIT_DURATION.fieldApiName] = 0;
		newRow[FIELD_TASK_PARAMETER_TEMPLATE.fieldApiName] = recordId;

		return newRow;
	}

	static newValueParamRecord(taskParamTemplateId, paramsData) {
		const newRecord = {};
		newRecord[FIELD_SEQUENCE.fieldApiName] = 1;
		newRecord[FIELD_PER_UNIT_DURATION.fieldApiName] = 0;
		newRecord[FIELD_TASK_PARAMETER_TEMPLATE.fieldApiName] = taskParamTemplateId;

		if (paramsData.isCheckbox) {
			newRecord.Id = 'RecordYes';
			newRecord[FIELD_LABEL.fieldApiName] = 'Yes';
		} else if (paramsData.isInteger) {
			newRecord.Id = 'RecordInteger';
		} else if (paramsData.isPicklist) {
			newRecord.Id = 'RecordPicklist0';
			newRecord[FIELD_LABEL.fieldApiName] = '';
		} else if (paramsData.IntegerTiers) {
			newRecord.Id = 'RecordPicklist0';
			newRecord[FIELD_FROM_VALUE.fieldApiName] = 0;
			newRecord[FIELD_TO_VALUE.fieldApiName] = '';
		}

		return newRecord;
	}

	static getCurrentParamValues(paramValues, selectedRecord, deletedRecords, type) {
		let newParamVals = [];
		if (paramValues.length > 0) {
			newParamVals = EstimateTemplateDataService.getParamValues(selectedRecord,
				paramValues,
				deletedRecords,
				type);
		}

		return newParamVals;
	}

	static cleanupNewRecordIds(activityGroupData) {
		activityGroupData.forEach((def) => {
			const element = def;
			if (EstimateTemplateDataService.isNewRecord(element.Id)) {
				delete element.Id;
			}
		});
	}

	static resequenceAttributeGroups(activityGroupData) {
		activityGroupData.forEach((ele, ind) => {
			const element = ele;
			element.Id = ele.Id.startsWith('Record') ? `Record${(ind + 1).toString()}` : ele.Id;
			element[FIELD_SEQUENCE.fieldApiName] = ind + 1;
			element.Sequence_field = element[FIELD_SEQUENCE.fieldApiName];
		});
	}

	static createProjectPhase(estimateTemplateId) {
		const newProjectPhaseRecord = {
			Id: 'Record1',
			Name: '',
		};

		newProjectPhaseRecord[FIELD_ESTIMATE_TEMPLATE.fieldApiName] = estimateTemplateId;
		newProjectPhaseRecord[FIELD_IS_ACTIVE.fieldApiName] = true;
		newProjectPhaseRecord[FIELD_SEQUENCE.fieldApiName] = '1';

		return newProjectPhaseRecord;
	}

	static createActivityGroup(parentId, recordId) {
		const newActivityGroupRecord = {
			Id: 'Record1',
			Name: '',
		};

		if (this.useProjectPhases) {
			newActivityGroupRecord[FIELD_PHASE_TEMPLATE.fieldApiName] = parentId;
		}

		newActivityGroupRecord[FIELD_ESTIMATE_TEMPLATE.fieldApiName] = recordId;
		newActivityGroupRecord[FIELD_IS_ACTIVE.fieldApiName] = true;
		newActivityGroupRecord[FIELD_SEQUENCE.fieldApiName] = '1';
		return newActivityGroupRecord;
	}

	static createActivity(activityGroupId) {
		const newActivityRecord = {
			Id: 'Record1',
			Name: '',
		};

		newActivityRecord[FIELD_ACTIVITY_GROUP_TEMPLATE.fieldApiName] = activityGroupId;
		newActivityRecord[FIELD_SEQUENCE.fieldApiName] = '1';
		newActivityRecord[FIELD_IS_ACTIVE.fieldApiName] = true;

		return newActivityRecord;
	}

	static createTask(activityGroupId) {
		const newTaskRecord = {
			Id: 'Record1',
			Name: '',
		};

		newTaskRecord[FIELD_SEQUENCE.fieldApiName] = '1';
		newTaskRecord[FIELD_IS_ACTIVE.fieldApiName] = true;
		newTaskRecord[FIELD_ACTIVITY_TEMPLATE_ID.fieldApiName] = activityGroupId;

		return newTaskRecord;
	}

	static createTaskParameter(activityGroupId) {
		const newTaskParameter = {
			Id: 'Record1',
			Name: '',
			Disabled: '',
		};

		newTaskParameter[FIELD_SEQUENCE.fieldApiName] = '1';
		newTaskParameter[FIELD_IS_ACTIVE.fieldApiName] = true;
		newTaskParameter[DEVELOPER_NAME_FIELD.fieldApiName] = '';
		newTaskParameter[FIELD_DATA_TYPE.fieldApiName] = 'Integer';
		newTaskParameter[FIELD_TASK_TEMPLATE.fieldApiName] = activityGroupId;

		return newTaskParameter;
	}
}
