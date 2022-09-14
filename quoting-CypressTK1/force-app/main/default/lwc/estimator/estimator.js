/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import { api, LightningElement, wire } from 'lwc';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import getEstimateForId from '@salesforce/apex/EstimatorController.getEstimateForId';
import getData from '@salesforce/apex/EstimatorController.getData';
import hasScopeParameters from '@salesforce/apex/ScopeParameterController.hasScopeParameters';
import ESTIMATE_SYNC_TO_QUOTE_FIELD from '@salesforce/schema/Estimate__c.IsSyncChangesToQuote__c';
import ESTIMATENAME_LINKED_QUOTE_FIELD from '@salesforce/schema/Estimate__c.QuoteId__c';
import { componentNamespace, isNullOrUndefined } from 'c/util';

import ScopeSummary from '@salesforce/label/c.ScopeSummary';
import ScopeDiscovery from '@salesforce/label/c.ScopeDiscovery';
import Previous from '@salesforce/label/c.Previous';
import NextButton from '@salesforce/label/c.Next';
import SaveButton from '@salesforce/label/c.SaveButton';
import CloseButton from '@salesforce/label/c.CloseButton';
import ResourceSummary from '@salesforce/label/c.ResourceSummary';
import TaskDiscovery from '@salesforce/label/c.TaskDiscovery';

const processData = (data) => {
	data.forEach((nextRow) => {
		const currentRow = nextRow;
		switch (currentRow.type) {
			case 'Activity Group':
				currentRow.icon = 'standard:work_type_group';
				currentRow.actionIcon = 'action:share_poll';
				currentRow.actionButtonEvent = 'openResourceSummary';
				break;
			case 'Activity':
				currentRow.icon = 'standard:work_type';
				currentRow.actionIcon = 'action:share_poll';
				currentRow.actionButtonEvent = 'openResourceSummary';
				break;
			case 'Task':
				currentRow.icon = 'standard:task';
				currentRow.actionIcon = 'action:edit';
				currentRow.actionButtonEvent = 'editTask';
				currentRow.modifiedIcon = currentRow.totalEstimatedDuration ? '' : 'utility:warning';
				break;
			default:
		}

		if (currentRow.children) {
			currentRow._children = currentRow.children;
			processData(currentRow.children);
		}
	});
};

const getIdsByType = (data, idsByType = {}) => {
	data.forEach((nextRow) => {
		const currentIdsByType = idsByType;
		const idsForType = currentIdsByType[nextRow.type] || [];
		currentIdsByType[nextRow.type] = idsForType;
		idsForType.push(nextRow.id);

		if (nextRow.children) {
			getIdsByType(nextRow.children, idsByType);
		}
	});

	return idsByType;
};

export default class Estimator extends LightningElement {
	@api recordId;

	_treegrid;
	_messageService;
	#expanded;

	estimate;
	data;
	idsByType;
	expandedRowIds = [];
	isComponentShown = false;
	scopeParametersExists = false;
	showSyncButton = false;

	columns = [
		{
			type: 'text',
			fieldName: 'name',
			label: 'Activity Group/Activity/Task',
			cellAttributes: { iconName: { fieldName: 'icon' } },
			initialWidth: 400,
		},
		{
			type: 'boolean',
			fieldName: 'isNotApplicable',
			label: 'N/A',
			initialWidth: 50,
			editable: true,

		},
		{
			type: 'text',
			fieldName: 'totalCalculatedDuration',
			label: 'Rolled-up Calculated Duration',
			cellAttributes: { alignment: 'center' },
		},
		{
			type: 'text',
			fieldName: 'totalAdjustments',
			label: 'Rolled-Up Duration Adjustment',
			cellAttributes: { alignment: 'center' },
		},
		{
			type: 'text',
			fieldName: 'totalLevelAdjustments',
			label: 'Level Adjustments',
			cellAttributes: { alignment: 'center' },
		},
		{
			type: 'text',
			fieldName: 'totalEstimatedDuration',
			label: 'Estimated Duration',
			hideDefaultActions: 'true',
			cellAttributes: { iconName: { fieldName: 'modifiedIcon' }, iconPosition: 'right', alignment: 'center' },
		},
		{
			type: 'text',
			fieldName: 'resourceRoleName',
			label: 'Resource Role',
			wrapText: true,
		},
		{
			label: '',
			type: 'button',
			initialWidth: 75,
			typeAttributes: {
				iconName: { fieldName: 'actionIcon' },
				title: { fieldName: 'actionButtonEvent' },
				variant: 'border-filled',
			},
		},
	];

	@wire(hasScopeParameters, { estimateId: '$recordId' })
	setScopeParameterExists(result) {
		this.scopeParametersExists = result.data;
	}

