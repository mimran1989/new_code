/* eslint-disable max-lines */
import {
	LightningElement, track, wire, api,
} from 'lwc';
import fetchRecords from '@salesforce/apex/EstimateTreeController.getRecords';
import getTaskDetails from '@salesforce/apex/EstimateTreeController.getTaskDetails';
import updateTask from '@salesforce/apex/EstimateTreeController.updateTask';
import updateTasks from '@salesforce/apex/EstimateTreeController.updateTasks';
import { getObjectInfo, getObjectInfos } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { getRecordNotifyChange, getRecord, updateRecord } from 'lightning/uiRecordApi';
import { componentNamespace } from 'c/util';
import { reduceErrors } from 'c/sparkUtils';
import SchemaDataService from 'c/schemaDataService';
import HashtagService from 'c/hashtagService';
import createSummaryRecords from '@salesforce/apex/EstimateTreeController.createSummaryRecords';
import getSourceSummary from '@salesforce/apex/EstimateTreeController.getSourceSummary';
import getRoleSummary from '@salesforce/apex/EstimateTreeController.getSummaryRecords';
import updateNotApplicableField from '@salesforce/apex/EstimateTreeController.updateNotApplicableField';
import hasScopeParameters from '@salesforce/apex/ScopeParameterController.hasScopeParameters';
import syncEstimateToQuote from '@salesforce/apex/SyncEstimateToQuoteController.syncEstimateToQuote';
import getResourceAvailability from '@salesforce/apex/ResourceAvailabilityController.getResourceAvailability';
import saveResourceAvailability from '@salesforce/apex/ResourceAvailabilityController.saveResourceAvailability';
import enableDurationFormula from '@salesforce/customPermission/DurationFormula';

import USE_PROJECT_PHASES_FIELD from '@salesforce/schema/Estimate__c.UseProjectPhases__c';
import RATECARD_ID_FIELD from '@salesforce/schema/Estimate__c.RateCardId__c';
import ESTIMATE_SYNC_TO_QUOTE_FIELD from '@salesforce/schema/Estimate__c.IsSyncChangesToQuote__c';
import ESTIMATENAME_LINKED_QUOTE_FIELD from '@salesforce/schema/Estimate__c.QuoteId__c';

import TASK_ROLE_SUMMARY from '@salesforce/schema/TaskRoleSummary__c';
import RESOURCEROLE_FIELD from '@salesforce/schema/TaskRoleSummary__c.ResourceRole__c';
import RESOURCE_ROLE_ID_FIELD from '@salesforce/schema/TaskRoleSummary__c.ResourceRoleId__c';
import LEVELADJUSTMENT_FIELD from '@salesforce/schema/TaskRoleSummary__c.LevelAdjustment__c';
import ACTIVITYID_FIELD from '@salesforce/schema/TaskRoleSummary__c.ActivityId__c';
import ACTIVITYGROUPID_FIELD from '@salesforce/schema/TaskRoleSummary__c.ActivityGroupId__c';
import ESTIMATEID_FIELD from '@salesforce/schema/TaskRoleSummary__c.EstimateId__c';

import PER_UNIT_DURATION_FIELD from '@salesforce/schema/TaskParameterValueTemplate__c.PerUnitDuration__c';
import FROM_VALUE_FIELD from '@salesforce/schema/TaskParameterValueTemplate__c.FromValue__c';
import TO_VALUE_FIELD from '@salesforce/schema/TaskParameterValueTemplate__c.ToValue__c';
import BOOLEANVALUE_FIELD from '@salesforce/schema/TaskParameterValue__c.BooleanValue__c';
import INTEGERVALUE_FIELD from '@salesforce/schema/TaskParameterValue__c.IntegerValue__c';
import TEXTVALUE_FIELD from '@salesforce/schema/TaskParameterValue__c.TextValue__c';
import TASK_PARAMETER_VALUE_TEMPLATE_OBJECT from '@salesforce/schema/TaskParameterValueTemplate__c';

import LABEL_ADJUST_HOURS from '@salesforce/label/c.AdjustHours';
import LABEL_SPECIFY_AVAILABILITY from '@salesforce/label/c.SpecifyAvailability';
import LABEL_ADD_RESOURCE from '@salesforce/label/c.AddResource';
import LABEL_CANCEL from '@salesforce/label/c.CancelButton';
import LABEL_CLOSE from '@salesforce/label/c.CloseButton';
import LABEL_DURATION_NOTIFICATION_MESSAGE from '@salesforce/label/c.DurationNotificationMessage';
import LABEL_LEVEL_ADJUSTMENT from '@salesforce/label/c.LevelAdjustment';
import LABEL_REQUIRED_FIELDS_MISSING_NOTIFICATION_MESSAGE from '@salesforce/label/c.RequiredFieldsMissingNotificationMessage';
import LABEL_RESOURCE from '@salesforce/label/c.Resource';
import LABEL_RESOURCE_NOTIFICATION_MESSAGE from '@salesforce/label/c.ResourceNotificationMessage';
import LABEL_SAVE from '@salesforce/label/c.SaveButton';
import LABEL_SPLIT from '@salesforce/label/c.Split';
import LABEL_SPLIT_RESOURCE from '@salesforce/label/c.SplitResource';
import LABEL_SHOW_ACTIVITIES from '@salesforce/label/c.ShowActivities';
import LABEL_SHOW_ACTIVITY_GROUP from '@salesforce/label/c.ShowActivityGroup';
import LABEL_SHOW_PROJECT_PHASE from '@salesforce/label/c.ShowProjectPhase';
import LABEL_SHOW_TASKS from '@salesforce/label/c.ShowTasks';
import LABEL_ACTIVITY_GROUP_COLUMN from '@salesforce/label/c.ActivityGroupColumn';
import LABEL_PROJECT_PHASE_COLUMN from '@salesforce/label/c.ProjectPhaseColumn';
import LABEL_SCOPE_DISCOVERY from '@salesforce/label/c.ScopeDiscovery';
import LABEL_SYNC_SUCCESS_MESSAGE from '@salesforce/label/c.SyncEstimateToQuoteSuccess';
import LABEL_SYNC_TO_QUOTE from '@salesforce/label/c.SyncToQuote';
import LABEL_REFRESH_NOTE from '@salesforce/label/c.RefreshNote';
import LABEL_AVAILABILITY_PERCENTAGE from '@salesforce/label/c.AvailabilityPercentage';

