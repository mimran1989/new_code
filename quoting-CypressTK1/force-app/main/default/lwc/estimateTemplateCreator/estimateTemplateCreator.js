import {
	LightningElement,
	wire,
	api,
	track,
} from 'lwc';
import {
	getRecord,
} from 'lightning/uiRecordApi';
import {
	getObjectInfo,
	getPicklistValues,
} from 'lightning/uiObjectInfoApi';
import {
	ShowToastEvent,
} from 'lightning/platformShowToastEvent';
import {
	refreshApex,
} from '@salesforce/apex';
import {
	componentNamespace, formatLabel,
} from 'c/util';
import log from 'c/log';
import HashtagService from 'c/hashtagService';
import copyPasteEstimateTemplates from '@salesforce/customPermission/CopyPasteEstimateTemplates';
import enableDurationFormula from '@salesforce/customPermission/DurationFormula';
import copyToClipboard from '@salesforce/apex/ClipboardService.copyToClipboard';
import copyActivityGroupIntoEstimateTemplate from '@salesforce/apex/EstimateTemplateCopyPasteService.copyActivityGroupIntoEstimateTemplate';
import copyActivityIntoActivityGroup from '@salesforce/apex/EstimateTemplateCopyPasteService.copyActivityIntoActivityGroup';
import copyTaskIntoActivity from '@salesforce/apex/EstimateTemplateCopyPasteService.copyTaskIntoActivity';
import deleteRecords from '@salesforce/apex/EstimateTemplateCreator.deleteRecords';
import getActivities from '@salesforce/apex/EstimateTemplateCreator.getActivities';
import getActivityGroups from '@salesforce/apex/EstimateTemplateDesignerController.getActivityGroups';
import getActivityGroupsForPhase from '@salesforce/apex/EstimateTemplateDesignerController.getActivityGroupsForPhase';
import getProjectPhase from '@salesforce/apex/EstimateTemplateCreator.getProjectPhase';
import getTaskParams from '@salesforce/apex/EstimateTemplateCreator.getTaskParams';
import getTaskParamValues from '@salesforce/apex/EstimateTemplateCreator.getTaskParamValues';
import getTaskParamValueTemplates from '@salesforce/apex/EstimateTemplateCreator.getTaskParamValueTemplates';
import getTasks from '@salesforce/apex/EstimateTemplateCreator.getTasks';
import getTemplateStructure from '@salesforce/apex/EstimateTemplateCreator.getTemplateStructure';
import saveRecords from '@salesforce/apex/EstimateTemplateCreator.saveRecords';
import insertTaskParamsForClonedTasks from '@salesforce/apex/EstimateTemplateCreator.insertTaskParamsForClonedTasks';
import upsertTaskParamsValues from '@salesforce/apex/EstimateTemplateCreator.upsertTaskParamsValues';

import FIELD_ACTIVITY_GROUP_TEMPLATE from '@salesforce/schema/ActivityTemplate__c.ActivityGroupTemplateId__c';
import FIELD_SEQUENCE from '@salesforce/schema/ActivityTemplate__c.Sequence__c';
import OBJECT_ACTIVITY_TEMPLATE from '@salesforce/schema/ActivityTemplate__c';
import FIELD_ACTIVITY_TEMPLATE_ID from '@salesforce/schema/TaskTemplate__c.ActivityTemplateId__c';
import FIELD_GUIDANCE_TASK_TEMPLATE from '@salesforce/schema/TaskTemplate__c.Guidance__c';
import FIELD_RESOURCE_ROLE from '@salesforce/schema/TaskTemplate__c.ResourceRoleId__c';
import FIELD_SEQUENCE_TASK_TEMPLATE from '@salesforce/schema/TaskTemplate__c.Sequence__c';
import OBJECT_TASK_TEMPLATE from '@salesforce/schema/TaskTemplate__c';
import FIELD_DATA_TYPE from '@salesforce/schema/TaskParameterTemplate__c.DataType__c';
import DEVELOPER_NAME_FIELD from '@salesforce/schema/TaskParameterTemplate__c.DeveloperName__c';
import FIELD_TASK_TEMPLATE from '@salesforce/schema/TaskParameterTemplate__c.TaskTemplateId__c';
import OBJECT_TASK_PARAMETER_TEMPLATE from '@salesforce/schema/TaskParameterTemplate__c';
import FIELD_ESTIMATE_TEMPLATE from '@salesforce/schema/ActivityGroupTemplate__c.EstimateTemplateId__c';
import FIELD_GUIDANCE from '@salesforce/schema/ActivityGroupTemplate__c.Guidance__c';
import FIELD_IS_ACTIVE from '@salesforce/schema/ActivityGroupTemplate__c.IsActive__c';
import FIELD_PHASE_TEMPLATE from '@salesforce/schema/ActivityGroupTemplate__c.PhaseTemplateId__c';
import OBJECT_ACTIVITY_GROUP_TEMPLATE from '@salesforce/schema/ActivityGroupTemplate__c';
import FIELD_FROM_VALUE from '@salesforce/schema/TaskParameterValueTemplate__c.FromValue__c';
import FIELD_LABEL from '@salesforce/schema/TaskParameterValueTemplate__c.Label__c';
import FIELD_PER_UNIT_DURATION from '@salesforce/schema/TaskParameterValueTemplate__c.PerUnitDuration__c';
import FIELD_TASK_PARAMETER_TEMPLATE from '@salesforce/schema/TaskParameterValueTemplate__c.TaskParameterTemplateId__c';
import FIELD_TO_VALUE from '@salesforce/schema/TaskParameterValueTemplate__c.ToValue__c';
import FIELD_NAME from '@salesforce/schema/TaskParameterValue__c.Name';
import OBJECT_TASK_PARAM_VALUE from '@salesforce/schema/TaskParameterValue__c';
import FIELD_PRODUCT from '@salesforce/schema/RateCardItem__c.ProductId__c';
import FIELD_PRODUCT_GROUP from '@salesforce/schema/Product__c.Group__c';
import FIELD_PRODUCT_PRACTICE from '@salesforce/schema/Product__c.Practice__c';
import FIELD_PRODUCTR_GROUP from '@salesforce/schema/EstimateTemplate__c.ServiceId__r.Group__c';
import FIELD_PRODUCTR_PRACTICE from '@salesforce/schema/EstimateTemplate__c.ServiceId__r.Practice__c';
import FIELD_RATE_CARD_ID from '@salesforce/schema/EstimateTemplate__c.RateCardId__c';
import FIELD_SERVICE from '@salesforce/schema/EstimateTemplate__c.ServiceId__c';
import FIELD_USE_PROJECT_PHASES from '@salesforce/schema/EstimateTemplate__c.UseProjectPhases__c';
import OBJECT_TASK from '@salesforce/schema/Task__c';
import FIELD_TEMPLATE from '@salesforce/schema/Task__c.TemplateId__c';
import OBJECT_PHASE_TEMPLATE from '@salesforce/schema/PhaseTemplate__c';
import FIELD_ESTIMATED_DURATION_FORMULA from '@salesforce/schema/TaskParameterValueTemplate__c.EstimatedDurationFormula__c';

