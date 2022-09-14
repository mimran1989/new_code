/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import LABEL_TOTAL from '@salesforce/label/c.Total';

const generatePeriodColumnMetadata = (periodsByGroup, periodGroups, isReadOnly) => {
	const periodColumnMetadata = [];
	let periodCounter = 0;

	Object.keys(periodsByGroup).forEach((periodGroupId) => {
		const { name: periodGroupName } = periodGroups[periodGroupId];
		const periods = periodsByGroup[periodGroupId];
		for (let i = 0; i < periods.length; i++) {
			const period = periods[i];
			periodColumnMetadata.push({
				data: `${periodCounter + 1}`.padStart(3, '0'),
				type: 'numeric',
				isPeriod: true,
				id: period.id,
				label: period.name,
				numericFormat: {
					pattern: '0,0.00',
					culture: 'en-US',
				},
				readOnly: isReadOnly,
			});
			periodCounter += 1;
		}

		periodColumnMetadata.push({
			data: `NamedRange__${periodGroupId}__mdt`,
			type: 'numeric',
			readOnly: true,
			isTotal: true,
			label: `${periodGroupName} ${LABEL_TOTAL}`,
			numericFormat: {
				pattern: '$0,0.00',
				culture: 'en-US',
			},
		});
	});

	return periodColumnMetadata;
};

const flattenPeriodGroups = (periodsByGroup) => {
	const periods = [];
	Object.values(periodsByGroup).forEach((nextGroup) => {
		periods.push(...nextGroup);
	});

	periods.sort((a, b) => (a.sequence > b.sequence ? 1 : -1));
	return periods;
};

const shiftableAmount = (periodValues, numPeriods) => {
	for (let i = numPeriods - 1; i >= 0; i--) {
		const periodColumnName = `${i + 1}`.padStart(3, '0');
		let foundValue;
		periodValues.forEach((nextPeriodValue) => {
			if (nextPeriodValue[periodColumnName]) {
				foundValue = true;
				return false;
			}

			return undefined;
		});

		if (foundValue) {
			return numPeriods - (i + 1);
		}
	}

	return 0;
};

const firstValueIndex = (periodValues, numPeriods) => {
	for (let i = 0; i < numPeriods - 1; i++) {
		const periodColumnName = `${i + 1}`.padStart(3, '0');
		let foundValue;
		periodValues.forEach((nextPeriodValue) => {
			if (nextPeriodValue[periodColumnName]) {
				foundValue = true;
				return false;
			}

			return undefined;
		});

		if (foundValue) {
			return i;
		}
	}

	return 0;
};

export {
	shiftableAmount, flattenPeriodGroups, generatePeriodColumnMetadata, firstValueIndex,
};
