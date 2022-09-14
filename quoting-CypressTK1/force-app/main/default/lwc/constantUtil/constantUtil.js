/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
const RateCardItem = {
	PriceUom: {
		HOURLY: 'Hourly',
		DAILY: 'Daily',
		WEEKLY: 'Weekly',
		MONTHLY: 'Monthly',
		YEARLY: 'Yearly',
	},
};

const Quote = {
	TimePeriod: {
		DAYS: 'Days',
		WEEKS: 'Weeks',
		MONTHS: 'Months',
		QUARTERS: 'Quarters',
	},
};

const RecurringHours = {
	TimePeriod: {
		DAYS: 'Days',
		WEEKS: 'Weeks',
		MONTHS: 'Months',
		QUARTERS: 'Quarters',
		YEARS: 'Years',
	},
};

const AdjustmentType = {
	MARGIN_ADJUSTMENT: 'Margin Adjustment',
	REALIGN_RESOURCE: 'Realign Resource',
	REVENUE_ADJUSTMENT: 'Revenue Adjustment',
	COLA_ADJUSTMENT: 'COLA Adjustment',
};

const OBSERVER_NAME_SFDC = 'SFDC';

const RateMatch = {
	RATE_MATCH_GLOBAL: 'Global',
	RATE_MATCH_COUNTRY: 'Country',
	RATE_MATCH_STATE: 'State',
	RATE_MATCH_CITY: 'City',
};

const CollaborationRequest = {
	Status: {
		READY_TO_MERGE: 'Ready to Merge',
		MERGED: 'Merged',
		ACCEPTED: 'Accepted',
		ASSIGNED: 'Assigned',
	},
};

const ColumnGroup = {
	RATE_ATTRIBUTE: 0,
	PRICING_ATTRIBUTE: 1,
};

const RecordType = {
	QUOTE: 'Quote',
	COLLABORATION: 'Collaboration',
};

const ScheduleSettingFields = {
	STANDARD_DAY_HOURS: 'StandardDayHours__c',
	STANDARD_WEEK_HOURS: 'StandardWeekHours__c',
	STANDARD_MONTH_HOURS: 'StandardMonthHours__c',
	STANDARD_YEAR_HOURS: 'StandardYearHours__c',
};

const ContextMenuActions = {
	ROW_BELOW: 'row_below',
	EDIT_ROW: 'edit_row',
};

const Discount = {
	DISCOUNT_PERCENT: 'Discount Percent',
	DISCOUNT_AMOUNT: 'Discount Amount',
	INITIAL: 'Initial',
	COST: 'Cost',
};

const ColaAdjustments = {
	COST_INCREASE: 'costIncrease',
	CURRENT_COST: 'currentCost',
	CURRENT_REVENUE: 'currentRevenue',
	LOCATION: 'location',
	MARGIN_WITH_COLA: 'marginWithCola',
	MARGIN_WITH_PASS_THROUGH: 'marginWithColaAndPassthrough',
	NEW_COST: 'newCost',
	NEW_REVENUE: 'newRevenue',
	RATE_MATCH: 'rateMatch',
	REVENUE_INCREASE: 'revenueIncrease',
	YEAR: 'year',
	YOY_COLA_RATE: 'yoyColaRate',
	YOY_COLA_RATE_FORMATTED: 'yoyColaRateFormatted',
};

const VolumeDiscountCategories = {
	Headcount: 'Headcount',
	LaborRevenue: 'Labor Revenue',
};

const LaborUnits = {
	HEADCOUNT: 'Headcount',
	HOURS: 'Hours',
};

const ReviewVolumeDiscountFieldNames = {
	TOTAL_BY: 'totalBy',
	ACTIVE_TIER: 'activeTier',
	MIN_VALUE: 'minValue',
	MAX_VALUE: 'maxValue',
	DISCOUNT: 'discount',
	REVENUE: 'revenue',
	DISCOUNT_AMOUNT: 'discountAmount',
};

const TemplateDataType = {
	CHECKBOX: 'Checkbox',
	INTEGER_TIERS: 'Integer Tiers',
	INTEGER: 'Integer',
	PICKLIST: 'Picklist',
};

export {
	AdjustmentType,
	RateMatch,
	ColaAdjustments,
	CollaborationRequest,
	ColumnGroup,
	ContextMenuActions,
	Discount,
	LaborUnits,
	OBSERVER_NAME_SFDC,
	Quote,
	RateCardItem,
	RecordType,
	RecurringHours,
	ReviewVolumeDiscountFieldNames,
	ScheduleSettingFields,
	TemplateDataType,
	VolumeDiscountCategories,
};
