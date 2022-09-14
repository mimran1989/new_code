/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

import { api, LightningElement } from 'lwc';

import LABEL_GLOBAL from '@salesforce/label/c.Global';
import LABEL_SCOPE_PARAMETERS from '@salesforce/label/c.ScopeParameters';
import LABEL_CLOSE from '@salesforce/label/c.CloseButton';
import LABEL_SAVE from '@salesforce/label/c.SaveButton';
import { componentNamespace } from 'c/util';

export default class ScopeParameterQuickAction extends LightningElement {
	@api recordId;
	@api invoke() {
		this.namespace = componentNamespace(this);
		this._messageService = this.template.querySelector('c-message-service');

		const dialogServicePayload = {
			method: 'bodyModalLarge',
			config: {
				auraId: 'scope-parameter-dialog',
				headerLabel: `${LABEL_GLOBAL} ${LABEL_SCOPE_PARAMETERS}`,
				component: `${this.namespace}:scopeParameterDialog`,
				componentParams: {
					estimateId: this.recordId,
					uniqueBoundary: 'component-state',
					recordId: this.recordId,
				},
				footerActions: [
					{ label: LABEL_CLOSE, eventName: 'close', class: '' },
					{
						label: LABEL_SAVE, eventName: 'c.save', class: 'slds-button_brand',
					},
				],
			},
		};

		this._messageService.dialogService(dialogServicePayload);
	}
}
