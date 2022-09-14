/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import { LightningElement } from 'lwc';

import getGlobalColaRates from '@salesforce/apex/GlobalColaRateAdminController.getActiveGlobalColaRates';
import saveGlobalColaRates from '@salesforce/apex/GlobalColaRateAdminController.saveGlobalColaRates';
import deleteGlobalColaRates from '@salesforce/apex/GlobalColaRateAdminController.deleteGlobalColaRates';

import OBJECT_COLA_RATE from '@salesforce/schema/ColaRate__c';
import FIELD_COUNTRY from '@salesforce/schema/ColaRate__c.Country__c';
import FIELD_STATE from '@salesforce/schema/ColaRate__c.State__c';

import LABEL_ADD_ROW from '@salesforce/label/c.AddRow';
import LABEL_CITY from '@salesforce/label/c.City';
import LABEL_COPY_FROM_TO from '@salesforce/label/c.CopyFromTo';
import LABEL_COUNTRY from '@salesforce/label/c.Country';
import LABEL_DELETE_ROW from '@salesforce/label/c.DeleteRow';
import LABEL_DUPLICATE_RATE_ERROR from '@salesforce/label/c.DuplicateRateError';
import LABEL_RATE_MATCH from '@salesforce/label/c.RateMatch';
import LABEL_SERVICE_YEAR from '@salesforce/label/c.ServiceYear';
import LABEL_STATE from '@salesforce/label/c.State';
import LABEL_YOY_COLA_RATE from '@salesforce/label/c.YoyColaRate';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { reduceErrors } from 'c/sparkUtils';
import { format } from 'c/i18n';

const MAX_FRACTION_DIGITS = 2;

const RateMatch = {
	GLOBAL: 'Global',
	COUNTRY: 'Country',
	STATE: 'State',
	CITY: 'City',
};

const updateRateMatch = (row) => {
	const updatedRow = row;
	updatedRow.rateMatch = RateMatch.GLOBAL;

	if (updatedRow.country) {
		updatedRow.rateMatch = RateMatch.COUNTRY;
	}

	if (updatedRow.state) {
		updatedRow.rateMatch = RateMatch.STATE;
	}

	if (updatedRow.city) {
		updatedRow.rateMatch = RateMatch.CITY;
	}
};

const yearLocationKey = (row) => {
	const { serviceYear } = row;
	const { rateMatch } = row;
	const rateMatchValue = row[row.rateMatch?.toLowerCase()];

	// e.g. "2022-Country-United States", "2022-State-California"
	return `${serviceYear}-${rateMatch}${rateMatchValue ? '-' : ''}${(rateMatchValue) || ''}`;
};

const currentYear = new Date().getFullYear();

export default class GlobalColaRateAdmin extends LightningElement {
	editable = true;
	data = [];
	dirtyRows = [];
	selectedRowIndices = [];
	editableFields = 'serviceYear, country, state, city, yearOverYearRate';
	_datatable;

	LABEL_ADD_ROW = LABEL_ADD_ROW;
	LABEL_COPY_FROM_TO = format(LABEL_COPY_FROM_TO, currentYear, currentYear + 1);
	LABEL_DELETE_ROW = LABEL_DELETE_ROW;

	columns = [
		{ label: LABEL_SERVICE_YEAR, fieldName: 'serviceYear', type: 'text' },
		{ label: LABEL_RATE_MATCH, fieldName: 'rateMatch', type: 'text' },
		{
			label: LABEL_COUNTRY,
			fieldName: 'country',
			type: 'customPicklist',
			typeAttributes: { columnName: 'country', objectApiName: OBJECT_COLA_RATE.objectApiName, fieldApiName: FIELD_COUNTRY.fieldApiName },
		},
		{
			label: LABEL_STATE,
			fieldName: 'state',
			type: 'customPicklist',
			typeAttributes: { columnName: 'state', objectApiName: OBJECT_COLA_RATE.objectApiName, fieldApiName: FIELD_STATE.fieldApiName },
		},
		{ label: LABEL_CITY, fieldName: 'city', type: 'text' },
		{
			label: LABEL_YOY_COLA_RATE,
			fieldName: 'yearOverYearRate',
			type: 'customPercentFixed',
			typeAttributes: { columnName: 'yearOverYearRate', maximumFractionDigits: MAX_FRACTION_DIGITS },
		},
	];

