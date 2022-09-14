import { LightningElement, api, wire } from 'lwc';
import { generateUUID } from 'c/baseUtils';

import getSearchGroup from '@salesforce/apex/LinkScopeParameterSearchController.getSearchGroup';

import SCOPE_PARAMETER_TEMPLATE_OBJECT from '@salesforce/schema/ScopeParameterTemplate__c';
import SCOPE_PARAMETER_TEMPLATE_ALLOWED_VALUES_FIELD from '@salesforce/schema/ScopeParameterTemplate__c.AllowedValues__c';
import SCOPE_PARAMETER_TEMPLATE_DEVELOPER_NAME_FIELD from '@salesforce/schema/ScopeParameterTemplate__c.DeveloperName__c';
import SCOPE_PARAMETER_TEMPLATE_ESTIMATE_TEMPLATE_ID_FIELD from '@salesforce/schema/ScopeParameterTemplate__c.EstimateTemplateId__c';
import SCOPE_PARAMETER_TEMPLATE_ACTIVITY_GROUP_TEMPLATE_ID_FIELD from '@salesforce/schema/ScopeParameterTemplate__c.ActivityGroupTemplateId__c';
import SCOPE_PARAMETER_TEMPLATE_ACTIVITY_TEMPLATE_ID_FIELD from '@salesforce/schema/ScopeParameterTemplate__c.ActivityTemplateId__c';
import SCOPE_PARAMETER_TEMPLATE_DATA_TYPE_FIELD from '@salesforce/schema/ScopeParameterTemplate__c.DataType__c';

export default class LinkScopeParameterSearch extends LightningElement {
	@api taskTemplateId;
	@api uniqueBoundary;
	@api selectedScopeParameterId;

	_uniqueBoundary = this.uniqueBoundary;

	@api
	handleLinkedScopeParameter() {
		this._messageService.publish({ key: 'linkedscopeparameter', value: this._selectedScopeParameter });
	}

	get selectedRows() {
		return this.selectedScopeParameterId ? [this.selectedScopeParameterId] : [];
	}

	_messageService;
	_scopeParameterTemplateDataTable;
	_selectedScopeParameter;
	objectApiName = SCOPE_PARAMETER_TEMPLATE_OBJECT.objectApiName;

	@wire(getSearchGroup, { taskTemplateId: '$taskTemplateId' })
	groupingIdsWire({ data }) {
		if (data) {
			this._estimateId = data.estimateId;
			this._activityGroupId = data.activityGroupId;
			this._activityId = data.activityId;
			this.refreshTableWithQueryString();
		}
	}

	connectedCallback() {
		if (!this._uniqueBoundary) {
			this._uniqueBoundary = generateUUID();
		}
	}

	renderedCallback() {
		this._messageService = this.template.querySelector('c-message-service');
		this._scopeParameterTemplateDataTable = this.template.querySelector('c-soql-datatable');
	}

	refreshTableWithQueryString() {
		const selectFields = [
			'Id',
			'Name',
			SCOPE_PARAMETER_TEMPLATE_DEVELOPER_NAME_FIELD.fieldApiName,
			SCOPE_PARAMETER_TEMPLATE_DATA_TYPE_FIELD.fieldApiName,
			SCOPE_PARAMETER_TEMPLATE_ALLOWED_VALUES_FIELD.fieldApiName,
		];

		const finalQueryString = `SELECT ${selectFields.join(',')} `
			+ `FROM ${SCOPE_PARAMETER_TEMPLATE_OBJECT.objectApiName} `
			+ `WHERE ${SCOPE_PARAMETER_TEMPLATE_ESTIMATE_TEMPLATE_ID_FIELD.fieldApiName} = '${this._estimateId}' `
			+ ` OR ${SCOPE_PARAMETER_TEMPLATE_ACTIVITY_GROUP_TEMPLATE_ID_FIELD.fieldApiName} = '${this._activityGroupId}' `
			+ ` OR ${SCOPE_PARAMETER_TEMPLATE_ACTIVITY_TEMPLATE_ID_FIELD.fieldApiName} = '${this._activityId}' `;

		this._scopeParameterTemplateDataTable.refreshTableWithQueryString(finalQueryString);
	}

	handleSelection(event) {
		[this._selectedScopeParameter] = event.detail.selectedRows;
	}
}
