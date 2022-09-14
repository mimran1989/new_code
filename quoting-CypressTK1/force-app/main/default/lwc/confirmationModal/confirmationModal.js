import {
	LightningElement,
	api,
	track,
} from 'lwc';
import LABEL_CANCEL_BUTTON from '@salesforce/label/c.CancelButton';
import LABEL_PROCEED_BUTTON from '@salesforce/label/c.ProceedButton';

export default class ConfirmationModal extends LightningElement {
	@api title;
	@api popUpMessage;
	@api promptName;
	@track label = {
		LABEL_CANCEL_BUTTON,
		LABEL_PROCEED_BUTTON,
	};

	handleOk() {
		const selectedEvent = new CustomEvent('confirm', {
			detail: {
				isConfirmed: true,
			},
		});

		this.dispatchEvent(selectedEvent);
	}

	handleCancel() {
		const selectedEvent = new CustomEvent('confirm', {
			detail: {
				isConfirmed: false,
			},
		});

		this.dispatchEvent(selectedEvent);
	}
}