import {
	FIELDS,
	FIELD_RESOURCE_SPLITS,
	HASHTAG_USER_INPUT,
	actions,
	activityGroupActions,
} from './estimateTreeGridConstants';

import {
	buildTaskRecord,
	buildScopeSummaryColumns,
	buildTaskParameterValueRecord,
	isUserInputFormula,
	getTasksToUpdate,
} from './estimateTreeGridSupport';

let baseSummaryColumns = [];

export default class EstimateTreeGrid extends LightningElement {
	@api recordId;
	@api showSyncToQuote; // depreciated. should always show it if quote id exists.
	@track openModal = false;
	@track taskDetails;
	@track taskFieldDef;
	@track taskforUpdate;
	@track estimatedTaskCost = 0;
	@track estimatedTaskDuration = 0;
	@track taskrole;
	@track gridExpandedRows;
	@track phasesList = [];
	@track openResourceSummary = false;
	@track resourceSummary = [];
	@track resourceSummaryExists = false;
	@track gridColumns = [];
	@track gridData;
	@track gridDataMain;
	@track loadedData;
	@track taskparamrecs;
	@track adjustedTaskDuration = 0;
	@track taskRow;
	@track openEstimateResourceSummary = false;
	@track data;
	@track draftValues = [];
	@track suppress = false;
	@track addResourcePanel = false;
	@track newAdjustedAmount = 0;
	@track selectedRecord;
	@track showTskWizard = false;
	@track sortBy = [];
	@track sortDirection = [];
	@track scopeParametersExists = false;
	_schemaDataService = new SchemaDataService(this);
	_estimateHashtagService;
	error;
	hideSplitResource = true;
	showSource = false;
	showAdjustHours = false;
	sourceData;
	sourceColumns = [];
	integerTierParameterColumns = [];
	updateTasks = true;

	namespace;
	_componentState;
	_formulaEvaluator;
	_componentLoaded = false;

	Label = {
		ADD_RESOURCE: LABEL_ADD_RESOURCE,
		CLOSE: LABEL_CLOSE,
		LEVEL_ADJUSTMENT: LABEL_LEVEL_ADJUSTMENT,
		CANCEL: LABEL_CANCEL,
		SAVE: LABEL_SAVE,
		SHOW_ACTIVITIES: LABEL_SHOW_ACTIVITIES,
		SHOW_ACTIVITY_GROUP: LABEL_SHOW_ACTIVITY_GROUP,
		SHOW_PROJECT_PHASE: LABEL_SHOW_PROJECT_PHASE,
		SHOW_TASKS: LABEL_SHOW_TASKS,
		PROJECT_PHASE_COLUMN: LABEL_PROJECT_PHASE_COLUMN,
		ACTIVITY_GROUP_COLUMN: LABEL_ACTIVITY_GROUP_COLUMN,
		SCOPE_DISCOVERY: LABEL_SCOPE_DISCOVERY,
		SYNC_TO_QUOTE: LABEL_SYNC_TO_QUOTE,
	}

	isEstimate = false;
	istreegridload = true;

	@track columns = [];
	recordName;
	quoteId;
	isSyncChangesToQuote = true;
	useProjectPhases = false;
	_rateCardId;

	// Get Estimate record details..
	@wire(getRecord, { recordId: '$recordId', fields: FIELDS })
	async recordData(result) {
		const { data } = result;
		if (data) {
			this.recordName = data.fields.Name.value;
			this.useProjectPhases = data.fields[USE_PROJECT_PHASES_FIELD.fieldApiName].value;
			this._rateCardId = data.fields[RATECARD_ID_FIELD.fieldApiName].value;
			this.quoteId = data.fields[ESTIMATENAME_LINKED_QUOTE_FIELD.fieldApiName].value;
			this.isSyncChangesToQuote = data.fields[ESTIMATE_SYNC_TO_QUOTE_FIELD.fieldApiName].value;
		}
	}

