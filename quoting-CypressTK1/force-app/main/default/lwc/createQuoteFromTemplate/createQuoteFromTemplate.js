import {
	LightningElement, track, api, wire,
} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import retrieveQuoteTemplateDetails from '@salesforce/apex/CreateQuoteFromTemplateController.retrieveQuoteTemplateDetails';
import computeNewEndDate from '@salesforce/apex/CreateQuoteFromTemplateController.computeNewEndDate';
import getOpportunityDetails from '@salesforce/apex/CreateQuoteFromTemplateController.getOpportunityDetails';
import { CloseActionScreenEvent } from 'lightning/actions';
import log from 'c/log';

import OBJECT_QUOTE from '@salesforce/schema/Quote__C';
import FIELD_NAME from '@salesforce/schema/Quote__c.Name';
import FIELD_TEMPLATE_ID from '@salesforce/schema/Quote__c.TemplateId__c';
import FIELD_ACCOUNT_ID from '@salesforce/schema/Quote__c.AccountId__c';
import FIELD_OPPORTUNITY_ID from '@salesforce/schema/Quote__c.OpportunityId__c';
import FIELD_RATE_CARD_ID from '@salesforce/schema/Quote__c.RateCardId__c';
import FIELD_SERVICE_START_DATE from '@salesforce/schema/Quote__c.ServiceStartDate__c';
import FIELD_PRACTICE from '@salesforce/schema/Quote__c.Practice__c';
import FIELD_GROUP from '@salesforce/schema/Quote__c.Group__c';
import FIELD_QUOTE_DATE from '@salesforce/schema/Quote__c.QuoteDate__c';
import FIELD_TOTAL_AMOUNT from '@salesforce/schema/Quote__c.TotalAmount__c';
import FIELD_TOTAL_COST from '@salesforce/schema/Quote__c.TotalCost__c';
import FIELD_SERVICE_END_DATE from '@salesforce/schema/Quote__c.ServiceEndDate__c';
import FIELD_SERVICE_ID from '@salesforce/schema/Quote__c.ServiceId__c';
import FIELD_TIME_PERIOD from '@salesforce/schema/Quote__c.TimePeriod__c';
import FIELD_TIME_PERIODS_GROUP_METHOD from '@salesforce/schema/Quote__c.TimePeriodsGroupMethod__c';
import FIELD_MARGIN_PERCENT from '@salesforce/schema/Quote__c.MarginPercent__c';
import FIELD_SECTION_HIERARCHY from '@salesforce/schema/Quote__c.SectionHierarchy__c';

export default class CreateQuoteFromTemplate extends NavigationMixin(LightningElement) {
	@api recordId;
	@track selectedTemplate;
	@track selectedTemplateId = null;
	@track serviceStartDate;
	@track serviceEndDate;
	@track quoteName;
	@track accountId;
	@track opportunityId;
	@track timePeriod;
	@track timePeriodsAlignment;
	@track timePeriodsGroupMethod;
	@track rateCardId;
	@track practice;
	@track group;
	@track marginPercent;
	@track priceUOM;
	@track profitAmount;
	@track quoteDate;
	@track totalAmount;
	@track totalCost;
	@track sectionHierarchy;
	@track serviceId;

	@track quoteObjectAPIName = OBJECT_QUOTE.objectApiName;
	@track quoteFields ={
		name: FIELD_NAME.fieldApiName,
		templateId: FIELD_TEMPLATE_ID.fieldApiName,
		accountId: FIELD_ACCOUNT_ID.fieldApiName,
		opportunityId: FIELD_OPPORTUNITY_ID.fieldApiName,
		rateCardId: FIELD_RATE_CARD_ID.fieldApiName,
		serviceStartDate: FIELD_SERVICE_START_DATE.fieldApiName,
		practice: FIELD_PRACTICE.fieldApiName,
		group: FIELD_GROUP.fieldApiName,
		quoteDate: FIELD_QUOTE_DATE.fieldApiName,
		totalAmount: FIELD_TOTAL_AMOUNT.fieldApiName,
		totalCost: FIELD_TOTAL_COST.fieldApiName,
		serviceEndDate: FIELD_SERVICE_END_DATE.fieldApiName,
		serviceId: FIELD_SERVICE_ID.fieldApiName,
		timePeriod: FIELD_TIME_PERIOD.fieldApiName,
		timePeriodsGroupMethod: FIELD_TIME_PERIODS_GROUP_METHOD.fieldApiName,
		marginPercent: FIELD_MARGIN_PERCENT.fieldApiName,
		sectionHierarchy: FIELD_SECTION_HIERARCHY.fieldApiName,

	}

	quoteId;

	@wire(getOpportunityDetails, { opportunityId: '$recordId' })
	wireOppData({ data, error }) {
		if (data) {
			this.accountId = data.AccountId;
			this.opportunityId = data.Id;
		} else if (error) {
			log(error);
		}
	}

	onTemplateSelection(event) {
		this.selectedTemplateId = event.detail.value;
		retrieveQuoteTemplateDetails({ selectedTemplateId: this.selectedTemplateId.toString() })
			.then((result) => {
				this.selectedTemplate = result;
				this.quoteName = result.Name;
				this.serviceStartDate = result[this.quoteFields.serviceStartDate];
				this.serviceEndDate = result[this.quoteFields.serviceEndDate];
				this.serviceId = result[this.quoteFields.serviceId];
				this.accountId = result[this.quoteFields.accountId];
				this.opportunityId = result[this.quoteFields.opportunityId];
				this.timePeriod = result[this.quoteFields.timePeriod];
				this.timePeriodsGroupMethod = result[this.quoteFields.timePeriodsGroupMethod];
				this.rateCardId = result[this.quoteFields.rateCardId];
				const marginPercentUnrounded = result[this.quoteFields.marginPercent];
				this.marginPercent = Math.round(marginPercentUnrounded * 100) / 100;
				this.quoteDate = result[this.quoteFields.quoteDate];
				this.totalAmount = result[this.quoteFields.totalAmount];
				this.totalCost = result[this.quoteFields.totalCost];
				this.practice = result[this.quoteFields.practice];
				this.group = result[this.quoteFields.group];
				this.sectionHierarchy = result[this.quoteFields.sectionHierarchy];
			})
			.catch((error) => {
				this.error = error;
			});
	}

	async onStartDateChange(event) {
		const newStartDate = event.detail.value;

		const newEndDate = await computeNewEndDate({
			selectedTemplateId: this.selectedTemplateId.toString(),
			newStartDate,
		});

		this.serviceEndDate = JSON.parse(newEndDate);
	}

	handleError(event) {
		const detailedMessage = event.detail?.data?.output?.message;
		const shortMessage = event.detail?.message;

		this.dispatchEvent(
			new ShowToastEvent({
				title: 'Failed to Create Quote',
				message: JSON.stringify(detailedMessage || shortMessage),
				variant: 'error',
			}),
		);
	}

	handleSuccess(event) {
		this.quoteId = event.detail.id.toString();
		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: this.quoteId,
				objectApiName: 'Quote__c',
				actionName: 'view',
			},
		});
	}

	cancel() {
		this.dispatchEvent(new CloseActionScreenEvent());
	}
}
