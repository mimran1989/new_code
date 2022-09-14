import { LightningElement, api, wire } from 'lwc';
import papaParseLib from '@salesforce/resourceUrl/papa_parse_5_0_2';
import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { generateUUID } from 'c/baseUtils';
import Fuse from 'c/fuseBasic';
import ProvusMessagingService from 'c/provusMessagingService';
import { reduceErrors } from 'c/sparkUtils';

import getColumnDataForImport from '@salesforce/apex/ImportDatatableController.getColumnDataForImport';
import importQuoteItems from '@salesforce/apex/ImportDatatableController.importQuoteItems';

import QUOTE_ITEM_OBJECT from '@salesforce/schema/QuoteItem__c';

export default class ImportDatatable extends LightningElement {
	@api quoteId;
	@api atRow;

	@api
	get uniqueBoundary() {
		if (!this._uniqueBoundary) {
			this._uniqueBoundary = generateUUID();
		}

		return this._uniqueBoundary;
	}

	get baseDatatable() {
		return this.template.querySelector('c-base-datatable');
	}

	get productNameFieldName() {
		// the first column is always the product columns
		return this.columns[0].fieldName;
	}

	get messageService() {
		if (!this._messageService) {
			this._messageService = this.template.querySelector('c-message-service');
		}

		return this._messageService;
	}

	_uniqueBoundary;
	_messageService;
	columns;
	parsedRows;
	isFileLoaded = false;

	provusMessagingService = new ProvusMessagingService(this);

	@wire(getColumnDataForImport, { quoteId: '$quoteId' })
	wireRateCardMetadata({ data, error }) {
		if (error) {
			this.provusMessagingService.handleWireError(error);
			return;
		}

		if (data) {
			this.columns = data;
		}
	}

	async connectedCallback() {
		try {
			await loadScript(this, papaParseLib);
		} catch (error) {
			this.provusMessagingService.notifySingleError('Error Loading Importer', error.message);
		}
	}

	// eslint-disable-next-line class-methods-use-this
	handleFileInputClicked(event) {
		// https://stackoverflow.com/a/12102992/899446
		const evt = event;
		evt.target.value = null;
	}

	handleFileInputChanged(event) {
		if (!event.target.files || !event.target.files.length) {
			return;
		}

		this.isFileLoaded = true;
		this.parseCsvFile(event.target.files[0]);
	}

	initializeTable() {
		this.baseDatatable.initializeTable(QUOTE_ITEM_OBJECT.objectApiName, this.columns, this.parsedRows);
	}

	parseCsvFile(file) {
		// eslint-disable-next-line no-undef
		Papa.parse(file, {
			skipEmptyLines: 'greedy',
			header: true,
			complete: (results) => {
				if (!results.data || !results.data.length) {
					this._notifyError('File Empty', 'Please check you have selected the correct file.');
					return;
				}

				if (results.data && results.data.length) {
					const csvHeadersFromFile = Object.keys(results.data[0]);
					const csvColumnToApiName = this.getApiNamesFromCsvHeaders(csvHeadersFromFile);
					this.parsedRows = results.data.map((csvLine, rowNumber) => {
						const translated = {
							rowNumber,
						};

						Object.keys(csvLine).forEach((columnName) => {
							translated[csvColumnToApiName[columnName]] = csvLine[columnName];
						});

						return translated;
					});

					this.initializeTable();
				}
			},
		});
	}

	getApiNamesFromCsvHeaders(csvHeaders) {
		const labelToApiName = {}; // fuzzy search match real api names from column labels in csv
		const csvHeadersLower = csvHeaders.map((header) => header.toLowerCase());
		const fuzzyHeaders = new Fuse(csvHeaders, { includeScore: true });
		this.columns.forEach((column) => {
			const fieldColumnIdx = csvHeadersLower.indexOf(column.fieldName.toLowerCase());
			if (fieldColumnIdx > -1) {
				const columnApiName = csvHeaders[fieldColumnIdx];
				labelToApiName[columnApiName] = columnApiName;
			} else {
				const labelSearchResult = fuzzyHeaders.search(column.label);
				if (labelSearchResult && labelSearchResult.length) {
					const bestMatch = labelSearchResult[0];
					const { item } = bestMatch;
					labelToApiName[item] = column.fieldName;
				}
			}
		});
		return labelToApiName;
	}

	async handleDownloadSampleCsv() {
		const sampleInput = {
			fields: this.columns.map((column) => column.label),
			data: [],
		};

		// eslint-disable-next-line no-undef
		const sampleCsv = await Papa.unparse(sampleInput);
		const link = document.createElement('a');
		link.href = window.URL.createObjectURL(new Blob([sampleCsv]));
		link.download = 'Sample.csv';

		document.body.appendChild(link);
		link.click();
	}

	@api
	async importRows() {
		try {
			await importQuoteItems({
				quoteId: this.quoteId,
				startSequence: this.atRow,
				rows: this.parsedRows.map((parsedRow) => {
					const productName = parsedRow[this.productNameFieldName];
					const row = { ...parsedRow };
					delete row.rowNumber;
					delete row[this.productNameFieldName];

					return { productName, quoteItem: { ...row } };
				}),
			});

			this.messageService.publish({ key: 'reloadgrid' });
			this.messageService.notifyClose();
		} catch (exception) {
			this.dispatchEvent(
				new ShowToastEvent({
					title: 'Failed to import',
					message: reduceErrors(exception).join(', '),
					variant: 'error',
				}),
			);
		}
	}
}
