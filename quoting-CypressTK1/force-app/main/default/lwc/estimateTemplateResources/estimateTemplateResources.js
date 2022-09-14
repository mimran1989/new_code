/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

import { api, LightningElement } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getDependencyTree from '@salesforce/apex/EstimateTemplateResourcesController.getDependencyTree';
import getTableColumns from '@salesforce/apex/EstimateTemplateResourcesController.getTableColumns';
import getResourceDefaults from '@salesforce/apex/EstimateTemplateResourcesController.getResourceDefaults';
import saveResourceDefaults from '@salesforce/apex/EstimateTemplateResourcesController.saveResourceDefaults';
import LABEL_RESOURCE_DEFAULT_HEADER from '@salesforce/label/c.ResourceDefaultsHeaderLabel';
import FIELD_RESOURCE_ROLE from '@salesforce/schema/ResourceDefault__c.ProductId__c';
import FIELD_RESOURCE_ROLE_NAME from '@salesforce/schema/ResourceDefault__c.ProductId__r.Name';

import LABEL_RESOURCE_DEFAULT_SUCCESS_MESSAGE from '@salesforce/label/c.ResourceDefaultSuccessMessage';
import LABEL_SUCCESS from '@salesforce/label/c.Success';
import LABEL_CLOSE_BUTTON from '@salesforce/label/c.CloseButton';
import LABEL_SAVE_BUTTON from '@salesforce/label/c.SaveButton';
import { getPropByString } from 'c/util';

export default class EstimateTemplateResources extends LightningElement {
	@api recordId;
	updatedRow = new Map();
	tableData = [];
	tableColumns = [];

	dependencyTree;
	rendered = false;
	resourceDefaultsByProductId = new Map();

	LABEL_SAVE_BUTTON = LABEL_SAVE_BUTTON;
	LABEL_RESOURCE_DEFAULT_HEADER = LABEL_RESOURCE_DEFAULT_HEADER;
	LABEL_CLOSE_BUTTON = LABEL_CLOSE_BUTTON;
	FIELD_RESOURCE_ROLE = FIELD_RESOURCE_ROLE.fieldApiName;
	FIELD_RESOURCE_ROLE_NAME = FIELD_RESOURCE_ROLE_NAME.fieldApiName;

	async renderedCallback() {
		if (this.recordId && !this.rendered) {
			this.tableColumns = await getTableColumns({ templateId: this.recordId });
			const rateCardItemFieldNames = this.tableColumns.map((nextColumn) => nextColumn.fieldName.split('.')[1]);
			this.dependencyTree = await getDependencyTree({ templateId: this.recordId, fields: rateCardItemFieldNames });
			this.tableData = await getResourceDefaults({ templateId: this.recordId, fields: this.tableColumns.map((nextColumn) => nextColumn.fieldName) });
			this.tableData.sort(
				(a, b) => ((getPropByString(a, FIELD_RESOURCE_ROLE_NAME.fieldApiName) > getPropByString(b, FIELD_RESOURCE_ROLE_NAME.fieldApiName)) ? 1 : -1),
			);
			this.tableData.forEach((nextDatum) => {
				this.resourceDefaultsByProductId.set(nextDatum[FIELD_RESOURCE_ROLE.fieldApiName], nextDatum.Id);
			});

			this.rendered = true;
		}
	}

	handleChange(event) {
		const targetValue = event.detail.value;
		if (targetValue.selectedValue) {
			this.updatedRow.set(targetValue.id, targetValue.selectedValue);
		}
	}

	handleSaveRecord() {
		const resourceDefaults = [];
		this.updatedRow.forEach((value, key) => {
			resourceDefaults.push({
				id: this.resourceDefaultsByProductId.get(key),
				rateCardItemId: value,
			});
		});

		if (this.updatedRow) {
			saveResourceDefaults({ resourceDefaults });
		}

		this.showNotification(LABEL_SUCCESS, LABEL_RESOURCE_DEFAULT_SUCCESS_MESSAGE, 'success');
		this.handleCloseDialog();
	}

	handleCloseDialog() {
		this.dispatchEvent(new CloseActionScreenEvent());
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
