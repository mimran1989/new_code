import { LightningElement, wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import removeEstimateFromQuote from '@salesforce/apex/RemoveEstimateFromQuoteController.removeEstimateFromQuote';
import SUCCESSFULLY_REMOVED_ESTIMATE from '@salesforce/label/c.SuccessfullyRemovedEstimate';
import log from 'c/log';

export default class RemoveEstimateFromQuote extends LightningElement {
	quoteId = null;

	renderedCallback() {
		this._messageService = this.template.querySelector('c-message-service');
	}

	@wire(CurrentPageReference)
	getStateParameters(currentPageReference) {
		if (currentPageReference) {
			this.urlStateParameters = currentPageReference.state;
			const { attributes } = currentPageReference;
			this.quoteId = this.urlStateParameters.recordId || attributes.recordId || null;
		}
	}

	async connectedCallback() {
		try {
			removeEstimateFromQuote({ quoteId: this.quoteId }).then((result) => {
				if (result.success) {
					const evt = new ShowToastEvent({
						title: SUCCESSFULLY_REMOVED_ESTIMATE.replace('{0}', result.estimateName),
						variant: 'success',
					});

					this.dispatchEvent(new CloseActionScreenEvent());
					this.dispatchEvent(evt);
					this._messageService.publish({ key: 'afterdelinkestimate' });
					this._messageService.notifyClose();
				}
			});
		} catch (error) {
			log(error);
			this.dispatchEvent(new CloseActionScreenEvent());
		}
	}
}
