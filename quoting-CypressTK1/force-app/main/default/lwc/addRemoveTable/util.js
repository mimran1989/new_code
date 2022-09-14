/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

const indexRows = (rows) => {
	for (let i = 0; i < rows.length; i++) {
		const row = rows[i];
		row.index = `${i}`;
	}

	return rows;
};

// TODO: remove lint disable when we have multiple exports
// eslint-disable-next-line import/prefer-default-export
export { indexRows };
