import { Discounting } from 'c/util';
import { Discount, RateMatch } from 'c/constantUtil';
import AdjustmentService from 'c/adjustmentService';
import getLocationDiscounts from '@salesforce/apex/LocationDiscountController.getLocationDiscounts';
import QuoteItemsDataService from 'c/quoteItemsDataService';

export default class LocationDiscountAdjustment {
	_laborAmountNamedRange;
	_quoteItemNamedRanges;

	async updateLocationDiscountAdjustments({ quoteId, locationDiscounts, namedRanges }) {
		let locationDiscountDtos = locationDiscounts;
		if (!locationDiscounts && quoteId) {
			locationDiscountDtos = await getLocationDiscounts({ quoteId });
		}

		this._laborAmountNamedRange = namedRanges.laborAmount;
		this._quoteItemNamedRanges = namedRanges.quoteItems;

		locationDiscountDtos.sort(LocationDiscountAdjustment.sortByRateMatch);
		this.removeExistingLocationDiscountAdjustments();
		this.applyLocationDiscounts(locationDiscountDtos);
	}

	applyLocationDiscounts(locationDiscountDtos) {
		if (locationDiscountDtos.length > 0) {
			this.updateAdjustments(locationDiscountDtos);
		}
	}

	removeExistingLocationDiscountAdjustments() {
		AdjustmentService.removeAdjustments([this._laborAmountNamedRange, ...Object.values(this._quoteItemNamedRanges)], 'Location Discount');
	}

	updateAdjustments(locationDiscountDtos) {
		const namedRanges = this._quoteItemNamedRanges;
		let discountAmount = 0;
		const quoteItems = QuoteItemsDataService.getAllQuoteItems();
		Object.values(quoteItems).forEach((quoteItem) => {
			const locationDiscount = LocationDiscountAdjustment.getLocationDiscount(quoteItem, locationDiscountDtos);
			const namedRange = namedRanges[quoteItem.id];
			if (locationDiscount && namedRange) {
				const ctxAdjustmentIndex = LocationDiscountAdjustment.getAdjustmentIdx(namedRange.adjustmentList);
				const isInLocation = LocationDiscountAdjustment.isInLocation(quoteItem, locationDiscount);
				if (isInLocation) {
					if (ctxAdjustmentIndex > -1) {
						const adjustment = namedRange.adjustmentList[ctxAdjustmentIndex];
						adjustment.amount = locationDiscount.amount;
						adjustment.locationDiscountId = locationDiscount.id;
						adjustment.operationType = null;
						namedRange.adjustmentList = [...namedRange.adjustmentList];
					} else {
						const ctxAdjustment = LocationDiscountAdjustment.getLocationDiscountAdjustment(namedRange, locationDiscount);
						namedRange.adjustmentList = [...namedRange.adjustmentList, ctxAdjustment];
					}

					discountAmount += (namedRange.relatedTotal.adjustedBaseAmount * (locationDiscount.amount / 100));
				}
			}
		});

		this.addAdjustmentToLaborTotal(discountAmount);
	}

	addAdjustmentToLaborTotal(discountAmount) {
		const laborTotal = this._laborAmountNamedRange;
		const adjustmentIndex = laborTotal.adjustmentList.findIndex((adjustment) => adjustment.method === 'Location Discount');
		if (discountAmount > 0) {
			const ctxAdjustment = LocationDiscountAdjustment.getLaborLocationDiscountAdjustment(laborTotal, adjustmentIndex);
			ctxAdjustment.amount = discountAmount;

			if (adjustmentIndex > -1) {
				laborTotal.adjustmentList[adjustmentIndex] = ctxAdjustment;
			} else {
				laborTotal.adjustmentList = [
					...laborTotal.adjustmentList || [],
					ctxAdjustment,
				];
			}

			laborTotal.adjustmentList = [...laborTotal.adjustmentList];
		}
	}