	get isCopyDisabled() {
		for (let i = 0; i < this.data.length; i++) {
			const nextData = this.data[i];
			if (nextData.serviceYear !== currentYear) {
				return true;
			}
		}

		return false;
	}

	async connectedCallback() {
		this.data = await getGlobalColaRates();
		this._datatable.initializeTable(this.columns, this.data);
	}

	renderedCallback() {
		this._datatable = this.template.querySelector('c-add-remove-table');
	}

	hasDuplicates(rows) {
		const rowsByYearLocationKey = new Map();
		const dupes = new Set();
		rows.forEach((nextRow) => {
			const key = yearLocationKey(nextRow);
			if (rowsByYearLocationKey.has(key)) {
				dupes.add(key);
			}

			rowsByYearLocationKey.set(key, true);
		});

		if (dupes.size) {
			this.dispatchEvent(
				new ShowToastEvent({
					title: LABEL_DUPLICATE_RATE_ERROR,
					message: Array.from(dupes).join(', '),
					variant: 'error',
				}),
			);

			return true;
		}

		return false;
	}

	validRows() {
		const validRows = [];
		this.data.forEach((nextRow) => {
			if (nextRow.serviceYear && nextRow.rateMatch && nextRow.yearOverYearRate) {
				validRows.push(nextRow);
			}
		});

		return validRows;
	}

	async saveRows() {
		const validRows = this.validRows();
		if (this.hasDuplicates(validRows)) {
			return;
		}

		const dirtyRows = validRows.filter((nextRow) => nextRow.isDirty);
		if (!dirtyRows.length) {
			return;
		}

		const dataByYearLocationKey = new Map();
		validRows.forEach((nextRow) => {
			dataByYearLocationKey.set(yearLocationKey(nextRow), nextRow);
		});

		try {
			const updatedRows = await saveGlobalColaRates({
				rateDtos: dirtyRows.map(((nextRow) => {
				// create copy with index deleted
					const row = { ...nextRow };
					delete row.index;
					return row;
				})),
			});

			updatedRows.forEach((nextRow) => {
				const dataRow = dataByYearLocationKey.get(yearLocationKey(nextRow));
				Object.assign(dataRow, nextRow);
				dataRow.isDirty = false;
			});

			this._datatable.resetDraftValues();
			this._datatable.initializeTable(this.columns, this.data);
		} catch (e) {
			this.toastError(e);
		}
	}

	toastError(error) {
		this.dispatchEvent(
			new ShowToastEvent({
				title: 'Application Exception',
				message: reduceErrors(error).join(', '),
				variant: 'error',
			}),
		);
	}

	// eslint-disable-next-line func-names
	handleCellChange = (function(event) {
		event.detail.draftValues.forEach((nextRow) => {
			const dataRow = this.data[nextRow.index];
			Object.assign(dataRow, nextRow);
			updateRateMatch(dataRow);
			dataRow.isDirty = true;
		});

		this.saveRows();
	}
	).bind(this);

	handleAddRow() {
		const rowsAfterAdd = this._datatable.addRow();
		rowsAfterAdd.at(-1).serviceYear = currentYear;
		this.data = rowsAfterAdd;
		this._datatable.initializeTable(this.columns, this.data);
	}

	handleDeleteRows() {
		const deletedRows = this._datatable.deleteRows();
		const deleteIds = [];
		deletedRows.forEach((nextRow) => {
			if (nextRow.id) { // exists on the server if there is an id
				deleteIds.push(nextRow.id);
			}
		});

		if (deleteIds.length) {
			deleteGlobalColaRates({ rateIds: deleteIds });
		}

		this.data = this._datatable.getData();
	}

	handleCopy() {
		const newData = [...this.data];
		this.data.forEach((nextData) => {
			const newRow = {
				serviceYear: nextData.serviceYear + 1,
				rateMatch: nextData.rateMatch,
				country: nextData.country,
				state: nextData.state,
				city: nextData.city,
				yearOverYearRate: nextData.yearOverYearRate,
				isDirty: true,
			};

			newData.push(newRow);
		});

		this.data = newData;
		this._datatable.initializeTable(this.columns, this.data);
		this.saveRows();
	}
}