	@wire(getObjectInfos, { objectApiNames: [TASK_ROLE_SUMMARY] })
	handleObjectSchemaInfoResults(getObjectInfosResult) {
		const objectSchemaInfos = this._schemaDataService.processObjectSchemaInfoResults(getObjectInfosResult);
		if (objectSchemaInfos.length > 0) {
			objectSchemaInfos.forEach((objectSchemaInfo) => {
				if (objectSchemaInfo.apiName === TASK_ROLE_SUMMARY.objectApiName) {
					const { fields } = objectSchemaInfo;
					baseSummaryColumns = [
						{
							label: LABEL_RESOURCE, fieldName: fields.ResourceRole.apiName, type: 'text', editable: false, sortable: 'true',
						},
						SchemaDataService.buildDataTableColumn(fields.TotalCalculatedDuration, { type: 'number', editable: false }),
						SchemaDataService.buildDataTableColumn(fields.TotalAdjustments, { type: 'number', editable: false, sortable: 'true' }),
						SchemaDataService.buildDataTableColumn(fields.LevelAdjustment, { type: 'number', editable: true }),
						SchemaDataService.buildDataTableColumn(fields.TotalEstimatedDuration, { type: 'number', editable: false, sortable: 'true' }),
					];
				}
			});
		}
	}

	get showSyncButton() {
		return this.isSyncChangesToQuote;
	}

	// Get Estimate record name...
	get estimateName() {
		return this.recordName;
	}
	// Get Estimate record name...
	get isPhasesEnabled() {
		return this.useProjectPhases;
	}
	get rateCardId() {
		return this._rateCardId;
	}
	get makeReadOnly() {
		return (this.quoteId !== null && !this.isSyncChangesToQuote);
	}
	// This method is to fetch the treegrid..
	@wire(fetchRecords, { estimateId: '$recordId' })
	async TreeData(result) {
		const { error, data } = result;
		this.loadedData = result;

		if (data) {
			if (data.length > 0) {
				this.gridExpandedRows = data[0].gridExpandedIds;
				this.loadColumns();
				this.istreegridload = false;
			}

			this.gridDataMain = data;
			this.gridData = data;
			await this.processAllFormulas();
		} else {
			this.toastError(error);
		}
	}

	@wire(getObjectInfo, { objectApiName: TASK_PARAMETER_VALUE_TEMPLATE_OBJECT })
	taskParamTemplateInfo({ data }) {
		if (data) {
			this.integerTierParameterColumns = [
				{
					label: data.fields[FROM_VALUE_FIELD.fieldApiName].label, fieldName: FROM_VALUE_FIELD.fieldApiName, type: 'text',
				},
				{
					label: data.fields[TO_VALUE_FIELD.fieldApiName].label, fieldName: TO_VALUE_FIELD.fieldApiName, type: 'text',
				},
				{
					label: 'Multiplier', fieldName: PER_UNIT_DURATION_FIELD.fieldApiName, type: 'text',
				},
			];
		}
	}

	@wire(hasScopeParameters, { estimateId: '$recordId' })
	setScopeParameterExists(result) {
		this.scopeParametersExists = result.data;
	}

	async connectedCallback() {
		this.namespace = componentNamespace(this);

		if (this.recordId && !this._componentLoaded) {
			await this.loadHashtags();
			this._componentLoaded = true;
		}
	}

	async renderedCallback() {
		this._formulaEvaluator = this.template.querySelector('c-formula-evaluator');
		this._componentState = this.template.querySelector('.component-state');

		if (this.recordId && !this._componentLoaded) {
			// should only run within the Estimate tab for quote
			await this.loadHashtags();
			// rerun formulas
			await this.processAllFormulas();
			this._componentLoaded = true;
		}
	}

	async loadHashtags() {
		this._estimateHashtagService = new HashtagService();
		await this._estimateHashtagService.loadHashtags(this.recordId);
		await this._formulaEvaluator.loadExpressions({
			...this._estimateHashtagService.getDictionary(),
			[HASHTAG_USER_INPUT]: 0,
		});
	}

	async processAllFormulas() {
		if (this.gridData && enableDurationFormula) {
			this.gridData = this.gridData.map((activityGroup) => {
				let activities = [...(activityGroup._children || [])];
				activities = activities.map((activity) => {
					const tasks = [...(activity._children || [])];
					for (let i = 0; i < tasks.length; i++) {
						tasks[i] = this.processTask(tasks[i]);
					}

					return {
						...activity,
						_children: tasks,
					};
				});

				return {
					...activityGroup,
					_children: activities,
				};
			});

			if (this.updateTasks) {
				await this.saveUpdatedTasks();
				await updateRecord({ fields: { Id: this.recordId } });
				refreshApex(this.loadedData);
				this.updateTasks = false;
			}
		}
	}

	async saveUpdatedTasks() {
		const tasksToUpdate = getTasksToUpdate(this.gridData);
		if (tasksToUpdate.length > 0) {
			await updateTasks({ tasks: tasksToUpdate });
		}
	}

	processTask(task) {
		if (!enableDurationFormula) {
			return task;
		}

		let calculatedDuration = 0;
		if (enableDurationFormula && task.EstimatedDurationFormula && !task.NotApplicable) {
			Object.keys(task.EstimatedDurationFormula).forEach((templateId) => {
				const { formula, selectedValue, perUnitDuration } = task.EstimatedDurationFormula[templateId];
				if (formula) {
					if (isUserInputFormula(formula)) {
						this._formulaEvaluator.addNamedExpression(HASHTAG_USER_INPUT, selectedValue);
					}

					calculatedDuration += this._formulaEvaluator.evaluateFormula(formula);
				} else {
					calculatedDuration += perUnitDuration;
				}
			});
		}

		return {
			...task,
			CalculatedDuration: calculatedDuration,
			EstimatedDuration: calculatedDuration + (+task.AdjustedDuration || 0),
		};
	}