	static getLaborLocationDiscountAdjustment(laborTotal, adjustmentIndex) {
		let ctxAdjustment;
		if (adjustmentIndex > -1) {
			ctxAdjustment = laborTotal.adjustmentList[adjustmentIndex];
			ctxAdjustment.operationType = null;
		} else {
			ctxAdjustment = Discounting.newAdjustment({
				currentIdx: laborTotal.adjustmentList.length,
				discountAppliedTo: 'Price',
				discountAppliedBy: 'Rule',
				discountMethod: 'Location Discount',
			});
		}

		ctxAdjustment.type = Discount.DISCOUNT_AMOUNT;
		return ctxAdjustment;
	}

	static getLocationDiscountAdjustment(namedRange, locationDiscount) {
		const ctxAdjustment = Discounting.newAdjustment({
			currentIdx: namedRange.adjustmentList.length,
			discountAppliedTo: 'Price',
			discountAppliedBy: 'Rule',
			discountMethod: 'Location Discount',
		});

		ctxAdjustment.type = Discount.DISCOUNT_PERCENT;
		ctxAdjustment.amount = locationDiscount.amount;
		ctxAdjustment.locationDiscountId = locationDiscount.id;
		return ctxAdjustment;
	}

	static getLocationDiscount(quoteItem, locationDiscounts) {
		let locationDiscount;
		locationDiscounts.forEach((ctxLocationDiscount) => {
			if (LocationDiscountAdjustment.isInLocation(quoteItem, ctxLocationDiscount)) {
				locationDiscount = ctxLocationDiscount;
			}
		});
		return locationDiscount;
	}

	static isInLocation(quoteItem, locationDiscount) {
		const matchLocation = LocationDiscountAdjustment.getMatchLocation(locationDiscount);
		if (matchLocation === RateMatch.RATE_MATCH_GLOBAL) {
			return true;
		}

		const country = quoteItem.location?.country;
		const state = quoteItem.location?.state;
		const city = quoteItem.location?.city;
		const countryStateCity = [country, state, city].filter(Boolean).join('/');
		const countryCity = `${country}/${city}`;
		const countryState = `${country}/${state}`;
		let isMatch = false;
		switch (locationDiscount.rateMatch) {
			case RateMatch.RATE_MATCH_COUNTRY:
				isMatch = country === matchLocation;
				break;
			case RateMatch.RATE_MATCH_STATE:
				isMatch = countryState === matchLocation;
				break;
			case RateMatch.RATE_MATCH_CITY:
				isMatch = countryCity === matchLocation || countryStateCity === matchLocation;
				break;
			default:
				break;
		}

		return isMatch;
	}

	static getMatchLocation(locationDiscount) {
		const { country, state, city } = locationDiscount;
		let matchLocation = RateMatch.RATE_MATCH_GLOBAL;
		const countryStateCity = [country, state, city].filter(Boolean).join('/');
		const countryState = `${country}/${state}`;
		switch (locationDiscount.rateMatch) {
			case RateMatch.RATE_MATCH_COUNTRY:
				matchLocation = country;
				break;
			case RateMatch.RATE_MATCH_STATE:
				matchLocation = countryState;
				break;
			case RateMatch.RATE_MATCH_CITY:
				matchLocation = countryStateCity;
				break;
			default:
				break;
		}

		return matchLocation;
	}

	static getAdjustmentIdx(adjustments) {
		return adjustments ? adjustments?.findIndex((adjustment) => (
			adjustment.method === 'Location Discount'
		)) : -1;
	}

	static sortByRateMatch(rowA, rowB) {
		if (rowA.rateMatch === RateMatch.RATE_MATCH_GLOBAL) {
			return -1;
		}

		if (rowB.rateMatch === RateMatch.RATE_MATCH_GLOBAL) {
			return 1;
		}

		if (rowA.rateMatch === rowB.rateMatch) {
			const rowALocation = LocationDiscountAdjustment.getMatchLocation(rowA);
			const rowBLocation = LocationDiscountAdjustment.getMatchLocation(rowB);
			return rowALocation.localeCompare(rowBLocation);
		}

		return rowA.country.localeCompare(rowB.country);
	}
}
