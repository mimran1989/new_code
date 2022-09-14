import { LightningElement, api, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import LABEL_CLOSE_BUTTON from '@salesforce/label/c.CloseButton';
import LABEL_SAVE from '@salesforce/label/c.SaveButton';

import LABEL_RESOURCE_DEFAULT_HEADER from '@salesforce/label/c.ResourceDefaultsHeaderLabel';

export default class EstimateResourcesQuickAction extends LightningElement {
	@api recordId;
	@track disableSaveButton = true;
	LABEL_SAVE_BUTTON = LABEL_SAVE;
	LABEL_CLOSE_BUTTON = LABEL_CLOSE_BUTTON;
	LABEL_RESOURCE_DEFAULT_HEADER = LABEL_RESOURCE_DEFAULT_HEADER;

	handleCloseDialog() {
		this.dispatchEvent(new CloseActionScreenEvent());
	}

	disableButtonStatus = (value) => { this.disableSaveButton = value; }

	handleSaveRecord() {
		this.template.querySelector('c-estimate-resources').saveRecord();
		this.handleCloseDialog();
	}
}
