/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

import { api, LightningElement } from 'lwc';

import LABEL_ADJUST_COLA_FOR_QUOTE from '@salesforce/label/c.AdjustColaForQuote';
import LABEL_CLOSE from '@salesforce/label/c.CloseButton';
import LABEL_SAVE from '@salesforce/label/c.SaveButton';
import LABEL_SAVE_AND_REVIEW from '@salesforce/label/c.SaveAndReview';
import { componentNamespace } from 'c/util';

export default class AdjustColaRatesQuickAction extends LightningElement {
	@api recordId;
	@api invoke() {
		this.namespace = componentNamespace(this);
		this._messageService = this.template.querySelector('c-message-service');

		const dialogServicePayload = {
			method: 'bodyModalLarge',
			config: {
				auraId: 'adjust-cola-rates-dialog',
				headerLabel: LABEL_ADJUST_COLA_FOR_QUOTE,
				component: `${this.namespace}:adjustColaRatesDialog`,
				componentParams: {
					recordId: this.recordId,
				},
				footerActions: [
					{ label: LABEL_CLOSE, eventName: 'close', class: '' },
					{
						label: LABEL_SAVE_AND_REVIEW, eventName: 'c.handlePreview', class: 'slds-button_brand',
					},
					{
						label: LABEL_SAVE, eventName: 'c.handleSave', class: 'slds-button_brand',
					},
				],
			},
		};

		this._messageService.dialogService(dialogServicePayload);
	}
}