	// This method is used for inline edit save at the resource level summary..
	handleSave(event) {
		this.suppress = true;

		const recordInputs = event.detail.draftValues.slice().map((draft) => {
			const fields = { ...draft };
			return { fields };
		});

		const promises = recordInputs.map((recordInput) => updateRecord(recordInput));
		Promise.all(promises).then(() => {
			this.dispatchEvent(
				new ShowToastEvent({
					title: 'Success',
					message: LABEL_DURATION_NOTIFICATION_MESSAGE,
					variant: 'success',
				}),
			);

			if (!this.isEstimate) {
				this.showResourceMethod(this.taskDetails);
				this.suppress = true;
			} else {
				getRoleSummary({ recordId: this.recordId, type: 'Estimate' })
					.then((result) => {
						this.data = result;
						this.resourceSummaryExists = result.length > 0;
					})
					.catch((e) => {
						this.toastError(e);
						this.contacts = undefined;
					});
			}

			return refreshApex(this.loadedData);
		}).catch((e) => {
			this.toastError(e);
		});
	}
	handleCellChange() {
		this.suppress = false;
	}
	addResource() {
		this.addResourcePanel = true;
		this.newAdjustedAmount = 0;
	}

	updateNewResourceAdjst(event) {
		this.newAdjustedAmount = event.target.value;
	}

	// eslint-disable-next-line max-lines-per-function
	loadColumns() {
		this.createScopeSummaryColumns();
		this.gridColumns = [
			{
				type: 'text',
				fieldName: 'ActivityGroup',
				label: this.isPhasesEnabled ? LABEL_PROJECT_PHASE_COLUMN : LABEL_ACTIVITY_GROUP_COLUMN,
				cellAttributes: { iconName: { fieldName: 'IconType' } },
				initialWidth: 400,
			},
			{
				type: 'boolean',
				fieldName: 'NotApplicable',
				label: 'N/A',
				initialWidth: 50,
				editable: true,

			},
			{
				type: 'text',
				fieldName: 'CalculatedDuration',
				label: 'Rolled-up Calculated Duration',
				cellAttributes: { alignment: 'center' },
			},
			{
				type: 'text',
				fieldName: 'AdjustedDuration',
				label: 'Rolled-Up Duration Adjustment',
				cellAttributes: { alignment: 'center' },
			},
			{
				type: 'text',
				fieldName: 'LevelAdjustments',
				label: 'Level Adjustments',
				cellAttributes: { alignment: 'center' },
			},
			{
				type: 'text',
				fieldName: 'EstimatedDuration',
				label: 'Estimated Duration',
				hideDefaultActions: 'true',
				cellAttributes: { iconName: { fieldName: 'NotTouched' }, iconPosition: 'right', alignment: 'center' },
			},
			{
				type: 'text',
				fieldName: 'Resourcerole',
				label: 'Resource Role',
				wrapText: true,
			},
		];

		if (!this.makeReadOnly) {
			this.gridColumns.push({
				label: '',
				type: 'button',
				initialWidth: 75,
				typeAttributes: {
					iconName: { fieldName: 'ActionIcon' },
					title: { fieldName: 'ActionbuttonTitle' },
					variant: 'border-filled',
					disabled: {
						fieldName: 'ActionIconDisabled',
					},
				},
			});
		}
	}

	loadSummaryColumns(rowActions) {
		if (!this.makeReadOnly) {
			this.columns = [
				...baseSummaryColumns,
				{
					type: 'action',
					typeAttributes: { rowActions: Object.values(rowActions), menuAlignment: 'auto' },
					cellAttributes: { class: { fieldName: 'cssClass' } },
				},
			];
		} else {
			this.columns = baseSummaryColumns;
		}
	}
	// Initialize Scope Summary Columns
	createScopeSummaryColumns() {
		this.sourceColumns = buildScopeSummaryColumns(this.isPhasesEnabled);
	}
	// This function is used to collapse and expand the tree based on the user selection..
	showAG() {
		const actGrp = [];
		if (this.isPhasesEnabled) {
			this.gridData.forEach((def) => {
				Object.keys(def._children).forEach((key) => {
					if (def._children[key].Type === 'ActivityGroup') {
						actGrp.push(def.ActivityGroupId);
					}
				});
			});
		} else {
			const grid = this.template.querySelector('lightning-tree-grid');
			grid.collapseAll();
		}

		this.gridExpandedRows = actGrp;
	}
	// This function is used to collapse and expand the tree based on the user selection..
	showPhases() {
		const grid = this.template.querySelector('lightning-tree-grid');
		grid.collapseAll();
	}
	// This function is used to collapse and expand the tree based on the user selection..
	showActivity() {
		const actGrp = [];
		if (this.isPhasesEnabled) {
			this.gridData.forEach((def) => {
				Object.keys(def._children).forEach((key) => {
					Object.keys(def._children[key]._children).forEach((key1) => {
						if (def._children[key]._children[key1].Type === 'Activity') {
							actGrp.push(def.ActivityGroupId);
							actGrp.push(def._children[key].ActivityGroupId);
						}
					});
				});
			});
		} else {
			this.gridData.forEach((def) => {
				Object.keys(def._children).forEach((key) => {
					if (def._children[key].Type === 'Activity') {
						actGrp.push(def.ActivityGroupId);
					}
				});
			});
		}

		this.gridExpandedRows = actGrp;
	}
	// This function is used to collapse and expand the tree based on the user selection..
	showTasks() {
		const grid = this.template.querySelector('lightning-tree-grid');
		grid.expandAll();
	}
	// Invokes the Resource Summary Page at the Estimate level..
	async showEstimateResourceSummary() {
		this.refreshSummaries = () => this.showEstimateResourceSummary();
		this.loadSummaryColumns(actions);
		this.data = [];
		this.isEstimate = true;
		this.addResourcePanel = false;
		this.suppress = false;
		this.openEstimateResourceSummary = true;
		this.newAdjustedAmount = 0;
		this.addResourcePanel = false;
		const result = await getRoleSummary({ recordId: this.recordId, type: 'Estimate' });
		if (result) {
			this.data = result;
			this.resourceSummaryExists = result.length > 0;
		}
	}
	// Row level actions for the lightning tree grid..
	handleRowAction(event) {
		const { row } = event.detail;
		this.refreshSummaries = () => this.showResourceMethod(row, row.Type);

		switch (row.Type) {
			case 'Phase':
				break;
			case 'ActivityGroup':
				this.showResourceMethod(row, row.Type);
				break;
			case 'Activity':
				this.showResourceMethod(row);
				break;
			case 'Task':
				this.showTaskDetails(row);
				break;
			default:
		}
	}

