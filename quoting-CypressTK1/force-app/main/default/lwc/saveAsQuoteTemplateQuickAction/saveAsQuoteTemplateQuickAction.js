import { api, LightningElement } from 'lwc';
import LABEL_SAVE_AS_TEMPLATE from '@salesforce/label/c.SaveAsTemplate';
import LABEL_CLOSE from '@salesforce/label/c.CloseButton';
import LABEL_SAVE from '@salesforce/label/c.SaveButton';
import { componentNamespace } from 'c/util';

export default class SaveAsQuoteTemplateQuickAction extends LightningElement {
	@api recordId;
	@api invoke() {
		this.namespace = componentNamespace(this);
		this._messageService = this.template.querySelector('c-message-service');

		const dialogServicePayload = {
			method: 'bodyModal',
			config: {
				auraId: 'save-as-quote-template',
				headerLabel: `${LABEL_SAVE_AS_TEMPLATE}`,
				component: `${this.namespace}:saveAsQuoteTemplate`,
				componentParams: {
					recordId: this.recordId,
				},
				footerActions: [
					{ label: LABEL_CLOSE, eventName: 'close' },
					{ label: LABEL_SAVE, eventName: 'c.saveTemplate', class: 'slds-button_brand' },
				],
			},
		};

		this._messageService.dialogService(dialogServicePayload);
	}
}
