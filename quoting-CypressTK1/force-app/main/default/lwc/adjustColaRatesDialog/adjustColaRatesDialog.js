/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import { api, LightningElement, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { reduceErrors } from 'c/sparkUtils';
import { componentNamespace } from 'c/util';

import getColaRatesForQuote from '@salesforce/apex/AdjustColaRatesController.getColaRatesForQuote';
import saveColaRateForQuote from '@salesforce/apex/AdjustColaRatesController.saveColaRateForQuote';
import saveColaAdjustments from '@salesforce/apex/ColaAdjustmentController.saveColaAdjustments';

import OBJECT_COLA_RATE from '@salesforce/schema/ColaRate__c';
import FIELD_COUNTRY from '@salesforce/schema/ColaRate__c.Country__c';
import FIELD_STATE from '@salesforce/schema/ColaRate__c.State__c';
import OBJECT_QUOTE from '@salesforce/schema/Quote__c';

import LABEL_ADD_ROW from '@salesforce/label/c.AddRow';
import LABEL_ADJUST_COLA_VALIDATION_MESSAGE from '@salesforce/label/c.AdjustColaValidationMessage';
import LABEL_ASK_TO_ENABLE_FEATURE from '@salesforce/label/c.AskToEnableFeature';
import LABEL_CITY from '@salesforce/label/c.City';
import LABEL_CLOSE from '@salesforce/label/c.CloseButton';
import LABEL_COLA_ADJUSTMENT_WORKSHEET from '@salesforce/label/c.ColaAdjustmentWorkSheet';
import LABEL_COUNTRY from '@salesforce/label/c.Country';
import LABEL_DELETE_ROW from '@salesforce/label/c.DeleteRow';
import LABEL_DUPLICATE_RATE_ERROR from '@salesforce/label/c.DuplicateRateError';
import LABEL_ERROR_SAVING_MESSAGE from '@salesforce/label/c.ErrorSavingMessage';
import LABEL_COLA_OVERRIDE from '@salesforce/label/c.ColaOverride';
import LABEL_RATE_MATCH from '@salesforce/label/c.RateMatch';
import LABEL_SAVE from '@salesforce/label/c.SaveButton';
import LABEL_SERVICE_YEAR from '@salesforce/label/c.ServiceYear';
import LABEL_STATE from '@salesforce/label/c.State';
import FIELD_SERVICE_START_DATE from '@salesforce/schema/Quote__c.ServiceStartDate__c';
import LABEL_SUCCESS from '@salesforce/label/c.Success';
import LABEL_SUCCESSFULLY_SAVED from '@salesforce/label/c.SuccessfullySaved';
import LABEL_YOY_COLA_RATE from '@salesforce/label/c.YoyColaRate';
import LABEL_COLA_PASS_THROUGH_PERCENT from '@salesforce/label/c.ColaPassThroughPercent';
import LABEL_YOY_PASS_THROUGH_RATE from '@salesforce/label/c.YoyPassthroughRate';

import {
	calculateColaAdjustment,
	isEmpty,
	getCostsByYear,
	getYears,
	loadData,
	processColaRates,
} from 'c/colaSupport';
import {
	indexRows,
	RateMatch,
	setIsNewRow,
	updateRateMatch,
	yearLocationKey,
} from './colaRatesSupport';

const MAX_FRACTION_DIGITS = 2;

export default class AdjustColaRatesDialog extends NavigationMixin(LightningElement) {
	@api recordId;
	editable = true;
	data = [];
	deletedRowIds = [];
	editableFields = 'country, state, city, rateOverride, passthroughOverride';
	passthroughPercentage;
	hasDeletedRows = false;
	isDirty = false;

	labels = {
		LABEL_ADD_ROW,
		LABEL_ASK_TO_ENABLE_FEATURE,
		LABEL_DELETE_ROW,
		LABEL_COLA_PASS_THROUGH_PERCENT,
	}

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
		{
			label: LABEL_COLA_OVERRIDE,
			fieldName: 'rateOverride',
			type: 'customPercentFixed',
			typeAttributes: { columnName: 'rateOverride', maximumFractionDigits: MAX_FRACTION_DIGITS },
		},
		{
			label: LABEL_YOY_PASS_THROUGH_RATE,
			fieldName: 'passthroughOverride',
			type: 'customPercentFixed',
			typeAttributes: { columnName: 'passthroughOverride', maximumFractionDigits: MAX_FRACTION_DIGITS },
		},
	];

	_datatable;
	_componentState;

	connectedCallback() {
		this.namespace = componentNamespace(this);
	}

	get isDisabled() {
		return !this.isDirty && !this.hasDeletedRows;
	}

	async renderedCallback() {
		if (!this.rendered && this.recordId) {
			this.rendered = true;
			this.data = setIsNewRow(await getColaRatesForQuote({ quoteId: this.recordId }));
			this._componentState = this.template.querySelector('.component-state');
			this._colaAdjustmentsMessageService = this.template.querySelector('.quote-adjustments');
			this._datatable = this.template.querySelector('c-add-remove-table');
			this._componentState.publish({ key: 'deselect' });

			if (this._datatable) {
				this._datatable.initializeTable(this.columns, this.data);
			}

			if (this.data.length && this.data[0].passthroughPercentage >= 0) {
				this.passthroughPercentage = this.data[0].passthroughPercentage;
			}
		}

		const style = document.createElement('style');
		style.innerText = `
		.cell-dropdown {
			position: fixed;
			left: auto;
		}
		.slds-card__header {
			padding: 0;
		}
		`;
		this.template.querySelector('c-add-remove-table').appendChild(style);
	}

	validateHasDuplicates(rows) {
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
			if (nextRow.rateMatch) {
				validRows.push(nextRow);
			}
		});

		return validRows;
	}

	@api
	async handlePreview() {
		const isSuccessful = await this.saveRows();
		if (isSuccessful) {
			this.handleColaAdjustments(false);
		}
	}

	@api
	async handleSave() {
		const isSuccessful = await this.saveRows();
		if (isSuccessful) {
			this.handleColaAdjustments(true);
		}
	}

	@api
	eventFooter(buttons) {
		[, this.saveAndReviewButton, this.saveButton] = buttons;
		this.setDisabled(!this.isDirty && !this.hasDeletedRows);
	}

	setDisabled(disabled) {
		this.saveAndReviewButton.set('v.disabled', disabled);
		this.saveButton.set('v.disabled', disabled);
	}

	handleColaAdjustments(saveAndClose) {
		if (saveAndClose) {
			this.saveColaWorksheet();
		} else {
			this.openColaWorksheet();
		}
	}

	@wire(getRecord, {
		recordId: '$recordId',
		fields: FIELD_SERVICE_START_DATE,
	})quoteRecord;
	async saveColaWorksheet() {
		const { quoteItems, periods } = await loadData(this.recordId);
		const { startYear, endYear } = getYears(periods);
		const colaRates = processColaRates(this.data, startYear);

		const costsByYear = getCostsByYear({
			startYear,
			endYear,
			quoteItems,
			periods,
			colaRates,
		});

		const hasCostsByYear = !isEmpty(costsByYear);
		if (hasCostsByYear) {
			let colaAdjustmentDtos = calculateColaAdjustment(colaRates, startYear, endYear, costsByYear);
			colaAdjustmentDtos = colaAdjustmentDtos.filter((row) => !!row.rateMatch).map((row) => ({
				...row,
				quoteId: this.recordId,
			}));

			await saveColaAdjustments({ quoteId: this.recordId, colaAdjustmentDtos });
			this._colaAdjustmentsMessageService.publish({
				key: 'changecolarates',
			});

			const evt = new ShowToastEvent({
				title: LABEL_SUCCESS,
				message: LABEL_SUCCESSFULLY_SAVED.replace('{0}', LABEL_COLA_ADJUSTMENT_WORKSHEET),
				variant: 'success',
			});

			this.dispatchEvent(evt);
			this.navigateToView(this.recordId, OBJECT_QUOTE.objectApiName);
		} else {
			this.notifyError(LABEL_ERROR_SAVING_MESSAGE.replace('{0}', LABEL_COLA_ADJUSTMENT_WORKSHEET));
		}
	}

	openColaWorksheet() {
		const dialogServicePayload = {
			method: 'bodyModalLarge',
			config: {
				auraId: 'cola-adjustment-dialog',
				headerLabel: LABEL_COLA_ADJUSTMENT_WORKSHEET,
				component: `${this.namespace}:colaWorksheet`,
				componentParams: {
					quoteItems: [],
					periods: [],
					quoteId: this.recordId,
					saveAndClose: false,
				},
				footerActions: [
					{ label: LABEL_CLOSE, eventName: 'close', class: '' },
					{ label: LABEL_SAVE, eventName: 'savecolaadjustments', class: 'slds-button_brand' },
				],
			},
		};

		this._componentState.dialogService(dialogServicePayload);
	}

	async saveRows() {
		const validRows = this.validRows();
		if (this.validateHasDuplicates(validRows)) {
			return false;
		}

		const dirtyRows = validRows.filter((nextRow) => nextRow.isDirty);
		if (!dirtyRows.length && !this.deletedRowIds.length) {
			this.data = validRows;
			return true;
		}

		const dataByYearLocationKey = new Map();
		validRows.forEach((nextRow) => {
			dataByYearLocationKey.set(yearLocationKey(nextRow), nextRow);
		});

		try {
			this.data = setIsNewRow(indexRows(await saveColaRateForQuote({
				rateDtos: dirtyRows.map(((nextRow) => {
					// create copy with index deleted
					const row = { ...nextRow };
					delete row.index;
					return row;
				})),
				colaRatesToDelete: this.deletedRowIds,
				quoteId: this.recordId,
			})));
			this.isDirty = false;
			this._datatable.resetDraftValues();
		} catch (e) {
			this.toastError(e);
			return false;
		}

		this.setDisabled(true);
		return true;
	}

	toastError(error) {
		this.dispatchEvent(
			new ShowToastEvent({
				title: 'There was a problem saving cola rates',
				message: reduceErrors(error).join(', '),
				variant: 'error',
			}),
		);
	}

	handleCellChange = (event) => {
		event.detail.draftValues.forEach((nextRow) => {
			const dataRow = this.data[nextRow.index];
			const changedRow = nextRow;
			if (nextRow.rateOverride !== undefined) {
				changedRow.rateOverride = changedRow.rateOverride === '' ? null : changedRow.rateOverride;
			} else if (nextRow.passthroughOverride !== undefined) {
				changedRow.passthroughOverride = changedRow.passthroughOverride === '' ? null : changedRow.passthroughOverride;
			}

			Object.assign(dataRow, changedRow);
			updateRateMatch(dataRow);
			dataRow.isDirty = true;
			this._datatable.initializeTable(this.columns, this.data);
		});
		this.isDirty = true;
		this.setDisabled(!this.isDirty && !this.hasDeletedRows);
	};

	handleAddRow() {
		const quoteStartYear = new Date(this.quoteRecord.data.fields[FIELD_SERVICE_START_DATE.fieldApiName].value).getFullYear();
		const rowsAfterAdd = this._datatable.addRow();
		const globalRate = rowsAfterAdd.length > 0 && rowsAfterAdd[0].rateMatch === RateMatch.GLOBAL ? rowsAfterAdd[0].yearOverYearRate : 0;
		rowsAfterAdd.at(-1).serviceYear = quoteStartYear;
		rowsAfterAdd.at(-1).isNewRow = true;
		rowsAfterAdd.at(-1).yearOverYearRate = globalRate;
		this.data = rowsAfterAdd;
		this._datatable.initializeTable(this.columns, this.data);
	}

	handleDeleteRows() {
		let hasGlobalRowDeleted = false;
		const deleteRows = this._datatable.deleteRows();
		const deletedRowIds = [];
		deleteRows.forEach((nextRow) => {
			if (nextRow.id && nextRow.rateMatch !== RateMatch.GLOBAL) { // exists on the server if there is an id
				deletedRowIds.push(nextRow.id);
			}

			if (nextRow.id && nextRow.rateMatch === RateMatch.GLOBAL) {
				hasGlobalRowDeleted = true;
			}
		});

		if (hasGlobalRowDeleted) {
			this.dispatchEvent(
				new ShowToastEvent({
					title: 'Application Exception',
					message: LABEL_ADJUST_COLA_VALIDATION_MESSAGE,
					variant: 'error',
				}),
			);

			this._datatable.initializeTable(this.columns, this.data); // restore original data since we aren't allowed to delete global
			return;
		}

		this.deletedRowIds = [...this.deletedRowIds, ...deletedRowIds];
		this.hasDeletedRows = this.deletedRowIds.length > 0;
		this.data = setIsNewRow(this._datatable.getData());
		this.setDisabled(!this.isDirty && !this.hasDeletedRows);
	}

	navigateToView(recordId, objectName) {
		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId,
				objectApiName: objectName,
				actionName: 'view',
			},
		});
	}
}
