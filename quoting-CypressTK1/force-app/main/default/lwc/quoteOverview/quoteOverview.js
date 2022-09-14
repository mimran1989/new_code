/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

import { api, LightningElement, wire } from 'lwc';
import LABEL_APPROVE from '@salesforce/label/c.Approve';
import LABEL_CREATED_BY from '@salesforce/label/c.CreatedBy';
import approveQuote from '@salesforce/apex/QuoteCompareController.approveQuote';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { reduceErrors } from 'c/sparkUtils';
import ApprovalRequest from '@salesforce/schema/ApprovalRequest__c';

export default class QuoteOverview extends NavigationMixin(LightningElement) {
	@api quote;
	labels;
	data;
	LABEL_APPROVE = LABEL_APPROVE;
	LABEL_CREATED_BY = LABEL_CREATED_BY;

	@wire(CurrentPageReference)
	setCurrentPageReference(currentPageReference) {
		this.currentPageReference = currentPageReference;
	}

	connectedCallback() {
		const labels = [];
		const data = [];
		Object.keys(this.quote.headcountByLocation).forEach((location) => {
			labels.push(location);
			data.push(this.quote.headcountByLocation[location]);
		});

		this.labels = labels;
		this.data = data;
	}

	async handleApprove() {
		try {
			await approveQuote({ requestId: this.currentPageReference.state.c__requestId, quoteId: this.quote.id });
			this.navigateToRecordPage();
		} catch (e) {
			this.dispatchEvent(
				new ShowToastEvent({
					title: 'Application Exception',
					message: reduceErrors(e).join(', '),
					variant: 'error',
				}),
			);
		}
	}

	navigateToRecordPage() {
		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: this.currentPageReference.state.c__requestId,
				objectApiName: ApprovalRequest.objectApiName,
				actionName: 'view',
			},
		});
	}
}
