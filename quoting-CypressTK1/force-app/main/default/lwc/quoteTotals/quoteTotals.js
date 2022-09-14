import getNamedRangesForQuote from '@salesforce/apex/NamedRangeService.getNamedRangesForQuote';
import LABEL_ERROR from '@salesforce/label/c.Error';
import baseJS from '@salesforce/resourceUrl/Provus';
import { reduceErrors } from 'c/baseUtils';
import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { api, LightningElement } from 'lwc';
import { sfdcNumberToNumber } from 'c/currencyUtil';
import enablePricingBetaPermission from '@salesforce/customPermission/EnablePricingBeta';
import {
	recalculateTotals,
	updateRelatedTotal,
	applyColaAdjustments,
	applyPassthroughAdjustments,
} from './quoteTotalsSupport';
import NamedRangesCache from './namedRangesCache';

const _loadingPromise = {};
const quoteLocationByPeriodTallies = {};

export default class QuoteTotals extends LightningElement {
	@api quoteId;

	get quoteService() {
		if (!this._quoteService) {
			this._quoteService = this.template.querySelector('c-quote-service');
		}

		return this._quoteService;
	}

	// locker data service removes the outside proxy belonging to the
	// named range. So although we do not have a true need to promisify
	// these getters, we do this as a hack to get around the LDS
	@api
	get quoteTotal() {
		return _loadingPromise[this.quoteId]
			.then(() => NamedRangesCache.getQuoteTotal(this.quoteId));
	}
	@api
	get laborTotal() {
		return _loadingPromise[this.quoteId]
			.then(() => NamedRangesCache.getLaborTotal(this.quoteId));
	}
	@api
	get unbilledLaborTotal() {
		return _loadingPromise[this.quoteId]
			.then(() => NamedRangesCache.getUnbilledLaborTotal(this.quoteId));
	}
	@api
	get addOnTotal() {
		return _loadingPromise[this.quoteId]
			.then(() => NamedRangesCache.getAddOnTotal(this.quoteId));
	}
	@api
	get unbilledAddOnTotal() {
		return _loadingPromise[this.quoteId]
			.then(() => NamedRangesCache.getUnbilledAddOnTotal(this.quoteId));
	}
	@api
	get periodTotals() {
		return _loadingPromise[this.quoteId]
			.then(() => NamedRangesCache.getPeriodTotals(this.quoteId));
	}
	@api
	get itemPeriodGroupTotals() {
		return _loadingPromise[this.quoteId]
			.then(() => NamedRangesCache.getItemPeriodGroupTotals(this.quoteId));
	}
	@api
	get quotePeriodGroupTotals() {
		return _loadingPromise[this.quoteId]
			.then(() => NamedRangesCache.getQuotePeriodGroupTotals(this.quoteId));
	}

	@api
	quoteItemTotal(quoteItemId) {
		return _loadingPromise[this.quoteId]
			.then(() => NamedRangesCache.getQuoteItemTotal(this.quoteId, quoteItemId));
	}

	@api
	quoteItemTotals() {
		return _loadingPromise[this.quoteId]
			.then(() => NamedRangesCache.getQuoteItemTotals(this.quoteId));
	}

	@api
	periodTotal(quotePeriodId) {
		return _loadingPromise[this.quoteId]
			.then(() => NamedRangesCache.getPeriodTotal(this.quoteId, quotePeriodId));
	}

	@api
	itemPeriodGroupTotal(quotePeriodGroupId, quoteItemId) {
		return _loadingPromise[this.quoteId]
			.then(() => NamedRangesCache.getItemPeriodGroupTotal(this.quoteId, quotePeriodGroupId, quoteItemId));
	}

	@api
	quotePeriodGroupTotal(quotePeriodGroupId) {
		return _loadingPromise[this.quoteId]
			.then(() => NamedRangesCache.getQuotePeriodGroupTotal(this.quoteId, quotePeriodGroupId));
	}

	@api
	getQuoteItemTotal(quoteItemId) {
		return _loadingPromise[this.quoteId]
			.then(() => NamedRangesCache.getQuoteItemTotal(this.quoteId, quoteItemId));
	}

