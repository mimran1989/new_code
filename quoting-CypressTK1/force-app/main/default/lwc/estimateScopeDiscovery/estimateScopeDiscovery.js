import {
	LightningElement, wire, api, track,
} from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getScopeParameters from '@salesforce/apex/ScopeParameterController.getScopeParameters';
import saveScopeParameters from '@salesforce/apex/ScopeParameterController.saveScopeParameters';
import ESTIMATENAME_FIELD from '@salesforce/schema/Estimate__c.Name';
import LABEL_CLOSE from '@salesforce/label/c.CloseButton';
import LABEL_SCOPE_PARAMETER from '@salesforce/label/c.ScopeParameters';
import LABEL_SUCCESS_MESSAGE from '@salesforce/label/c.SuccessfullyUpdatedNotificationTitle';
import LABEL_HASHTAG from '@salesforce/label/c.Hashtag';
import LABEL_NAME from '@salesforce/label/c.Name';
import LABEL_PARAMETER from '@salesforce/label/c.ParameterName';
import LABEL_PREVIOUS from '@salesforce/label/c.Previous';
import LABEL_NEXT from '@salesforce/label/c.Next';
import LABEL_FROM_VALUE from '@salesforce/label/c.FromValue';
import LABEL_TO_VALUE from '@salesforce/label/c.ToValue';
import LABEL_GUIDANCE from '@salesforce/label/c.Guidance';

const FIELDS = [
	ESTIMATENAME_FIELD,
];

export default class EstimateScopeDiscovery extends LightningElement {
	@api recordId;
	@api closeAction; // depreciated
	@track scope = {};
	@track isInteger;
	@track isCheckBox;
	@track isIntegerTier;
	@track isPicklist;
	@track picklistValues;
	@track tiers;
	@track columns;
	@track indexPosition;
	recordName = '';
	data;
	indx = 0;
	Label = {
		CLOSE: LABEL_CLOSE,
		NAME: LABEL_NAME,
		PARAMETER: LABEL_PARAMETER,
		HASHTAG: LABEL_HASHTAG,
		PREVIOUS: LABEL_PREVIOUS,
		NEXT: LABEL_NEXT,
		GUIDANCE: LABEL_GUIDANCE,
	}

	dataType = {
		integer: 'Integer',
		checkbox: 'Checkbox',
		integerTiers: 'Integer Tiers',
		picklist: 'Picklist',
	};

	_messageService;

	@wire(getRecord, { recordId: '$recordId', fields: FIELDS })
	getResult(result) {
		const { data } = result;
		if (data) {
			this.recordName = data.fields.Name.value;
		}
	}

	async renderedCallback() {
		if (!this.rendered && this.recordId) {
			this._messageService = this.template.querySelector('c-message-service');
			await this.loadData();
			this.setScopeValue();
			this.rendered = true;
		}
	}

	get getTitle() {
		return `${this.scope.title} - ${LABEL_SCOPE_PARAMETER}`;
	}

	async loadData() {
		this.data = await getScopeParameters({ estimateId: this.recordId });
	}

	handleChange(event) {
		this.scope.value[event.target.name] = event.target.value;
	}

	@api
	eventFooter(buttons) {
		[this.previousButton, this.nextButton] = buttons;
		this.setDisabled();
	}

	@api
	handleNext() {
		this.indx += 1;
		this.setScopeValue();
	}

	@api
	handlePrevious() {
		this.indx -= 1;
		this.setScopeValue();
	}

	setDisabled() {
		const isPreviousDisabled = !(this.indx > 0 && this.data?.length);
		const isNextDisabled = !((this.indx + 1) < (this.data?.length || 0));
		this.previousButton.set('v.disabled', isPreviousDisabled);
		this.nextButton.set('v.disabled', isNextDisabled);
	}

	setScopeValue() {
		this.scope = this.data[this.indx];
		this.indexPosition = `${this.indx + 1} / ${this.data.length}`;
		this.isInteger = this.scope.dataType === this.dataType.integer;
		this.isCheckBox = this.scope.dataType === this.dataType.checkbox;
		this.isIntegerTier = this.scope.dataType === this.dataType.integerTiers;
		this.isPicklist = this.scope.dataType === this.dataType.picklist;

		if (this.isPicklist) {
			this.picklistValues = [];
			this.scope.templateValues.forEach((e) => {
				this.picklistValues.push({ label: e.label, value: e.label });
			});
		}

		if (this.isIntegerTier) {
			this.tiers = this.scope.templateValues;
			this.columns = [
				{ label: LABEL_FROM_VALUE, fieldName: 'fromValue', type: 'text' },
				{ label: LABEL_TO_VALUE, fieldName: 'toValue', type: 'text' },
			];
		}

		this.setDisabled();
	}

	@api
	async save() {
		const records = [];
		const messageResponse = [];
		this.data.forEach((ele) => {
			records.push(ele.value);

			if (ele.dataType === this.dataType.integer) {
				messageResponse.push({
					hashtag: ele.hashtag,
					value: +ele.value.integerValue,
				});
			}
		});

		await saveScopeParameters({ scopeParameters: records });
		this.showNotification(LABEL_SUCCESS_MESSAGE, LABEL_SCOPE_PARAMETER, 'success');
		this._messageService.publish({ key: 'aftersavescopeparams', value: messageResponse });
		this._messageService.notifyClose();
	}

	showNotification(title, message, variant) {
		const evt = new ShowToastEvent({
			title,
			message,
			variant,
		});

		this.dispatchEvent(evt);
	}
}
