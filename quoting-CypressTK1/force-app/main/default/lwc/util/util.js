import FIELDS_QUOTE_DESCRIPTION from '@salesforce/schema/Quote__c.Description__c';
import Discounting from './discounting';

const provusNamespace = 'PSQ';
export function IFrameCallback(fn) {
	return {
		type: 'IFrameCallback',
		functionString: fn.toString(),
	};
}

/**
 * Check if value from lightning-input of type=number is empty/blank or not. Null
 * and undefined are considered empty/blank.
 *
 * @param fieldValue
 * @returns {boolean}
 */
export function inputIsBlank(fieldValue) {
	return !(isString(fieldValue) && fieldValue.length > 0);
}

export function isString(value) {
	if (value === undefined || value === null) {
		return false;
	}

	return typeof value === 'string' || value instanceof String;
}

export function isEmpty(obj) {
	let result = true;
	if (typeof obj !== 'undefined' && obj !== null) {
		if (
			(Array.isArray(obj) && obj.length !== 0)
			|| (typeof obj === 'string' && obj.trim() !== '')
		) {
			result = false;
		}
	}

	return result;
}

export function isNullOrUndefined(object) {
	return typeof object === 'undefined' || object === null;
}

export function get(prop, object) {
	let result = object;
	const propSplit = prop.split('.');
	for (let i = 0; i < prop.length; i++) {
		result = result[propSplit[i]];

		if (!result) {
			break;
		}
	}

	return result;
}

export function put(prop, object, value) {
	let contextObject = object;
	const propSplit = prop.split('.');
	for (let i = 0; i < prop.length - 1; i++) {
		if (!contextObject[propSplit[i]]) {
			contextObject[propSplit[i]] = {};
		}

		contextObject = contextObject[propSplit[i]];
	}

	contextObject[propSplit[propSplit.length - 1]] = value;
}

export function refreshView() {
	// eslint-disable-next-line no-eval
	eval("$A.get('e.force:refreshView').fire();");
}

export function componentNamespace(cmp) {
	const namespaceObjString = cmp.template.host.toString().match(/{"namespace":.*?}/);
	return namespaceObjString && JSON.parse(namespaceObjString[0]).namespace;
}

/**
 * Returns standard Provus package namespace
 * @returns {string}
 */
export function packageNamespace() {
	let _packageNamespace = '';
	if (FIELDS_QUOTE_DESCRIPTION.fieldApiName.indexOf(provusNamespace) > -1) {
		_packageNamespace = provusNamespace;
	}

	return _packageNamespace;
}

const keyBy = (array, key) => (array || []).reduce((accumulator, nextElement) => ({ ...accumulator, [key ? nextElement[key] : nextElement]: nextElement }), {});
const formatLabel = (stringToFormat, stringArguments) => {
	if (typeof stringToFormat !== 'string') {
		throw new Error('input label must be a String');
	}

	return stringToFormat.replace(/{(\d+)}/gm, (match, index) => (stringArguments[index] === undefined ? '' : `${stringArguments[index]}`));
};

const toFixedNumber = (num, fractionDigits) => Number(num.toFixed(fractionDigits));
const getPath = (obj, path) => path.split('.').reduce((p, c) => p?.[c], obj);
const setPath = (obj, path, value) => {
	const a = path.split('.');
	let o = obj;
	while (a.length - 1) {
		const n = a.shift();
		if (!(n in o)) o[n] = {};
		o = o[n];
	}

	o[a[0]] = value;
};

const marginPercentage = (revenue, cost) => {
	if (revenue === 0 && cost > 0) {
		return 0;
	}

	const relativeDifference = revenue - cost || 0;
	return relativeDifference === 0 ? 0 : (relativeDifference / revenue) * 100;
};

const discountPercentage = (netAmount, baseAmount) => (+baseAmount ? (1 - (+netAmount / +baseAmount)) * 100 : 0);
const resequence = (list, field, start = 1) => {
	let index = start;
	list.forEach((nextElem) => {
		const elem = nextElem;
		elem[field] = index;
		index += 1;
	});

	return list;
};

function getPropByString(obj, propString) {
	let ctxObject = obj;
	if (!propString) {
		return ctxObject;
	}

	let prop;
	let i;
	const props = propString.split('.');
	for (i = 0; i < props.length - 1; i++) {
		prop = props[i];

		const candidate = ctxObject[prop];
		if (candidate !== undefined) {
			ctxObject = candidate;
		} else {
			break;
		}
	}

	return ctxObject[props[i]];
}

const getYearFromDate = (currentDate) => {
	if (currentDate) {
		return new Date(currentDate).getUTCFullYear();
	}

	return new Date().getUTCFullYear();
};

const addDays = (date, days) => {
	const result = new Date(date);
	result.setDate(result.getDate() + days);
	return result;
};

const weekdaysInYear = (year) => {
	const start = new Date(`${year}-1-1`);
	const end = new Date(`${year}-12-31`);
	let weekdays = 0;
	for (let i = start; i <= end; i = addDays(i, 1)) {
		if (i.getDay() !== 0 && i.getDay() !== 6) {
			weekdays += 1;
		}
	}

	return weekdays;
};

const infinity = {
	inputValue: 'Infinity',
	numericValue: 2147483647, // max apex Decimal value
};

export {
	getPropByString,
	formatLabel,
	keyBy,
	toFixedNumber,
	discountPercentage,
	getPath,
	setPath,
	marginPercentage,
	resequence,
	getYearFromDate,
	weekdaysInYear,
	Discounting,
	infinity,
};