	/**
	 * Update tally value for location/period column
	 * @param quoteId quote id
	 * @param location current quote item location
	 * @param revenueAmount period revenue amount
	 * @param periodIndex
	 * @param groupIndex
	 * @returns {QuoteTotals}
	 */
	@api
	updateQuoteTotals({
		quoteId,
		location,
		revenueAmount,
		periodIndex,
		groupIndex,
	}) {
		if (!enablePricingBetaPermission) {
			return this;
		}

		const quoteTallies = quoteLocationByPeriodTallies[quoteId];
		const { locationByPeriodTallies } = quoteTallies;
		let periodLocationKey;
		if (periodIndex) {
			const { country, state, city } = location;
			const compositeLocation = [country, state, city].filter(Boolean).join('/');
			const locationKey = QuoteTotals.updateLocationEntry(quoteId, compositeLocation);
			periodLocationKey = `Period${periodIndex}${locationKey}`;
		} else if (groupIndex) {
			const locationPeriodKeys = QuoteTotals.generateLocationKeys(quoteId, location);
			const lastKeyIndex = locationPeriodKeys.length - 1;
			// roll up revenue amount to state/country level respectively
			for (let i = lastKeyIndex; i >= 0; i--) {
				const locationKey = locationPeriodKeys[i];
				locationByPeriodTallies[locationKey] = QuoteTotals.currentValueForKey(locationByPeriodTallies, locationKey) + revenueAmount;
			}

			periodLocationKey = `Group${groupIndex}${locationPeriodKeys[lastKeyIndex]}`;
		}

		locationByPeriodTallies[periodLocationKey] = QuoteTotals.currentValueForKey(locationByPeriodTallies, periodLocationKey) + revenueAmount;

		return this;
	}

	/**
	 * Gets value if exists for specified key, if does not exist returns zero
	 *
	 * @param locationByPeriodTallies
	 * @param tallyKey
	 * @returns {number|*}
	 */
	static currentValueForKey(locationByPeriodTallies, tallyKey) {
		if (locationByPeriodTallies[tallyKey]) {
			return locationByPeriodTallies[tallyKey];
		}

		return 0;
	}

	/**
	 * Generate list of location keys which are representative of real geographical locations
	 * @param quoteId
	 * @param location
	 * @returns {*[]}
	 */
	static generateLocationKeys(quoteId, location) {
		const { country, state, city } = location;
		let compositeLocation;
		const locationKeys = [];
		if (country) {
			compositeLocation = country;
			const locationKey = QuoteTotals.updateLocationEntry(quoteId, compositeLocation);
			locationKeys.push(locationKey);
		}

		if (state) {
			compositeLocation = [country, state].join('/');
			const locationKey = QuoteTotals.updateLocationEntry(quoteId, compositeLocation);
			locationKeys.push(locationKey);
		}

		if (city) {
			compositeLocation = [country, state, city].join('/');
			const locationKey = QuoteTotals.updateLocationEntry(quoteId, compositeLocation);
			locationKeys.push(locationKey);
		}

		return locationKeys;
	}

	/**
	 * locations are keyed to the letter L + an index number I.E. 'L5'
	 *
	 * @param quoteId
	 * @param locationName full name of location
	 * @returns {string} location key
	 */
	static updateLocationEntry(quoteId, locationName) {
		const quoteTallies = quoteLocationByPeriodTallies[quoteId];
		const newLocationKey = `L${quoteTallies.locationCount}`;
		if (!quoteTallies.locationKeys[locationName]) {
			quoteTallies.locationKeys[locationName] = newLocationKey;
			quoteTallies.locationByKey[newLocationKey] = locationName;
			quoteTallies.locationCount += 1;
		}

		return newLocationKey;
	}

	@api
	/* eslint-disable class-methods-use-this */
	getQuoteTotals(quoteId) {
		return quoteLocationByPeriodTallies[quoteId];
	}

	@api
	resetQuoteTotals(quoteId) {
		quoteLocationByPeriodTallies[quoteId] = {
			locationByPeriodTallies: {},
			locationKeys: {},
			locationByKey: {},
			locationCount: 1,
		};
	}

