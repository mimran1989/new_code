/*
 * Provus Services Quoting
 * Copyright (c) 2021 Provus Inc. All rights reserved.
 */
import { LightningElement, api, wire } from 'lwc';
import getAllOriginalProductsForQuote from '@salesforce/apex/QuoteConfiguratorController.getAllOriginalProductsForQuote';
import getAttributesFor from '@salesforce/apex/RateCardService.getAttributesFor';
import getRateCardFilters from '@salesforce/apex/ResourceRoleDialogController.getRateCardFilters';
import checkIfRateCardIsExpired from '@salesforce/apex/RateCardService.checkIfRateCardIsExpired';
import hasFilterResourcesPermission from '@salesforce/customPermission/FilterResources';

import LABEL_ADD_TO_QUOTE from '@salesforce/label/c.AddToQuote';
import LABEL_CANCEL from '@salesforce/label/c.CancelButton';
import LABEL_SELECT_RESOURCE_ROLE from '@salesforce/label/c.SelectResourceRole';
import LABEL_ERROR_NO_AVAILABLE_ROLES from '@salesforce/label/c.ErrorNoAvailableRoles';
import LABEL_ERROR_RATECARD_EXPIRED from '@salesforce/label/c.ErrorRateCardExpired';
import LABEL_CONTINUE from '@salesforce/label/c.Continue';
import LABEL_SELECT from '@salesforce/label/c.Select';
import LABEL_SELECT_ALL from '@salesforce/label/c.SelectAll';

import OBJECT_RATE_CARD_ITEM from '@salesforce/schema/RateCardItem__c';
import FIELD_PRODUCT from '@salesforce/schema/RateCardItem__c.ProductId__c';
import FIELD_RATE_CARD from '@salesforce/schema/RateCardItem__c.RateCardId__c';
import FIELD_UNIT_COST from '@salesforce/schema/RateCardItem__c.UnitCost__c';
import FIELD_UNIT_PRICE from '@salesforce/schema/RateCardItem__c.UnitPrice__c';
import FIELD_MARGIN_PERCENT from '@salesforce/schema/RateCardItem__c.MarginPercent__c';
import FIELD_GROUP from '@salesforce/schema/Product__c.Group__c';
import FIELD_PRACTICE from '@salesforce/schema/Product__c.Practice__c';
import FIELD_LOCATION_COUNTRY from '@salesforce/schema/RateCardItem__c.LocationCountry__c';
import FIELD_LOCATION_STATE_PROVINCE from '@salesforce/schema/RateCardItem__c.LocationStateProvince__c';
import FIELD_LOCATION_CITY from '@salesforce/schema/RateCardItem__c.LocationCity__c';

const RATE_CARD_ITEM_QUERY_LIMIT = 100;
export default class ResourceRoleDialog extends LightningElement {
	@api quote;
	@api group;
	@api practice;
	@api rateCard;
	@api selectedRole;
	@api showCloseButton;
	rateItemId = [];
	hasExpired = false;
	rateCardItemFilters = {};
	_isFilterChange = false;
	_selectedRole = this.selectedRole;

	LABEL_ADD_TO_QUOTE = LABEL_ADD_TO_QUOTE;
	LABEL_CANCEL = LABEL_CANCEL;
	LABEL_SELECT_RESOURCE_ROLE = LABEL_SELECT_RESOURCE_ROLE;
	LABEL_ERROR_NO_AVAILABLE_ROLES = LABEL_ERROR_NO_AVAILABLE_ROLES;
	LABEL_CONTINUE = LABEL_CONTINUE;

	_messageService;
	_roleDatatable;
	_searchFilterAttributes;
	_searchAttributesByName = {};
	_showSearchFilterIcon = false;
	_showSearchFilters = false;
	queryStr;
	selectedRateItem;
	roles = [];
	sortedBy = FIELD_MARGIN_PERCENT.fieldApiName;

	@wire(getAttributesFor, { rateCardId: '$rateCard' })
	_rateCardAttributes

	@api
	get rateCardItemId() {
		return this.rateItemId;
	}
	set rateCardItemId(val) {
		this.rateItemId = [].concat(val); // preselect requires an array
	}

	get isAddButtonDisabled() {
		return !this.selectedRateItem;
	}

	get showSearchFilterIcon() {
		return hasFilterResourcesPermission && this._showSearchFilterIcon;
	}

	get showSearchFilters() {
		return this._showSearchFilterIcon && this._showSearchFilters;
	}

	get rateCardAttributes() {
		return this._rateCardAttributes.data;
	}

	get hasRoles() {
		return this.roles.length > 0;
	}

	get disableAddButton() {
		return !this.selectedRateItem;
	}

	get disableContinueButton() {
		return this.hasExpired;
	}

	get searchFilterAttributes() {
		return this._searchFilterAttributes;
	}

	get isApplyButtonDisabled() {
		return !this._isFilterChange;
	}

	get filtersQueryString() {
		return Object.keys(this.rateCardItemFilters)
			.filter((filterKey) => !!this.rateCardItemFilters[filterKey])
			.map((filterKey) => `${filterKey} = '${this.rateCardItemFilters[filterKey]}'`)
			.join(' AND ');
	}

	get datatableClasses() {
		let tableClass = 'role-datatable';
		if (!this._selectedRole) {
			tableClass += ' slds-hide';
		}

		return tableClass;
	}

