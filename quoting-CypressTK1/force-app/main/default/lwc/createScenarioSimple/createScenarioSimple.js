import { LightningElement, api, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { NavigationMixin } from 'lightning/navigation';

import cloneQuoteToScenario from '@salesforce/apex/CreateNewScenarioController.cloneQuoteToScenario';
import QUOTE_OBJECT from '@salesforce/schema/Quote__c';

import log from 'c/log';

export default class CreateScenarioSimple extends NavigationMixin(LightningElement) {
	@api recordId;
	@track quoteRecord = {};
	isLoading = false;
	scenarioId;
	error;
	isActionDisabled = false;

	scenarioNameUpdate(event) {
		this.scenarioName = event.detail.value.trim();
	}

	@api validate() {
		const scenarioInput = this.template.querySelector('.scenario-name');
		if (scenarioInput) {
			scenarioInput.reportValidity();
		}
	}

	createScenario() {
		this.validate();

		if (this.scenarioName !== undefined) {
			this.isActionDisabled = true;
			this.isLoading = true;

			cloneQuoteToScenario({
				quoteId: this.recordId,
				adjustment: '{}',
				scenarioName: this.scenarioName,
			})
				.then((result) => {
					this.scenarioId = result;
					this.navigateToView(this.scenarioId, QUOTE_OBJECT);
				})
				.catch((error) => {
					log(error);
				});
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

	closeAction() {
		this.dispatchEvent(new CloseActionScreenEvent());
		this.rendered = false;
	}
}