	get _quoteTotal() {
		return NamedRangesCache.getQuoteTotal(this.quoteId);
	}
	get _laborTotal() {
		return NamedRangesCache.getLaborTotal(this.quoteId);
	}
	get _addOnTotal() {
		return NamedRangesCache.getAddOnTotal(this.quoteId);
	}

	async renderedCallback() {
		const loadScriptPromise = loadScript(this, `${baseJS}/data/index.js`);
		if (!_loadingPromise[this.quoteId]) {
			if (NamedRangesCache.getIsStale(this.quoteId)) { // re-provision quote named ranges
				_loadingPromise[this.quoteId] = loadScriptPromise.then(() => this.loadNamedRanges());
			}
		}

		await loadScriptPromise;
	}

	async loadNamedRanges() {
		const namedRangeDtos = await getNamedRangesForQuote({ quoteId: this.quoteId });
		const namedRanges = namedRangeDtos.map((namedRangeDto) => Provus.NamedRange.for(Provus.NamedRange.newDO(namedRangeDto)));
		for (let i = 0; i < namedRanges.length; i++) {
			const namedRange = namedRanges[i];
			namedRange.elementDO.relatedTotal.totalQuantity = sfdcNumberToNumber(namedRange.elementDO.relatedTotal.totalQuantity);
			namedRange.elementDO.relatedTotal.baseExtendedAmount = sfdcNumberToNumber(namedRange.elementDO.relatedTotal.baseExtendedAmount);
			namedRange.elementDO.relatedTotal.adjustedBaseAmount = sfdcNumberToNumber(namedRange.elementDO.relatedTotal.adjustedBaseAmount);
			namedRange.elementDO.relatedTotal.netExtendedAmount = sfdcNumberToNumber(namedRange.elementDO.relatedTotal.netExtendedAmount);
			namedRange.elementDO.relatedTotal.baseExtendedCost = sfdcNumberToNumber(namedRange.elementDO.relatedTotal.baseExtendedCost);
			namedRange.elementDO.relatedTotal.netExtendedCost = sfdcNumberToNumber(namedRange.elementDO.relatedTotal.netExtendedCost);
		}

		NamedRangesCache.setData(this.quoteId, namedRanges);
	}

	// eslint-disable-next-line class-methods-use-this
	@api async getNamedRangesForQuote() {
		await _loadingPromise[this.quoteId];
		return NamedRangesCache.getNamedRanges(this.quoteId);
	}

	@api async newNamedRange(initialProperties) {
		const namedRange = QuoteTotals.newNamedRangeDto(initialProperties);
		NamedRangesCache.addNamedRange(this.quoteId, namedRange[0].namedRange);
		return namedRange;
	}

	@api async newNamedRangeForUnbilledLabor() {
		const newNamedRange = QuoteTotals.newNamedRangeDto({
			quoteId: this.quoteId,
			name: 'Labor Amount (Non-billable)',
			type: 'Quote Labor (Non-billable)',
		});

		NamedRangesCache.addUnbilledLaborNamedRange(this.quoteId, newNamedRange[0].namedRange);
		return newNamedRange;
	}

	@api async newNamedRangeForQuotePeriodGroup(quotePeriodGroupId) {
		const newNamedRange = QuoteTotals.newNamedRangeDto({
			quoteId: this.quoteId,
			quotePeriodGroupId,
			type: 'Quote Period Group',
		});

		NamedRangesCache.addQuotePeriodGroupNamedRange(this.quoteId, quotePeriodGroupId, newNamedRange[0].namedRange);
		return newNamedRange;
	}

