const RateMatch = {
	GLOBAL: 'Global',
	COUNTRY: 'Country',
	STATE: 'State',
	CITY: 'City',
};

const setIsNewRow = (rows) => {
	for (let i = 0; i < rows.length; i++) {
		const row = rows[i];
		if (row.isNewRow === undefined) {
			row.isNewRow = false;
		}
	}

	return rows;
};

const indexRows = (rows) => {
	for (let i = 0; i < rows.length; i++) {
		const row = rows[i];
		row.index = `${i}`;
	}

	return rows;
};

const updateRateMatch = (row) => {
	const updatedRow = row;
	updatedRow.rateMatch = RateMatch.GLOBAL;

	if (updatedRow.country) {
		updatedRow.rateMatch = RateMatch.COUNTRY;
	}

	if (updatedRow.state) {
		updatedRow.rateMatch = RateMatch.STATE;
	}

	if (updatedRow.city) {
		updatedRow.rateMatch = RateMatch.CITY;
	}
};

const yearLocationKey = (row) => {
	const { serviceYear } = row;
	const { rateMatch } = row;
	const rateMatchValue = row[row.rateMatch?.toLowerCase()];

	// e.g. "2022-Country-United States", "2022-State-California"
	return `${serviceYear}-${rateMatch}${rateMatchValue ? '-' : ''}${(rateMatchValue) || ''}`;
};

export {
	indexRows,
	RateMatch,
	setIsNewRow,
	updateRateMatch,
	yearLocationKey,
};
