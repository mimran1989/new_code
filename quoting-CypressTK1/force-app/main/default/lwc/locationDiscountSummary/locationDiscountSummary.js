import { LightningElement, api } from 'lwc';

import getLocationDiscountReviewForQuote from '@salesforce/apex/LocationDiscountReviewController.getLocationDiscountReviewForQuote';
import LABEL_RATE_MATCH from '@salesforce/label/c.RateMatch';
import LABEL_LOCATION from '@salesforce/label/c.Location';
import LABEL_DISCOUNT_PERCENT from '@salesforce/label/c.DiscountPercent';
import LABEL_NEW_AMOUNT from '@salesforce/label/c.NewAmount';
import LABEL_DISCOUNT_AMOUNT from '@salesforce/label/c.DiscountAmount';
import LABEL_LOCATION_AMOUNT from '@salesforce/label/c.LocationAmount';

export default class LocationDiscountSummary extends LightningElement {
	@api quoteId;

	editableFields = '';

	data;
	columns = [
		{ label: LABEL_RATE_MATCH, fieldName: 'rateMatch', type: 'text' },
		{
			label: LABEL_LOCATION,
			fieldName: 'location',
			type: 'text',
		},
		{
			label: LABEL_LOCATION_AMOUNT,
			fieldName: 'locationAmount',
			type: 'currency',
		},
		{
			label: LABEL_DISCOUNT_PERCENT,
			fieldName: 'discountPercentage',
			type: 'customPercentFixed',
			typeAttributes: { columnName: 'discountPercentage', maximumFractionDigits: 0 },
		},
		{
			label: LABEL_DISCOUNT_AMOUNT,
			fieldName: 'discountAmount',
			type: 'currency',
		},
		{
			label: LABEL_NEW_AMOUNT,
			fieldName: 'newAmount',
			type: 'currency',
		},
	];

	async connectedCallback() {
		this.data = await getLocationDiscountReviewForQuote({ quoteId: this.quoteId });
		this._datatable.initializeTable(undefined, this.columns, this.data);
	}

	renderedCallback() {
		this._datatable = this.template.querySelector('c-base-datatable');
	}
}
