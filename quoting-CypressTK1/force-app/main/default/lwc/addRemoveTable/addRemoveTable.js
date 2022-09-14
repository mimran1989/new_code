/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

import { api, LightningElement } from 'lwc';

import LABEL_ADD_ROW from '@salesforce/label/c.AddRow';
import LABEL_DELETE_ROW from '@salesforce/label/c.DeleteRow';
import { indexRows } from './util';

export default class AddRemoveTable extends LightningElement {
	@api editableFields;
	@api afterCellChange = (function afterCellChangeFn(event) {
		event.detail.draftValues.forEach((nextRow) => {
			const dataRow = this.data[nextRow.index];
			Object.assign(dataRow, nextRow);
			dataRow.isDirty = true;
		});
	}
	).bind(this);

	data;
	columns;
	selectedRowIndices = [];

	LABEL_ADD_ROW = LABEL_ADD_ROW;
	LABEL_DELETE_ROW = LABEL_DELETE_ROW;

	@api
	getData() {
		return this.data;
	}

	@api
	initializeTable(columns, data) {
		this.data = indexRows(data);
		this.columns = columns;
		this._datatable.initializeTable(undefined, this.columns, this.data);
	}

	@api
	resetDraftValues() {
		this._datatable.resetDraftValues();
	}

	renderedCallback() {
		this._datatable = this.template.querySelector('c-base-datatable');
	}

	@api
	addRow() {
		const newRow = {
			index: `${this.data.length}`,
		};

		this.data.push(newRow);
		this._datatable.initializeTable(undefined, this.columns, this.data);
		return this.data;
	}

	handleRowSelect(event) {
		this.selectedRowIndices = [];
		event.detail.selectedRows.forEach((nextRow) => {
			this.selectedRowIndices.push(nextRow.index);
		});
	}

	@api
	deleteRows() {
		const deleteRows = [];
		this.selectedRowIndices.forEach((nextIndex) => {
			deleteRows.push(this.data[nextIndex]);
			this.data[nextIndex] = undefined;
		});

		this.clearSelectedRows();
		this.data = indexRows(this.data.filter((x) => x));
		this._datatable.initializeTable(undefined, this.columns, this.data);
		return deleteRows;
	}

	clearSelectedRows() {
		this._datatable.clearDraftValuesForIndices(this.selectedRowIndices);
		this._datatable.selectedRows = [];
		this.selectedRowIndices = [];
	}
}
