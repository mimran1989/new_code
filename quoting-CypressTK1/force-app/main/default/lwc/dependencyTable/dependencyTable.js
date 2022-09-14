/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

import { api, LightningElement } from 'lwc';
import { getPath, setPath } from 'c/util';

import LABEL_NONE from '@salesforce/label/c.None';

export default class DependencyTable extends LightningElement {
	@api uniqueBoundary;
	@api recordId;
	@api rowLabelField;
	@api rowIdField;
	@api tableData;
	@api tableColumns;
	@api dependencyTree;

	data;
	rowById = new Map();
	_messageService;
	columnLabels;

	connectedCallback() {
		this.initPicklists();
	}

	renderedCallback() {
		this._messageService = this.template.querySelector('c-message-service');
	}

	initPicklists() {
		const copiedRows = [];
		this.tableData.forEach((nextRow) => {
			const rowCopy = JSON.parse(JSON.stringify(nextRow));
			rowCopy.id = getPath(rowCopy, this.rowIdField);
			rowCopy.label = getPath(rowCopy, this.rowLabelField);
			this.rowById.set(rowCopy.id, rowCopy);
			this.updatePicklists(rowCopy.id);
			copiedRows.push(rowCopy);
		});

		this.data = copiedRows;
		this.columnLabels = ['Resource Role', ...this.tableColumns.map((nextColumn) => nextColumn.label)];
	}

	updatePicklists(rowId) {
		const row = this.rowById.get(rowId);
		row.picklists = row.picklists || [];
		const contextTree = this.dependencyTree[rowId];
		this.update(row, contextTree);
	}

	update(row, tree) {
		const contextRow = row;
		let contextTree = tree;
		for (let i = 0; i < this.tableColumns.length; i++) {
			const column = this.tableColumns[i];
			const dependentValues = contextTree ? Object.keys(contextTree) : [];

			const picklistField = {
				id: `${contextRow.id}_${i}`,
				label: column.label,
				value: getPath(contextRow, column.fieldName) || `--${LABEL_NONE}--`,
				options: dependentValues.map((nextValue) => ({
					label: nextValue, value: nextValue,
				})),
			};

			contextRow.picklists[i] = picklistField;

			if (contextTree) {
				contextTree = contextTree[picklistField.value];
				contextRow.selectedValue = contextTree;
			}
		}
	}

	handleChange(event) {
		const [rowId, columnIndexStr] = event.target.dataset.index.split('_');
		const columnIndex = Number(columnIndexStr);
		const contextRow = this.rowById.get(rowId);
		setPath(contextRow, this.tableColumns[columnIndex].fieldName, event.detail.value);
		this.updatePicklists(rowId);
		this.data = [...this.data];

		this._messageService.publish({ key: 'change', value: { id: contextRow.id, selectedValue: contextRow.selectedValue } });
	}
}