	// This function is called when Resource summary button is clicked at the Activity group and activity level..
	async showResourceMethod(row, type) {
		this.loadSummaryColumns(actions);

		if (type === 'ActivityGroup') {
			this.loadSummaryColumns(activityGroupActions);
		}

		this.data = [];
		this.isEstimate = false;
		this.suppress = true;
		this.addResourcePanel = false;
		this.taskDetails = row;
		this.openResourceSummary = true;
		const result = await getRoleSummary({ recordId: row.ActivityGroupId, type: row.Type });
		if (result) {
			this.data = result;
			this.transformChildren();
			this.resourceSummaryExists = result.length > 0;
		}
	}

	transformChildren() {
		let resourceSplitRelField;
		this.data.forEach((nextRow) => {
			const summary = nextRow;
			if (!resourceSplitRelField) {
				Object.keys(summary).forEach((nextKey) => {
					if (nextKey.indexOf(FIELD_RESOURCE_SPLITS) >= 0) {
						resourceSplitRelField = nextKey;
					}
				});
			}

			if (summary[resourceSplitRelField]?.length) {
				summary._children = summary[resourceSplitRelField];
				summary._children.forEach((nextChild) => {
					const split = nextChild;
					split[RESOURCEROLE_FIELD.fieldApiName] = split.Name;
					split.cssClass = 'slds-hide';
				});
			}
		});
	}

	setTaskParam(taskParams) {
		this.taskFieldDef = taskParams.map((taskParam) => {
			let showUserInput = true;
			if (enableDurationFormula && this.taskDetails.EstimatedDurationFormula) {
				const formulaDto = this.taskDetails.EstimatedDurationFormula[taskParam.FieldId];
				if (formulaDto) {
					const { formula } = formulaDto;
					if (formula) {
						showUserInput = isUserInputFormula(formula);
					}
				}
			}

			return {
				...taskParam,
				showUserInput,
			};
		});
	}

	// This function is called when Edit Task is invoked from the task level..
	async showTaskDetails(row) {
		this.taskDetails = row;
		this.estimatedTaskDuration = row.EstimatedDuration;
		this.adjustedTaskDuration = row.AdjustedDuration;
		this.taskrole = row.Resourcerole;
		const formulas = row.EstimatedDurationFormula;
		const result = await getTaskDetails({ taskId: row.ActivityGroupId });
		if (result) {
			this.setTaskParam(result.TaskParams);
			this.taskDetails = this.processTask({
				...result.TaskDetails,
				EstimatedDurationFormula: formulas,
			});

			this.openModal = true;
		}
	}

	async showSourceSummary() {
		this.sourceData = [];
		const result = await getSourceSummary({ estimateId: this.recordId });
		if (result) {
			result.forEach((ele) => {
				const rec = buildTaskParameterValueRecord(ele, this.isPhasesEnabled);
				this.sourceData.push(rec);
			});
			this.showSource = true;
		}
	}
	// To handle event for SourceSummaryData
	handleSortSourceSummaryData(event) {
		const sortByValue = event.detail.fieldName;
		const sortDirectionValue = event.detail.sortDirection;
		this.sortBy = sortByValue;
		this.sortDirection = sortDirectionValue;
		const parseData = JSON.parse(JSON.stringify(this.sourceData));
		this.sortSummaryData(this.sortBy, this.sortDirection, parseData);
	}
	// To handle event for ResourceSummaryData
	handleResourceSummaryData(event) {
		const sortByValue = event.detail.fieldName;
		const sortDirectionValue = event.detail.sortDirection;
		this.sortBy = sortByValue;
		this.sortDirection = sortDirectionValue;
		const parseData = JSON.parse(JSON.stringify(this.data));
		this.sortSummaryData(this.sortBy, this.sortDirection, parseData);
	}
	// Sorting the columns of sourcesummary and resourcesummary by ascending and descending order
	sortSummaryData(fieldname, direction, parseData) {
		const keyValue = (keyVal) => {
			const value = keyVal[fieldname];
			return typeof value === 'string' ? value.toUpperCase() : value;
		};

		const isReverse = direction === 'asc' ? 1 : -1;
		parseData.sort((firstVal, lastVal) => {
			let firstValue = firstVal;
			let lastValue = lastVal;
			firstValue = keyValue(firstValue) ? keyValue(firstValue) : '';
			lastValue = keyValue(lastValue) ? keyValue(lastValue) : '';
			return isReverse * ((firstValue > lastValue) - (lastValue > firstValue));
		});
		this.sourceData = parseData;
		this.data = parseData;
	}

