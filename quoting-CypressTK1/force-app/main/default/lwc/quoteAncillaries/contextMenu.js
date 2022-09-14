/*
 * Provus Services Quoting
 * Copyright (c) 2021 Provus Inc. All rights reserved.
 */
/* eslint-disable max-lines-per-function */
import LABEL_RENAME_ADDON from '@salesforce/label/c.RenameAddon';
import LABEL_REMOVE_ADDON from '@salesforce/label/c.RemoveAddon';
import LABEL_NON_BILLABLE from '@salesforce/label/c.MakeNonBillable';
import LABEL_BILLABLE from '@salesforce/label/c.MakeBillable';
import { IFrameCallback } from 'c/util';

export default class ContextMenu {
	static items = {
		rename_addon: {
			name: LABEL_RENAME_ADDON,
			hidden: IFrameCallback(isRenameAddonHidden),
		},
		remove_row: {
			name: LABEL_REMOVE_ADDON,
		},
		toggle_non_billable: {
			name: LABEL_NON_BILLABLE,
			hidden: IFrameCallback(rowIsNotBillable),
		},
		toggle_billable: {
			name: LABEL_BILLABLE,
			hidden: IFrameCallback(rowIsBillable),
		},
	}
}

function rowIsBillable() {
	let isHidden = true;
	const selectedRange = this.getSelectedRangeLast();
	const fromRow = selectedRange.from.row;
	const toRow = selectedRange.to.row;
	if (fromRow === toRow || fromRow >= 0) {
		const quoteItemSO = this.getSourceDataAtRow(fromRow);
		if (quoteItemSO.locked) {
			return true;
		}

		const nonBillableApiName = Object.keys(quoteItemSO).filter((fieldName) => fieldName.indexOf('NonBillable__c') > -1);
		isHidden = !quoteItemSO[nonBillableApiName];
	}

	return isHidden;
}

function rowIsNotBillable() {
	let isHidden = true;
	const selectedRange = this.getSelectedRangeLast();
	const fromRow = selectedRange.from.row;
	const toRow = selectedRange.to.row;
	if (fromRow === toRow || fromRow >= 0) {
		const quoteItemSO = this.getSourceDataAtRow(fromRow);
		if (quoteItemSO.locked) {
			return true;
		}

		const nonBillableApiName = Object.keys(quoteItemSO).filter((fieldName) => fieldName.indexOf('NonBillable__c') > -1);
		isHidden = quoteItemSO[nonBillableApiName];
	}

	return isHidden;
}

function isRenameAddonHidden() {
	function isAnyAtOrBelowRow(contextRow, ...checkRows) {
		let isAnyAtOrBelow = false;
		for (let i = 0; i < checkRows.length; i++) {
			const checkRow = checkRows[i];
			if (checkRow >= contextRow) {
				isAnyAtOrBelow = true;
				break;
			}
		}

		return isAnyAtOrBelow;
	}

	function containsSectionHeaderOrFooter(
		fromRow,
		toRow,
		exclude = [],
	) {
		let hasSectionHeaderOrFooter = false;
		for (let i = fromRow; i < toRow + 1; i++) {
			if (i > -1) {
				const cellMeta = this.getCellMeta(i, 0);
				const { isSectionHeader, isSectionFooter } = cellMeta;
				let isExcluded = false;
				for (let j = 0; j < exclude.length; j++) {
					if (exclude[j]) {
						isExcluded = true;
						break;
					}
				}

				if (!isExcluded && (isSectionHeader || isSectionFooter)) {
					hasSectionHeaderOrFooter = true;
					break;
				}
			}
		}

		return hasSectionHeaderOrFooter;
	}

	const selectedRange = this.getSelectedRangeLast();
	const secondToLastRow = this.countRows() - 2;
	const fromRow = selectedRange.from.row + 1;
	const toRow = selectedRange.to.row;
	let isHidden = containsSectionHeaderOrFooter.call(this, fromRow, toRow);
	if (!isHidden) {
		isHidden = isAnyAtOrBelowRow(secondToLastRow, fromRow, toRow);
	}

	const startColumn = selectedRange.from.col;
	isHidden = startColumn < 0 || fromRow < 0;

	if (!isHidden) {
		const cellMeta = this.getCellMeta(fromRow, startColumn);
		const { isAddonColumn } = cellMeta;
		isHidden = !isAddonColumn;
	}

	return isHidden;
}
