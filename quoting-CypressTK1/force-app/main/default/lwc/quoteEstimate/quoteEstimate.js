import { LightningElement, wire, api } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

import FIELD_ESTIMATE_ID from '@salesforce/schema/Quote__c.EstimateId__c';

export default class QuickActionPanel extends LightningElement {
	@api recordId;
	@wire(getRecord, { recordId: '$recordId', fields: [FIELD_ESTIMATE_ID] }) quote;

	get estimateId() {
		return getFieldValue(this.quote.data, FIELD_ESTIMATE_ID);
	}
}
