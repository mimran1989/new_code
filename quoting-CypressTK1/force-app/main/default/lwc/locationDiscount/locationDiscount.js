/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

import { api, LightningElement } from 'lwc';
import getLocationDiscounts from '@salesforce/apex/LocationDiscountController.getLocationDiscounts';
import saveLocationDiscounts from '@salesforce/apex/LocationDiscountController.saveLocationDiscounts';

import LABEL_RATE_MATCH from '@salesforce/label/c.RateMatch';
import LABEL_COUNTRY from '@salesforce/label/c.Country';
import LABEL_STATE from '@salesforce/label/c.State';
import LABEL_CITY from '@salesforce/label/c.City';
import LABEL_DISCOUNT_PERCENT from '@salesforce/label/c.DiscountPercent';
import LABEL_ADD_ROW from '@salesforce/label/c.AddRow';
import LABEL_DELETE_ROW from '@salesforce/label/c.DeleteRow';
import LABEL_REQUIRED_FIELD from '@salesforce/label/c.RequiredFieldEmpty';
import LABEL_DUPLICATE_LOCATION from '@salesforce/label/c.DuplicateLocationError';
import OBJECT_LOCATION_DISCOUNT from '@salesforce/schema/LocationDiscount__c';
import FIELD_COUNTRY from '@salesforce/schema/LocationDiscount__c.Country__c';
import FIELD_STATE from '@salesforce/schema/LocationDiscount__c.State__c';
import ProvusMessagingService from 'c/provusMessagingService';
import { formatLabel } from 'c/util';

const MAX_FRACTION_DIGITS = 2;

export default class LocationDiscount extends LightningElement {
	@api quoteId;
	editableFields = 'country, state, city, amount';

	LABEL_ADD_ROW = LABEL_ADD_ROW;
	LABEL_DELETE_ROW = LABEL_DELETE_ROW;

	messagingService = new ProvusMessagingService(this);

	data;
	locationDiscountsToDelete = [];
	columns = [
		{ label: LABEL_RATE_MATCH, fieldName: 'rateMatch', type: 'text' },
		{
			label: LABEL_COUNTRY,
			fieldName: 'country',
			type: 'customPicklist',
			typeAttributes: { columnName: 'country', objectApiName: OBJECT_LOCATION_DISCOUNT.objectApiName, fieldApiName: FIELD_COUNTRY.fieldApiName },
		},
		{
			label: LABEL_STATE,
			fieldName: 'state',
			type: 'customPicklist',
			typeAttributes: { columnName: 'state', objectApiName: OBJECT_LOCATION_DISCOUNT.objectApiName, fieldApiName: FIELD_STATE.fieldApiName },
		},
		{ label: LABEL_CITY, fieldName: 'city', type: 'text' },
		{
			label: LABEL_DISCOUNT_PERCENT,
			fieldName: 'amount',
			type: 'customPercentFixed',
			typeAttributes: { columnName: 'amount', maximumFractionDigits: MAX_FRACTION_DIGITS },
		},
	];

	async connectedCallback() {
		this.data = await getLocationDiscounts({ quoteId: this.quoteId });
		this._datatable.initializeTable(this.columns, this.data);
	}

	renderedCallback() {
		this._datatable = this.template.querySelector('c-add-remove-table');

		const style = document.createElement('style');
		style.innerText = `
		.cell-dropdown {
			position: fixed;
			left: auto;
		}
		`;
		this._datatable?.appendChild(style);
	}

	handleAddRow() {
		const rowsAfterAdd = this._datatable.addRow();
		rowsAfterAdd.at(-1).quoteId = this.quoteId;
		this.data = rowsAfterAdd;
		this._datatable.initializeTable(this.columns, this.data);
	}

	@api
	async saveLocationDiscounts() {
		try {
			this.data = this._datatable.getData();
			const locationDiscountDtos = [...this.data];
			this.locationDiscountsToDelete.forEach((locationDiscountToDelete) => {
				locationDiscountDtos.push({
					...locationDiscountToDelete,
					operationType: 'delete',
				});
			});
			this.locationDiscountsToDelete = [];
			this.data = await saveLocationDiscounts({ locationDiscountDtos });
			this._datatable.resetDraftValues();
			this._datatable.initializeTable(this.columns, this.data);
		} catch (e) {
			this.messagingService.handleWireError(e);
		}

		return this.data;
	}

	@api
	validate() {
		this.data = this._datatable.getData();
		const errors = [];
		if (this.data?.length) {
			this.data.forEach((nextRow) => {
				if (!nextRow.amount) {
					errors.push({
						message: `${+nextRow.index + 1}: ${formatLabel(LABEL_REQUIRED_FIELD, [LABEL_DISCOUNT_PERCENT])}`,
					});
				}
			});
		}

		const rowsByLocation = new Map();
		const dupes = new Set();
		this.data.forEach((nextRow) => {
			const keyArray = [nextRow.country, nextRow.state, nextRow.city];
			const key = keyArray.filter((x) => x).join('-');
			if (rowsByLocation.has(key)) {
				dupes.add(key);
			}

			rowsByLocation.set(key, true);
		});

		if (dupes.size) {
			errors.push({
				message: `${LABEL_DUPLICATE_LOCATION}: ${Array.from(dupes).join(', ')}`,
			});
		}

		return errors;
	}

	async handleDeleteRows() {
		this.locationDiscountsToDelete = this.locationDiscountsToDelete.concat(this._datatable.deleteRows());
	}
}