	@api async newNamedRangeForUnbilledAddOns() {
		const newNamedRange = QuoteTotals.newNamedRangeDto({
			quoteId: this.quoteId,
			name: 'Add-Ons Amount (Non-billable)',
			type: 'Quote Ancillaries (Non-billable)',
		});

		NamedRangesCache.addUnbilledAddOnNamedRange(this.quoteId, newNamedRange[0].namedRange);
		return newNamedRange;
	}
	@api async newNamedRangeForPeriod(period) {
		const newNamedRange = QuoteTotals.newNamedRangeDto({
			quoteId: this.quoteId,
			quotePeriodId: period.id,
			periodGroupId: period.periodGroupId,
			type: 'Quote Period',
		});

		NamedRangesCache.addPeriodNamedRange(this.quoteId, period, newNamedRange[0].namedRange);
		return newNamedRange;
	}
	@api async newNamedRangeForQuoteItem(quoteItemId) {
		const newNamedRange = QuoteTotals.newNamedRangeDto({
			quoteId: this.quoteId,
			quoteItemId,
			type: 'Quote Item',
		});

		NamedRangesCache.addQuoteItemNamedRange(this.quoteId, newNamedRange[0].namedRange);
		return newNamedRange;
	}

	@api async newNamedRangeForItemPeriodGroup(quotePeriodGroupId, quoteItemId) {
		const newNamedRange = QuoteTotals.newNamedRangeDto({
			quoteId: this.quoteId,
			quotePeriodGroupId,
			quoteItemId,
			type: 'Quote Item Period Group',
		});

		NamedRangesCache.addItemPeriodGroupNamedRange(this.quoteId, quotePeriodGroupId, quoteItemId, newNamedRange[0].namedRange);
		return newNamedRange;
	}

	static newNamedRangeDto(initialProperties) {
		const namedRange = Provus.NamedRange.for(Provus.NamedRange.newDO(initialProperties));
		namedRange.insert();
		return [{ namedRange }];
	}

	@api async saveTotals(recalculateQuoteTotals) {
		// TODO: remove passed param, temporary hack to turn off quote when unrelated named range is saved
		await _loadingPromise[this.quoteId];

		if (enablePricingBetaPermission) {
			// uses new beta save totals
			await this.betaSaveTotals(recalculateQuoteTotals);
		} else {
			// original save totals without modifications
			await this.calculateTotals(recalculateQuoteTotals);
		}

		await this.quoteService.saveNamedRanges();
	}

	async calculateTotals(recalculateQuoteTotals) {
		NamedRangesCache.getNamedRanges(this.quoteId).forEach((namedRangeDto) => {
			const isQuoteTotal = namedRangeDto.type === 'Quote Labor'
				|| namedRangeDto.type === 'Quote Ancillaries'
				|| namedRangeDto.type === 'Quote';

			if (!isQuoteTotal) {
				recalculateTotals(namedRangeDto);
			}
		});

		this._laborTotal.relatedTotal = this.rollupLaborTotals();

		if (recalculateQuoteTotals) {
			recalculateTotals(this._laborTotal);
			recalculateTotals(this._addOnTotal);
			this.recalculateQuoteTotal();
		}
	}

	async betaSaveTotals(recalculateQuoteTotals) {
		NamedRangesCache.getNamedRanges(this.quoteId).forEach((namedRangeDto) => {
			const isQuoteTotal = namedRangeDto.type === 'Quote Labor'
				|| namedRangeDto.type === 'Quote Ancillaries'
				|| namedRangeDto.type === 'Quote';

			if (!isQuoteTotal) {
				updateRelatedTotal(namedRangeDto);
			}
		});

		this._laborTotal.relatedTotal = this.rollupLaborTotals();
		this._laborTotal.netExtendedCost = applyColaAdjustments(this._laborTotal.relatedTotal, this._laborTotal.adjustmentList);
		this._laborTotal.netExtendedAmount = applyPassthroughAdjustments(this._laborTotal.relatedTotal, this._laborTotal.adjustmentList);

		if (recalculateQuoteTotals) {
			updateRelatedTotal(this._laborTotal);
			updateRelatedTotal(this._addOnTotal);

			this.recalculateQuoteTotal();
		}
	}

	@api deleteQuoteItemNamedRange(quoteItemId) {
		NamedRangesCache.deleteQuoteItemNamedRange(this.quoteId, quoteItemId);
	}