import Actions from '@salesforce/label/c.Actions';
import AddIcon from '@salesforce/label/c.AddIcon';
import AddRow from '@salesforce/label/c.AddRow';
import Activity from '@salesforce/label/c.Activity';
import ActivityGroup from '@salesforce/label/c.ActivityGroup';
import AddEditActivities from '@salesforce/label/c.AddEditActivities';
import AddEditActivityGroups from '@salesforce/label/c.AddEditActivityGroups';
import AddEditScopeParameters from '@salesforce/label/c.AddEditScopeParameters';
import AddEditTaskParameters from '@salesforce/label/c.AddEditTaskParameters';
import AddEditTasks from '@salesforce/label/c.AddEditTasks';
import CancelButton from '@salesforce/label/c.CancelButton';
import CloseButton from '@salesforce/label/c.CloseButton';
import CloneButton from '@salesforce/label/c.CloneButton';
import CopyToClipboard from '@salesforce/label/c.CopyToClipboard';
import CreateEditActivityGroups from '@salesforce/label/c.CreateEditActivityGroups';
import CreateEditPhase from '@salesforce/label/c.CreateEditPhase';
import DefineDurationIfChecked from '@salesforce/label/c.DefineDurationIfChecked';
import DefineRecommendedDurations from '@salesforce/label/c.DefineRecommendedDurations';
import DefineRecommendedPerUnitDuration from '@salesforce/label/c.DefineRecommendedPerUnitDuration';
import DeleteButton from '@salesforce/label/c.DeleteButton';
import DeleteIcon from '@salesforce/label/c.DeleteIcon';
import EstimateDuration from '@salesforce/label/c.EstimateDuration';
import PasteFromClipboard from '@salesforce/label/c.PasteFromClipboard';
import SaveButton from '@salesforce/label/c.SaveButton';
import ShowActivities from '@salesforce/label/c.ShowActivities';
import ShowActivityGroup from '@salesforce/label/c.ShowActivityGroup';
import ShowProjectPhase from '@salesforce/label/c.ShowProjectPhase';
import ShowTasks from '@salesforce/label/c.ShowTasks';
import Task from '@salesforce/label/c.Task';
import HashTag from '@salesforce/label/c.Hashtag';
import ScopeParameterMissing from '@salesforce/label/c.ScopeParameterMissing';
import ScopeParameterIncompatible from '@salesforce/label/c.ScopeParameterIncompatible';

import LABEL_PER_UNIT_DURATION from '@salesforce/label/c.PerUnitDuration';
import LABEL_DEFINE_DURATION from '@salesforce/label/c.DefineDuration';
import LABEL_SCOPE_PARAMETERS from '@salesforce/label/c.ScopeParameters';
import LABEL_ERROR_COULD_NOT_VALIDATE from '@salesforce/label/c.ErrorCouldNotValidate';
import LABEL_FORMULA_EVALUATION_ERROR_TITLE from '@salesforce/label/c.FormulaEvaluationErrorTitle';
import LABEL_ERROR_COULD_NOT_EVALUATE_FORMULA from '@salesforce/label/c.ErrorCouldNotEvaluateFormula';
import LABEL_VALIDATION_ERROR_TITLE from '@salesforce/label/c.ValidationErrorTitle';
import LABEL_SUCCESS from '@salesforce/label/c.Success';
import LABEL_SUCCESSFULLY_SAVED from '@salesforce/label/c.SuccessfullySaved';
import ACTIVITY_GROUP_COLUMN from '@salesforce/label/c.ActivityGroupColumn';
import PROJECT_PHASE_COLUMN from '@salesforce/label/c.ProjectPhaseColumn';
import EstimateTemplateDataService from './estimateTemplateDataService';

const fields = [
	FIELD_RATE_CARD_ID,
	FIELD_PRODUCTR_PRACTICE,
	FIELD_PRODUCTR_GROUP,
	FIELD_USE_PROJECT_PHASES,
];

const IDRegex = /[a-zA-Z0-9]{15}|[a-zA-Z0-9]{18}/;
const ACTIVITY_TEMPLATE = 'ActivityTemplate';
const ACTIVITY_GROUP_TEMPLATE = 'ActivityGroupTemplate';

