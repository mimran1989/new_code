/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import { api, LightningElement, wire } from 'lwc';
import getQuoteOverviewsForRequest from '@salesforce/apex/QuoteCompareController.getQuoteOverviewsForRequest';
import LABEL_REJECT_WITH_COMMENTS from '@salesforce/label/c.RejectWithComments';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import rejectQuotes from '@salesforce/apex/QuoteCompareController.rejectQuotes';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { reduceErrors } from 'c/sparkUtils';
import ApprovalRequest from '@salesforce/schema/ApprovalRequest__c';
import LABEL_INVALID_APPROVAL_REQUEST from '@salesforce/label/c.InvalidApprovalRequest';

export default class QuoteCompare extends NavigationMixin(LightningElement) {
	@api quoteIds = [];
	currentPageReference;
	@wire(CurrentPageReference)
	setCurrentPageReference(currentPageReference) {
		this.currentPageReference = currentPageReference;
	}

	quotes;
	hasQuotes = false;
	isInvalidRequest = false;
	isRejectDisabled = true;

	LABEL_REJECT_WITH_COMMENTS = LABEL_REJECT_WITH_COMMENTS;
	LABEL_INVALID_APPROVAL_REQUEST = LABEL_INVALID_APPROVAL_REQUEST;

	async connectedCallback() {
		this.quotes = await getQuoteOverviewsForRequest({ requestId: this.currentPageReference.state.c__requestId });
		this.quotes.forEach((nextQuote) => {
			const quote = nextQuote;
			quote.css = `slds-col slds-p-around_xx-small slds-size_1-of-${this.quotes.length}`;
		});

		this.hasQuotes = this.quotes.length;

		if (!this.hasQuotes) {
			this.isInvalidRequest = true;
		}
	}

	handleChange(event) {
		this.isRejectDisabled = !event.detail.value?.trim() || '';
	}
	async handleReject() {
		const rejectCommentsInput = this.template.querySelector('.reject-comments-input');
		rejectCommentsInput.reportValidity();

		if (!rejectCommentsInput.checkValidity()) {
			return;
		}

		try {
			await rejectQuotes({ requestId: this.currentPageReference.state.c__requestId, rejectComments: rejectCommentsInput.value });
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