	async saveAndRetrieveTask(taskIdToRetrieve) {
		await updateTask({ tsk: buildTaskRecord(this.taskDetails), taskParams: this.taskparamrecs });
		refreshApex(this.loadedData);
		getRecordNotifyChange([{ recordId: this.recordId }]);
		this.adjustedTaskDuration = 0;
		const result = await getTaskDetails({ taskId: taskIdToRetrieve });
		if (result) {
			this.resetTaskDetails(result);
		}
	}

	async getPreviousSaveTask() {
		await this.saveAndRetrieveTask(this.taskDetails.beforeTaskId);
	}

	async getNextSaveTask() {
		await this.saveAndRetrieveTask(this.taskDetails.afterTaskId);
	}

	resetTaskDetails(result) {
		this.taskDetails = result.TaskDetails;
		this.setTaskParam(result.TaskParams);
		this.estimatedTaskDuration = this.taskDetails.EstimatedDuration;
		this.adjustedTaskDuration = this.taskDetails.AdjustedDuration;
		this.taskrole = this.taskDetails.Resourcerole;
		this.openModal = true;
	}

	closeResourceModal() {
		this.addResourcePanel = false;
	}
	// Method to capture the resourceId selected in the Lookup component..
	SelectedResource(event) {
		this.selectedRecord = event.detail.recordId;
	}

	showValidationMessage() {
		const event = new ShowToastEvent({
			title: LABEL_REQUIRED_FIELDS_MISSING_NOTIFICATION_MESSAGE,
			variant: 'error',
			mode: 'dismissable',
		});

		this.dispatchEvent(event);
	}

	async saveResource() {
		const summaryRec = {};
		if (this.isEstimate) {
			summaryRec[ESTIMATEID_FIELD.fieldApiName] = this.recordId;
		} else if (this.taskDetails.Type === 'Activity') {
			summaryRec[ACTIVITYID_FIELD.fieldApiName] = this.taskDetails.ActivityGroupId;
		} else if (this.taskDetails.Type === 'ActivityGroup') {
			summaryRec[ACTIVITYGROUPID_FIELD.fieldApiName] = this.taskDetails.ActivityGroupId;
		}

		if (!this.selectedRecord) {
			this.showValidationMessage();
			return;
		}

		summaryRec[RESOURCE_ROLE_ID_FIELD.fieldApiName] = this.selectedRecord;
		summaryRec[LEVELADJUSTMENT_FIELD.fieldApiName] = this.newAdjustedAmount;
		const rectype = this.isEstimate ? 'Estimate' : this.taskDetails.Type;
		await createSummaryRecords({ summaryRecord: summaryRec, typeof: rectype });

		const event = new ShowToastEvent({
			title: LABEL_RESOURCE_NOTIFICATION_MESSAGE,
			variant: 'success',
			mode: 'dismissable',
		});

		this.dispatchEvent(event);
		this.selectedRecord = undefined;
		getRecordNotifyChange([{ recordId: this.recordId }]);
		this.addResourcePanel = false;

		if (this.isEstimate) {
			this.showEstimateResourceSummary(event);
		} else {
			this.showResourceMethod(this.taskDetails);
		}

		refreshApex(this.loadedData);
	}

	// Generic method to close modal windows..
	closeModal() {
		this.openModal = false;
		this.openResourceSummary = false;
		this.openEstimateResourceSummary = false;
		this.addResourcePanel = false;
		this.showSource = false;
	}

	async handleAfterSaveScopeParams(event) {
		const scopeParams = event.detail.value;
		if (scopeParams.length && enableDurationFormula) {
			scopeParams.forEach((nextParam) => {
				this._estimateHashtagService.setHashtag(nextParam.hashtag, nextParam.value);
				this._formulaEvaluator.addNamedExpression(nextParam.hashtag, nextParam.value);
			});
		}

		refreshApex(this.loadedData);

		this.updateTasks = true;
		await this.processAllFormulas();
		getRecordNotifyChange([{ recordId: this.recordId }]);
	}