export default class EstimateTemplateCreator extends LightningElement {
	@track label = {
		Actions,
		Activity,
		ActivityGroup,
		AddEditActivities,
		AddEditActivityGroups,
		AddEditScopeParameters,
		AddEditTaskParameters,
		AddEditTasks,
		AddIcon,
		AddRow,
		CancelButton,
		CloneButton,
		CopyToClipboard,
		CloseButton,
		CreateEditActivityGroups,
		CreateEditPhase,
		DefineDurationIfChecked,
		DefineRecommendedDurations,
		DefineRecommendedPerUnitDuration,
		DeleteButton,
		DeleteIcon,
		EstimateDuration,
		HashTag,
		PasteFromClipboard,
		SaveButton,
		ShowActivities,
		ShowActivityGroup,
		ShowProjectPhase,
		ShowTasks,
		Task,
		LABEL_PER_UNIT_DURATION,
		LABEL_DEFINE_DURATION,
	};
	treeGrid
	copyPasteEstimateTemplates = copyPasteEstimateTemplates;
	@track estimateTemplateVM = {
		hasActivityGroups: false,
		gridExpandedRows: [],
		tree: [],
	};
	fieldLabels = {};
	objectNameLabels = {};
	@api recordId;
	displayAg = false;
	columns = [{
		type: 'text',
		fieldName: 'ActivityGroup',
		cellAttributes: {
			iconName: {
				fieldName: 'IconType',
			},
		},
		initialWidth: 400,
	},
	{
		type: 'text',
		fieldName: 'ResourceName',
		label: 'Resource Role',
		wrapText: true,
	},
	{
		label: '',
		type: 'button',
		initialWidth: 230,
		typeAttributes: {
			label: {
				fieldName: 'Actionlabel',
			},
			iconName: {
				fieldName: 'ActionIcon',
			},
			title: {
				fieldName: 'ActionbuttonTitle',
			},
			variant: 'border-filled',
			disabled: {
				fieldName: 'ActionIconDisabled',
			},
		},
	},
	{
		label: '',
		type: 'button',
		initialWidth: 250,
		typeAttributes: {
			name: 'scopeParams',
			label: this.label.AddEditScopeParameters,
			title: this.label.AddEditScopeParameters,
			variant: 'border-filled',
		},
		cellAttributes: {
			class: {
				fieldName: 'scopeParamCss',
			},
		},
	},
	];
	@track error;
	@track activityGroupData = [];
	@track clonedTasks = [];
	loadedData;
	@track modalHeader;
	type;
	Data = [];
	parentId;
	taskParams = false;
	isTask = false;
	isCloneEnabled = false;
	showParamPopUp = false;
	@track paramsData;
	paramHeader = 'Add Values';
	deletedRecords = [];
	deletedValues = [];
	disableSave = false;
	togglePhase = false;
	toggleactivityGroup = true;
	clipboardContent;
	entityPastedDisplayName;
	channelName;
	estimate = {};
	fullNamespace;
	ns;
	enableDurationFormula = enableDurationFormula;

	@track paramFields = {
		Sequence_field: FIELD_SEQUENCE.fieldApiName,
		PerUnitDuration_field: FIELD_PER_UNIT_DURATION.fieldApiName,
		Fromvalue_field: FIELD_FROM_VALUE.fieldApiName,
		Tovalue_field: FIELD_TO_VALUE.fieldApiName,
		Label_field: FIELD_LABEL.fieldApiName,
		activityGroupTemplateId: FIELD_ACTIVITY_GROUP_TEMPLATE.fieldApiName,
		EstimatedDurationFormula_field: FIELD_ESTIMATED_DURATION_FORMULA.fieldApiName,
	}

	templateTypes = {
		ActivityGroupTemplates: OBJECT_ACTIVITY_GROUP_TEMPLATE.objectApiName,
		PhaseTemplates: OBJECT_PHASE_TEMPLATE.objectApiName,
		ActivityTemplates: OBJECT_ACTIVITY_TEMPLATE.objectApiName,
		TaskTemplates: OBJECT_TASK_TEMPLATE.objectApiName,
		TaskParameters: OBJECT_TASK_PARAMETER_TEMPLATE.objectApiName,
	}

	templateTitles = {
		ActivityGroupTemplates: 'Activity Groups',
		PhaseTemplates: 'Project Phases',
		ActivityTemplates: 'Activities',
		TaskTemplates: 'Tasks',
		TaskParameters: 'Task Parameters',
	}

	// function to get the child component value..
	selectedResource(event) {
		this.activityGroupData.forEach((ele) => {
			const elememt = ele;
			if (elememt.Id === event.detail.TaskId) {
				elememt[FIELD_RESOURCE_ROLE.fieldApiName] = event.detail.recordId;
				elememt.ResourceroleId_field = event.detail.recordId;
			}
		});
	}

	@wire(getObjectInfo, {
		objectApiName: OBJECT_TASK_TEMPLATE,
	})
	taskTemplateInfo({
		data,
	}) {
		if (data) {
			this.fieldLabels.Sequence = data.fields[FIELD_SEQUENCE_TASK_TEMPLATE.fieldApiName].label;
			this.fieldLabels.Guidance = data.fields[FIELD_GUIDANCE_TASK_TEMPLATE.fieldApiName].label;
			this.fieldLabels.ResourceRole = data.fields[FIELD_RESOURCE_ROLE.fieldApiName].label;
		}
	}

	@wire(getObjectInfo, {
		objectApiName: OBJECT_TASK_PARAMETER_TEMPLATE,
	})
	taskParamTemplateInfo({
		data,
	}) {
		if (data) {
			this.fieldLabels.DataType = data.fields[FIELD_DATA_TYPE.fieldApiName].label;
			this.fieldLabels.DeveloperName = data.fields[DEVELOPER_NAME_FIELD.fieldApiName].label;
		}
	}

	@wire(getObjectInfo, {
		objectApiName: OBJECT_TASK_PARAM_VALUE,
	})
	taskParamValueInfo({
		data,
	}) {
		if (data) {
			this.objectNameLabels.TaskParamValueName = data.fields[FIELD_NAME.fieldApiName].label;
		}
	}

	@wire(getObjectInfo, {
		objectApiName: OBJECT_TASK,
	})
	taskInfo({
		data,
	}) {
		if (data) {
			this.objectNameLabels.TaskTemplateName = data.fields[FIELD_TEMPLATE.fieldApiName].label;
		}
	}

	// Wire method to get the estimate details..Rate Card
	@wire(getRecord, {
		recordId: '$recordId',
		fields,
	})
	estimateCallback({
		data,
	}) {
		this.estimate = {
			data,
		};

		if (this.estimate.data && this.togglePhase === false) {
			this.useProjectPhases = this.estimate.data.fields[FIELD_USE_PROJECT_PHASES.fieldApiName].value;

			const activityGroupCol = this.columns[0];
			if (this.useProjectPhases) {
				this.togglePhase = true;
				this.toggleactivityGroup = false;
				activityGroupCol.label = PROJECT_PHASE_COLUMN;
			} else {
				activityGroupCol.label = ACTIVITY_GROUP_COLUMN;
			}
		}
	}

	// Get Estimate Rate Card Id
	get estimateRateCardId() {
		return this.estimate.data.fields[FIELD_RATE_CARD_ID.fieldApiName].value;
	}

	get isProjectPhasesEnabled() {
		return this.estimate.data.fields[FIELD_USE_PROJECT_PHASES.fieldApiName].value;
	}

