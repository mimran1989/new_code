/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

import { api, LightningElement } from 'lwc';
import getRoleSummaries from '@salesforce/apex/ResourceSummaryController.getRoleSummaries';
import getResourceAvailability from '@salesforce/apex/ResourceAvailabilityController.getResourceAvailability';
import saveResourceAvailability from '@salesforce/apex/ResourceAvailabilityController.saveResourceAvailability';
import addResource from '@salesforce/apex/ResourceSummaryController.addResource';
import adjustHours from '@salesforce/apex/ResourceSummaryController.adjustHours';
import updateNotApplicableField from '@salesforce/apex/ResourceSummaryController.updateNotApplicableField';

import AdjustHours from '@salesforce/label/c.AdjustHours';
import AvailabilityPercentage from '@salesforce/label/c.AvailabilityPercentage';
import CloseButton from '@salesforce/label/c.CloseButton';
import LevelAdjustment from '@salesforce/label/c.LevelAdjustment';
import Resource from '@salesforce/label/c.Resource';
import RolledUpAdjustments from '@salesforce/label/c.RolledUpAdjustments';
import RolledUpCalculatedDuration from '@salesforce/label/c.RolledUpCalculatedDuration';
import RolledUpEstimatedDuration from '@salesforce/label/c.RolledUpEstimatedDuration';
import SaveButton from '@salesforce/label/c.SaveButton';
import SpecifyAvailability from '@salesforce/label/c.SpecifyAvailability';
import Split from '@salesforce/label/c.Split';
import SplitResource from '@salesforce/label/c.SplitResource';
import { componentNamespace } from 'c/util';

const actions = [
	{ label: AdjustHours, name: 'adjustHours' },
];

const activityGroupActions = [
	...actions,
	{ label: SpecifyAvailability, name: 'specifyAvailability' },
	{ label: SplitResource, name: 'split' },
];

const processData = (data) => {
	data.forEach((nextRow) => {
		const currentRow = nextRow;
		if (currentRow.splits) {
			currentRow._children = currentRow.splits;
			currentRow.splits.forEach((nextSplit) => {
				const split = nextSplit;
				split.cssClass = 'slds-hide'; // hide actions on splits
				split.resourceRole = split.name;
			});
		}
	});
};

export default class ResourceSummary extends LightningElement {
	@api recordId; // estimate, activity group, or activity id
	@api rateCardId;
	@api isNotApplicable;
	@api type;

	#expanded;
	_treegrid;
	_parentMessageService;
	_messageService;

	data;
	columns;

	async connectedCallback() {
		this.namespace = componentNamespace(this);
		await this.refreshData();
		this.columns = [
			{
				label: Resource, fieldName: 'resourceRole', type: 'text', editable: false, sortable: 'true',
			},
			{
				label: RolledUpCalculatedDuration, fieldName: 'totalCalculatedDuration', type: 'number', editable: false,
			},
			{
				label: RolledUpAdjustments, fieldName: 'totalAdjustments', type: 'number', editable: false, sortable: 'true',
			},
			{
				label: LevelAdjustment, fieldName: 'levelAdjustment', type: 'number', editable: true,
			},
			{
				label: RolledUpEstimatedDuration, fieldName: 'totalEstimatedDuration', type: 'number', editable: false, sortable: 'true',
			},
			{
				type: 'action',
				typeAttributes: { rowActions: this.type === 'Activity Group' ? activityGroupActions : actions, menuAlignment: 'auto' },
				cellAttributes: { class: { fieldName: 'cssClass' } },
			},
		];
	}

	async refreshData() {
		this.data = await getRoleSummaries({ type: this.type, recordId: this.recordId });
		processData(this.data);
	}

	renderedCallback() {
		this._parentMessageService = this.template.querySelector('.component-state');
		this._messageService = this.template.querySelector('.layer-two');
		this._treegrid = this.template.querySelector('lightning-tree-grid');

		try {
			if (!this.#expanded && this._treegrid) {
				this._treegrid.expandAll();
				this.#expanded = true;
			}
		} catch (e) {
			// ignore, expandAll will fail to run until the DOM is rendered
		}
	}

	async handleResourceRowAction(event) {
		const { row } = event.detail;
		switch (event.detail.action.name) {
			case 'adjustHours':
				this.openAdjustHoursDialog(row.id, row.levelAdjustment);
				break;
			case 'specifyAvailability':
				await this.openSpecifyAvailabilityDialog(row.id);
				break;
			case 'split':
				this.openSplitDialog(row.id, row.resourceRole);
				break;
			default:
		}
	}

