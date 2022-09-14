import { CloseActionScreenEvent } from 'lightning/actions';
import { LightningElement, api } from 'lwc';

export default class QuoteDiscounting extends LightningElement {
	@api recordId;

	_messageService;
	renderedCallback() {
		this._messageService = this.template.querySelector('c-message-service');
		this._quoteDiscounting = this.template.querySelector('c-quote-discounting');

		const style = document.createElement('style');
		style.innerText = `
			.slds-modal__content {
				overflow: hidden !important;
			}
		`;
		this.template.querySelector('.quote-discount')?.appendChild(style);
	}

	closeDialog() {
		this.dispatchEvent(new CloseActionScreenEvent());
	}

	async saveAndClose() {
		const success = await this._quoteDiscounting.saveAction();
		if (success) {
			this.closeDialog();
		}
	}
}