	get filterCriteriaString() {
		const productIdRelField = FIELD_PRODUCT.fieldApiName.replace('__c', '__r');
		const serviceProductField = FIELD_SERVICE.fieldApiName.replace('__c', '__r');
		const serviceProductSOFields = this.estimate.data.fields[serviceProductField].value.fields;
		const practice = serviceProductSOFields[FIELD_PRODUCT_PRACTICE.fieldApiName].value;
		const group = serviceProductSOFields[FIELD_PRODUCT_GROUP.fieldApiName].value;
		let filterCriteriaValue = `${productIdRelField}.${FIELD_PRODUCT_PRACTICE.fieldApiName} = `;
		if (!practice) {
			filterCriteriaValue += 'NULL ';
		} else {
			filterCriteriaValue += `'${practice}' `;
		}

		filterCriteriaValue += `AND ${productIdRelField}.${FIELD_PRODUCT_GROUP.fieldApiName} = `;

		if (!group) {
			filterCriteriaValue += 'NULL ';
		} else {
			filterCriteriaValue += `'${group}' `;
		}

		return filterCriteriaValue;
	}

	get channel() {
		return this.channelName;
	}

	// Get Object Details of the Task Params
	@wire(getObjectInfo, {
		objectApiName: OBJECT_TASK_PARAMETER_TEMPLATE,
	})
	objectInfo;
	// Get Picklist values of the TaskParamObject
	@wire(getPicklistValues, {
		recordTypeId: '$objectInfo.data.defaultRecordTypeId',
		fieldApiName: FIELD_DATA_TYPE,
	}) picklistValues;
	// Get Details of the tree grid structure..
	@wire(getTemplateStructure, {
		estimateId: '$recordId',
	})
	wiredAccount(templateStructureResult) {
		const {
			error,
			data,
		} = templateStructureResult;

		this.loadedData = templateStructureResult;

		if (data) {
			this.estimateTemplateVM = EstimateTemplateDataService.getViewModel(data);
		} else if (error) {
			this.error = error;
		}
	}

	async connectedCallback() {
		this.ns = componentNamespace(this);

		if (this.ns) {
			this.fullNamespace = `${this.ns}__`;
		}

		this.channelName = `${this.fullNamespace}Clipboard__e`;
		const component = this;
		// called when platform event for clipboard copy action occurred
		this.onMessage = (() => (response) => {
			if (response.data) {
				component.clipboardContent = response.data.payload;
			}
		})();

		if (this.recordId) {
			this._estimateHashtagService = new HashtagService();
			await this._estimateHashtagService.loadHashtagsForEstimateTemplate(this.recordId);
		}
	}

	renderedCallback() {
		this.treeGrid = this.template.querySelector('lightning-tree-grid');
		this._messageService = this.template.querySelector('c-message-service');
		this._formulaEvaluator = this.template.querySelector('c-formula-evaluator');
	}

	showPhase() {
		this.treeGrid.collapseAll();
	}

	// This function is used to collapse and expand the tree based on the user selection
	showAG() {
		if (this.isProjectPhasesEnabled) {
			const actGrp = [];
			this.estimateTemplateVM.tree.forEach((def) => {
				Object.keys(def._children).forEach((key) => {
					if (def._children[key].Type === ACTIVITY_GROUP_TEMPLATE) {
						actGrp.push(def.ActivityGroupId);
					}
				});
			});
			this.estimateTemplateVM.gridExpandedRows = actGrp;
		} else {
			this.treeGrid.collapseAll();
		}
	}
	// This function is used to collapse and expand the tree based on the user selection..
	showActivity() {
		const actGrp = [];
		if (this.isProjectPhasesEnabled) {
			this.estimateTemplateVM.tree.forEach((def) => {
				Object.keys(def._children).forEach((key) => {
					const data = def._children[key]._children;
					Object.keys(data).forEach((n) => {
						if (data[n].Type === ACTIVITY_TEMPLATE) {
							actGrp.push(def.ActivityGroupId);
							actGrp.push(def._children[key].ActivityGroupId);
						}
					});
				});
			});
		} else {
			this.estimateTemplateVM.tree.forEach((def) => {
				Object.keys(def._children).forEach((key) => {
					if (def._children[key].Type === ACTIVITY_TEMPLATE) {
						actGrp.push(def.ActivityGroupId);
					}
				});
			});
		}

		this.estimateTemplateVM.gridExpandedRows = actGrp;
	}
	// This function is used to collapse and expand the tree based on the user selection..
	showTasks() {
		this.treeGrid.expandAll();
	}

	// Tree grid Actions
	handleRowAction(event) {
		if (event.detail.action.name === 'scopeParams') {
			this.handleOpenScopeParams(event.detail.row);
		} else {
			this.deletedRecords = [];
			this.deletedValues = [];
			this.isTask = false;
			this.isCloneEnabled = false;
			this.taskParams = false;

			const {
				row,
			} = event.detail;

			this.disableSave = false;

			switch (row.Actionlabel) {
				case this.label.AddEditActivities:
					this.createActivities(row);
					break;
				case this.label.AddEditTasks:
					this.isTask = true;
					this.isCloneEnabled = true;
					this.createTasks(row);
					break;
				case this.label.AddEditTaskParameters:
					this.createTaskParameters(row);
					break;
				case this.label.AddEditActivityGroups:
					this.createActivityGroups(row);
					break;
				default:
					break;
			}
		}
	}

	async handleLinkScopeParameterToTaskParameter(event) {
		const {
			scopeParameter,
		} = event.detail;

		if (!scopeParameter) {
			return;
		}

		const recordString = [];
		const rowIdx = +event.target.getAttribute('data-id');

		recordString.push(EstimateTemplateDataService.prepareTaskParamForLinking(rowIdx, scopeParameter, this.activityGroupData));

		const result = await saveRecords({
			recordString: JSON.stringify(recordString),
			objectApiName: this.type,
		});

		let linkedTaskParameter;
		Object.keys(result).forEach((key) => {
			linkedTaskParameter = result[key];
		});

		Object.keys(this.activityGroupData).forEach((key) => {
			if (this.activityGroupData[key].Id === undefined && this.activityGroupData[key].Sequence__c === linkedTaskParameter.Sequence__c) {
				this.activityGroupData[key].Id = linkedTaskParameter.Id;
			}
		});
	}

