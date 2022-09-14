/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

import { RateMatch, ColaAdjustments } from 'c/constantUtil';
import { getYearFromDate, marginPercentage } from 'c/util';

import LABEL_GRAND_TOTAL from '@salesforce/label/c.GrandTotal';
import LABEL_TOTAL_ADJUSTMENT from '@salesforce/label/c.TotalAdjustment';

import getQuoteTemplate from '@salesforce/apex/QuoteConfiguratorController.getQuoteTemplate';
import getQuoteItemsForQuote from '@salesforce/apex/QuoteConfiguratorController.getQuoteItemsForQuote';
import QUOTE_ITEM_ADJUSTED_UNIT_PRICE_FIELD from '@salesforce/schema/QuoteItem__c.AdjustedUnitPrice__c';
import QUOTE_ITEM_UNIT_COST_FIELD from '@salesforce/schema/QuoteItem__c.UnitCost__c';

const isEmpty = (costsByYear) => {
	let result = true;
	const years = Object.keys(costsByYear);
	for (let i = 0; i < years.length; i++) {
		const year = years[i];
		const costByYear = costsByYear[year];
		const originalCost = costByYear[ColaAdjustments.ORIGINAL_COST];
		const currentCost = costByYear[ColaAdjustments.CURRENT_COST];
		if (Object.keys(costByYear).length > 0 && (originalCost !== 0 || currentCost !== 0)) {
			result = false;
			break;
		}
	}

	return result;
};

const loadData = async(quoteId) => {
	const quoteItems = {};

	const [quote, items] = await Promise.all([
		getQuoteTemplate({ quoteId }),
		getQuoteItemsForQuote({ quoteId }),
	]);

	const { quotePeriodList: periods } = quote;

	Provus.QuoteItems.for(JSON.parse(items))
		.filter((item) => item.isMiscellaneous !== true)
		.forEach((item) => {
			quoteItems[item.$id] = item;
		});

	return { quoteItems, periods };
};

const calculateTotalForYear = (data, year) => {
	const total = {
		[ColaAdjustments.CURRENT_REVENUE]: 0,
		[ColaAdjustments.COST_INCREASE]: 0,
		[ColaAdjustments.NEW_COST]: 0,
		[ColaAdjustments.REVENUE_INCREASE]: 0,
		[ColaAdjustments.NEW_REVENUE]: 0,
		[ColaAdjustments.LOCATION]: LABEL_TOTAL_ADJUSTMENT,
		[ColaAdjustments.YEAR]: year,
		isSummaryLine: true,
	};

	data.forEach((currentRow) => {
		total[ColaAdjustments.CURRENT_REVENUE] += currentRow[ColaAdjustments.CURRENT_REVENUE];
		total[ColaAdjustments.COST_INCREASE] += currentRow[ColaAdjustments.COST_INCREASE];
		total[ColaAdjustments.NEW_COST] += currentRow[ColaAdjustments.NEW_COST];
		total[ColaAdjustments.REVENUE_INCREASE] += currentRow[ColaAdjustments.REVENUE_INCREASE];
		total[ColaAdjustments.NEW_REVENUE] += currentRow[ColaAdjustments.NEW_REVENUE];
	});

	const currentRevenue = total[ColaAdjustments.CURRENT_REVENUE];
	const newRevenue = total[ColaAdjustments.NEW_REVENUE];
	const newCost = total[ColaAdjustments.NEW_COST];
	const marginWithCola = marginPercentage(currentRevenue, newCost) / 100;
	const marginWithColaAndPassthrough = marginPercentage(newRevenue, newCost) / 100;

	total[ColaAdjustments.MARGIN_WITH_COLA] = marginWithCola;
	total[ColaAdjustments.MARGIN_WITH_PASS_THROUGH] = marginWithColaAndPassthrough;

	return total;
};

const sortByRateMatch = (rowA, rowB) => {
	if (rowA[ColaAdjustments.RATE_MATCH] === RateMatch.RATE_MATCH_GLOBAL) {
		return -1;
	}

	if (rowB[ColaAdjustments.RATE_MATCH] === RateMatch.RATE_MATCH_GLOBAL) {
		return 1;
	}

	if (rowA[ColaAdjustments.RATE_MATCH] === rowB[ColaAdjustments.RATE_MATCH]) {
		return rowA.location.localeCompare(rowB.location);
	}

	return rowA.country.localeCompare(rowB.country);
};

const compoundYoyRate = (startYear, year, yoyColaRate) => {
	const compoundYear = year - startYear;
	return compoundYear <= 0 ? 0 : ((1 + yoyColaRate) ** compoundYear - 1);
};

const getFormattedYoyRate = (yoyColaRate, yoyColaRateOverride) => {
	if (yoyColaRateOverride) {
		return `* ${yoyColaRateOverride.toFixed(2)}%`;
	}

	return yoyColaRate >= 0 ? `${yoyColaRate.toFixed(2)}%` : 0;
};

