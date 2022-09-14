/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import { api, LightningElement, wire } from 'lwc';
import { keyBy, toFixedNumber } from 'c/util';
import LABEL_SPLIT_INPUT_MESSAGE from '@salesforce/label/c.SplitInputMessage';
import LABEL_SPLIT_PERCENTAGE_ERROR from '@salesforce/label/c.SplitPercentageError';
import LABEL_RESOURCE_ROLE from '@salesforce/label/c.ResourceRole';
import OBJECT_RESOURCE_SPLIT from '@salesforce/schema/ResourceSplit__c';
import FIELD_SPLIT_PERCENTAGE from '@salesforce/schema/ResourceSplit__c.SplitPercentage__c';
import getSplitsForRoleSummary from '@salesforce/apex/SplitResourceDialogController.getSplitsForRoleSummary';
import saveSplits from '@salesforce/apex/SplitResourceDialogController.saveSplits';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { MAX_FRACTION_DIGITS, formatSplitPercentage } from './splitResourceDialogSupport';

const DTOFIELD_NAME = 'name';
const DTOFIELD_SPLIT_PERCENTAGE = 'splitPercentage';
let LABEL_SPLIT_PERCENTAGE;

export default class SplitResourceDialog extends LightningElement {
	@api roleName;
	@api roleSummaryId;
	@api uniqueBoundary;
	LABEL_SPLIT_INPUT_MESSAGE = LABEL_SPLIT_INPUT_MESSAGE;
	LABEL_SPLIT_PERCENTAGE_ERROR = LABEL_SPLIT_PERCENTAGE_ERROR;

	@wire(getObjectInfo, { objectApiName: OBJECT_RESOURCE_SPLIT })
	resourceSplitMetadata({ data: metadata }) {
		if (metadata) {
			LABEL_SPLIT_PERCENTAGE = metadata.fields[FIELD_SPLIT_PERCENTAGE.fieldApiName].label;
			this.buildColumns();
		}
	}

	columns;
	dataByName = {};
	data = [];

	async connectedCallback() {
		const splitData = await getSplitsForRoleSummary({ roleSummaryId: this.roleSummaryId });
		if (splitData.length) {
			this.data = splitData;
		} else {
			this.data = [{
				name: `${this.roleName} (1)`,
				taskRoleSummaryId: this.roleSummaryId,
				splitPercentage: 50,
			},
			{
				name: `${this.roleName} (2)`,
				taskRoleSummaryId: this.roleSummaryId,
				splitPercentage: 50,
			}];
		}

		this.dataByName = keyBy(this.data, 'name');
	}

	buildColumns() {
		this.columns = [
			{
				label: LABEL_RESOURCE_ROLE, fieldName: DTOFIELD_NAME, type: 'text', editable: false, sortable: 'true',
			},
			{
				label: LABEL_SPLIT_PERCENTAGE,
				fieldName: DTOFIELD_SPLIT_PERCENTAGE,
				type: 'number',
				editable: true,
				typeAttributes: {
					maximumFractionDigits: `${MAX_FRACTION_DIGITS}`,
				},
			},
		];
	}

	handleChange(event) {
		const splitAmount = event.detail.value;
		const rows = [];
		let splitPercentage = toFixedNumber(100 / splitAmount, MAX_FRACTION_DIGITS);
		for (let i = 0; i < splitAmount; i++) {
			const name = `${this.roleName} (${i + 1})`;
			const split = this.dataByName[name] || { name, taskRoleSummaryId: this.roleSummaryId };
			// give the last row the remaining split
			if (i === splitAmount - 1) {
				splitPercentage = 100 - (splitPercentage * (splitAmount - 1));
			}

			split.sequence = i + 1;
			split.splitPercentage = toFixedNumber(splitPercentage, MAX_FRACTION_DIGITS);
			this.dataByName[split.name] = split;

			rows.push(split);
		}

		this.data = rows;
		this.error = !this.hasValidSplitPercentage();
	}

	renderedCallback() {
		this._messageService = this.template.querySelector('c-message-service');
	}

	handleCellChange(event) {
		const updatedRows = [...this.data];
		event.detail.draftValues.forEach((nextSplit) => {
			const dataForName = this.dataByName[nextSplit.name];
			dataForName.splitPercentage = toFixedNumber(formatSplitPercentage(nextSplit.splitPercentage), MAX_FRACTION_DIGITS);
		});
		this.template.querySelector('lightning-datatable').draftValues = [];
		this.data = updatedRows;
		this.error = !this.hasValidSplitPercentage();
	}

	@api
	async handleSplit() {
		if (!this.error && this.isValidNumberOfSplitResources()) {
			await saveSplits({ roleSummaryId: this.roleSummaryId, splits: JSON.stringify(this.data) });
			this._messageService.publish({ key: 'aftersplit' });
			this._messageService.notifyBoundaryClose();
		}
	}

	isValidNumberOfSplitResources() {
		return this.template.querySelector('.split-input').checkValidity();
	}

	hasValidSplitPercentage() {
		const sum = this.data.reduce((accumulator, nextSplit) => toFixedNumber(accumulator + nextSplit.splitPercentage, MAX_FRACTION_DIGITS), 0);
		return this.data.length === 0 || sum === 100;
	}
}