	openAdjustHoursDialog(rowId, levelAdjustment) {
		const inputFields = [
			{
				key: 'levelAdjustment',
				type: 'number',
				value: levelAdjustment,
				label: LevelAdjustment,
				required: true,
			},
		];

		const dialogServicePayload = {
			method: 'bodyModal',
			config: {
				auraId: 'adjust-hours-dialog',
				headerLabel: AdjustHours,
				component: `${this.namespace}:inputForm`,
				componentParams: {
					contextId: rowId,
					inputFields,
					eventKey: 'afteradjusthours',
					uniqueBoundary: 'layer-two',
				},
				footerActions: [
					{ label: CloseButton, eventName: 'close', class: '' },
					{ label: SaveButton, eventName: 'c.save', class: 'slds-button_brand' },
				],
			},
		};

		this._messageService.dialogService(dialogServicePayload);
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
				label: AvailabilityPercentage,
				required: true,
			},
		];

		const dialogServicePayload = {
			method: 'bodyModal',
			config: {
				auraId: 'specify-availability-dialog',
				headerLabel: SpecifyAvailability,
				component: `${this.namespace}:inputForm`,
				componentParams: {
					inputFields,
					eventKey: 'afterspecifyavailability',
					uniqueBoundary: 'layer-two',
				},
				footerActions: [
					{ label: CloseButton, eventName: 'close', class: '' },
					{ label: SaveButton, eventName: 'c.save', class: 'slds-button_brand' },
				],
			},
		};

		this._messageService.dialogService(dialogServicePayload);
	}
	openSplitDialog(rowId, resourceRole) {
		const dialogServicePayload = {
			method: 'bodyModal',
			config: {
				auraId: 'split-resource-dialog',
				headerLabel: SplitResource,
				component: `${this.namespace}:splitResourceDialog`,
				componentParams: {
					uniqueBoundary: 'layer-two',
					roleSummaryId: rowId,
					roleName: resourceRole,
				},
				footerActions: [
					{ label: CloseButton, eventName: 'close' },
					{ label: Split, eventName: 'c.handleSplit', class: 'slds-button_brand' },
				],
			},
		};

		this._messageService.dialogService(dialogServicePayload);
	}

	openAddResourceDialog() {
		const inputFields = [
			{
				key: 'resourceRoleId',
				isCustomLookup: true,
				required: true,
				customLookupId: this.recordId,
				rateCardId: this.rateCardId,
				level: this.type,
			},
			{
				key: 'levelAdjustment',
				type: 'number',
				value: 0,
				label: LevelAdjustment,
				required: true,
			},
		];

		const dialogServicePayload = {
			method: 'bodyModal',
			config: {
				auraId: 'add-resource-dialog',
				headerLabel: AdjustHours,
				component: `${this.namespace}:inputForm`,
				componentParams: {
					inputFields,
					eventKey: 'afteraddresource',
					uniqueBoundary: 'layer-two',
				},
				footerActions: [
					{ label: CloseButton, eventName: 'close', class: '' },
					{ label: SaveButton, eventName: 'c.save', class: 'slds-button_brand' },
				],
			},
		};

		this._messageService.dialogService(dialogServicePayload);
	}

	async handleAfterAddResource(event) {
		const newTaskRoleSummaryDto = {
			summaryLevel: this.type,
		};

		switch (this.type) {
			case 'Estimate':
				newTaskRoleSummaryDto.estimateId = this.recordId;
				break;
			case 'Activity Group':
				newTaskRoleSummaryDto.activityGroupId = this.recordId;
				break;
			case 'Activity':
				newTaskRoleSummaryDto.activityId = this.recordId;
				break;
			default:
		}

		newTaskRoleSummaryDto.resourceRoleId = event.detail.value.resourceRoleId;
		newTaskRoleSummaryDto.levelAdjustment = +event.detail.value.levelAdjustment;

		await addResource({ roleSummaryDtos: [newTaskRoleSummaryDto] });
		await this.refreshData();
		this._parentMessageService.publish({ key: 'resourceupdate' });
	}

	async handleAfterAdjustHours(event) {
		const updateDto = {
			id: event.detail.value.contextId,
			levelAdjustment: +event.detail.value.levelAdjustment,
		};

		await adjustHours({ roleSummaryDto: updateDto });
		await this.refreshData();
		this._parentMessageService.publish({ key: 'resourceupdate' });
	}

	async handleAfterSpecifyAvailability(event) {
		this.availabilityDto.availabilityPercentage = +event.detail.value.availabilityPercentage;

		try {
			await saveResourceAvailability({ resourceAvailabilityDto: this.availabilityDto });
		} catch (e) {
			// TODO: error handling
		}
	}

	async toggleApplicable(event) {
		const { checked } = event.target;
		await updateNotApplicableField({ recordId: this.recordId, isNotApplicable: checked, type: this.type });
		await this.refreshData();
		this._parentMessageService.publish({ key: 'resourceupdate' });
	}
}