	@wire(getRecord, { recordId: '$recordId', fields: [ESTIMATENAME_LINKED_QUOTE_FIELD, ESTIMATE_SYNC_TO_QUOTE_FIELD] })
	recordData(result) {
		const { data } = result;
		if (data) {
			const quoteId = data.fields[ESTIMATENAME_LINKED_QUOTE_FIELD.fieldApiName].value;
			this.showSyncButton = data.fields[ESTIMATE_SYNC_TO_QUOTE_FIELD.fieldApiName].value && !isNullOrUndefined(quoteId);
		}
	}

	async connectedCallback() {
		this.namespace = componentNamespace(this);
		this.estimate = await getEstimateForId({ estimateId: this.recordId });
		await this.refreshData();
		this.idsByType = getIdsByType(this.data);
	}

	async refreshData() {
		this.data = await getData({ estimateId: this.recordId });
		processData(this.data);
	}

	renderedCallback() {
		this._treegrid = this.template.querySelector('lightning-tree-grid');
		this._messageService = this.template.querySelector('c-message-service');

		try {
			if (!this.#expanded && this._treegrid) {
				this._treegrid.expandAll();
				this.#expanded = true;
			}
		} catch (e) {
			// ignore, expandAll will fail to run until the DOM is rendered
		}
	}

	handleRowAction(event) {
		const { row } = event.detail;
		if (row.actionButtonEvent === 'openResourceSummary') {
			this.openResourceSummaryDialog(row);
		} else {
			this.openTaskDiscovery(row.id);
			// TODO: open task parameter component
		}
	}

	openTaskDiscovery(rowId) {
		const dialogServicePayload = {
			method: 'bodyModal',
			config: {
				auraId: 'task-discovery-dialog',
				headerLabel: TaskDiscovery,
				component: `${this.namespace}:taskDiscovery`,
				componentParams: {
					recordId: this.recordId,
					initialTaskId: rowId,
				},
				footerActions: [
					{ label: Previous, eventName: 'c.handlePrevious' },
					{ label: NextButton, eventName: 'c.handleNext' },
					{ label: SaveButton, eventName: 'c.save', class: 'slds-button_brand' },
				],
			},
		};

		this._messageService.dialogService(dialogServicePayload);
	}

	openResourceSummaryDialog(row) {
		const dialogServicePayload = {
			method: 'bodyModalLarge',
			config: {
				auraId: 'resource-summary-dialog',
				headerLabel: ResourceSummary,
				component: `${this.namespace}:resourceSummary`,
				componentParams: {
					recordId: row.id,
					type: row.type,
					isNotApplicable: row.isNotApplicable,
					rateCardId: this.estimate.rateCardId,
				},
				footerActions: [
					{ label: CloseButton, eventName: 'close', class: 'slds-button_brand' },
				],
			},
		};

		this._messageService.dialogService(dialogServicePayload);
	}

	showActivityGroups() {
		this.expandedRowIds = [];
		this._treegrid.collapseAll();
	}
	showActivities() {
		this.expandedRowIds = this.idsByType['Activity Group'];
	}
	showTasks() {
		this.expandedRowIds = [...this.idsByType['Activity Group'], ...this.idsByType.Activity];
	}

	openEstimateResourceSummary() {
		const row = {
			id: this.recordId,
			type: 'Estimate',
		};

		this.openResourceSummaryDialog(row);
	}

	openScopeDiscovery() {
		const dialogServicePayload = {
			method: 'bodyModal',
			config: {
				auraId: 'scope-discovery-dialog',
				headerLabel: ScopeDiscovery,
				component: `${this.namespace}:estimateScopeDiscovery`,
				componentParams: {
					recordId: this.recordId,
				},
				footerActions: [
					{ label: Previous, eventName: 'c.handlePrevious' },
					{ label: NextButton, eventName: 'c.handleNext' },
					{ label: SaveButton, eventName: 'c.save', class: 'slds-button_brand' },
				],
			},
		};

		this._messageService.dialogService(dialogServicePayload);
	}

	openScopeSummary() {
		const dialogServicePayload = {
			method: 'bodyModalLarge',
			config: {
				auraId: 'scope-summary-dialog',
				headerLabel: ScopeSummary,
				component: `${this.namespace}:scopeSummary`,
				componentParams: {
					estimateId: this.recordId,
				},
				footerActions: [
					{ label: CloseButton, eventName: 'close', class: 'slds-button_brand' },
				],
			},
		};

		this._messageService.dialogService(dialogServicePayload);
	}

	async handleResourceUpdate() {
		await this.refreshData();
		const fields = {};
		fields.Id = this.recordId;
		const recordInput = { fields };

		updateRecord(recordInput);
	}
}
