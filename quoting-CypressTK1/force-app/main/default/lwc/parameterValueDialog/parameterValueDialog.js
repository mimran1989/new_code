/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

import { api, LightningElement } from 'lwc';

import LABEL_ADD_ROW from '@salesforce/label/c.AddRow';
import LABEL_DELETE_ROW from '@salesforce/label/c.DeleteRow';
import LABEL_SEQUENCE from '@salesforce/label/c.Sequence';
import LABEL_LABEL from '@salesforce/label/c.Label';
import LABEL_FROM from '@salesforce/label/c.From';
import LABEL_TO from '@salesforce/label/c.To';
import { resequence } from 'c/util';
import picklistHtml from './picklist.html';
import integerTiersHtml from './integerTiers.html';

const DataType = {
	INTEGER_TIERS: 'Integer Tiers',
	PICKLIST: 'Picklist',
};

export default class ParameterValueDialog extends LightningElement {
	@api uniqueBoundary;
	@api type;
	@api values;
	@api index;

	_componentState;
	_parameterValueDialogState;
	data;
	deleted = [];

	LABEL_ADD_ROW = LABEL_ADD_ROW;
	LABEL_DELETE_ROW = LABEL_DELETE_ROW;
	LABEL_SEQUENCE = LABEL_SEQUENCE;
	LABEL_LABEL = LABEL_LABEL;
	LABEL_FROM = LABEL_FROM;
	LABEL_TO = LABEL_TO;

	render() {
		switch (this.type) {
			case DataType.INTEGER_TIERS: {
				return integerTiersHtml;
			}

			case DataType.PICKLIST: {
				return picklistHtml;
			}

			default:
		}

		return undefined;
	}

	connectedCallback() {
		this.data = JSON.parse(JSON.stringify(this.values || []));

		if (!this.data.length) {
			this.data.push({ sequence: `${this.data.length + 1}`, fromValue: 1 });
		}
	}

	renderedCallback() {
		this._componentState = this.template.querySelector('.component-state');
		this._parameterValueDialogState = this.template.querySelector('.parameter-value-dialog-state');
	}

	handleAddRow(event) {
		const rowBelow = Number(event.target.dataset.index) + 1;
		if (this.type === DataType.INTEGER_TIERS) {
			this.addIntegerTierRow();
		} else {
			this.addPicklistRow(rowBelow);
		}

		return this;
	}

	addIntegerTierRow() {
		this.data.push({ sequence: `${this.data.length + 1}`, fromValue: Number(this.data[this.data.length - 1].toValue) + 1 });
		this.data = [...this.data];
	}

	addPicklistRow(index) {
		this.data.splice(index, 0, { sequence: `${this.data.length + 1}` });
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

	handleBlur(event) {
		this.data[event.target.dataset.index][event.target.name] = event.target.value;
	}

	@api
	saveParamValues() {
		const allValid = [...this.template.querySelectorAll('lightning-input')]
			.reduce((validSoFar, inputCmp) => {
				inputCmp.reportValidity();
				return validSoFar && inputCmp.checkValidity();
			}, true);

		if (!allValid) {
			return;
		}

		this._componentState.publish({
			key: 'updateparamvalues',
			value: {
				index: this.index,
				data: this.data,
				deleted: this.deleted,
			},
		});

		this._parameterValueDialogState.notifyBoundaryClose();
	}
}
