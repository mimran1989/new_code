/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import { wire, api, LightningElement } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { reduceErrors } from 'c/sparkUtils';

import getNamespacePrefix from '@salesforce/apex/SystemUtility.getNamespacePrefix';
import getScenariosForApproval from '@salesforce/apex/SubmitForApprovalController.getScenariosForApproval';
import submitScenariosForApproval from '@salesforce/apex/SubmitForApprovalController.submitScenariosForApproval';

import QUOTE_TOTAL_AMOUNT_FIELD from '@salesforce/schema/Quote__c.TotalAmount__c';
import QUOTE_MARGIN_PERCENT_FIELD from '@salesforce/schema/QuoteItem__c.MarginPercent__c';
import QUOTE_TOTAL_COST_FIELD from '@salesforce/schema/Quote__c.TotalCost__c';
import QUOTE_TOTAL_TYPE_FIELD from '@salesforce/schema/Quote__c.Type__c';

import LABEL_CANCEL from '@salesforce/label/c.CancelButton';
import LABEL_COMMENTS_FOR_APPROVER from '@salesforce/label/c.CommentsForApprover';
import LABEL_SUBMIT_FOR_APPROVAL from '@salesforce/label/c.SubmitForApproval';
import LABEL_SUBMIT_FOR_APPROVAL_ERROR_MESSAGE from '@salesforce/label/c.SubmitForApprovalErrorMessage';
import LABEL_SUBMIT_FOR_APPROVAL_HEADER from '@salesforce/label/c.SubmitForApprovalHeader';
import LABEL_SUBMITTED_SCENARIOS_FOR_APPROVAL from '@salesforce/label/c.SubmittedScenariosForApproval';
import LABEL_SUCCESS from '@salesforce/label/c.Success';

let nsPrefix;

export default class SubmitForApprovalDialog extends NavigationMixin(LightningElement) {
	@api recordId;
	_recordId = this.recordId;

	scenarios;

	labels = {
		LABEL_CANCEL,
		LABEL_COMMENTS_FOR_APPROVER,
		LABEL_SUBMIT_FOR_APPROVAL,
		LABEL_SUBMIT_FOR_APPROVAL_ERROR_MESSAGE,
		LABEL_SUBMIT_FOR_APPROVAL_HEADER,
		LABEL_SUBMITTED_SCENARIOS_FOR_APPROVAL,
		LABEL_SUCCESS,
	}

	@wire(CurrentPageReference)
	getStateParameters(currentPageReference) {
		if (currentPageReference) {
			this._recordId = currentPageReference.state.recordId;
		}
	}

	async renderedCallback() {
		nsPrefix = await getNamespacePrefix();

		if (!this.rendered && this._recordId) {
			this.rendered = true;
			const result = await getScenariosForApproval({ quoteId: this._recordId });
			const scenarioData = [];
			let primaryScenario = {};

			result.forEach((scenario) => {
				const scenarioObject = SubmitForApprovalDialog.createScenarioObject(scenario);
				if (scenarioObject.RecordType === 'Quote') {
					primaryScenario = scenarioObject;
				} else {
					scenarioData.push(scenarioObject);
				}
			});

			primaryScenario.isChecked = true;
			primaryScenario.isCheckboxDisabled = true;
			scenarioData.unshift(primaryScenario);
			this.scenarios = scenarioData;
		}
	}

	static createScenarioObject(scenarioRecord) {
		const scenarioObject = {};

		scenarioObject.Name = scenarioRecord.Name;
		scenarioObject.Id = scenarioRecord.Id;
		scenarioObject.CreatedDate = scenarioRecord.CreatedDate;
		scenarioObject.AccountName = scenarioRecord[`${nsPrefix}AccountId__r`]?.Name;
		scenarioObject.totalAmount = scenarioRecord[QUOTE_TOTAL_AMOUNT_FIELD.fieldApiName];
		scenarioObject.marginPercent = scenarioRecord[QUOTE_MARGIN_PERCENT_FIELD.fieldApiName] / 100;
		scenarioObject.RecordType = scenarioRecord[QUOTE_TOTAL_TYPE_FIELD.fieldApiName];
		scenarioObject.isChecked = false;
		scenarioObject.isCheckboxDisabled = false;
		scenarioObject.Comments = '';

		if (scenarioRecord[QUOTE_TOTAL_COST_FIELD.fieldApiName]) {
			scenarioObject.totalCost = scenarioRecord[QUOTE_TOTAL_COST_FIELD.fieldApiName];
		} else {
			scenarioObject.totalCost = 0;
		}

		return scenarioObject;
	}

	handleCloseDialog() {
		this.dispatchEvent(new CloseActionScreenEvent());
	}

	handleCheckScenario(event) {
		const currentScenarioId = event.target.dataset.id;
		let checkedScenarios = 1;
		for (let i = 0; i < this.scenarios.length; i++) {
			const scenarioObject = this.scenarios[i];
			if (scenarioObject.Id === currentScenarioId) {
				scenarioObject.isChecked = !scenarioObject.isChecked;
			}

			if (scenarioObject.RecordType !== 'Quote' && scenarioObject.isChecked) {
				checkedScenarios += 1;
			}
		}

		const scenarioCheckboxes = this.template.querySelectorAll('.scenario-checkbox');
		const idToCheckboxMap = {};
		for (let i = 0; i < scenarioCheckboxes.length; i++) {
			const checkbox = scenarioCheckboxes[i];
			idToCheckboxMap[checkbox.dataset.id] = checkbox;
		}

		for (let i = 0; i < this.scenarios.length; i++) {
			const scenarioObject = this.scenarios[i];
			const checkbox = idToCheckboxMap[scenarioObject.Id];
			if (scenarioObject.RecordType !== 'Quote') {
				checkbox.disabled = checkedScenarios >= 3 && !scenarioObject.isChecked;
			}
		}
	}

	handleAddScenarioComments(event) {
		const currentScenarioId = event.target.dataset.id;
		const scenarioObject = this.scenarios.find((scenario) => scenario.Id === currentScenarioId);
		scenarioObject.Comments = event.target.value;
	}

	async handleSubmitForApproval() {
		const scenariosForApproval = [];
		this.scenarios.forEach((scenario) => {
			if (scenario.isChecked) {
				scenariosForApproval.push({
					submittedComments: scenario.Comments,
					QuoteId: scenario.Id,
					IsPrimaryItem: scenario.RecordType === 'Quote',
				});
			}
		});

		try {
			await submitScenariosForApproval({ approvalRequestItems: scenariosForApproval });
			this.toastSubmitSuccess();
			this.dispatchEvent(new CloseActionScreenEvent());
		} catch (error) {
			this.toastError(error);
		}
	}

	toastSubmitSuccess() {
		this.dispatchEvent(
			new ShowToastEvent({
				title: this.labels.LABEL_SUCCESS,
				message: this.labels.LABEL_SUBMITTED_SCENARIOS_FOR_APPROVAL,
				variant: 'success',
			}),
		);
	}
	toastError(error) {
		this.dispatchEvent(
			new ShowToastEvent({
				title: this.labels.LABEL_SUBMIT_FOR_APPROVAL_ERROR_MESSAGE,
				message: reduceErrors(error).join(', '),
				variant: 'error',
			}),
		);
	}
}