	handleOpenScopeParams(row) {
		const dialogServicePayload = {
			method: 'bodyModalLarge',
			config: {
				auraId: 'scope-parameter-dialog',
				headerLabel: `${row.ParentLabel}/${LABEL_SCOPE_PARAMETERS}`,
				component: `${this.ns}:scopeParameterDialog`,
				componentParams: {
					estimateId: this.recordId,
					uniqueBoundary: 'component-state',
					recordId: row.id,
				},
				footerActions: [{
					label: CloseButton,
					eventName: 'close',
					class: '',
				},
				{
					label: SaveButton,
					eventName: 'c.save',
					class: 'slds-button_brand',
				},
				],
			},
		};

		this._messageService.dialogService(dialogServicePayload);
	}

	async createActivityGroups(event) {
		this.deletedRecords = [];
		this.disableSave = false;
		this.modalHeader = this.templateTitles.ActivityGroupTemplates;
		this.displayAg = true;
		this.taskParams = false;
		this.isTask = false;
		this.isCloneEnabled = false;
		this.type = this.templateTypes.ActivityGroupTemplates;

		await this.prepareActivityGroupData(event);

		EstimateTemplateDataService.transformTaskParamValues('activityGroupData',
			this.type,
			this.activityGroupData);
	}

	async prepareActivityGroupData(event) {
		if (this.useProjectPhases) {
			this.parentId = event.ActivityGroupId;
			this.activityGroupData = await getActivityGroupsForPhase({
				phaseTemplateId: event.ActivityGroupId,
			});
		} else {
			this.parentId = this.recordId;
			this.activityGroupData = await getActivityGroups({
				estimateId: this.recordId,
			});
		}

		if (this.activityGroupData.length === 0) {
			const record = EstimateTemplateDataService.createActivityGroup(this.parentId, this.recordId);
			this.activityGroupData.push(record);
		}
	}

	async createEditProjectPhase() {
		this.deletedRecords = [];
		this.disableSave = false;
		this.modalHeader = this.templateTitles.PhaseTemplates;
		this.displayAg = true;
		this.taskParams = false;
		this.isTask = false;
		this.isCloneEnabled = false;

		const projectPhaseResult = await getProjectPhase({
			estimateTemplateId: this.recordId,
		});

		this.activityGroupData = projectPhaseResult;
		this.type = this.templateTypes.PhaseTemplates;
		this.parentId = this.recordId;

		if (projectPhaseResult.length === 0) {
			const record = EstimateTemplateDataService.createProjectPhase(this.recordId);
			this.activityGroupData.push(record);
		}

		EstimateTemplateDataService.transformTaskParamValues('activityGroupData',
			this.type,
			this.activityGroupData);
	}

	async createActivities(event) {
		this.displayAg = true;
		this.modalHeader = `${event.ActivityGroupName}/ ${this.templateTitles.ActivityTemplates}`;

		const activitiesResult = await getActivities({
			activityGroupTemplateId: event.ActivityGroupId,
		});

		this.activityGroupData = activitiesResult;
		this.parentId = event.ActivityGroupId;
		this.type = this.templateTypes.ActivityTemplates;

		if (activitiesResult.length === 0) {
			const newRecord = EstimateTemplateDataService.createActivity(event.ActivityGroupId);
			this.activityGroupData.push(newRecord);
		}

		EstimateTemplateDataService.transformTaskParamValues('activityGroupData',
			this.type,
			this.activityGroupData);
	}

	async createTasks(event) {
		this.modalHeader = `${event.ParentLabel}/ ${this.templateTitles.TaskTemplates}`;

		const tasksResult = await getTasks({
			activityTemplateId: event.ActivityGroupId,
		});

		this.activityGroupData = tasksResult;
		this.type = this.templateTypes.TaskTemplates;
		this.parentId = event.ActivityGroupId;
		this.displayAg = true;

		if (tasksResult.length === 0) {
			const record = EstimateTemplateDataService.createTask(event.ActivityGroupId);
			this.activityGroupData.push(record);
		}

		EstimateTemplateDataService.transformTaskParamValues('activityGroupData',
			this.type,
			this.activityGroupData);
	}
	async createTaskParameters(event) {
		this.displayAg = true;
		this.modalHeader = `${event.ParentLabel}/ ${this.templateTitles.TaskParameters}`;
		this.taskParams = true;
		this.isCloneEnabled = true;
		this.type = this.templateTypes.TaskParameters;
		this.parentId = event.ActivityGroupId;

		const taskParamsResult = await getTaskParams({
			taskTemplateId: event.ActivityGroupId,
		});

		this.activityGroupData = taskParamsResult;

		if (taskParamsResult.length === 0) {
			const record = EstimateTemplateDataService.createTaskParameter(event.ActivityGroupId);
			this.activityGroupData.push(record);
		}

		EstimateTemplateDataService.transformTaskParamValues('activityGroupData',
			this.type,
			this.activityGroupData);
	}
	// Close Modal window
	closeModal() {
		this.displayAg = false;
		this.activityGroupData = [];
	}
	// Field change event handler..
	handleChange(event) {
		const foundIndex = this.activityGroupData.findIndex((rec) => rec.Id === event.target.dataset.id);
		if (event.target.name === 'Sequence') {
			this.activityGroupData[foundIndex][FIELD_SEQUENCE.fieldApiName] = event.target.value;
		} else if (event.target.name === 'Name') {
			const targetId = event.target.dataset.id;
			const target = this.template.querySelector(`lightning-button[data-id="${targetId}"]`);
			if (target !== null) {
				target.disabled = event.target.value.trim() === '';
			}

			this.activityGroupData[foundIndex].Name = event.target.value;
		} else if (event.target.name === 'Datatype') {
			this.activityGroupData[foundIndex][FIELD_DATA_TYPE.fieldApiName] = event.target.value;
		} else if (event.target.name === 'Guidance') {
			this.activityGroupData[foundIndex][FIELD_GUIDANCE.fieldApiName] = event.target.value;
		} else if (event.target.name === 'IsMultiplier__c') {
			//
		} else if (event.target.name === 'developerName') {
			this.activityGroupData[foundIndex][DEVELOPER_NAME_FIELD.fieldApiName] = event.target.value;
		} else {
			this.activityGroupData[event.target.dataset.id][FIELD_GUIDANCE.fieldApiName] = event.target.value;
		}

		EstimateTemplateDataService.transformTaskParamValues('activityGroupData',
			this.type,
			this.activityGroupData);
	}
	// Removing records
	async removeRow(event) {
		if (event.target.dataset.id.match(IDRegex)) {
			this.deletedRecords.push(event.target.dataset.id);
		}

		this.activityGroupData = this.activityGroupData.filter((rec) => rec.Id !== event.target.dataset.id);
		EstimateTemplateDataService.resequenceAttributeGroups(this.activityGroupData);
	}
	// Adding Row..Activity Group, Activity, Task, TaskParams
	addRow(event) {
		const indx = this.activityGroupData.findIndex((ele) => ele.Id === event.target.dataset.id);
		let parentApiName;
		if (this.type === this.templateTypes.ActivityGroupTemplates) {
			parentApiName = this.isProjectPhasesEnabled ? FIELD_PHASE_TEMPLATE.fieldApiName : FIELD_ESTIMATE_TEMPLATE.fieldApiName;
		} else if (this.type === this.templateTypes.ActivityTemplates) {
			parentApiName = FIELD_ACTIVITY_GROUP_TEMPLATE.fieldApiName;
		} else if (this.type === this.templateTypes.TaskParameters) {
			parentApiName = FIELD_TASK_TEMPLATE.fieldApiName;
		} else if (this.type === this.templateTypes.PhaseTemplates) {
			parentApiName = FIELD_ESTIMATE_TEMPLATE.fieldApiName;
		} else {
			parentApiName = FIELD_ACTIVITY_TEMPLATE_ID.fieldApiName;
		}

		const newJson = {
			Id: 'Record',
			Name: '',
			Disabled: true,
		};

		newJson[FIELD_SEQUENCE.fieldApiName] = this.activityGroupData.length + 1;
		newJson[FIELD_IS_ACTIVE.fieldApiName] = true;

		if (this.type === this.templateTypes.TaskParameters) newJson[FIELD_DATA_TYPE.fieldApiName] = 'Integer';
		newJson[parentApiName] = this.parentId;

		if (this.type === this.templateTypes.ActivityGroupTemplates && this.isProjectPhasesEnabled) {
			newJson[FIELD_ESTIMATE_TEMPLATE.fieldApiName] = this.recordId;
		}

		this.activityGroupData.splice(indx + 1, 0, newJson);
		EstimateTemplateDataService.resequenceAttributeGroups(this.activityGroupData);
		EstimateTemplateDataService.transformTaskParamValues('activityGroupData',
			this.type,
			this.activityGroupData);
	}

