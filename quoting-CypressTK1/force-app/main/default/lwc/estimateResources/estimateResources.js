/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

import { api, LightningElement } from 'lwc';
import { refreshView } from 'c/util';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getDependencyTree from '@salesforce/apex/EstimateResourcesController.getDependencyTree';
import getTableColumns from '@salesforce/apex/EstimateResourcesController.getTableColumns';
import getTaskRoleSummaryDefaults from '@salesforce/apex/EstimateResourcesController.getTaskRoleSummaryDefaults';
import saveRoleSummaries from '@salesforce/apex/EstimateResourcesController.saveRoleSummaries';
import LABEL_RESOURCE_DEFAULT_HEADER from '@salesforce/label/c.ResourceDefaultsHeaderLabel';
import LABEL_RESOURCE_DEFAULT_SUCCESS_MESSAGE from '@salesforce/label/c.ResourceDefaultSuccessMessage';
import LABEL_SUCCESS from '@salesforce/label/c.Success';
import FIELD_RESOURCE_ROLE from '@salesforce/schema/TaskRoleSummary__c.ResourceRoleId__c';
import FIELD_RESOURCE_ROLE_NAME from '@salesforce/schema/TaskRoleSummary__c.ResourceRoleId__r.Name';

export default class EstimateResources extends LightningElement {
	@api recordId;
	@api disableButtonStatus;
	tableData = [];
	tableColumns = [];
	updatedRow = new Map();
	dependencyTree;
	rendered = false;
	taskRoleSummaryIdByProductId = new Map();

	LABEL_RESOURCE_DEFAULT_HEADER = LABEL_RESOURCE_DEFAULT_HEADER;
	FIELD_RESOURCE_ROLE = FIELD_RESOURCE_ROLE.fieldApiName;
	FIELD_RESOURCE_ROLE_NAME = FIELD_RESOURCE_ROLE_NAME.fieldApiName;

	async renderedCallback() {
		if (this.recordId && !this.rendered) {
			this.tableColumns = await getTableColumns({ estimateId: this.recordId });
			const rateCardItemFieldNames = this.tableColumns.map((nextColumn) => nextColumn.fieldName.split('.')[1]);
			this.dependencyTree = await getDependencyTree({ estimateId: this.recordId, fields: rateCardItemFieldNames });
			this.tableData = await getTaskRoleSummaryDefaults({ estimateId: this.recordId, fields: this.tableColumns.map((nextColumn) => nextColumn.fieldName) });
			this.tableData.forEach((nextDatum) => {
				this.taskRoleSummaryIdByProductId.set(nextDatum[FIELD_RESOURCE_ROLE.fieldApiName], nextDatum.Id);
			});

			this.rendered = true;
		}
	}

	handleChange(event) {
		const targetValue = event.detail.value;
		if (targetValue.selectedValue) {
			this.updatedRow.set(targetValue.id, targetValue.selectedValue);
		}

		if (this.disableButtonStatus !== undefined) {
			this.disableButtonStatus(this.updatedRow.size === 0);
		}
	}

	@api saveRecord() {
		const roleSummaries = [];

		this.updatedRow.forEach((value, key) => {
			roleSummaries.push({
				id: this.taskRoleSummaryIdByProductId.get(key),
				rateCardItemId: value,
			});
		});

		if (this.updatedRow) {
			saveRoleSummaries({ roleSummaries }).then(refreshView);
		}

		this.updatedRow = [];

		if (this.disableButtonStatus !== undefined) {
			this.showNotification(LABEL_SUCCESS, LABEL_RESOURCE_DEFAULT_SUCCESS_MESSAGE, 'success');
		}
	}

	showNotification(title, message, variant) {
		const evt = new ShowToastEvent({
			title,
			message,
			variant,
		});

		this.dispatchEvent(evt);
	}
}
