/*
 * Provus Services Quoting
 * Copyright (c) 2021 Provus Inc. All rights reserved.
 */
/* eslint-disable no-new-func */
import ContextMenu from '../contextMenu';

describe('contextMenu', () => {
	let contextMenu;
	beforeEach(() => {
		contextMenu = new ContextMenu({
			isCollaborationQuote: jest.fn(),
			disableSections: jest.fn(),
		});
	});
	describe('remove_row', () => {
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

				const result = Function(`"use strict";return (${contextMenu.items.remove_row.hidden.functionString})`)().bind(grid)();
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

				const result = Function(`"use strict";return (${contextMenu.items.remove_row.hidden.functionString})`)().bind(grid)();
				expect(result).toBeTruthy();
			});
			it('should return true when selected row is not a quote item', () => {
				const rowData = {
					from: { row: 0 },
					to: { row: 0 },
				};

				const grid = {
					getSelectedRangeLast: jest.fn(() => rowData),
					getSourceDataAtRow: jest.fn(() => ({})),
				};

				const result = Function(`"use strict";return (${contextMenu.items.remove_row.hidden.functionString})`)().bind(grid)();
				expect(result).toBeTruthy();
			});
		});
	});
	describe('edit_row', () => {
		describe('hidden', () => {
			it('should return true when multiple rows are selected', () => {
				const rowData = {
					from: { row: 0 },
					to: { row: 5 },
				};

				const grid = {
					getSelectedRangeLast: jest.fn(() => rowData),
					getSourceDataAtRow: jest.fn(() => ({ isQuoteItem: true })),
				};

				const result = Function(`"use strict";return (${contextMenu.items.edit_row.hidden.functionString})`)().bind(grid)();
				expect(result).toBeTruthy();
			});
			it('should return true when a non-quote item row is selected', () => {
				const rowData = {
					from: { row: 0 },
					to: { row: 0 },
				};

				const grid = {
					getSelectedRangeLast: jest.fn(() => rowData),
					getSourceDataAtRow: jest.fn(() => ({ isQuoteItem: false })),
				};

				const result = Function(`"use strict";return (${contextMenu.items.edit_row.hidden.functionString})`)().bind(grid)();
				expect(result).toBeTruthy();
			});
			it('should return false when a single quote item row is selected', () => {
				const rowData = {
					from: { row: 0 },
					to: { row: 0 },
				};

				const grid = {
					getSelectedRangeLast: jest.fn(() => rowData),
					getSourceDataAtRow: jest.fn(() => ({ isQuoteItem: true })),
				};

				const result = Function(`"use strict";return (${contextMenu.items.edit_row.hidden.functionString})`)().bind(grid)();
				expect(result).toBeFalsy();
			});
			it('should return true when a single locked quote item row is selected', () => {
				const rowData = {
					from: { row: 0 },
					to: { row: 0 },
				};

				const grid = {
					getSelectedRangeLast: jest.fn(() => rowData),
					getSourceDataAtRow: jest.fn(() => ({ isQuoteItem: true, locked: true })),
				};

				const result = Function(`"use strict";return (${contextMenu.items.edit_row.hidden.functionString})`)().bind(grid)();
				expect(result).toBeTruthy();
			});
		});
	});
	describe('edit_section', () => {
		describe('hidden', () => {
			it('should return false when the selected row is a section', () => {
				const rowData = {
					from: { row: 0 },
					to: { row: 0 },
				};

				const grid = {
					getSelectedRangeLast: jest.fn(() => rowData),
					getCellMeta: jest.fn(() => ({ isSectionHeader: true })),
					getSourceDataAtRow: jest.fn(() => ({})),
				};

				const result = Function(`"use strict";return (${contextMenu.items.edit_section.hidden.functionString})`)().bind(grid)();
				expect(result).toBeFalsy();
			});
			it('should return true when the selected row is a locked section', () => {
				const rowData = {
					from: { row: 0 },
					to: { row: 0 },
				};

				const grid = {
					getSelectedRangeLast: jest.fn(() => rowData),
					getCellMeta: jest.fn(() => ({ isSectionHeader: true })),
					getSourceDataAtRow: jest.fn(() => ({ locked: true })),
				};

				const result = Function(`"use strict";return (${contextMenu.items.edit_section.hidden.functionString})`)().bind(grid)();
				expect(result).toBeTruthy();
			});
		});
	});
	describe('rename_role', () => {
		describe('hidden', () => {
			it('should return true when the selected row is a locked section', () => {
				const rowData = {
					from: { row: 0 },
					to: { row: 0 },
				};

				const grid = {
					getSelectedRangeLast: jest.fn(() => rowData),
					getSourceDataAtRow: jest.fn(() => ({ locked: true })),
				};

				const result = Function(`"use strict";return (${contextMenu.items.rename_role.hidden.functionString})`)().bind(grid)();
				expect(result).toBeTruthy();
			});
		});
	});
});