	async cloneRow(event) {
		const rowIndex = this.activityGroupData.findIndex((searchRec) => searchRec.Id === event.target.dataset.id);

		const parentRecordId = EstimateTemplateDataService.getParentRecordId(
			this.type,
			this.isProjectPhasesEnabled,
		);

		const newCloneRecord = {
			Id: 'Record',
			Name: this.activityGroupData[rowIndex].Name,
			OriginalTaskTemplateId: this.activityGroupData[rowIndex].Id,

		};

		newCloneRecord[FIELD_SEQUENCE.fieldApiName] = this.activityGroupData.length + 1;
		newCloneRecord.Sequence_field = this.activityGroupData[rowIndex][FIELD_SEQUENCE.fieldApiName];
		newCloneRecord[FIELD_IS_ACTIVE.fieldApiName] = true;
		newCloneRecord[FIELD_GUIDANCE.fieldApiName] = this.activityGroupData[rowIndex].Guidance_field;
		newCloneRecord[FIELD_RESOURCE_ROLE.fieldApiName] = this.activityGroupData[rowIndex].ResourceroleId_field;

		if (this.type === this.templateTypes.TaskParameters) {
			newCloneRecord[FIELD_DATA_TYPE.fieldApiName] = 'Integer';
		}

		newCloneRecord[parentRecordId] = this.parentId;

		if (this.type === this.templateTypes.ActivityGroupTemplates && this.isProjectPhasesEnabled) {
			newCloneRecord[FIELD_ESTIMATE_TEMPLATE.fieldApiName] = this.recordId;
		}

		this.activityGroupData.splice(rowIndex + 1, 0, newCloneRecord);
		EstimateTemplateDataService.resequenceAttributeGroups(this.activityGroupData);
		EstimateTemplateDataService.transformTaskParamValues('activityGroupData',
			this.type,
			this.activityGroupData);
	}

	/**
	 * Called when user clicks the copy button. Generates platform event with record Id and record type details.
	 *
	 * @param event component event object
	 */
	copyActivityGroup(event) {
		const activityGroupId = event.target.dataset.id;

		copyToClipboard({
			parentId: activityGroupId,
			type: this.type,
		});
	}

	/**
	 * Called when user clicks paste button. Calls API to deep clone object then closes dialog and triggers save action
	 *
	 * @param event LWC component event object
	 */
	async pasteActivityGroup(event) {
		if (this.isFormInputsValid()) {
			this.disableSave = true;
			// get the current activity group (could be an activity group, activity or task) object
			const activityGroup = this.activityGroupData.find((ag) => ag.Id === event.target.dataset.id);
			// get the clipboard's parent id
			const activityGroupId = this.clipboardContent[`${this.fullNamespace}ParentId__c`];
			if (this.type === this.templateTypes.ActivityGroupTemplates) {
				await copyActivityGroupIntoEstimateTemplate({
					activityGroupTemplateId: activityGroupId,
					estimateTemplateId: this.recordId,
					sequence: activityGroup.Sequence_field,
				});
				this.entityPastedDisplayName = this.label.ActivityGroup;
			} else if (this.type === this.templateTypes.ActivityTemplates) {
				await copyActivityIntoActivityGroup({
					activityTemplateId: activityGroupId,
					activityGroupTemplateId: activityGroup[`${this.fullNamespace}ActivityGroupTemplateId__c`],
					sequence: activityGroup.Sequence_field,
				});
				this.entityPastedDisplayName = this.label.Activity;
			} else if (this.type === this.templateTypes.TaskTemplates) {
				await copyTaskIntoActivity({
					taskTemplateId: activityGroupId,
					activityTemplateId: activityGroup[`${this.fullNamespace}ActivityTemplateId__c`],
					sequence: activityGroup.Sequence_field,
				});
				this.entityPastedDisplayName = this.label.Task;
			}

			refreshApex(this.loadedData);
			this.closeModal();
		}
	}