	rollupLaborTotals() {
		const quotePeriodGroupNamedRanges = NamedRangesCache.getQuotePeriodGroupTotals(this.quoteId);
		let laborTotal = QuoteTotals.getNewRelatedTotal();
		for (let i = 0; i < quotePeriodGroupNamedRanges.length; i++) {
			const quotePeriodGroupNamedRange = quotePeriodGroupNamedRanges[i];
			const quotePeriodGroupPeriodsNamedRanges = NamedRangesCache.getPeriodsByPeriodGroup(quotePeriodGroupNamedRange.quotePeriodGroupId);
			if (quotePeriodGroupPeriodsNamedRanges) {
				// rollup period totals to period group totals
				const periodsTotalTally = QuoteTotals.rollupNamedRangeTotals(quotePeriodGroupPeriodsNamedRanges);
				quotePeriodGroupNamedRange.relatedTotal = Object.assign(
					JSON.parse(JSON.stringify(quotePeriodGroupNamedRange.relatedTotal)),
					periodsTotalTally,
				);

				if (enablePricingBetaPermission) {
					updateRelatedTotal(quotePeriodGroupNamedRange);
				} else {
					recalculateTotals(quotePeriodGroupNamedRange);
				}
			}

			// tally period group related total values
			laborTotal = QuoteTotals.sumRelatedTotals(laborTotal, quotePeriodGroupNamedRange.relatedTotal);
		}

		return Object.assign(JSON.parse(JSON.stringify(this._laborTotal.relatedTotal)), laborTotal);
	}

	static getNewRelatedTotal() {
		return {
			adjustedBaseAmount: 0,
			netExtendedAmount: 0,
			netExtendedCost: 0,
			baseExtendedAmount: 0,
			baseExtendedCost: 0,
		};
	}

	static rollupNamedRangeTotals(namedRanges) {
		let relatedTotals = QuoteTotals.getNewRelatedTotal();
		for (let i = 0; i < namedRanges.length; i++) {
			const namedRangeDto = namedRanges[i];
			if (enablePricingBetaPermission) {
				updateRelatedTotal(namedRangeDto);
			} else {
				recalculateTotals(namedRangeDto);
			}

			relatedTotals = QuoteTotals.sumRelatedTotals(relatedTotals, namedRangeDto.relatedTotal);
		}

		return relatedTotals;
	}

	static sumRelatedTotals(accumulatedRelatedTotal, relatedTotal) {
		return {
			adjustedBaseAmount: accumulatedRelatedTotal.adjustedBaseAmount + relatedTotal.netExtendedAmount,
			netExtendedAmount: accumulatedRelatedTotal.netExtendedAmount + relatedTotal.netExtendedAmount,
			netExtendedCost: accumulatedRelatedTotal.netExtendedCost + relatedTotal.netExtendedCost,
			baseExtendedAmount: accumulatedRelatedTotal.baseExtendedAmount + relatedTotal.baseExtendedAmount,
			baseExtendedCost: accumulatedRelatedTotal.baseExtendedCost + relatedTotal.baseExtendedCost,
		};
	}

	recalculateQuoteTotal() {
		// the total can have a bottom line discount, so its base price is the sum of the net price of its components
		const laborTotal = this._laborTotal.relatedTotal;
		const addOnTotal = this._addOnTotal.relatedTotal;

		this._quoteTotal.relatedTotal.baseExtendedAmount = laborTotal.baseExtendedAmount + addOnTotal.baseExtendedAmount;
		this._quoteTotal.relatedTotal.adjustedBaseAmount = laborTotal.netExtendedAmount + addOnTotal.netExtendedAmount;
		this._quoteTotal.relatedTotal.baseExtendedCost = laborTotal.netExtendedCost + addOnTotal.netExtendedCost;

		if (enablePricingBetaPermission) {
			this._quoteTotal.relatedTotal.netExtendedAmount = laborTotal.netExtendedAmount + addOnTotal.netExtendedAmount;
			updateRelatedTotal(this._quoteTotal);
		} else {
			recalculateTotals(this._quoteTotal);
		}

		return this._quoteTotal;
	}

	notifyError(error) {
		this.showNotification(LABEL_ERROR, error, 'error');
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
