/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import { toFixedNumber } from 'c/util';

const MAX_FRACTION_DIGITS = 2;
const formatSplitPercentage = (split) => {
	const splitPercentageFixed = toFixedNumber(Number(split), MAX_FRACTION_DIGITS);
	return Number(splitPercentageFixed) || 1; // don't allow zero value;
};

export { MAX_FRACTION_DIGITS, formatSplitPercentage };
