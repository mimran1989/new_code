import {
	LightningElement, api, wire, track,
} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import RateCardObject from '@salesforce/schema/RateCard__c';
import OBJECT_QUOTE from '@salesforce/schema/Quote__c';
import FIELD_ACCOUNT from '@salesforce/schema/Quote__c.AccountId__c';
import SERVICE_START_DATE from '@salesforce/schema/Quote__c.ServiceStartDate__c';
import SERVICE_END_DATE from '@salesforce/schema/Quote__c.ServiceEndDate__c';
import createRateCardFromQuoteId from '@salesforce/apex/CreateRateCardFromQuoteController.createRateCardFromQuoteId';
import getRateCardByQuoteId from '@salesforce/apex/CreateRateCardFromQuoteController.getRateCardByQuoteId';
import { CloseActionScreenEvent } from 'lightning/actions';
import Success from '@salesforce/label/c.Success';
import Error from '@salesforce/label/c.Error';
import LabelCreate from '@salesforce/label/c.CreateButton';
import LabelCancel from '@salesforce/label/c.CancelButton';
import LabelRateCardName from '@salesforce/label/c.RateCardName';
import LabelHighestRevenue from '@salesforce/label/c.HighestRevenue';
import LabelLowestRevenue from '@salesforce/label/c.LowestRevenue';
import LabelAverageRevenue from '@salesforce/label/c.AverageRevenue';
import LabelExpirationDate from '@salesforce/label/c.ExpirationDate';
import LabelEffectiveDate from '@salesforce/label/c.EffectiveDate';
import LabelDuplicateStrategy from '@salesforce/label/c.DuplicateStrategy';
import CreateRateCardFromQuoteTitle from '@salesforce/label/c.CreateRateCardFromQuoteTitle';
import CreateRateCardFromQuoteSuccess from '@salesforce/label/c.CreateRateCardFromQuoteSuccess';
import CreateRateCardFromQuoteAlreadyExisting from '@salesforce/label/c.CreateRateCardFromQuoteAlreadyExisting';
import CreateRateCardFromQuoteAccountIdMissing from '@salesforce/label/c.CreateRateCardFromQuoteAccountIdMissing';
import { getRecord } from 'lightning/uiRecordApi';
import log from 'c/log';
import { reduceErrors } from 'c/sparkUtils';
import { isEmpty, formatLabel } from 'c/util';

const FIELDS = [
	`${OBJECT_QUOTE.objectApiName}.Name`,
	`${OBJECT_QUOTE.objectApiName}.${FIELD_ACCOUNT.fieldApiName}`,
	`${OBJECT_QUOTE.objectApiName}.${SERVICE_START_DATE.fieldApiName}`,
	`${OBJECT_QUOTE.objectApiName}.${SERVICE_END_DATE.fieldApiName}`,
];

export default class CreateRateCardFromQuote extends NavigationMixin(LightningElement) {
	@api recordId;
	@track rateCardName;
	@track effectiveDate;
	@track expirationDate;
	@track duplicateStrategy;
	@track title = CreateRateCardFromQuoteTitle;
	@track objectApiName = RateCardObject.objectApiName;
	successTitle = CreateRateCardFromQuoteSuccess;
	accountId;
	@track labelRateCardName = LabelRateCardName;
	@track labelCreate = LabelCreate;
	@track labelCancel = LabelCancel;
	@track labelEffectiveDate = LabelEffectiveDate;
	@track labelExpirationDate = LabelExpirationDate;
	@track labelDuplicateStrategy = LabelDuplicateStrategy;

	@wire(getRecord, { recordId: '$recordId', fields: FIELDS })
	wiredData({ error, data }) {
		if (data) {
			this.rateCardName = data.fields.Name.value;
			this.effectiveDate = data.fields[SERVICE_START_DATE.fieldApiName].value;
			this.expirationDate = data.fields[SERVICE_END_DATE.fieldApiName].value;
			this.accountId = data.fields[FIELD_ACCOUNT.fieldApiName].value;
		} else if (error) {
			this.error = error;
		}
	}

	async createRateCard(quoteId) {
		try {
			const requestObject = {
				request: {
					quoteId,
					rateCardName: this.rateCardName,
					effectiveDate: this.effectiveDate,
					expirationDate: this.expirationDate,
					duplicateStrategy: this.duplicateStrategy,
				},
			};

			const result = await createRateCardFromQuoteId(requestObject);
			this.showNotification(formatLabel(this.successTitle, [this.rateCardName]), Success, 'success');
			this.navigateToView(result.Id, RateCardObject.objectApiName);
			this.dispatchEvent(new CloseActionScreenEvent());
		} catch (e) {
			this.showNotification('Error occurred', Error, 'error');
			log(e);
		}
	}

	get duplicateStrategyOptions() {
		if (!this.duplicateStrategy) {
			this.duplicateStrategy = 'Highest';
		}

		const duplicateStrategyOptionList = [
			{ label: LabelHighestRevenue, value: 'Highest' },
			{ label: LabelLowestRevenue, value: 'Lowest' },
			{ label: LabelAverageRevenue, value: 'Average' },
		];

		return duplicateStrategyOptionList;
	}

	handleChange(event) {
		switch (event.target.name) {
			case 'rateCardName':
				this.rateCardName = event.target.value;
				break;
			case 'effectiveDate':
				this.effectiveDate = event.target.value;
				break;
			case 'expirationDate':
				this.expirationDate = event.target.value;
				break;
			case 'duplicateStrategy':
				this.duplicateStrategy = event.target.value;
				break;
			default:
		}
	}

	handleCancel() {
		this.dispatchEvent(new CloseActionScreenEvent());
	}

	get disableButton() {
		return isEmpty(this.rateCardName);
	}

	async handleSave() {
		this.rateCardQuote = await getRateCardByQuoteId({ quoteId: this.recordId });
		log('rateCardQuote ', this.rateCardQuote);

		if (!isEmpty(this.rateCardQuote)) {
			this.showNotification(CreateRateCardFromQuoteAlreadyExisting, Error, 'error');
		} else if (isEmpty(this.accountId)) {
			this.showNotification(CreateRateCardFromQuoteAccountIdMissing, Error, 'error');
		} else {
			await this.createRateCard(this.recordId);
		}
	}

	navigateToView(recordId, objectName) {
		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: { recordId, objectApiName: objectName, actionName: 'view' },
		});
	}

	showNotification(title, message, variant) {
		const evt = new ShowToastEvent({
			title,
			message: reduceErrors(message).join(', '),
			variant,
		});

		this.dispatchEvent(evt);
	}
}
