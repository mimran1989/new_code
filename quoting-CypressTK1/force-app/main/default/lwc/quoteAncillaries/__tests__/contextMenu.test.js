/*
 * Provus Services Quoting
 * Copyright (c) 2021 Provus Inc. All rights reserved.
 */
/* eslint-disable no-new-func */
import ContextMenu from '../contextMenu';

describe('contextMenu', () => {
	describe('toggle_non_billable', () => {
		describe('hidden', () => {
			it('should return false when selected row is a quote item', () => {
				const rowData = {
					from: { row: 0 },
					to: { row: 0 },
				};

				const grid = {
					getSelectedRangeLast: jest.fn(() => rowData),
					getSourceDataAtRow: jest.fn(() => ({ isQuoteItem: true })),
				};

				const result = Function(`"use strict";return (${ContextMenu.items.toggle_non_billable.hidden.functionString})`)().bind(grid)();
				expect(result).toBeFalsy();
			});
			it('should return true when selected row is a locked quote item', () => {
				const rowData = {
					from: { row: 0 },
					to: { row: 0 },
				};

				const grid = {
					getSelectedRangeLast: jest.fn(() => rowData),
					getSourceDataAtRow: jest.fn(() => ({ isQuoteItem: true, locked: true })),
				};

				const result = Function(`"use strict";return (${ContextMenu.items.toggle_non_billable.hidden.functionString})`)().bind(grid)();
				expect(result).toBeTruthy();
			});
		});
	});

	describe('toggle_billable', () => {
		describe('hidden', () => {
			it('should return true when selected row is a locked quote item', () => {
				const rowData = {
					from: { row: 0 },
					to: { row: 0 },
				};

				const grid = {
					getSelectedRangeLast: jest.fn(() => rowData),
					getSourceDataAtRow: jest.fn(() => ({ isQuoteItem: true, locked: true })),
				};

				const result = Function(`"use strict";return (${ContextMenu.items.toggle_billable.hidden.functionString})`)().bind(grid)();
				expect(result).toBeTruthy();
			});
		});
		it('should return false when selected row is a quote item', () => {
			const rowData = {
				from: { row: 0 },
				to: { row: 0 },
			};

			const grid = {
				getSelectedRangeLast: jest.fn(() => rowData),
				getSourceDataAtRow: jest.fn(() => ({})),
			};

			const result = Function(`"use strict";return (${ContextMenu.items.toggle_billable.hidden.functionString})`)().bind(grid)();
			expect(result).toBeTruthy();
		});
	});
});
