import { LightningElement, track, api } from 'lwc';
import { formatLabel } from 'c/util';

import LABEL_CANCEL from '@salesforce/label/c.CancelButton';
import LABEL_ERROR_NEGATIVE_VALUE from '@salesforce/label/c.ErrorNegativeValue';
import LABEL_HOURS_PER_OCCURRENCE from '@salesforce/label/c.HoursPerOccurrence';
import LABEL_HOW_MANY_TIMES from '@salesforce/label/c.HowManyTimesPerPeriod';
import LABEL_MAX_NUMBER_OF_OCCURRENCE from '@salesforce/label/c.MaxNumberOfOccurrences';
import LABEL_OCCURS_HOW_OFTEN from '@salesforce/label/c.OccursHowOften';
import LABEL_SAVE from '@salesforce/label/c.SaveButton';

export default class RecurringResourceDialog extends LightningElement {
	@api showCloseButton;
	@api recurringHoursTimePeriod;
	@api quoteTimePeriod; // DEPRECATED

	hoursPerOccurrence;
	occurrence;
	maxOccurrences;
	timePeriod;

	@track labels = {
		LABEL_CANCEL,
		LABEL_ERROR_NEGATIVE_VALUE,
		LABEL_HOURS_PER_OCCURRENCE,
		LABEL_HOW_MANY_TIMES,
		LABEL_MAX_NUMBER_OF_OCCURRENCE,
		LABEL_OCCURS_HOW_OFTEN,
		LABEL_SAVE,
	};

	renderedCallback() {
		this._messageService = this.template.querySelector('c-message-service');
		const timePeriod = this.recurringHoursTimePeriod.toLowerCase().slice(0, -1); // Converts time period label to singular form
		this.labels.LABEL_HOW_MANY_TIMES = formatLabel(LABEL_HOW_MANY_TIMES, [timePeriod]);
	}

	handleUpdateHoursPerOccurrence(event) {
		this.hoursPerOccurrence = event.detail.value;
	}

	handleUpdateOccurrence(event) {
		this.occurrence = event.detail.value;
	}

	handleUpdateMaxOccurrence(event) {
		this.maxOccurrences = event.detail.value;
	}

	handleSave() {
		const allValid = [...this.template.querySelectorAll('lightning-input, lightning-combobox')]
			.reduce((validSoFar, inputCmp) => {
				inputCmp.reportValidity();
				return validSoFar && inputCmp.checkValidity();
			}, true);

		if (!allValid) {
			return;
		}

		const recurringInfo = {
			hoursPerOccurrence: Number(this.hoursPerOccurrence) || 0,
			occurrence: Number(this.occurrence) || 0,
			maxOccurrences: Number(this.maxOccurrences) || 0,
		};

		this._messageService.publish({ key: 'recurringhours', value: recurringInfo });
		this._messageService.notifyClose();
	}

	handleCancel() {
		this._messageService.notifyClose();
	}
}
