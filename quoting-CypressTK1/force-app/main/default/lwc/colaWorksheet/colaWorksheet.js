import { api, LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { reduceErrors } from 'c/sparkUtils';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { ColaAdjustments } from 'c/constantUtil';

import getColaRatesForQuote from '@salesforce/apex/AdjustColaRatesController.getColaRatesForQuote';
import saveColaAdjustments from '@salesforce/apex/ColaAdjustmentController.saveColaAdjustments';
import baseJS from '@salesforce/resourceUrl/Provus';
import { loadScript } from 'lightning/platformResourceLoader';

import LABEL_ADD_HEAD_COUNT_FOR_RESOURCES from '@salesforce/label/c.AddHeadCountForResources';
import LABEL_COLA_ADJUSTMENT_WORKSHEET from '@salesforce/label/c.ColaAdjustmentWorkSheet';
import LABEL_COLA_RATE_OVERRIDE from '@salesforce/label/c.ColaRateOverride';
import LABEL_COST_INCREASE from '@salesforce/label/c.CostIncrease';
import LABEL_ERROR from '@salesforce/label/c.Error';
import LABEL_LOCATION from '@salesforce/label/c.Location';
import LABEL_NEW_COST from '@salesforce/label/c.NewCost';
import LABEL_NEW_REVENUE from '@salesforce/label/c.NewRevenue';
import LABEL_MARGIN_AFTER_COLA from '@salesforce/label/c.MarginAfterCOLA';
import LABEL_MARGIN_AFTER_PASS_THROUGH from '@salesforce/label/c.MarginAfterPassthrough';
import LABEL_RATE_MATCH from '@salesforce/label/c.RateMatch';
import LABEL_REVENUE_INCREASE from '@salesforce/label/c.RevenueIncrease';
import LABEL_SUCCESS from '@salesforce/label/c.Success';
import LABEL_SUCCESSFULLY_SAVED from '@salesforce/label/c.SuccessfullySaved';
import LABEL_YEAR from '@salesforce/label/c.Year';
import LABEL_YOY_COLA_RATE from '@salesforce/label/c.YOYCOLARate';
import LABEL_YOY_PASS_THROUGH_RATE from '@salesforce/label/c.YoyPassthroughRate';

import LABEL_PASS_THROUGH from '@salesforce/label/c.Passthrough';
import QUOTE_OBJECT from '@salesforce/schema/Quote__c';

import {
	calculateColaAdjustment,
	calculateGrandTotal,
	isEmpty,
	getCostsByYear,
	getYears,
	loadData,
	processColaRates,
} from 'c/colaSupport';

export default class ColaWorksheet extends NavigationMixin(LightningElement) {
	@api quoteItems = {};
	@api periods = [];
	@api quoteId;
	@api saveAndClose = false;

	_quoteItems = this.quoteItems;
	_periods = this.periods;

	data = [];
	startYear;
	endYear;
	costsByYear;
	colaRates;
	_adjustmentsState;
	_componentState;
	loaded = false;
	hasCostsByYear = false;

	LABEL_COLA_RATE_OVERRIDE = LABEL_COLA_RATE_OVERRIDE;
	LABEL_PASS_THROUGH = LABEL_PASS_THROUGH;

	errorMessage;

	columns = [
		{
			label: LABEL_YEAR,
			fieldName: ColaAdjustments.YEAR,
			cellAttributes: { alignment: 'right' },
			hideDefaultActions: true,
		},
		{
			label: LABEL_LOCATION,
			fieldName: ColaAdjustments.LOCATION,
			hideDefaultActions: true,
		},
		{
			label: LABEL_RATE_MATCH,
			fieldName: ColaAdjustments.RATE_MATCH,
			hideDefaultActions: true,
		},
		{
			label: LABEL_YOY_COLA_RATE,
			fieldName: ColaAdjustments.YOY_COLA_RATE_FORMATTED,
			type: 'text',
			hideDefaultActions: true,
			cellAttributes: { alignment: 'right' },
		},
		{
			label: LABEL_YOY_PASS_THROUGH_RATE,
			fieldName: 'passthroughRateFormatted',
			type: 'text',
			hideDefaultActions: true,
			cellAttributes: { alignment: 'right' },
		},
		{
			label: LABEL_COST_INCREASE,
			fieldName: ColaAdjustments.COST_INCREASE,
			type: 'currency',
			hideDefaultActions: true,
		},
		{
			label: LABEL_NEW_COST,
			fieldName: ColaAdjustments.NEW_COST,
			type: 'currency',
			hideDefaultActions: true,
		},
		{
			label: LABEL_REVENUE_INCREASE,
			fieldName: ColaAdjustments.REVENUE_INCREASE,
			type: 'currency',
			hideDefaultActions: true,
		},
		{
			label: LABEL_NEW_REVENUE,
			fieldName: ColaAdjustments.NEW_REVENUE,
			type: 'currency',
			hideDefaultActions: true,
		},
		{
			label: LABEL_MARGIN_AFTER_COLA,
			fieldName: ColaAdjustments.MARGIN_WITH_COLA,
			type: 'percent',
			typeAttributes: { step: '0.00001', minimumFractionDigits: '2' },
			hideDefaultActions: true,
		},
		{
			label: LABEL_MARGIN_AFTER_PASS_THROUGH,
			fieldName: ColaAdjustments.MARGIN_WITH_PASS_THROUGH,
			type: 'percent',
			typeAttributes: { step: '0.00001', minimumFractionDigits: '2' },
			hideDefaultActions: true,
		},
	];

	async renderedCallback() {
		if (!this.loaded) {
			this.loaded = true;
			this._componentState = this.template.querySelector('c-message-service');
			this._adjustmentsState = this.template.querySelector('.quote-adjustments');
			this._quoteTotals = this.template.querySelector('c-quote-totals');
			await loadScript(this, `${baseJS}/grid/index.js`);
			await loadScript(this, `${baseJS}/data/index.js`);
			this.refreshTable();
		}
	}

	get isLoaded() {
		return this.loaded;
	}

	setYears() {
		if (!this.startYear && !this.endYear) {
			const { startYear, endYear } = getYears(this._periods);
			this.startYear = startYear;
			this.endYear = endYear;
		}
	}

	setCostsByYear() {
		if (!this.costsByYear) {
			this.costsByYear = getCostsByYear({
				startYear: this.startYear,
				endYear: this.endYear,
				quoteItems: this._quoteItems,
				periods: this._periods,
				colaRates: this.colaRates,
			});
		}
	}

	async refreshTable() {
		const data = await loadData(this.quoteId);
		this._quoteItems = data.quoteItems;
		this._periods = data.periods;
		this.setYears();
		const colaRates = await getColaRatesForQuote({ quoteId: this.quoteId });
		this.colaRates = processColaRates(colaRates, this.startYear);
		this.setCostsByYear();

		this.hasCostsByYear = !isEmpty(this.costsByYear);

		if (this.hasCostsByYear) {
			this.data = calculateColaAdjustment(this.colaRates, this.startYear, this.endYear, this.costsByYear);
			const totals = this.data.filter((adjustment) => adjustment.isSummaryLine);
			this.data.push(calculateGrandTotal(totals));
		} else {
			this.errorMessage = LABEL_ADD_HEAD_COUNT_FOR_RESOURCES;
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

	static getColaAdjustmentIdx(adjustments) {
		return adjustments?.findIndex((adjustment) => adjustment.method === 'Cola');
	}

	static newAdjustment(currentIdx) {
		return {
			adjustmentId: null,
			appliedBy: 'Manual',
			appliedTo: 'Cost',
			method: 'Cola',
			sequence: currentIdx + 1, // zero indexed array
		};
	}

	async saveColaAdjustments() {
		try {
			const colaAdjustmentDtos = this.data.filter((row) => !!row.rateMatch).map((row) => ({
				...row,
				quoteId: this.quoteId,
			}));

			await saveColaAdjustments({ quoteId: this.quoteId, colaAdjustmentDtos });
			this._adjustmentsState.publish({
				key: 'changecolarates',
			});

			const evt = new ShowToastEvent({
				title: LABEL_SUCCESS,
				message: LABEL_SUCCESSFULLY_SAVED.replace('{0}', LABEL_COLA_ADJUSTMENT_WORKSHEET),
				variant: 'success',
			});

			this.dispatchEvent(evt);
			this.navigateToView(this.quoteId, QUOTE_OBJECT.objectApiName);
		} catch (e) {
			this.notifyError(e);
		}
	}

	notifyError(error) {
		this.showNotification(LABEL_ERROR, error.message, 'error');
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
