import {
	LightningElement, api, wire, track,
} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import cloneEstimateToQuote from '@salesforce/apex/EstimateCloner.cloneEstimateToQuote';
import ESTIMATE_OBJECT from '@salesforce/schema/Estimate__c';
import { CloseActionScreenEvent } from 'lightning/actions';
import { getRecord } from 'lightning/uiRecordApi';
import EstimateCloneSuccess from '@salesforce/label/c.CLoneSuccessMessage';
import EstimateCloneHeader from '@salesforce/label/c.EstimateCloneHeader';
import EstimateCloneError from '@salesforce/label/c.EstimateCloneError';
import Success from '@salesforce/label/c.Success';
import Error from '@salesforce/label/c.Error';

import { isEmpty, formatLabel } from 'c/util';

const FIELDS = [
	'Estimate__c.Name',
];

export default class EstimateCloner extends NavigationMixin(LightningElement) {
	@api recordId;
	clonedEstimateName;
	@track quoteObjectAPIName = ESTIMATE_OBJECT.objectApiName;
	@track title = EstimateCloneHeader;
	error;

	closeAction() {
		this.dispatchEvent(new CloseActionScreenEvent());
	}

	@wire(getRecord, { recordId: '$recordId', fields: FIELDS })
	wiredData({ error, data }) {
		if (data) {
			this.clonedEstimateName = data.fields.Name.value;
		} else if (error) {
			this.error = error;
		}
	}

	handleChange(event) {
		this.clonedEstimateName = event.target.value;
	}

	get disableButton() {
		return isEmpty(this.clonedEstimateName);
	}

	async cloneEstimate() {
		const result = await cloneEstimateToQuote({ estimateId: this.recordId, estimateName: this.clonedEstimateName, clonedQuote: null });
		if (result) {
			const successTitle = formatLabel(EstimateCloneSuccess, [this.clonedEstimateName]);
			this.showNotification(successTitle, Success, 'success');
			this.navigateToView(result, 'Estimate__c');
		} else {
			this.showNotification(EstimateCloneError, Error, 'error');
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
