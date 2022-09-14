import {
	LightningElement,
	api,
} from 'lwc';
import RENAME_ADDON from '@salesforce/label/c.RenameAddon';

export default class RenameAddOn extends LightningElement {
	@api quote;
	LABEL_RENAME_ADDON = RENAME_ADDON;
	_messageService;

	renderedCallback() {
		this._messageService = this.template.querySelector('c-message-service');
		this._messageService.publish({
			key: 'deselect',
		});
	}

	handleRenameAddon() {
		const allValid = [...this.template.querySelectorAll('lightning-input')]
			.reduce((validSoFar, inputCmp) => {
				inputCmp.reportValidity();
				return validSoFar && inputCmp.checkValidity();
			}, true);

		if (!allValid) {
			return;
		}

		const renametext = this.template.querySelector('lightning-input').value;
		this._messageService.publish({
			key: 'updateaddon',
			value: renametext,
		});
		this._messageService.notifyClose();
	}
}
