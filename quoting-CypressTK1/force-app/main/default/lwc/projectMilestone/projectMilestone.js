/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import {
	api, LightningElement, track,
} from 'lwc';
import deleteMilestoneFromQuote from '@salesforce/apex/ProjectMilestoneController.deleteMilestoneFromQuote';
import getNamespacePrefix from '@salesforce/apex/SystemUtility.getNamespacePrefix';

import OBJECT_PROJECT_MILESTONE from '@salesforce/schema/ProjectMilestone__c';
import FIELD_NAME from '@salesforce/schema/ProjectMilestone__c.Name';
import FIELD_ALIGN_TO_ACTIVITY_OR_MILESTONE from '@salesforce/schema/ProjectMilestone__c.AlignToActivityOrMilestone__c';
import FIELD_ALIGN_TO_DATE from '@salesforce/schema/ProjectMilestone__c.AlignToDate__c';
import FIELD_ACTIVITY_NAME from '@salesforce/schema/ProjectMilestone__c.ActivityName__c';
import FIELD_OFFSET from '@salesforce/schema/ProjectMilestone__c.Offset__c';
import FIELD_OFFSET_UNIT from '@salesforce/schema/ProjectMilestone__c.OffsetUnit__c';
import FIELD_CREATED_DATE from '@salesforce/schema/ProjectMilestone__c.CreatedDate';
import FIELD_ESTIMATED_OCCURRENCE_DATE from '@salesforce/schema/ProjectMilestone__c.EstimatedOccurrenceDate__c';
import FIELD_QUOTE_ID from '@salesforce/schema/ProjectMilestone__c.QuoteId__c';

import NewButton from '@salesforce/label/c.NewButton';
import DeleteButton from '@salesforce/label/c.DeleteButton';
import LABEL_DELETE_MILESTONE_HEADER from '@salesforce/label/c.DeleteMilestoneHeader';
import LABEL_DELETE_MILESTONE_MESSAGE from '@salesforce/label/c.DeleteMilestoneMessage';
import LABEL_CREATE_NEW_MILESTONE from '@salesforce/label/c.CreateNewMilestone';

let nsPrefix;

export default class ProjectMilestone extends LightningElement {
	@api recordId;
	@track showConfirmDeleteDialog = false;
	@track label = {
		DeleteButton,
		NewButton,
		LABEL_DELETE_MILESTONE_HEADER,
		LABEL_DELETE_MILESTONE_MESSAGE,
	};
	_milestoneDatatable;
	queryStr;
	columnLabels = `
		${FIELD_NAME.fieldApiName} => Name
	`;
	sortedBy = FIELD_CREATED_DATE.fieldApiName;

	milestonesToDelete = [];

	get milestoneDatatable() {
		if (!this._milestoneDatatable) {
			this._milestoneDatatable = this.template.querySelector('.milestone-datatable');
		}

		return this._milestoneDatatable;
	}

	async renderedCallback() {
		nsPrefix = await getNamespacePrefix();
		this._componentState = this.template.querySelector('c-message-service');
		this.refreshTableWithQueryString();
	}

	async handleFlowFinish() {
		this.refreshTableWithQueryString();
	}

	async handleAddMilestone() {
		const dialogServicePayload = {
			method: 'flow',
			config: {
				auraId: 'create-milestone-flow',
				headerLabel: LABEL_CREATE_NEW_MILESTONE,
				componentParams: {
					flowApiName: `${nsPrefix}CreateNewMilestone`,
					uniqueBoundary: 'project-milestone',
					inputVariables: [{ name: 'quoteId', type: 'String', value: this.recordId }],
				},
			},
		};

		this._componentState.dialogService(dialogServicePayload);
	}

	async handleDeleteMilestone() {
		await deleteMilestoneFromQuote({ milestoneIds: this.milestonesToDelete, quoteId: this.recordId });
		this.refreshTableWithQueryString();
		this.showConfirmDeleteDialog = false;
	}

	handleDelete() {
		this.showConfirmDeleteDialog = true;
	}

	handleDeleteOnConfirm(event) {
		this.isDeleteConfirmed = event.detail.isConfirmed;

		if (this.isDeleteConfirmed) {
			this.handleDeleteMilestone();
		} else {
			this.showConfirmDeleteDialog = false;
		}
	}

	refreshTableWithQueryString() {
		const fields = [
			FIELD_NAME.fieldApiName,
			FIELD_ALIGN_TO_DATE.fieldApiName,
			FIELD_ALIGN_TO_ACTIVITY_OR_MILESTONE.fieldApiName,
			FIELD_ACTIVITY_NAME.fieldApiName,
			FIELD_OFFSET.fieldApiName,
			FIELD_OFFSET_UNIT.fieldApiName,
			FIELD_ESTIMATED_OCCURRENCE_DATE.fieldApiName,
			FIELD_CREATED_DATE.fieldApiName,
			'Id',
		];

		this.queryStr = `SELECT ${fields.join(', ')}`
			+ ` FROM ${OBJECT_PROJECT_MILESTONE.objectApiName}`
			+ ` WHERE ${FIELD_QUOTE_ID.fieldApiName} = '${this.recordId}'`;

		this.milestoneDatatable.refreshTableWithQueryString(this.queryStr);
	}

	handleRowSelection(event) {
		this.milestonesToDelete = [];
		event.detail.selectedRows.forEach((nextRow) => {
			this.milestonesToDelete.push(nextRow.Id);
		});
	}
}
