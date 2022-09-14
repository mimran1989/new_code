import { Discount } from 'c/constantUtil';

const NamedRangeTypes = {
	QUOTE_LABOR: 'Quote Labor',
	QUOTE_ANCILLARIES: 'Quote Ancillaries',
	QUOTE: 'Quote',
	QUOTE_PERIOD: 'Quote Period',
	QUOTE_ITEM_PERIOD_GROUP: 'Quote Item Period Group',
};

const AppliedByTypes = {
	INCENTIVE: 'Incentive',
	MANUAL: 'Manual',
	PROMOTION: 'Promotion',
	RULE: 'Rule',
};

const newAdjustment = ({
	discountAppliedTo,
	discountMethod,
	currentIdx,
	discountAppliedBy = 'Manual',
}) => ({
	adjustmentId: null,
	appliedBy: discountAppliedBy,
	appliedTo: discountAppliedTo,
	method: discountMethod,
	sequence: currentIdx + 1, // zero indexed array
});

const createNewVolumeDiscountAdjustment = (namedRange, tier) => {
	const ctxAdjustment = newAdjustment({ currentIdx: namedRange.adjustmentList.length, discountAppliedBy: AppliedByTypes.RULE });
	ctxAdjustment.type = Discount.DISCOUNT_PERCENT;
	ctxAdjustment.amount = tier.discount;
	ctxAdjustment.method = 'Volume Discount';
	ctxAdjustment.appliedTo = 'Price';
	ctxAdjustment.tierId = tier.id;
	return ctxAdjustment;
};

const getNamedRangeQuantity = (namedRange, category) => {
	const {
		relatedTotal: {
			adjustedBaseAmount,
			totalQuantity,
		},
	} = namedRange;

	if (category === 'Labor Revenue') {
		return adjustedBaseAmount;
	}

	return totalQuantity;
};

const isNamedRangeInTier = (quantity, tier, category) => {
	let result = false;
	const isFirstTier = tier.sequence === 1;
	const isLastTier = tier.sequence === 3;
	let roundedValue;
	if (category === 'Labor Revenue') {
		roundedValue = Math.round(quantity);
	} else {
		roundedValue = quantity.toFixed(0);
	}

	if (isFirstTier) {
		// cannot be lower than from value
		if (quantity >= tier.fromValue && +roundedValue <= tier.toValue) {
			result = true;
		}
	} else if (isLastTier) {
		// cannot be lower than the to value
		if (quantity >= tier.fromValue && quantity <= tier.toValue) {
			result = true;
		}
	} else if (quantity >= tier.fromValue && +roundedValue <= tier.toValue) {
		result = true;
	}

	return result;
};

const getNamedRangesByType = (namedRanges) => {
	const namedRangesByType = {
		laborRecord: {},
		addonAmount: {},
		quoteTotal: {},
		periods: [],
		periodGroups: [],
	};

	namedRanges.forEach((namedRange) => {
		switch (namedRange.type) {
			case NamedRangeTypes.QUOTE_LABOR:
				namedRangesByType.laborRecord = namedRange;
				break;
			case NamedRangeTypes.QUOTE_ANCILLARIES:
				namedRangesByType.addonAmount = namedRange;
				break;
			case NamedRangeTypes.QUOTE:
				namedRangesByType.quoteTotal = namedRange;
				break;
			case NamedRangeTypes.QUOTE_PERIOD:
				namedRangesByType.periods.push(namedRange);
				break;
			case NamedRangeTypes.QUOTE_ITEM_PERIOD_GROUP:
				namedRangesByType.periodGroups.push(namedRange);
				break;
			default:
				break;
		}
	});

	return namedRangesByType;
};

export default {
	newAdjustment,
	createNewVolumeDiscountAdjustment,
	isNamedRangeInTier,
	getNamedRangeQuantity,
	getNamedRangesByType,
};
