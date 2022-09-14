import {
	LightningElement, api, wire, track,
} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import cloneEstimateTemplate from '@salesforce/apex/EstimateTemplateCloner.cloneEstimateTemplate';
import estimateTemplateObject from '@salesforce/schema/EstimateTemplate__c';
import { CloseActionScreenEvent } from 'lightning/actions';
import { getRecord } from 'lightning/uiRecordApi';
import EstimateTemplateCloneSuccess from '@salesforce/label/c.CLoneSuccessMessage';
import LabelCloneButton from '@salesforce/label/c.CloneButton';
import LabelEstimateTemplateName from '@salesforce/label/c.EstimateTemplateName';
import EstimateTemplateCloneHeader from '@salesforce/label/c.EstimateTemplateCloneHeader';
import EstimateTemplateCloneError from '@salesforce/label/c.EstimateTemplateCloneError';
import FIELD_EST_TEMPLATE_NAME from '@salesforce/schema/EstimateTemplate__c.Name';
import Success from '@salesforce/label/c.Success';
import Error from '@salesforce/label/c.Error';

import { isEmpty, formatLabel } from 'c/util';

export default class EstimateTemplateCloner extends NavigationMixin(LightningElement) {
    @api recordId;
	clonedEstimateTemplateName;
	@track quoteObjectAPIName = estimateTemplateObject.objectApiName;
	@track title = EstimateTemplateCloneHeader;
	error;
	Label = {
		LABEL_CLONE_BUTTON: LabelCloneButton,
		LABEL_ESTIMATE_TEMPLATE_NAME: LabelEstimateTemplateName,
	}
	closeAction() {
		this.dispatchEvent(new CloseActionScreenEvent());
	}

	@wire(getRecord, { recordId: '$recordId', fields: FIELD_EST_TEMPLATE_NAME })
	wiredData({ error, data }) {
		if (data) {
			this.clonedEstimateTemplateName = data.fields.Name.value;
		} else if (error) {
			this.error = error;
		}
	}

	handleChange(event) {
		this.clonedEstimateTemplateName = event.target.value;
	}

	get disableButton() {
		return isEmpty(this.clonedEstimateTemplateName);
	}

	async cloneEstimateTemplate() {
		const result = await cloneEstimateTemplate({ estimateTemplateId: this.recordId, estimateTemplateName: this.clonedEstimateTemplateName });
		if (result) {
			const successTitle = formatLabel(EstimateTemplateCloneSuccess, [this.clonedEstimateTemplateName]);
			this.showNotification(successTitle, Success, 'success');
			this.navigateToView(result, 'EstimateTemplate__c');
		} else {
			this.showNotification(EstimateTemplateCloneError, Error, 'error');
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