	/**
	 * Determines whether paste button for current entity should be enabled or not
	 *
	 * @returns {boolean}
	 */
	get isPasteActivityGroupDisabled() {
		let isDisabled = true;
		if (this.clipboardContent && this.clipboardContent[`${this.fullNamespace}Type__c`] === this.type) {
			isDisabled = false;
		}

		return isDisabled;
	}

	get isRemoveDisabled() {
		return this.activityGroupData.length < 2;
	}

	validateAllInputFields() {
		return [...this.template.querySelectorAll('lightning-input')].reduce((validSoFar, inputField) => {
			inputField.reportValidity();
			return validSoFar && inputField.checkValidity();
		}, true);
	}

	validateDurationFormulaInputFields() {
		if (this.validateAllInputFields()) {
			const paramsValue = this.paramsData.paramValues[0][this.paramFields.EstimatedDurationFormula_field];
			const hashtags = paramsValue.match(/#[\w]+/g) || [];

			let areHashtagsValid = !hashtags.length // no hashtags
				|| hashtags.reduce((validSoFar, hashtag) => validSoFar && this._formulaEvaluator.isNamedExpressionValid(hashtag), true);

			const canEvaluate = areHashtagsValid && this._formulaEvaluator.isFormulaValid(paramsValue);
			if (!canEvaluate) {
				this.showNotification(LABEL_FORMULA_EVALUATION_ERROR_TITLE, LABEL_ERROR_COULD_NOT_EVALUATE_FORMULA, 'error');
				return false;
			}

			hashtags.forEach((nextHashtag) => {
				if (this._estimateHashtagService.getHashtag(nextHashtag) === undefined) {
					this.showNotification(LABEL_FORMULA_EVALUATION_ERROR_TITLE, formatLabel(ScopeParameterMissing, [nextHashtag]), 'error');
					areHashtagsValid = false;
					return false;
				}

				if (this._estimateHashtagService.getHashtag(nextHashtag).dataType !== 'Integer') {
					this.showNotification(LABEL_FORMULA_EVALUATION_ERROR_TITLE, formatLabel(ScopeParameterIncompatible, [nextHashtag]), 'error');
					areHashtagsValid = false;
					return false;
				}

				return true;
			});

			return areHashtagsValid;
		}

		return true;
	}

	validateTaskTemplateLookups() {
		this.template.querySelectorAll('c-custom-lookup').forEach((element) => element.isValid());
		return this.activityGroupData.every((ele) => ele[FIELD_RESOURCE_ROLE.fieldApiName] !== undefined);
	}

	async validateTaskParamValues() {
		let areTaskParamValuesValid = true;
		const taskTemplateIds = this.activityGroupData.map((activityGroupElement) => activityGroupElement.Id);
		try {
			const paramValuesList = await getTaskParamValueTemplates({
				taskParamsTemplateIds: taskTemplateIds,
			});

			const paramsToTaskTemplateMap = {};
			taskTemplateIds.forEach((templateId) => {
				paramsToTaskTemplateMap[templateId] = [];
			});
			paramValuesList.forEach((paramValue) => {
				const templateId = paramValue[FIELD_TASK_PARAMETER_TEMPLATE.fieldApiName];
				paramsToTaskTemplateMap[templateId].push(paramValue);
			});
			areTaskParamValuesValid = taskTemplateIds.every((taskTemplateId) => paramsToTaskTemplateMap[taskTemplateId].length > 0);
		} catch (error) {
			log(error);
		}

		return areTaskParamValuesValid;
	}

	validateAndSave() {
		if (this.isFormInputsValid()) {
			this.saveRecord();
		}
	}

	isFormInputsValid() {
		if (this.type === this.templateTypes.TaskTemplates && !this.validateTaskTemplateLookups()) {
			this.showNotification(LABEL_VALIDATION_ERROR_TITLE, LABEL_ERROR_COULD_NOT_VALIDATE.replace('{0}', this.objectNameLabels.TaskTemplateName), 'warning');
			return false;
		}

		return this.validateAllInputFields();
	}

	async saveRecord() {
		this.disableSave = true;
		EstimateTemplateDataService.cleanupNewRecordIds(this.activityGroupData);

		this.clonedTasks = this.activityGroupData.filter((taskRec) => taskRec.OriginalTaskTemplateId !== undefined).map((a) => ({
			Id: a.OriginalTaskTemplateId,
			taskName: a.Name,
			guidance: a.Guidance_field,
			sequenceNumber: a.Sequence_field,
			resourceRole: a.ResourceroleId_field,
		}));
		const updatedActivityGroupData = this.activityGroupData.filter((taskRec) => taskRec.OriginalTaskTemplateId === undefined);
		await insertTaskParamsForClonedTasks({
			recordString: JSON.stringify(this.clonedTasks),
			objectApiName: this.templateTypes.TaskParameters,
		});

		if (this.deletedRecords.length > 0) {
			await deleteRecords({
				removeRecordIds: this.deletedRecords,
			});
		}

		const [isSuccess] = await saveRecords({
			recordString: JSON.stringify(updatedActivityGroupData),
			objectApiName: this.type,
		});

		if (this.entityPastedDisplayName) {
			this._messageService.notifySuccess(`${this.entityPastedDisplayName} successfully copied`);
			this.entityPastedDisplayName = null;
		} else {
			this.showNotification(LABEL_SUCCESS, LABEL_SUCCESSFULLY_SAVED.replace('{0}', this.modalHeader), isSuccess);
		}

		refreshApex(this.loadedData);
		this.closeModal();
	}
	// Close Param Values Modal Window..
	closeParamPopup() {
		this.deletedValues = [];
		this.showParamPopUp = false;
	}
	// Display Success or Failure notification..
	showNotification(title, message, variant) {
		const evt = new ShowToastEvent({
			title,
			message,
			variant,
		});

		this.dispatchEvent(evt);
	}
	// Add Values to the TaskParams/..
	async addValues(event) {
		const recId = event.target.dataset.id;
		const selectedRecord = this.activityGroupData.filter((e) => e.Id === recId)[0];
		this.paramsData = EstimateTemplateDataService.buildParamData(selectedRecord, this.activityGroupData);

		if (!EstimateTemplateDataService.isNewRecord(recId)) {
			const paramValues = await getTaskParamValues({
				taskParamsTemplateId: event.target.dataset.id,
			});

			const filteredParamValues = EstimateTemplateDataService.getCurrentParamValues(paramValues, selectedRecord, this.deletedRecords, this.type);
			if (filteredParamValues.length > 0) {
				this.paramsData.paramValues = filteredParamValues;
			}
		}

		this.setParamHeader(this.paramsData);

		if (!this.paramsData.paramValues > 0) {
			this.addRecordBasedonDataType(event);
		}

		this.showParamPopUp = true;
	}

	setParamHeader(paramsData) {
		if (paramsData.isCheckbox) {
			this.paramHeader = this.label.DefineDurationIfChecked;
		} else if (paramsData.isInteger) {
			this.paramHeader = this.label.LABEL_DEFINE_DURATION;
		} else if (paramsData.isPicklist || paramsData.IntegerTiers) {
			this.paramHeader = this.label.DefineRecommendedDurations;
		}
	}

	addRecordBasedonDataType(event) {
		const paramVal = [];

		const newRecord = EstimateTemplateDataService.newValueParamRecord(event.target.dataset.id,
			this.paramsData);

		paramVal.push(newRecord);

		this.paramsData.paramValues = paramVal;
		EstimateTemplateDataService.transformTaskParamValues('taskParamValues',
			this.type,
			this.paramsData.paramValues);
	}

	// Handling the Param value field changes..
	handleTaskParamsValueChange(event) {
		if (this.paramsData.paramValues !== undefined) {
			const parameterValueRecord = this.paramsData.paramValues.find((parameterValue) => parameterValue.Id === event.target.dataset.id);
			parameterValueRecord[event.target.dataset.field] = (event.target.type === 'Checkbox') ? event.target.checked : event.target.value;
		}

		EstimateTemplateDataService.transformTaskParamValues('taskParamValues',
			this.type,
			this.paramsData.paramValues);
	}

	async addIntegerTierValueRow(event) {
		const isPageInputValid = this.validateAllInputFields();
		if (isPageInputValid) {
			const recordId = event.target.dataset.id;
			const rowIndex = this.paramsData.paramValues.findIndex((row) => row.Id === recordId);
			const previousRecord = this.paramsData.paramValues[rowIndex];

			const newIntegerTierValueRow = EstimateTemplateDataService.buildNewIntegerTierValueRow(recordId,
				rowIndex,
				previousRecord);

			this.spliceIntoParameterValueRows(rowIndex, newIntegerTierValueRow);
			EstimateTemplateDataService.transformTaskParamValues('phasesGroupData', this.type, this.activityGroupData);
		}
	}

	async removeIntegerTierValueRow(event) {
		this.removeFromParameterValueRows(event, event.target.dataset.id);
	}

	async addPicklistValueRow(event) {
		const recordId = event.target.dataset.id;
		const rowIndex = this.paramsData.paramValues.findIndex((row) => row.Id === recordId);
		const newRow = EstimateTemplateDataService.buildNewPicklistTierRow(rowIndex, recordId);

		this.spliceIntoParameterValueRows(rowIndex, newRow);
	}

	async removePicklistValueRow(event) {
		this.removeFromParameterValueRows(event, event.target.dataset.id);
	}

	removeFromParameterValueRows(event, recordId) {
		this.paramsData.paramValues = this.paramsData.paramValues.filter((e) => e.Id !== recordId);
		this.paramsData.paramValues.forEach((ele, ind) => {
			const element = ele;
			element[FIELD_SEQUENCE.fieldApiName] = ind + 1;
		});
		this.deletedValues.push(recordId);

		if (this.paramsData.paramValues.length === 0) {
			this.addRecordBasedonDataType(event);
		}

		EstimateTemplateDataService.transformTaskParamValues('taskParamValues',
			this.type,
			this.paramsData.paramValues);
	}

	spliceIntoParameterValueRows(index, newRow) {
		if (newRow !== undefined) {
			this.paramsData.paramValues.splice(index + 1, 0, newRow);
			this.paramsData.paramValues.forEach((ele, ind) => {
				const element = ele;
				element[FIELD_SEQUENCE.fieldApiName] = ind + 1;
			});
		}

		EstimateTemplateDataService.transformTaskParamValues('taskParamValues',
			this.type,
			this.paramsData.paramValues);
	}
	// Save logic for Param Values
	async saveParamValues() {
		const isPageInputValid = (this.enableDurationFormula && this.paramsData.isInteger) ? this.validateDurationFormulaInputFields() : this.validateAllInputFields();
		if (isPageInputValid) {
			const response = await upsertTaskParamsValues({
				taskParamTemplateRecord: this.paramsData.taskTemplateParameter,
				taskParamValues: this.paramsData.paramValues,
			});

			if (response === 'Success') {
				this.activityGroupData = await getTaskParams({
					taskTemplateId: this.parentId,
				});
				this.showNotification(LABEL_SUCCESS, LABEL_SUCCESSFULLY_SAVED.replace('{0}', this.objectNameLabels.TaskParamValueName), 'success');
			}

			this.deletedRecords.push(...this.deletedValues);
			this.deletedValues = [];

			this.showParamPopUp = false;
		}

		EstimateTemplateDataService.transformTaskParamValues('taskParamValues',
			this.type,
			this.paramsData.paramValues);
		EstimateTemplateDataService.transformTaskParamValues('activityGroupData',
			this.type,
			this.activityGroupData);
	}

	async handleUpdateHashtagsData(event) {
		const hashtagData = event.detail.value;
		hashtagData.updatedParams.forEach((scopeParam) => {
			const hashtags = Object.keys(this._estimateHashtagService.getDictionary());

			// check if current scope param already exists
			const isHashtagNew = hashtags.every((hashtag) => {
				const savedParam = this._estimateHashtagService.getHashtag(hashtag);
				if (scopeParam.id === savedParam.id) {
					// if hashtag was simply modified, replace the key with updated hashtag
					this._estimateHashtagService.deleteHashtag(hashtag);
					this._estimateHashtagService.setHashtag(scopeParam.developerName, scopeParam);
					return false;
				}

				return true;
			});

			if (isHashtagNew) {
				this._estimateHashtagService.setHashtag(scopeParam.developerName, scopeParam);
			}
		});
		hashtagData.deletedParams.forEach((param) => {
			this._estimateHashtagService.deleteHashtag(param.developerName);
		});
	}
}
