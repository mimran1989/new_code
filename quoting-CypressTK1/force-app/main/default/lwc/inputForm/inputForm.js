/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import { api, LightningElement } from 'lwc';

export default class InputForm extends LightningElement {
	@api inputFields = [];
	@api eventKey;
	@api boundary; // deprecated
	@api contextId;
	@api uniqueBoundary;

	recordSelections = {};

	renderedCallback() {
		this._messageService = this.template.querySelector('c-message-service');
	}

	@api
	async save() {
		const allValid = [...this.template.querySelectorAll('lightning-input')]
			.reduce((validSoFar, inputCmp) => {
				inputCmp.reportValidity();
				return validSoFar && inputCmp.checkValidity();
			}, true);

		if (!allValid) {
			return undefined;
		}

		const inputValues = { contextId: this.contextId, ...this.recordSelections };
		this.template.querySelectorAll('lightning-input').forEach((x) => {
			inputValues[x.name] = x.value;
		});

		if (this.uniqueBoundary) {
			this._messageService.publish({ key: this.eventKey, value: inputValues });
			this._messageService.notifyBoundaryClose();
		}

		return inputValues;
	}

	handleRecordSelect(event) {
		this.recordSelections[event.detail.name] = event.detail.recordId;
	}
}
