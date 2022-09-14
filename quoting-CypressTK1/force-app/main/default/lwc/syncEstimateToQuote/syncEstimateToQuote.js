import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LABEL_ERROR from '@salesforce/label/c.Error';
import LABEL_SUCCESS_MESSAGE from '@salesforce/label/c.SyncEstimateToQuoteSuccess';
import log from 'c/log';

import syncEstimateToQuote from '@salesforce/apex/SyncEstimateToQuoteController.syncEstimateToQuote';

export default class SyncEstimateToQuote extends NavigationMixin(LightningElement) {
	@api recordId;
	successTitle=LABEL_SUCCESS_MESSAGE;
	errorMsg=LABEL_ERROR;

	@api async invoke() {
		try {
			const result = await syncEstimateToQuote({ estimateId: this.recordId });
			if (result) {
				this.showNotification(this.successTitle, result, 'success');
			}
		} catch (error) {
			log(error);
			this.showNotification(this.errorMsg, error.body.message, 'error');
		}
	}

	showNotification(title, message, variant) {
		const evt = new ShowToastEvent({
			title,
			message,
			variant,
		});

		this.dispatchEvent(evt);
	}
}
