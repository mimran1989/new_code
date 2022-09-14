/**
 *  Provus Services Quoting
 *  quoteVolumeDiscount
 *  @2022 Provus Inc. All rights reserved.
 */
import {
	LightningElement,
	api,
	wire,
	track,
} from 'lwc';
import LaborRevenueVolumeDiscount from '@salesforce/customPermission/LaborRevenueVolumeDiscount';
import { getObjectInfos, getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import QUOTE_VOLUME_DISCOUNT_OBJECT from '@salesforce/schema/VolumeDiscount__c';
import QUOTE_VOLUME_DISCOUNT_TIER_OBJECT from '@salesforce/schema/VolumeDiscountTier__c';

import QVDB_FIELD_CATEGORY from '@salesforce/schema/VolumeDiscount__c.Category__c';
import QVDB_FIELD_TOTAL_BY from '@salesforce/schema/VolumeDiscount__c.TotalBy__c';
import QVDT_FIELD_FROM from '@salesforce/schema/VolumeDiscountTier__c.From__c';
import QVDT_FIELD_TO from '@salesforce/schema/VolumeDiscountTier__c.To__c';
import QVDT_FIELD_DISCOUNT from '@salesforce/schema/VolumeDiscountTier__c.Discount__c';
import ProvusMessagingService from 'c/provusMessagingService';
import saveVolumeDiscounts from '@salesforce/apex/VolumeDiscountController.saveVolumeDiscounts';
import getVolumeDiscounts from '@salesforce/apex/VolumeDiscountController.getVolumeDiscounts';
import { VolumeDiscountCategories } from 'c/constantUtil';
import { loadStyle } from 'lightning/platformResourceLoader';
import ProvusStyles from '@salesforce/resourceUrl/ProvusStyles';
import VolumeDiscountVm from './volumeDiscountVm';

const MASTER_RECORD_TYPE_ID = '012000000000000AAA';

const CATEGORY_VALUES = [
	VolumeDiscountCategories.Headcount,
	VolumeDiscountCategories.LaborRevenue,
];

// remove labor revenue entry if feature not turned on
if (!LaborRevenueVolumeDiscount) {
	CATEGORY_VALUES.pop();
}

export default class QuoteVolumeDiscount extends LightningElement {
	@api quoteId;
	volumeDiscountDtosForDeletion = [];
	/**
	 * volume discount view model object
	 * @type {VolumeDiscountVm}
	 */
	@track volumeDiscountVm = {
		tiers: [],
	};
	@track firstVolumeDiscountTiers = [];
	// track changes to custom labels object since some labels are added dynamically
	@track labels = {};
	@track categoryOptions = {};
	@track totalByOptions = {};
	provusMessagingService = new ProvusMessagingService(this);
	rendered = false;

	loadVolumeDiscountDtos(volumeDiscountDtos) {
		if (volumeDiscountDtos.length > 0) {
			const [firstVolumeDiscountDto] = volumeDiscountDtos;
			if (firstVolumeDiscountDto) {
				this.volumeDiscountVm = new VolumeDiscountVm({
					dto: firstVolumeDiscountDto,
				});

				this.volumeDiscountVm.category = firstVolumeDiscountDto.category;
			}
		}

		// delete all other DTOs since we now only allow user to have one volume discount at a time # PSQ-5195
		for (let index = 1; index < volumeDiscountDtos.length; index++) {
			const volumeDiscountDtoForDeletion = volumeDiscountDtos[index];
			volumeDiscountDtoForDeletion.operationType = 'delete';
			this.volumeDiscountDtosForDeletion.push(volumeDiscountDtoForDeletion);
		}
	}

	async renderedCallback() {
		if (!this.rendered) {
			await loadStyle(this, `${ProvusStyles}/provusRadioGroup.css`);
			this.rendered = true;
		}
	}

	@wire(getPicklistValuesByRecordType, {
		objectApiName: QUOTE_VOLUME_DISCOUNT_OBJECT,
		recordTypeId: MASTER_RECORD_TYPE_ID,
	})
	async wirePicklistFieldsValues({ data, errors }) {
		if (errors) {
			this.provusMessagingService.handleWireError(errors);
			return;
		}

		if (data) {
			// create default volume discount and add
			const { picklistFieldValues } = data;
			this.totalByOptions = picklistFieldValues[QVDB_FIELD_TOTAL_BY.fieldApiName].values;
			this.categoryOptions = picklistFieldValues[QVDB_FIELD_CATEGORY.fieldApiName].values;

			const resultingVolumeDiscountDtos = await getVolumeDiscounts({ quoteId: this.quoteId });

			this.loadVolumeDiscountDtos(resultingVolumeDiscountDtos);

			if (!Array.isArray(resultingVolumeDiscountDtos) || resultingVolumeDiscountDtos.length === 0) {
				this.volumeDiscountVm = new VolumeDiscountVm({
					quoteId: this.quoteId,
				});
			}

			this.labels.SelectDiscountMetric = this.volumeDiscountVm.labels.SelectDiscountMetric;
			this.labels.SelectAggregatedBy = this.volumeDiscountVm.labels.SelectAggregatedBy;
		}
	}

	@wire(getObjectInfos, { objectApiNames: [QUOTE_VOLUME_DISCOUNT_TIER_OBJECT] })
	quoteVolumeDiscountInfo({ data, error }) {
		if (error) {
			this.provusMessagingService.handleWireError(error);
			return;
		}

		if (data) {
			const hasErrors = this.provusMessagingService.handleObjectInfoResultErrors(data.results);
			if (hasErrors) {
				return;
			}

			const volumeDiscountTierObjInfo = data.results[0].result;

			this.labels.From = volumeDiscountTierObjInfo.fields[QVDT_FIELD_FROM.fieldApiName].label;
			this.labels.To = volumeDiscountTierObjInfo.fields[QVDT_FIELD_TO.fieldApiName].label;
			this.labels.Discount = volumeDiscountTierObjInfo.fields[QVDT_FIELD_DISCOUNT.fieldApiName].label;
		}
	}

	get categoryOptionValue() {
		return this.volumeDiscountVm?.category;
	}

	get totalByValue() {
		return this.volumeDiscountVm?.totalBy;
	}

	handleCategoryChange(event) {
		// update instance reference to new instance to trigger LWC rerender
		this.volumeDiscountVm = new VolumeDiscountVm({ viewModel: this.volumeDiscountVm });
		this.volumeDiscountVm.category = event.target.value;
	}

	/**
	 * Locate associated volumeDiscount record and update total by value on view model when user changes Total by
	 * picklist value
	 *
	 * @param event LWC event object from lightning-combobox
	 */
	handleTotalByChange = (event) => {
		const { value } = event.target;
		this.volumeDiscountVm.totalBy = value;
	}

	handleFromChange(event) {
		const tierFieldEventDetail = this.getTierFieldEventDetails(event);
		tierFieldEventDetail.selectedTier.from = tierFieldEventDetail.value;
	}

	handleToChange(event) {
		const tierFieldEventDetail = this.getTierFieldEventDetails(event);
		tierFieldEventDetail.selectedTier.to = tierFieldEventDetail.value;
	}

	handleDiscountChange(event) {
		const tierFieldEventDetail = this.getTierFieldEventDetails(event);
		tierFieldEventDetail.selectedTier.discount = tierFieldEventDetail.value;
	}

	getTierFieldEventDetails(event) {
		const { value } = event.target;
		const tierId = event.target.dataset.index;
		const selectedTier = this.volumeDiscountVm.tiers.find((tier) => tier.id === tierId);

		return {
			value,
			selectedTier,
		};
	}

	@api validate() {
		const results = [];
		const validationResults = this.volumeDiscountVm.validate();
		if (validationResults.length > 0) {
			results.push(...validationResults);
		}

		return results;
	}

	@api async saveVolumeDiscountDtos() {
		const volumeDiscountDtos = [];
		if (this.volumeDiscountDtosForDeletion) {
			this.volumeDiscountDtosForDeletion.forEach((volumeDiscount) => {
				volumeDiscountDtos.push(volumeDiscount);
			});
		}

		volumeDiscountDtos.push(this.volumeDiscountVm.getDto());

		const resultingVolumeDiscountDtos = await saveVolumeDiscounts({
			volumeDiscountDtos,
		});

		this.loadVolumeDiscountDtos(resultingVolumeDiscountDtos);
		return resultingVolumeDiscountDtos;
	}
}
