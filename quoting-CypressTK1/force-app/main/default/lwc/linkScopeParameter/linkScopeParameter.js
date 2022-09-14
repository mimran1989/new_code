import { LightningElement, api } from 'lwc';
import { generateUUID } from 'c/baseUtils';
import { componentNamespace } from 'c/util';

import LINK_BUTTON_LABEL from '@salesforce/label/c.Link';
import CANCEL_BUTTON_LABEL from '@salesforce/label/c.CancelButton';

export default class LinkScopeParameter extends LightningElement {
	@api taskTemplateId;
	@api selectedScopeParameterId;

	_dialogService;
	_messageService;
	_namespace;
	_uniqueBoundary;

	LINK_BUTTON_LABEL = LINK_BUTTON_LABEL;

	get uniqueBoundary() {
		return `link-scope-parameter-components-${this._uniqueBoundary}`;
	}

	connectedCallback() {
		this._uniqueBoundary = generateUUID();
		this._namespace = componentNamespace(this);
	}

	renderedCallback() {
		this._dialogService = this.template.querySelector('.dialog-service');
	}

	handleOpenLinkDialog() {
		const dialogServicePayload = {
			method: 'bodyModal',
			config: {
				auraId: 'link-scope-parameter',
				headerLabel: 'Link a scope parameter',
				component: `${this._namespace}:linkScopeParameterSearch`,
				componentParams: {
					taskTemplateId: this.taskTemplateId,
					selectedScopeParameterId: this.selectedScopeParameterId,
					uniqueBoundary: this.uniqueBoundary,
				},
				footerActions: [
					{ label: CANCEL_BUTTON_LABEL, eventName: 'close', class: '' },
					{ label: LINK_BUTTON_LABEL, eventName: 'c.handleLinkedScopeParameter', class: 'slds-button_brand' },
				],
			},
		};

		this._dialogService.dialogService(dialogServicePayload);
	}

	async handleLinkedScopeParameter(event) {
		this._dialogService.notifyClose();
		this.dispatchEvent(
			new CustomEvent('selection', {
				detail: { scopeParameter: event.detail.value },
				bubbles: true,
				composed: true,
			}),
		);
	}
}
