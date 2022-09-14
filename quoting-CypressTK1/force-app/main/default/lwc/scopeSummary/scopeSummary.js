/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

import { api, LightningElement } from 'lwc';

import getEstimateScopeSummaries from '@salesforce/apex/ScopeSummaryController.getEstimateScopeSummaries';
import ActivityGroup from '@salesforce/label/c.ActivityGroup';
import Activity from '@salesforce/label/c.Activity';
import Task from '@salesforce/label/c.Task';
import ParameterName from '@salesforce/label/c.ParameterName';
import EstimatedDuration from '@salesforce/label/c.EstimatedDuration';
import NA from '@salesforce/label/c.NA';
import UserInput from '@salesforce/label/c.UserInput';

export default class ScopeSummary extends LightningElement {
	@api estimateId;

	scopeSummaries;
	columns = [
		{
			label: ActivityGroup, fieldName: 'activityGroupName', type: 'text', editable: false, sortable: 'true',
		},
		{
			label: Activity, fieldName: 'activityName', type: 'text', editable: false,
		},
		{
			label: Task, fieldName: 'taskName', type: 'text', editable: false, sortable: 'true',
		},
		{
			label: NA, fieldName: 'isNotApplicable', type: 'text', editable: false,
		},
		{
			label: ParameterName, fieldName: 'parameterName', type: 'text', editable: false, sortable: 'true',
		},
		{
			label: UserInput, fieldName: 'userInput', type: 'text', editable: false, sortable: 'true',
		},
		{
			label: EstimatedDuration, fieldName: 'estimatedDuration', type: 'number', editable: false, sortable: 'true',
		},
	];

	async connectedCallback() {
		this.scopeSummaries = await getEstimateScopeSummaries({ estimateId: this.estimateId });
	}
}