	get showCancelButton() {
		let displayCloseBtn = true;
		if (this.showCloseButton === false) {
			// if there are no roles available for selection, allow the user to cancel out of the dialog
			displayCloseBtn = !this.hasRoles;
		}

		return displayCloseBtn;
	}

	get roleDatatable() {
		if (!this._roleDatatable) {
			this._roleDatatable = this.template.querySelector('.role-datatable');
		}

		return this._roleDatatable;
	}

	@wire(checkIfRateCardIsExpired, { quoteId: '$quote' })
	rateCardStatus({ data }) {
		if (data) {
			Object.keys(data).forEach((key) => {
				if (key === 'true') {
					this.hasExpired = key;
					this.LABEL_ERROR_RATECARD_EXPIRED = LABEL_ERROR_RATECARD_EXPIRED.replace('{0}', data[key]);
				}
			});
		}
	}

	@wire(getRateCardFilters, { rateCardId: '$rateCard' })
	wireSearchFilterAttributes({ data }) {
		if (data) {
			this._searchFilterAttributes = data.map((predicate) => ({
				...predicate,
				placeholder: `${LABEL_SELECT.replace('{0}', predicate.label)}`,
				options: [{ label: LABEL_SELECT_ALL }, ...predicate.options.map((option) => ({ label: option, value: option }))],
			}));

			this._searchFilterAttributes.forEach((filter) => {
				this._searchAttributesByName[filter.name] = filter;
			});
		}
	}

	@wire(getAllOriginalProductsForQuote, {
		quoteId: '$quote',
	})
	wiredProducts({ data }) {
		if (data) {
			this.roles = data.filter(
				(nextProduct) => (!nextProduct.isMiscellaneous),
			).map((nextProduct) => ({ label: nextProduct.name, value: nextProduct.id }));

			if (this._selectedRole) {
				this.refreshTableWithQueryString(this._selectedRole);
			}
		}
	}

	renderedCallback() {
		this._messageService = this.template.querySelector('c-message-service');
	}

	refreshTableWithQueryString(productId) {
		const fields = [
			FIELD_PRODUCT.fieldApiName,
			...(this.rateCardAttributes || []),
			FIELD_UNIT_PRICE.fieldApiName,
			FIELD_UNIT_COST.fieldApiName,
			FIELD_MARGIN_PERCENT.fieldApiName,
			FIELD_LOCATION_COUNTRY.fieldApiName,
			FIELD_LOCATION_STATE_PROVINCE.fieldApiName,
			FIELD_LOCATION_CITY.fieldApiName,
			'Id',
		];

		const productRFieldName = FIELD_PRODUCT.fieldApiName.replace('__c', '__r');
		this.queryStr = `SELECT ${fields.join(', ')}`
			+ ` FROM ${OBJECT_RATE_CARD_ITEM.objectApiName}`
			+ ` WHERE ${FIELD_RATE_CARD.fieldApiName} = '${this.rateCard}'`
			+ ` AND ${FIELD_PRODUCT.fieldApiName} = '${productId}'`;

		if (this.group == null) {
			this.queryStr += ` AND ${productRFieldName}.${FIELD_GROUP.fieldApiName} = NULL`;
		} else {
			this.queryStr += ` AND ${productRFieldName}.${FIELD_GROUP.fieldApiName} = '${this.group}'`;
		}

		if (this.practice == null) {
			this.queryStr += ` AND ${productRFieldName}.${FIELD_PRACTICE.fieldApiName} = NULL`;
		} else {
			this.queryStr += ` AND ${productRFieldName}.${FIELD_PRACTICE.fieldApiName} = '${this.practice}'`;
		}

		const { filtersQueryString } = this;
		if (filtersQueryString) {
			this.queryStr += ` AND ${filtersQueryString}`;
		}

		this.queryStr += ` LIMIT ${RATE_CARD_ITEM_QUERY_LIMIT}`;
		this.roleDatatable.refreshTableWithQueryString(this.queryStr);
	}

	handleRateItemSelection(event) {
		[this.selectedRateItem] = event.detail.selectedRows;
	}

	handleRoleSelection(event) {
		this._selectedRole = event.detail.value;
		this._showSearchFilterIcon = true;
		this.refreshTableWithQueryString(this._selectedRole);
	}

	handleAddResource() {
		this._messageService.publish({ key: 'roleselected', value: this.selectedRateItem });
		this._messageService.notifyClose();
	}

	handleFilterChange(event) {
		const elementName = event.target.ariaLabelledBy;
		const filterFieldName = event.target.ariaLabelledBy.substring(0, elementName.indexOf('-'));
		this.rateCardItemFilters[filterFieldName] = event.detail.value;
		this._searchAttributesByName[filterFieldName].value = event.detail.value;
		this._isFilterChange = true;
	}

	handleCloseFilters() {
		this._showSearchFilters = false;
	}

	handleApplyFilters() {
		this.refreshTableWithQueryString(this._selectedRole);
		this._isFilterChange = false;
		this._showSearchFilters = false;
	}

	handleToggleSearchFilters() {
		this._showSearchFilters = !this._showSearchFilters;
	}

	handleCancel() {
		this._messageService.notifyClose();
	}

	handleContinue() {
		this.hasExpired = false;
	}
}