const getDataForYear = (costByYear, colaRates, year, startYear, location) => {
	const { currentCost, currentRevenue } = costByYear[location];

	const {
		rateOverride, yearOverYearRate, passthroughPercentage: yearOverYearPassthrough, passthroughOverride,
	} = colaRates[location];

	const rateOrOverrideRate = rateOverride >= 0 ? rateOverride : yearOverYearRate;
	const yoyColaRate = ((rateOrOverrideRate || 0) / 100);
	const yoyColaRateOverride = (rateOverride || 0) / 100;
	const passthroughRateOrOverrideRate = passthroughOverride >= 0 ? passthroughOverride : yearOverYearPassthrough;
	const passthroughRate = (passthroughRateOrOverrideRate || 0) / 100;
	const costIncrease = currentCost * compoundYoyRate(startYear, year, yoyColaRate) || 0;
	const revenueIncrease = currentRevenue * compoundYoyRate(startYear, year, passthroughRate) || 0;
	const newCost = currentCost + costIncrease;
	const newRevenue = currentRevenue + revenueIncrease;
	const marginWithCola = marginPercentage(currentRevenue, newCost) / 100;
	const marginWithColaAndPassthrough = marginPercentage(newRevenue, newCost) / 100;
	return {
		city: colaRates[location].city,
		colaRateId: colaRates[location].id,
		costIncrease,
		country: colaRates[location].country,
		currentRevenue,
		location,
		marginWithCola,
		marginWithColaAndPassthrough,
		newCost,
		newRevenue,
		passthroughRateFormatted: getFormattedYoyRate(passthroughRateOrOverrideRate),
		rateMatch: colaRates[location].rateMatch,
		revenueIncrease,
		state: colaRates[location].state,
		year,
		yoyColaRateFormatted: getFormattedYoyRate(yearOverYearRate, rateOverride),
		yoyColaRate,
		rateOverride: yoyColaRateOverride,
	};
};

const calculateDataForYear = (costByYear, colaRates, year, startYear) => {
	const data = [];
	let result = [];

	Object.keys(costByYear).forEach((location) => {
		data.push(getDataForYear(costByYear, colaRates, year, startYear, location));
	});

	if (year !== startYear && data.length > 0) {
		data.sort(sortByRateMatch);
		result = result.concat(data);
	}

	result.push(calculateTotalForYear(data, year));
	return { data: result };
};

const calculateColaAdjustment = (colaRates, startYear, endYear, costsByYear) => {
	let data = [];
	for (let year = startYear; year < endYear + 1; year++) {
		const response = calculateDataForYear(costsByYear[year], colaRates, year, startYear);
		data = data.concat(response.data);
	}

	return data;
};

const processColaRates = (colaRates, colaRateYear) => {
	const processedColaRates = {
		[RateMatch.RATE_MATCH_GLOBAL]: {},
	};

	colaRates.forEach((colaRate) => {
		if (colaRate.serviceYear === colaRateYear) {
			let countryStateCity;
			switch (colaRate.rateMatch) {
				case RateMatch.RATE_MATCH_COUNTRY:
					countryStateCity = colaRate.country;
					break;
				case RateMatch.RATE_MATCH_STATE:
					countryStateCity = `${colaRate.country}/${colaRate.state}`;
					break;
				case RateMatch.RATE_MATCH_CITY:
					countryStateCity = [colaRate.country, colaRate.state, colaRate.city].filter((x) => x).join('/');
					break;
				default:
					processedColaRates[RateMatch.RATE_MATCH_GLOBAL] = colaRate;
					break;
			}

			if (countryStateCity) {
				processedColaRates[countryStateCity] = colaRate;
			}
		}
	});

	return processedColaRates;
};

const populateEmptyCost = (costByYear, key) => {
	if (!costByYear[key]) {
		return {
			currentCost: 0,
			currentRevenue: 0,
		};
	}

	return costByYear[key];
};

const getMatchLocation = (colaRates, country, state, city) => {
	const countryStateCity = [country, state, city].join('/');
	const countryCity = `${country}/${city}`;
	const countryState = `${country}/${state}`;
	let matchLocation = RateMatch.RATE_MATCH_GLOBAL;
	if (colaRates[countryStateCity]) {
		matchLocation = countryStateCity;
	} else if (colaRates[countryCity]) {
		matchLocation = countryCity;
	} else if (colaRates[countryState]) {
		matchLocation = countryState;
	} else if (colaRates[country]) {
		matchLocation = country;
	}

	return matchLocation;
};

