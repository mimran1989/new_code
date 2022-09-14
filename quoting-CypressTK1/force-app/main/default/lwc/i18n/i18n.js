/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
const format = (stringToFormat, ...formattingArguments) => {
	if (typeof stringToFormat !== 'string') throw new Error('\'stringToFormat\' must be a String');
	return stringToFormat.replace(/{(\d+)}/gm, (match, index) => (formattingArguments[index] === undefined ? '' : `${formattingArguments[index]}`));
};

// eslint-disable-next-line import/prefer-default-export
export { format };
