const getContingenciesDialog = (quoteId, namespace) => {
	const dialogServicePayload = {
		method: 'bodyModalLarge',
		config: {
			auraId: 'manage-fixed-bid-adjustment',
			headerLabel: 'Manage contingencies',
			component: `${namespace}:quoteDiscounting`,
			componentParams: {
				recordId: quoteId,
				discountName: 'Contingency',
				discountMethod: 'Contingency',
				isMarkup: true,
			},
			footerActions: [
				{ label: 'Close', eventName: 'close', class: '' },
				{ label: 'Save', eventName: 'c.saveTotalsAndClose', class: 'slds-button_brand' },
			],
		},
	};

	return dialogServicePayload;
};

const getColaDialog = (recordId, namespace, title) => {
	const dialogServicePayload = {
		method: 'bodyModalLarge',
		config: {
			auraId: 'cola-adjustment-dialog',
			headerLabel: title,
			component: `${namespace}:colaWorksheet`,
			componentParams: {
				quoteItems: [],
				periods: [],
				quoteId: recordId,
				saveAndClose: false,
			},
			footerActions: [
				{ label: 'Close', eventName: 'close', class: '' },
				{ label: 'Save', eventName: 'savecolaadjustments', class: 'slds-button_brand' },
			],
		},
	};

	return dialogServicePayload;
};

const getReviewVolumeDiscountsDialog = (recordId, namespace, title) => {
	const dialogServicePayload = {
		method: 'bodyModalLarge',
		config: {
			auraId: 'review-volume-discounts-dialog',
			headerLabel: title,
			component: `${namespace}:reviewVolumeDiscounts`,
			componentParams: {
				quoteId: recordId,
			},
			footerActions: [
				{ label: 'Close', eventName: 'close', class: '' },
			],
		},
	};

	return dialogServicePayload;
};

const getReviewLocationDiscountsDialog = (recordId, namespace, title) => {
	const dialogServicePayload = {
		method: 'bodyModalLarge',
		config: {
			auraId: 'review-location-discounts-dialog',
			headerLabel: title,
			component: `${namespace}:locationDiscountSummary`,
			componentParams: {
				quoteId: recordId,
			},
			footerActions: [
				{ label: 'Close', eventName: 'close', class: '' },
			],
		},
	};

	return dialogServicePayload;
};

/**
 * Launches the dialog for recurring hours
 *
 * @param action
 * @param selectedRange
 * @param options
 */
const getRecurringHoursDialog = (namespace, timePeriod, headerLabel, options) => {
	const componentName = 'recurringResourceDialog';
	const auraId = 'recurring-resource-dialog';
	const showCloseButton = !(options && options.showCloseButton === false);

	const dialogServicePayload = {
		method: 'bodyModalLarge',
		config: {
			auraId,
			headerLabel,
			showCloseButton,
			component: `${namespace}:${componentName}`,
			componentParams: {
				showCloseButton,
				recurringHoursTimePeriod: timePeriod,
			},
		},
	};

	return dialogServicePayload;
};

const getImportResourcesDialog = (namespace, headerLabel, quoteId, atRow) => ({
	method: 'bodyModal',
	config: {
		auraId: 'import-roles-dialog',
		headerLabel,
		component: `${namespace}:importDatatable`,
		componentParams: {
			quoteId,
			atRow,
		},
		footerActions: [
			{ label: 'Cancel', eventName: 'close', class: '' },
			{ label: 'Import', eventName: 'c.importRows', class: 'slds-button_brand' },
		],
	},
});

export {
	getContingenciesDialog, getColaDialog, getReviewVolumeDiscountsDialog,
	getReviewLocationDiscountsDialog, getRecurringHoursDialog, getImportResourcesDialog,
};
