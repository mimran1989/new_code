import {
	LightningElement, api, wire,
} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord } from 'lightning/uiRecordApi';
import LABEL_TEMPLATE_NAME from '@salesforce/label/c.TemplateName';
import { inputIsBlank } from 'c/util';

import copyAsTemplate from '@salesforce/apex/CopyAsTemplateController.copyAsTemplate';
import QUOTE_OBJECT from '@salesforce/schema/Quote__c';
import NAME_FIELD from '@salesforce/schema/Quote__c.Name';

const FIELDS = [NAME_FIELD];
export default class SaveAsQuoteTemplate extends NavigationMixin(LightningElement) {
	@api recordId;
	templateName;
	Label = {
		templateName: LABEL_TEMPLATE_NAME,
	};

	@wire(getRecord, { recordId: '$recordId', fields: FIELDS })
	quoteName(result) {
		if (result.data) {
			this.templateName = result.data.fields.Name.value;
		}
	}

	templateNameChange(event) {
		this.templateName = event.detail.value.trim();
		this.saveButton.set('v.disabled', inputIsBlank(this.templateName));
	}

	@api
	eventFooter(buttons) {
		[this.closeButton, this.saveButton] = buttons;
	}

	@api
	async saveTemplate() {
		if (!inputIsBlank(this.templateName)) {
			this.saveButton.set('v.disabled', true);
			const result = await copyAsTemplate({ recordId: this.recordId, templateName: this.templateName });
			this.navigateToView(result.Id, QUOTE_OBJECT);
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
}