	async saveAndClose() {
		this.openResourceSummary = false;
		this.openEstimateResourceSummary = false;

		if (!this.isEstimate) {
			if (this.taskDetails.NotApplicable) {
				const event = new ShowToastEvent({
					title: `${this.taskDetails.Type}-${this.taskDetails.ActivityGroupName} is made "Not Applicable".`,
					variant: 'success',
					mode: 'dismissable',
				});

				this.dispatchEvent(event);
			}

			this.updateTasks = true;
			this.openModal = false;

			try {
				await updateNotApplicableField({
					recordId: this.taskDetails.ActivityGroupId,
					notApplicable: this.taskDetails.NotApplicable,
					type: this.taskDetails.Type,
				});

				refreshApex(this.loadedData);
				getRecordNotifyChange([{ recordId: this.recordId }]);
				this.adjustedTaskDuration = 0;
			} catch (e) {
				this.toastError(e);
			}
		}
	}
	NotApplicable(event) {
		this.taskDetails.NotApplicable = event.target.checked;

		if (event.target.checked) {
			// Can add modal window confirmation box.
		}
	}
	// This function is called when a task is saved from the Edit Task Screen.
	saveTask() {
		const taskrec = buildTaskRecord(this.taskDetails);

		updateTask({ tsk: taskrec, taskParams: this.taskparamrecs })
			.then(() => {
				refreshApex(this.loadedData);

				const event = new ShowToastEvent({
					title: 'Task Updated Successfully',
					variant: 'success',
					mode: 'dismissable',
				});

				this.dispatchEvent(event);
				this.openModal = false;
				getRecordNotifyChange([{ recordId: this.recordId }]);
				this.adjustedTaskDuration = 0;
			})
			.catch((e) => {
				this.toastError(e);
			});
	}
	// Calulation when adjustment is changed at the tasklevel in the Edit task screen.
	handleAdjustmentAmountChange(e) {
		if (e.detail.value === '' || e.detail.value === null) {
			this.taskDetails.AdjustedDuration = 0;
		}

		this.taskDetails.AdjustedDuration = e.detail.value;
		this.taskDetails.EstimatedDuration = +this.taskDetails.CalculatedDuration + +e.detail.value;
	}
	// Assign the adjustment reason value to the taskdetails variable
	handleAdjustmentReason(e) {
		this.taskDetails.AdjustmentReason = e.detail.value;
	}
	// This method is invoked when fields are changed in the Edit task Screen.
	handleChange(event) {
		let enteredValue = event.target.value;
		if (enteredValue === null || enteredValue === '') enteredValue = 0;

		this.taskFieldDef.forEach((def) => {
			const element = def;
			if (element.FieldId === event.target.name) {
				if (def.Datatype === 'Integer' || def.Datatype === 'Integer Tiers') {
					element.selectedValue = +enteredValue;
				} else if (element.Datatype === 'Picklist') {
					element.selectedValue = enteredValue;
					element.picklistLabel = event.target.options.find((opt) => opt.value === event.detail.value).label;
				} else if (element.Datatype === 'Checkbox') {
					element.selectedValue = event.target.checked;
				}
			}
		});

		this.updateTaskDetails(this.taskFieldDef);
	}

	evaluateFormulaForTaskParam(taskParam) {
		let currentSelectedValue = +taskParam.selectedValue;
		let addedDuration = 0;
		if (enableDurationFormula) {
			if (taskParam.showUserInput) {
				this._formulaEvaluator.addNamedExpression(HASHTAG_USER_INPUT, taskParam.selectedValue);
			}

			if (this.taskDetails.EstimatedDurationFormula) {
				const formulaDto = this.taskDetails.EstimatedDurationFormula[taskParam.FieldId];
				if (formulaDto) {
					const { formula } = formulaDto;
					currentSelectedValue = this._formulaEvaluator.evaluateFormula(formula);
				}
			}

			addedDuration += currentSelectedValue;
		} else {
			addedDuration += (+taskParam.selectedValue * +taskParam.Multiplier);
		}

		return {
			currentSelectedValue,
			addedDuration,
		};
	}

	updateTaskDetails(fieldDef) {
		let calculatedtaskDuration = 0;
		const recs = [];
		fieldDef.forEach((def) => {
			if (def.selectedValue !== undefined) {
				const paramrec = {};
				paramrec.Id = def.TaskParameterValueId;

				if (def.Datatype === 'Integer') {
					const evaluatedFormula = this.evaluateFormulaForTaskParam(def);
					calculatedtaskDuration += evaluatedFormula.addedDuration;
					paramrec[INTEGERVALUE_FIELD.fieldApiName] = +def.selectedValue;
				} else if (def.Datatype === 'Picklist') {
					calculatedtaskDuration += +def.selectedValue;
					paramrec[TEXTVALUE_FIELD.fieldApiName] = def.picklistLabel;
				} else if (def.Datatype === 'Checkbox') {
					paramrec[BOOLEANVALUE_FIELD.fieldApiName] = def.selectedValue;
					calculatedtaskDuration += paramrec[BOOLEANVALUE_FIELD.fieldApiName] ? +def.Multiplier : 0;
				} else if (def.Datatype === 'Integer Tiers') {
					paramrec[INTEGERVALUE_FIELD.fieldApiName] = +def.selectedValue;
					// eslint-disable-next-line max-len
					const matchTier = def.IntegerTiers.find((ele) => ele[FROM_VALUE_FIELD.fieldApiName] <= +def.selectedValue && +def.selectedValue <= ele[TO_VALUE_FIELD.fieldApiName]);
					if (matchTier !== undefined) {
						calculatedtaskDuration += (+def.selectedValue * +matchTier[PER_UNIT_DURATION_FIELD.fieldApiName]);
					}
				}

				recs.push(paramrec);
			}
		});
		this.taskparamrecs = recs;
		this.taskDetails.CalculatedDuration = calculatedtaskDuration;
		this.taskDetails.EstimatedDuration = +this.taskDetails.CalculatedDuration + +this.taskDetails.AdjustedDuration;
	}

	toastError(error) {
		this.dispatchEvent(
			new ShowToastEvent({
				title: 'Application Exception',
				message: reduceErrors(error).join(', '),
				variant: 'error',
			}),
		);
	}

