import {
	LightningElement, track, api, wire,
} from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import errorSavingNotificationTitleLabel from '@salesforce/label/c.ErrorSavingNotificationTitle';
import QuotePeriodCountRangeError from '@salesforce/label/c.QuotePeriodCountRangeError';
import TooManyPeriods from '@salesforce/label/c.TooManyPeriods';
import QUOTE_OBJECT from '@salesforce/schema/Quote__c';
import NAME from '@salesforce/schema/Quote__c.Name';
import IS_PRIMARY from '@salesforce/schema/Quote__c.IsPrimary__c';
import ACCOUNT_ID from '@salesforce/schema/Quote__c.AccountId__c';
import DESCRIPTION from '@salesforce/schema/Quote__c.Description__c';
import LABOR_UNITS from '@salesforce/schema/Quote__c.LaborUnits__c';
import OPPORTUNITY_ID from '@salesforce/schema/Quote__c.OpportunityId__c';
import SERVICE_START_DATE from '@salesforce/schema/Quote__c.ServiceStartDate__c';
import RATE_CARD_ID from '@salesforce/schema/Quote__c.RateCardId__c';
import SERVICE_END_DATE from '@salesforce/schema/Quote__c.ServiceEndDate__c';
import PRACTICE from '@salesforce/schema/Quote__c.Practice__c';
import TIME_PERIOD from '@salesforce/schema/Quote__c.TimePeriod__c';
import GROUP from '@salesforce/schema/Quote__c.Group__c';
import TIME_PERIODS_GROUP_METHOD from '@salesforce/schema/Quote__c.TimePeriodsGroupMethod__c';
import STATUS from '@salesforce/schema/Quote__c.Status__c';
import TIME_PERIODS_ALIGNMENT from '@salesforce/schema/Quote__c.TimePeriodsAlignment__c';
import LABEL_RESOURCE_DEFAULT_HEADER from '@salesforce/label/c.ResourceDefaultsHeaderLabel';

import getEstimateDetails from '@salesforce/apex/CreateQuoteFromEstimateController.getEstimateDetails';
import createQuote from '@salesforce/apex/CreateQuoteFromEstimateController.createQuote';
import getServiceEndDate from '@salesforce/apex/CreateQuoteFromEstimateController.getServiceEndDate';
import isValidPeriodCount from '@salesforce/apex/CreateQuoteFromEstimateController.isValidPeriodCount';
import log from 'c/log';
import { reduceErrors } from 'c/sparkUtils';

export default class CreateQuoteFromEstimate extends NavigationMixin(LightningElement) {
	@api recordId;
	@track quote = {};
	@track isQuoteForm = true;
	@track quoteObjectAPIName = QUOTE_OBJECT.objectApiName;
	@track quoteFields ={
		name: NAME.fieldApiName,
		isPrimary: IS_PRIMARY.fieldApiName,
		accountId: ACCOUNT_ID.fieldApiName,
		description: DESCRIPTION.fieldApiName,
		laborUnits: LABOR_UNITS.fieldApiName,
		opportunityId: OPPORTUNITY_ID.fieldApiName,
		serviceStartDate: SERVICE_START_DATE.fieldApiName,
		rateCardId: RATE_CARD_ID.fieldApiName,
		serviceEndDate: SERVICE_END_DATE.fieldApiName,
		practice: PRACTICE.fieldApiName,
		timePeriod: TIME_PERIOD.fieldApiName,
		group: GROUP.fieldApiName,
		timePeriodsGroupMethod: TIME_PERIODS_GROUP_METHOD.fieldApiName,
		status: STATUS.fieldApiName,
		timePeriodsAlignment: TIME_PERIODS_ALIGNMENT.fieldApiName,
	}
	labels = {
		errorSavingNotificationTitle: errorSavingNotificationTitleLabel,
		LABEL_RESOURCE_DEFAULT_HEADER,
	};
	@wire(getEstimateDetails, { estimateId: '$recordId' })
	wireOppData({ data, error }) {
		if (data) {
			this.quote = { ...data };
			this.quote.timePeriodsAlignment = 'User Defined Calendar';
			this.quote.laborUnits = 'Headcount';
		} else if (error) {
			log(error);
		}
	}

	async onChange(event) {
		try {
			this.quote[event.target.name] = event.target.value;
			const fieldName = event.target.name;
			if (fieldName === 'serviceStartDate' || fieldName === 'timePeriod' || fieldName === 'timePeriodsAlignment') {
				const endDateArgs = {
					calendarAlignment: this.quote.timePeriodsAlignment,
					serviceStartDate: this.quote.serviceStartDate,
				};

				const [endDate] = await Promise.all([getServiceEndDate({
					estimateId: this.recordId,
					endDateArgs,
				})]);

				this.quote.serviceEndDate = endDate;
			}
		} catch (error) {
			log(error);
		}
	}

	async checkPeriodCount() {
		const [isValid] = await Promise.all([isValidPeriodCount({
			serviceStartDate: this.quote.serviceStartDate,
			serviceEndDate: this.quote.serviceEndDate,
			timePeriods: this.quote.timePeriod,
		})]);

		if (!isValid) {
			const evt = new ShowToastEvent({
				title: TooManyPeriods,
				message: QuotePeriodCountRangeError,
				variant: 'error',
			});

			this.dispatchEvent(evt);
			return false;
		}

		return true;
	}

	async handleNext() {
		try {
			const isQuoteValid = [...this.template.querySelectorAll('lightning-input-field')]
				.reduce((validSoFar, inputField) => {
					const validity = inputField.reportValidity();
					return validSoFar && validity;
				}, true);

			const isPeriodValid = await this.checkPeriodCount();
			if (isQuoteValid && isPeriodValid) {
				this.isQuoteForm = false;
			}
		} catch (error) {
			log(error);
		}
	}

	saveQuote() {
		this.template.querySelector('c-estimate-resources').saveRecord();
		createQuote({ quoteDetails: JSON.stringify(this.quote) })
			.then((result) => {
				this.navigateToView(result, this.quoteObjectAPIName);
			})
			.catch((error) => {
				if (error.body.pageErrors.length) {
					const evt = new ShowToastEvent({
						title: this.labels.errorSavingNotificationTitle,
						message: reduceErrors(error).join(', '),
						variant: 'error',
					});

					this.dispatchEvent(evt);
				}

				log(error);
			});
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

	handleCancel() {
		this.dispatchEvent(new CloseActionScreenEvent());
	}
}
