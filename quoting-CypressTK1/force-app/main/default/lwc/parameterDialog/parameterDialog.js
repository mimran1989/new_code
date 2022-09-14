/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

import { api, LightningElement, wire } from 'lwc';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';

import FIELD_DATA_TYPE from '@salesforce/schema/TaskParameterTemplate__c.DataType__c';
import LABEL_ACTIONS from '@salesforce/label/c.Actions';
import LABEL_ADD_ROW from '@salesforce/label/c.AddRow';
import LABEL_ADD_VALUES from '@salesforce/label/c.AddValuesButton';
import LABEL_CLOSE from '@salesforce/label/c.CloseButton';
import LABEL_DATA_TYPE from '@salesforce/label/c.DataType';
import LABEL_DELETE_ROW from '@salesforce/label/c.DeleteRow';
import LABEL_GUIDANCE from '@salesforce/label/c.Guidance';
import LABEL_HASHTAG from '@salesforce/label/c.Hashtag';
import LABEL_NAME from '@salesforce/label/c.Name';
import LABEL_PARAMETER from '@salesforce/label/c.Parameter';
import LABEL_SAVE from '@salesforce/label/c.SaveButton';
import LABEL_SELECT from '@salesforce/label/c.Select';
import LABEL_SEQUENCE from '@salesforce/label/c.Sequence';
import LABEL_SHOW_VALUES from '@salesforce/label/c.ShowValues';
import LABEL_PARAMETER_VALUES from '@salesforce/label/c.ParameterValues';
import { componentNamespace, formatLabel, resequence } from 'c/util';

const MASTER_RECORD_TYPE_ID = '012000000000000AAA';

const DataType = {
	INTEGER_TIERS: 'Integer Tiers',
	PICKLIST: 'Picklist',
};

const newParameterRow = (baseObj) => ({
	...baseObj,
	isDirty: !!baseObj.id,
	get valuesEditable() {
		return this.dataType === DataType.INTEGER_TIERS || this.dataType === DataType.PICKLIST;
	},
});

export default class ParameterDialog extends LightningElement {
	@api params;
	_componentState;
	_parameterValueDialogState;

	LABEL_ACTIONS = LABEL_ACTIONS;
	LABEL_ADD_ROW = LABEL_ADD_ROW;
	LABEL_ADD_VALUES = LABEL_ADD_VALUES;
	LABEL_DATA_TYPE = LABEL_DATA_TYPE;
	LABEL_DELETE_ROW = LABEL_DELETE_ROW;
	LABEL_GUIDANCE = LABEL_GUIDANCE;
	LABEL_HASHTAG = LABEL_HASHTAG;
	LABEL_NAME = `${LABEL_PARAMETER} ${LABEL_NAME}`;
	LABEL_SELECT_DATA_TYPE = formatLabel(LABEL_SELECT, [LABEL_DATA_TYPE]);
	LABEL_SEQUENCE = LABEL_SEQUENCE;
	LABEL_SHOW_VALUES = LABEL_SHOW_VALUES;
	LABEL_HASHTAG_EXAMPLE = `#${LABEL_HASHTAG}`;

	data;
	deleted = [];

	@wire(getPicklistValues, {
		recordTypeId: MASTER_RECORD_TYPE_ID,
		fieldApiName: FIELD_DATA_TYPE,
	}) picklistValues;

	connectedCallback() {
		this.namespace = componentNamespace(this);
		this.data = JSON.parse(JSON.stringify(this.params)).map((nextParam) => newParameterRow(nextParam));

		if (!this.data.length) {
			this.data.push(newParameterRow({ sequence: `${this.data.length + 1}` }));
		}
	}

	renderedCallback() {
		this._componentState = this.template.querySelector('.component-state');
		this._parameterValueDialogState = this.template.querySelector('.parameter-value-dialog-state');
	}

	handleBlur(event) {
		const fieldName = event.target.name;
		if (fieldName) {
			const row = this.data[event.target.dataset.index];
			row[fieldName] = event.target.value;
			row.isDirty = true;

			// rerender to update visibility of Add Values
			if (fieldName === 'dataType') {
				this.data = [...this.data];
			}
		}
	}

	@api
	save(close = true) {
		const allValid = [...this.template.querySelectorAll('lightning-input, lightning-combobox')]
			.reduce((validSoFar, inputCmp) => {
				inputCmp.reportValidity();
				return validSoFar && inputCmp.checkValidity();
			}, true);

		if (!allValid) {
			return;
		}

		const dirtyRows = this.data.filter((row) => row.isDirty);
		dirtyRows.forEach((nextValue) => {
			const nextParam = nextValue;
			delete nextParam.isDirty;
		});

		this._componentState.publish({
			key: 'saveparams',
			value: {
				data: dirtyRows,
				deleted: this.deleted,
				close,
			},
		});
	}

	handleAddValues(event) {
		const row = this.data[event.target.dataset.index];

		const dialogServicePayload = {
			method: 'bodyModal',
			config: {
				auraId: 'parameter-value-dialog',
				headerLabel: LABEL_PARAMETER_VALUES,
				component: `${this.namespace}:parameterValueDialog`,
				componentParams: {
					uniqueBoundary: 'parameter-value-dialog-state',
					type: row.dataType,
					index: event.target.dataset.index,
					values: row.paramValues,
				},
				footerActions: [
					{ label: LABEL_CLOSE, eventName: 'close', class: '' },
					{
						label: LABEL_SAVE, eventName: 'c.saveParamValues', class: 'slds-button_brand',
					},
				],
			},
		};

		this._parameterValueDialogState.dialogService(dialogServicePayload);
	}

	handleUpdateParamValues(event) {
		// copy ids over in case they resolved after the param values dialog opened
		event.detail.value.data.forEach((value, index) => {
			const paramValue = value;
			const eventIdx = event.detail.value.index;
			paramValue.id = this.data[eventIdx]
				&& this.data[eventIdx].paramValues
				&& this.data[eventIdx].paramValues[index]
				&& this.data[eventIdx].paramValues[index].id;
		});

		this.data[event.detail.value.index].paramValues = event.detail.value.data;
		this.data[event.detail.value.index].deletedParamValues = event.detail.value.deleted;
		this.data[event.detail.value.index].isDirty = true;
		this.save(false);
	}

	handleAddRow(event) {
		const rowBelow = Number(event.target.dataset.index) + 1;
		this.data.splice(
			rowBelow,
			0,
			newParameterRow({
				sequence: `${this.data.length + 1}`,
			}),
		);
		this.data = [...resequence(this.data, 'sequence')];
	}

	handleRemoveRow(event) {
		const row = this.data[event.target.dataset.index];
		delete this.data[event.target.dataset.index];

		if (row.id) {
			this.deleted.push(row);
		}

		this.data = resequence(this.data.filter((x) => x), 'sequence');
	}

	get isRemoveDisabled() {
		return this.data.length < 2;
	}

	handleUpdateData(event) {
		this.data = event.detail.value.map((nextParam) => (newParameterRow(nextParam)));
	}
}
