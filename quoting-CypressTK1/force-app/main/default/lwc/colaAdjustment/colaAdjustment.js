import { api, LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import {
	calculateColaAdjustment,
	isEmpty,
	getCostsByYear,
	getYears,
	processColaRates,
} from 'c/colaSupport';

import getColaRatesForQuote from '@salesforce/apex/AdjustColaRatesController.getColaRatesForQuote';

export default class ColaAdjustment extends NavigationMixin(LightningElement) {
	@api quoteItems;
	@api periods;
	@api quoteId;

	_quoteTotals;
	_loaded = false;

	get quoteTotals() {
		if (!this._quoteTotals) {
			this._quoteTotals = this.template.querySelector('c-quote-totals');
		}

		return this._quoteTotals;
	}

	async renderedCallback() {
		if (!this._loaded) {
			this._loaded = true;
			this._colaRates = await getColaRatesForQuote({ quoteId: this.quoteId });
		}
	}

	static getAdjustmentIdx(adjustments, adjustmentMethod) {
		return adjustments ? adjustments?.findIndex((adjustment) => adjustment.method === adjustmentMethod) : -1;
	}

	static newAdjustment(currentIdx) { // TODO: move this to an adjustment service class
		return {
			adjustmentId: null,
			appliedBy: 'Manual',
			type: 'Markup Amount',
			sequence: currentIdx + 1, // zero indexed array
		};
	}

	async handleColaRateChange() {
		// re-provision data
		this._colaRates = await getColaRatesForQuote({ quoteId: this.quoteId });
		await this.saveCostAdjustment();
		await this.quoteTotals.saveTotals(true);
	}

	static addAdjustment(namedRange, method, amount) {
		const ctxNamedRange = namedRange;
		const adjustmentIdx = ColaAdjustment.getAdjustmentIdx(ctxNamedRange.adjustmentList, method);
		let adjustmentDto;
		if (adjustmentIdx < 0 && +amount > 0) {
			adjustmentDto = ColaAdjustment.newAdjustment(ctxNamedRange.adjustmentList?.length || 0);
			adjustmentDto.method = method;
			adjustmentDto.appliedTo = adjustmentDto.method === 'Cola' ? 'Cost' : 'Price'; // pass-through is an adjustment on price
			ctxNamedRange.adjustmentList = [
				...ctxNamedRange.adjustmentList || [],
				adjustmentDto,
			];
		} else {
			adjustmentDto = ctxNamedRange.adjustmentList[adjustmentIdx];
		}

		if (adjustmentDto) {
			adjustmentDto.amount = amount;
		}

		return adjustmentDto;
	}

	@api
	async saveCostAdjustment() {
		const laborTotal = await this.quoteTotals.laborTotal;
		const { cost, revenue } = this.calculateMarkups();
		ColaAdjustment.addAdjustment(laborTotal, 'Cola', +cost);
		ColaAdjustment.addAdjustment(laborTotal, 'Pass-through', +revenue);
	}

	calculateMarkups() {
		if (!this._colaRates || this._colaRates.length === 0) {
			return 0; // no rates to apply, do nothing
		}

		const { startYear, endYear } = getYears(this.periods);
		const colaRatesByLocation = processColaRates(this._colaRates, startYear);

		const costsByYear = getCostsByYear({
			startYear,
			endYear,
			quoteItems: this.quoteItems,
			periods: this.periods,
			colaRates: colaRatesByLocation,
		});

		const hasCostsByYear = !isEmpty(costsByYear);

		const totalAdjustment = {
			cost: 0,
			revenue: 0,
		};

		if (hasCostsByYear) {
			const summaryLines = calculateColaAdjustment(colaRatesByLocation, startYear, endYear, costsByYear)
				.filter((adjustment) => adjustment.isSummaryLine);

			totalAdjustment.cost = summaryLines
				.reduce((acc, nextAdjustment) => acc + nextAdjustment.costIncrease, 0);
			totalAdjustment.revenue = summaryLines
				.reduce((acc, nextAdjustment) => acc + nextAdjustment.revenueIncrease, 0);
		}

		return totalAdjustment;
	}
}