	handleResourceRowAction(event) {
		const { row } = event.detail;
		const rowId = row.Id;
		switch (event.detail.action.name) {
			case 'adjust_hours':
				this.openAdjustHoursDialog(rowId, row[LEVELADJUSTMENT_FIELD.fieldApiName]);
				break;
			case 'specify_availability':
				this.openSpecifyAvailabilityDialog(rowId);
				break;
			case 'split':
				this.openSplitDialog(rowId, row[RESOURCEROLE_FIELD.fieldApiName]);
				break;
			default:
		}
	}

	async handleAfterAdjustHours(event) {
		const values = event.detail.value;
		await updateRecord({
			fields: {
				Id: this.currentRowId,
				[LEVELADJUSTMENT_FIELD.fieldApiName]: values.levelAdjustment,
			},
		});

		this.refreshSummaries();
	}

	async handleAfterSpecifyAvailability(event) {
		const values = event.detail.value;
		this.availabilityDto.availabilityPercentage = values.availabilityPercentage;

		try {
			await saveResourceAvailability({ resourceAvailabilityDto: this.availabilityDto });
		} catch (e) {
			this.toastError(e);
		}
	}

	handleAfterSplit() {
		this.refreshSummaries();
	}

	openAdjustHoursDialog(rowId, initialLevelAdjustment) {
		this.currentRowId = rowId;

		const inputFields = [
			{
				key: 'levelAdjustment',
				type: 'number',
				value: initialLevelAdjustment,
				label: LABEL_LEVEL_ADJUSTMENT,
				required: true,
			},
		];

		const dialogServicePayload = {
			method: 'bodyModal',
			config: {
				auraId: 'adjust-hours-dialog',
				headerLabel: LABEL_ADJUST_HOURS,
				component: `${this.namespace}:inputForm`,
				componentParams: {
					inputFields,
					eventKey: 'afteradjusthours',
					uniqueBoundary: 'component-state',
				},
				footerActions: [
					{ label: LABEL_CLOSE, eventName: 'close', class: '' },
					{ label: LABEL_SAVE, eventName: 'c.save', class: 'slds-button_brand' },
				],
			},
		};

		this._componentState.dialogService(dialogServicePayload);
	}

	async openSpecifyAvailabilityDialog(rowId) {
		this.availabilityDto = await getResourceAvailability({ taskRoleSummaryId: rowId });

		const inputFields = [
			{
				key: 'availabilityPercentage',
				type: 'number',
				formatter: 'percent-fixed',
				value: this.availabilityDto.availabilityPercentage,
				min: 1,
				max: 100,
				label: LABEL_AVAILABILITY_PERCENTAGE,
				required: true,
			},
		];

		const dialogServicePayload = {
			method: 'bodyModal',
			config: {
				auraId: 'specify-availability-dialog',
				headerLabel: LABEL_SPECIFY_AVAILABILITY,
				component: `${this.namespace}:inputForm`,
				componentParams: {
					inputFields,
					eventKey: 'afterspecifyavailability',
					uniqueBoundary: 'component-state',
				},
				footerActions: [
					{ label: LABEL_CLOSE, eventName: 'close', class: '' },
					{ label: LABEL_SAVE, eventName: 'c.save', class: 'slds-button_brand' },
				],
			},
		};

		this._componentState.dialogService(dialogServicePayload);
	}

	openSplitDialog(roleSummaryId, roleName) {
		const dialogServicePayload = {
			method: 'bodyModal',
			config: {
				auraId: 'split-resource-dialog',
				headerLabel: LABEL_SPLIT_RESOURCE,
				component: `${this.namespace}:splitResourceDialog`,
				componentParams: {
					uniqueBoundary: 'component-state',
					roleSummaryId,
					roleName,
				},
				footerActions: [
					{ label: LABEL_CLOSE, eventName: 'close' },
					{ label: LABEL_SPLIT, eventName: 'split', class: 'slds-button_brand' },
				],
			},
		};

		this._componentState.dialogService(dialogServicePayload);
	}

	showScopeDiscovery() {
		const dialogServicePayload = {
			method: 'bodyModal',
			config: {
				auraId: 'scope-discovery-dialog',
				headerLabel: 'Scope discovery',
				component: `${this.namespace}:estimateScopeDiscovery`,
				componentParams: {
					recordId: this.recordId,
				},
				footerActions: [
					{ label: 'Previous', eventName: 'c.handlePrevious' },
					{ label: 'Next', eventName: 'c.handleNext' },
					{ label: 'Save', eventName: 'c.save', class: 'slds-button_brand' },
				],
			},
		};

		this._componentState.dialogService(dialogServicePayload);
	}

	async handleQuickSync() {
		try {
			const quoteName = await syncEstimateToQuote({ estimateId: this.recordId });
			if (quoteName) {
				this.showNotification(`${LABEL_SYNC_SUCCESS_MESSAGE} - ${quoteName}`, LABEL_REFRESH_NOTE, 'success');
				this._componentState.publishOpen({ key: 'onrefreshestimate' });
			}
		} catch (error) {
			this.showNotification(this.errorMsg, error.body.message, 'error');
		}
	}

	showNotification(title, message, variant) {
		this.dispatchEvent(
			new ShowToastEvent({
				title: LABEL_SYNC_SUCCESS_MESSAGE,
				message,
				variant: variant || 'success',
			}),
		);
	}
}
