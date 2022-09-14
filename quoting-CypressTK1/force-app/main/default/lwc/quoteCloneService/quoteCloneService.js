import {
	LightningElement,
	api,
	wire,
	track,
} from 'lwc';
import {
	NavigationMixin,
} from 'lightning/navigation';
import {
	ShowToastEvent,
} from 'lightning/platformShowToastEvent';
import cloneQuote from '@salesforce/apex/QuoteCloneService.cloneQuote';
import quoteObject from '@salesforce/schema/Quote__c';
import {
	CloseActionScreenEvent,
} from 'lightning/actions';
import {
	getRecord,
} from 'lightning/uiRecordApi';
import QuoteCloneSuccess from '@salesforce/label/c.CLoneSuccessMessage';
import LabelCloneButton from '@salesforce/label/c.CloneButton';
import LabelCancelButton from '@salesforce/label/c.CancelButton';
import LabelQuoteName from '@salesforce/label/c.QuoteName';
import QuoteCloneHeader from '@salesforce/label/c.QuoteCloneHeader';
import QuoteCloneError from '@salesforce/label/c.QuoteCloneError';
import FIELD_QUOTE_NAME from '@salesforce/schema/Quote__c.Name';
import Success from '@salesforce/label/c.Success';
import Error from '@salesforce/label/c.Error';

import {
	isEmpty,
	formatLabel,
} from 'c/util';

export default class quoteCloneService extends NavigationMixin(LightningElement) {
	@api recordId;
	clonedQuoteName;
	@track quoteObjectAPIName = quoteObject.objectApiName;
	@track title = QuoteCloneHeader;
	error;
	Label = {
		LABEL_CLONE_BUTTON: LabelCloneButton,
		LABEL_CANCEL_BUTTON: LabelCancelButton,
		LABEL_QUOTE_NAME: LabelQuoteName,
	}
	closeAction() {
		this.dispatchEvent(new CloseActionScreenEvent());
	}

	@wire(getRecord, {
		recordId: '$recordId',
		fields: FIELD_QUOTE_NAME,
	})
	wiredData({
		error,
		data,
	}) {
		if (data) {
			this.clonedQuoteName = data.fields.Name.value;
		} else if (error) {
			this.error = error;
		}
	}

	handleChange(event) {
		this.clonedQuoteName = event.target.value;
	}

	get disableButton() {
		return isEmpty(this.clonedQuoteName);
	}

	async cloneQuote() {
		const result = await cloneQuote({
			quoteId: this.recordId,
			quoteName: this.clonedQuoteName,
		});

		if (result) {
			const successTitle = formatLabel(QuoteCloneSuccess, [this.clonedQuoteName]);
			this.showNotification(successTitle, Success, 'success');
			this.navigateToView(result, this.quoteObjectAPIName);
		} else {
			this.showNotification(QuoteCloneError, Error, 'error');
		}
	}

	navigateToView(recordId, objectName) {
		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId,
				objectApiName: objectName,
				actionName: 'view',
			},
		});
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