const updateCostForYear = ({
	colaRates,
	costsByYear,
	elementDO,
	periodValue,
	periodYear,
	term,
}) => {
	const { quoteItemSO } = elementDO;

	let {
		location,
	} = elementDO;

	if (!location) {
		location = {};
	}

	const costForYear = { ...costsByYear[periodYear] };
	const unitCost = quoteItemSO[QUOTE_ITEM_UNIT_COST_FIELD.fieldApiName];
	const adjustedUnitPrice = quoteItemSO[QUOTE_ITEM_ADJUSTED_UNIT_PRICE_FIELD.fieldApiName];
	const cost = (unitCost * periodValue * term);
	const revenue = (adjustedUnitPrice * periodValue * term);
	const matchLocation = getMatchLocation(colaRates, location.country, location.state, location.city);
	costForYear[matchLocation] = populateEmptyCost(costsByYear[periodYear], matchLocation);
	costForYear[matchLocation].currentCost += cost;
	costForYear[matchLocation].currentRevenue += revenue;

	return costForYear;
};

const updateCostYear = ({
	quoteItems,
	periods,
	colaRates,
	costsByYear,
}) => {
	const currentCostsByYear = { ...costsByYear };
	Object.values(quoteItems).forEach((quoteItem) => {
		Object.keys(quoteItem.elementDO.periodValueMap).forEach((periodColumn) => {
			const periodIndex = parseInt(periodColumn, 10) - 1;
			// we use out of bounds indexes to indicate blank cells
			if (periodIndex < periods.length) {
				const { startDate, term } = periods[periodIndex];
				const periodYear = getYearFromDate(startDate);
				const { periodValueMap } = quoteItem.elementDO;

				const costForYear = updateCostForYear({
					colaRates,
					costsByYear: currentCostsByYear,
					elementDO: quoteItem.elementDO,
					periodValue: periodValueMap[periodColumn],
					periodYear,
					term,
				});

				currentCostsByYear[periodYear] = {
					...currentCostsByYear[periodYear],
					...costForYear,
				};
			}
		});
	});
	return currentCostsByYear;
};

const initializeCostByYear = (startYear, endYear) => {
	const costsByYear = {};
	for (let year = startYear; year < endYear + 1; year++) {
		costsByYear[year] = {};
	}

	return costsByYear;
};

const getCostsByYear = (
	{
		startYear,
		endYear,
		quoteItems,
		periods,
		colaRates,
	},
) => {
	let costsByYear = initializeCostByYear(startYear, endYear);
	costsByYear = updateCostYear({
		quoteItems,
		periods,
		colaRates,
		costsByYear,
	});

	return costsByYear;
};

const getYears = (periods) => {
	let startYear;
	let endYear;
	if (periods.length > 0) {
		const firstPeriod = periods[0].startDate;
		const lastPeriod = periods[periods.length - 1].startDate;
		startYear = getYearFromDate(firstPeriod);
		endYear = getYearFromDate(lastPeriod);
	} else {
		const thisYear = getYearFromDate();
		startYear = thisYear;
		endYear = thisYear;
	}

	return { startYear, endYear };
};

const calculateGrandTotal = (totals) => {
	const grandTotal = {
		[ColaAdjustments.CURRENT_REVENUE]: 0,
		[ColaAdjustments.COST_INCREASE]: 0,
		[ColaAdjustments.NEW_COST]: 0,
		[ColaAdjustments.REVENUE_INCREASE]: 0,
		[ColaAdjustments.NEW_REVENUE]: 0,
		[ColaAdjustments.LOCATION]: LABEL_GRAND_TOTAL,
		isSummaryLine: true,
	};

	totals.forEach((totalAdjustment) => {
		grandTotal[ColaAdjustments.CURRENT_REVENUE] += totalAdjustment[ColaAdjustments.CURRENT_REVENUE];
		grandTotal[ColaAdjustments.COST_INCREASE] += totalAdjustment[ColaAdjustments.COST_INCREASE];
		grandTotal[ColaAdjustments.NEW_COST] += totalAdjustment[ColaAdjustments.NEW_COST];
		grandTotal[ColaAdjustments.REVENUE_INCREASE] += totalAdjustment[ColaAdjustments.REVENUE_INCREASE];
		grandTotal[ColaAdjustments.NEW_REVENUE] += totalAdjustment[ColaAdjustments.NEW_REVENUE];
	});

	const currentRevenue = grandTotal[ColaAdjustments.CURRENT_REVENUE];
	const newRevenue = grandTotal[ColaAdjustments.NEW_REVENUE];
	const newCost = grandTotal[ColaAdjustments.NEW_COST];
	const marginWithCola = marginPercentage(currentRevenue, newCost) / 100;
	const marginWithColaAndPassthrough = marginPercentage(newRevenue, newCost) / 100;

	grandTotal[ColaAdjustments.MARGIN_WITH_COLA] = marginWithCola;
	grandTotal[ColaAdjustments.MARGIN_WITH_PASS_THROUGH] = marginWithColaAndPassthrough;

	return grandTotal;
};

export {
	calculateColaAdjustment,
	calculateGrandTotal,
	isEmpty,
	getCostsByYear,
	getYears,
	loadData,
	processColaRates,
	sortByRateMatch,
};
