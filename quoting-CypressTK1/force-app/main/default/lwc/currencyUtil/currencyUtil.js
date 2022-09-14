/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
const roundAmount = (value) => +value.toFixed(2);
const sfdcNumberToNumber = (value) => {
	let result = null;
	const isStringType = typeof value === 'string' || value instanceof String;
	if (isStringType && value.trim() !== '') {
		result = +value;
	} else if (!Number.isNaN(value)) {
		result = value;
	}

	return result;
};

export { roundAmount, sfdcNumberToNumber };
