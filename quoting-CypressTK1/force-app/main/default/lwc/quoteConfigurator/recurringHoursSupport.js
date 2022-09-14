/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

import { LaborUnits, RecurringHours } from 'c/constantUtil';
import QuoteItemsDataService from 'c/quoteItemsDataService';

const updateQuoteItem = (quoteItem, hoursForTimePeriod, laborUnits, periodColumnMetadata, recurringInfo) => {
	const {
		hoursPerOccurrence,
		occurrence,
		maxOccurrences,
	} = recurringInfo;

	const { periodValueMap } = quoteItem.elementDO;
	let adjustmentPerPeriod = hoursPerOccurrence * occurrence;
	if (laborUnits === LaborUnits.HEADCOUNT) {
		adjustmentPerPeriod /= hoursForTimePeriod;
	}

	if (!maxOccurrences || maxOccurrences >= periodColumnMetadata.length) {
		periodColumnMetadata.forEach((periodColumnElement) => {
			const columnIndex = periodColumnElement.data;
			const currentPeriodValue = periodValueMap[columnIndex] ? periodValueMap[columnIndex] : 0;
			periodValueMap[columnIndex] = currentPeriodValue + adjustmentPerPeriod;
		});
	} else {
		for (let i = 0; i < maxOccurrences; i++) {
			const columnIndex = periodColumnMetadata[i].data;
			const currentPeriodValue = periodValueMap[columnIndex] ? periodValueMap[columnIndex] : 0;
			periodValueMap[columnIndex] = currentPeriodValue + adjustmentPerPeriod;
		}
	}
};

const updateRecurringHours = async(params) => {
	const {
		laborUnits,
		rowMetadata,
		quoteItems,
		recurringInfo,
		row,
		recurringHoursTimePeriod,
		periodColumnMetadata,
		quoteScheduleSettings,
	} = params;

	const targetMeta = rowMetadata[row];
	const quoteItem = quoteItems[targetMeta.$id];
	let hoursForTimePeriod;
	switch (recurringHoursTimePeriod) {
		case RecurringHours.TimePeriod.DAYS:
			hoursForTimePeriod = quoteScheduleSettings.standardDayHours;
			break;
		case RecurringHours.TimePeriod.WEEKS:
			hoursForTimePeriod = quoteScheduleSettings.standardWeekHours;
			break;
		case RecurringHours.TimePeriod.MONTHS:
			hoursForTimePeriod = quoteScheduleSettings.standardMonthHours;
			break;
		case RecurringHours.TimePeriod.QUARTERS:
			hoursForTimePeriod = quoteScheduleSettings.standardMonthHours * 3;
			break;
		default: break;
	}

	updateQuoteItem(quoteItem, hoursForTimePeriod, laborUnits, periodColumnMetadata, recurringInfo);
	QuoteItemsDataService.setQuoteItem(quoteItem.$id, quoteItem);
};

export default updateRecurringHours;
