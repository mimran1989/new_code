import IsScenariosEnabled from '@salesforce/apex/FeatureDecisions.isScenariosEnabled';
import commitChanges from '@salesforce/apex/QuoteCollaborationController.commitChanges';
import getCollaborationRequestsForQuote from '@salesforce/apex/QuoteCollaborationController.getCollaborationRequestsForQuote';
import mergeSections from '@salesforce/apex/QuoteCollaborationController.mergeSections';
import revokeSections from '@salesforce/apex/QuoteCollaborationController.revokeSections';
import getAllProductsForQuote from '@salesforce/apex/QuoteConfiguratorController.getAllProductsForQuote';
import getRateCardItemsForProduct from '@salesforce/apex/QuoteConfiguratorController.getAllRateCardItemsForProduct';
import getNamedRangesForQuote from '@salesforce/apex/QuoteConfiguratorController.getNamedRangesForQuote';
import getProjectPhasesForQuote from '@salesforce/apex/QuoteConfiguratorController.getProjectPhasesForQuote';
import getQuoteItemsForQuote from '@salesforce/apex/QuoteConfiguratorController.getQuoteItemsForQuote';
import getQuoteSectionsForQuote from '@salesforce/apex/QuoteConfiguratorController.getQuoteSectionsForQuote';
import getQuoteTemplate from '@salesforce/apex/QuoteConfiguratorController.getQuoteTemplate';
import shiftQuoteItemSection from '@salesforce/apex/QuoteItemSectionController.shiftQuoteItemSection';
import getColaRatesForQuote from '@salesforce/apex/AdjustColaRatesController.getColaRatesForQuote';
import NamespacePrefix from '@salesforce/apex/SystemUtility.getNamespacePrefix';
import hasQuoteLocationDiscountPermission from '@salesforce/customPermission/QuoteLocationDiscount';
import hasQuoteVolumeDiscountSummaryPermission from '@salesforce/customPermission/QuoteVolumeDiscountSummary';

// labels
import LABEL_ADD_RESOURCE from '@salesforce/label/c.AddResource';
import LABEL_COLA_ADJUSTMENT_WORKSHEET from '@salesforce/label/c.ColaAdjustmentWorkSheet';
import LABEL_VOLUME_DISCOUNT_SUMMARY from '@salesforce/label/c.VolumeDiscountSummary';
import LABEL_ADD_RECURRING_HOURS from '@salesforce/label/c.AddRecurringHours';
import LABEL_ADD_PERIODS from '@salesforce/label/c.AddPeriods';
import LABEL_COLLABORATION_COMMITTED from '@salesforce/label/c.CollaborationCommitted';
import LABEL_COLLABORATION_MERGED from '@salesforce/label/c.CollaborationMerged';
import LABEL_COMMIT from '@salesforce/label/c.Commit';
import LABEL_CLOSE from '@salesforce/label/c.CloseButton';
import LABEL_DEFAULT_SECTION from '@salesforce/label/c.DefaultSection';
import LABEL_DISCOUNT_PERCENT from '@salesforce/label/c.DiscountPercent';
import LABEL_EDIT_RESOURCE from '@salesforce/label/c.EditResource';
import LABEL_EDIT_SECTION from '@salesforce/label/c.EditSection';
import LABEL_GRAND_TOTAL from '@salesforce/label/c.GrandTotal';
import LABEL_GRAND_TOTAL_PERSON from '@salesforce/label/c.GrandTotalPerson';
import LABEL_HIDE_METRICS from '@salesforce/label/c.HideMetrics';
import LABEL_HIDE_PRICING_ATTRIBUTES from '@salesforce/label/c.HidePricingAttributes';
import LABEL_HIDE_QUOTE_ITEMS from '@salesforce/label/c.HideQuoteItems';
import LABEL_HIDE_RATE_ATTRIBUTES from '@salesforce/label/c.HideRateAttributes';
import LABEL_HIDE_TOTALS from '@salesforce/label/c.HideTotals';
import LABEL_MERGE from '@salesforce/label/c.Merge';
import LABEL_REVIEW_COLA from '@salesforce/label/c.ReviewCola';
import LABEL_REVIEW_VOLUME_DISCOUNTS from '@salesforce/label/c.ReviewVolumeDiscounts';
import LABEL_ROLE from '@salesforce/label/c.Role';
import LABEL_SECTION from '@salesforce/label/c.Section';
import LABEL_SHOW_METRICS from '@salesforce/label/c.ShowMetrics';
import LABEL_SHOW_PRICING_ATTRIBUTES from '@salesforce/label/c.ShowPricingAttributes';
import LABEL_SHOW_QUOTE_ITEMS from '@salesforce/label/c.ShowQuoteItems';
import LABEL_SHOW_RATE_ATTRIBUTES from '@salesforce/label/c.ShowRateAttributes';
import LABEL_SHOW_TOTALS from '@salesforce/label/c.ShowTotals';
import LABEL_START_PERIOD from '@salesforce/label/c.StartPeriod';
import LABEL_TOTAL from '@salesforce/label/c.Total';
import LABEL_ACTIVITIES_TASKS from '@salesforce/label/c.ActivitiesAndTasks';
import LABEL_REVIEW_LOCATION_DISCOUNTS from '@salesforce/label/c.ReviewLocationDiscounts';
import LABEL_IMPORT_RESOURCES from '@salesforce/label/c.ImportResources';
import baseJS from '@salesforce/resourceUrl/Provus';
import QUOTE_ITEM_OBJECT from '@salesforce/schema/QuoteItem__c';
import QUOTE_ITEM_ADJUSTED_UNIT_PRICE_FIELD from '@salesforce/schema/QuoteItem__c.AdjustedUnitPrice__c';
import QUOTE_ITEM_LINE_TYPE_FIELD from '@salesforce/schema/QuoteItem__c.LineType__c';
import QUOTE_ITEM_LOCATION_COUNTRY_FIELD from '@salesforce/schema/QuoteItem__c.LocationCountry__c';
import QUOTE_ITEM_LOCATION_DISPLAY_NAME_FIELD from '@salesforce/schema/QuoteItem__c.LocationDisplayName__c';
import QUOTE_ITEM_MARGIN_PERCENT_FIELD from '@salesforce/schema/QuoteItem__c.MarginPercent__c';
import QUOTE_ITEM_NETEXTENDEDAMOUNT_FIELD from '@salesforce/schema/QuoteItem__c.NetExtendedAmount__c';
import QUOTE_ITEM_NETEXTENDEDCOST_FIELD from '@salesforce/schema/QuoteItem__c.NetExtendedCost__c';
import QUOTE_ITEM_NONBILLABLE_FIELD from '@salesforce/schema/QuoteItem__c.NonBillable__c';
import QUOTE_ITEM_QUANTITY_FIELD from '@salesforce/schema/QuoteItem__c.Quantity__c';
import QUOTE_ITEM_ROLE_NAME_OVERRIDE_FIELD from '@salesforce/schema/QuoteItem__c.RoleNameOverride__c';
import QUOTE_ITEM_SKILL_LEVEL_FIELD from '@salesforce/schema/QuoteItem__c.SkillLevel__c';
import QUOTE_ITEM_UNIT_COST_FIELD from '@salesforce/schema/QuoteItem__c.UnitCost__c';
import QUOTE_ITEM_UNIT_PRICE_FIELD from '@salesforce/schema/QuoteItem__c.UnitPrice__c';
import QUOTE_ITEM_RATE_CARD_ITEM_FIELD from '@salesforce/schema/QuoteItem__c.RateCardItemId__c';

// schema
import QUOTE_OBJECT from '@salesforce/schema/Quote__c';
import RATE_CARD_ITEM_OBJECT from '@salesforce/schema/RateCardItem__c';
import RATE_CARD_ITEM_PRICE_UOM_FIELD from '@salesforce/schema/RateCardItem__c.PriceUOM__c';
import RATE_CARD_ITEM_PRODUCT_FIELD from '@salesforce/schema/RateCardItem__c.ProductId__c';
import RATE_CARD_ITEM_LOCATION_COUNTRY_FIELD from '@salesforce/schema/RateCardItem__c.LocationCountry__c';
import RATE_CARD_ITEM_LOCATION_STATE_PROVINCE_FIELD from '@salesforce/schema/RateCardItem__c.LocationStateProvince__c';
import RATE_CARD_ITEM_LOCATION_CITY_FIELD from '@salesforce/schema/RateCardItem__c.LocationCity__c';
import {
	CollaborationRequest,
	ColumnGroup,
	ContextMenuActions,
	LaborUnits,
	OBSERVER_NAME_SFDC,
	Quote,
	RateCardItem,
	RecordType,
	ScheduleSettingFields,
} from 'c/constantUtil';
import LinkedList from 'c/linkedList';
import log from 'c/log';
import { reduceErrors } from 'c/sparkUtils';
import {
	componentNamespace, isEmpty, isNullOrUndefined, getYearFromDate,
} from 'c/util';
import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import {
	api, LightningElement, track, wire,
} from 'lwc';
import VolumeDiscountAdjustment from 'c/volumeDiscountAdjustment';
import LocationDiscountAdjustment from 'c/locationDiscountAdjustment';
import QuoteItemsDataService from 'c/quoteItemsDataService';

// internal imports
import ContextMenu from './contextMenu';
import { beforeRowMove, onColumnDrag, onMouseOver } from './gridCallbacks';
import {
	firstValueIndex, flattenPeriodGroups, generatePeriodColumnMetadata, shiftableAmount,
} from './periodSupport';
import updateRecurringHours from './recurringHoursSupport';
import {
	getContingenciesDialog, getColaDialog, getReviewVolumeDiscountsDialog, getReviewLocationDiscountsDialog,
	getRecurringHoursDialog, getImportResourcesDialog,
} from './dialogSupport';

const rateCardRNameField = QUOTE_ITEM_RATE_CARD_ITEM_FIELD.fieldApiName.replace('__c', '__r');

export default class QuoteConfigurator extends LightningElement {
	@api recordId;
	@api isReadOnly;
	@track isNameModalOpen = false;
	@track isMetricsAvailable = false;
	@wire(NamespacePrefix) nsPrefix;
	_volumeDiscountAdjustment = new VolumeDiscountAdjustment();
	_locationDiscountAdjustment = new LocationDiscountAdjustment();
	_isReadOnly = this.isReadOnly;
	hideResourceRole = true;
	rateCardId;
	estimateId;
	group;
	practice;
	namespace;

	Label = {
		ADD_PERIODS: LABEL_ADD_PERIODS,
		START_PERIOD: LABEL_START_PERIOD,
	}

	render = Date.now();

	currencyISOCode;
	currencyConversionRatio;

	ComponentId = 'quoteGrid';

	rows = new LinkedList();
	grid;
	loading = true;
	quoteProducts;
	productsById = {};
	rateCardItems = {};
	columnMetadata;
	rowMetadata = [];

	onMessage;

	gridURL = `${baseJS}/grid/index.html`;
	periods = [];
	periodsByGroup;
	periodGroups = {};
	periodsBySequence = {};
	baseItemSequenceNumber = 0;
	baseSectionSequenceNumber = 0;

	modifiedColumns = {};

	laborUnits;
	quoteTimePeriod;
	sectionHierarchy;
	selectedRange;
	dialogActionLabel;
	dialogInputTitle;
	dialogInputPlaceholder;
	dialogInitialValue;
	startPeriodOptions;
	startPeriod;
	isModalActionInProgress;
	loaded = false;
	quoteItems = {};
	quoteItemsByLineSeq;
	sections = {};
	rootItems = [];
	renderingGrid = false;
	showColaRatesMenu = false;

	collaborationRequests = [];

	quoteItemNamedRanges = {};
	quoteItemPeriodGroupNamedRanges = {};
	namedRanges = {};
	disableAdjustment = false;
	_gridUpdateChannel;
	_componentState;
	_quoteService;
	_columnsByName;
	_phases = [];
	_phasesById = {};
	_phaseNamedRanges = {};
	_quoteTotals;
	_rateCardColumnCount = 0;

	initPromise;
	disableButton = true;

	@track
	primaryActions;

	@track
	viewSettings = {
		cola: {
			label: LABEL_REVIEW_COLA,
			isVisible: true,
		},
		reviewVolumeDiscounts: {
			label: LABEL_REVIEW_VOLUME_DISCOUNTS,
			isVisible: hasQuoteVolumeDiscountSummaryPermission,
		},
		quoteItems: {
			label: LABEL_HIDE_QUOTE_ITEMS,
			isVisible: true,
		},
		totals: {
			label: LABEL_HIDE_TOTALS,
			isVisible: true,
		},
		rateAttributes: {
			label: LABEL_HIDE_RATE_ATTRIBUTES,
			isVisible: true,
		},
		pricingAttributes: {
			label: LABEL_HIDE_PRICING_ATTRIBUTES,
			isVisible: true,
		},
		metrics: {
			label: LABEL_SHOW_METRICS,
			isVisible: false,
		},
		reviewLocationDiscounts: {
			label: LABEL_REVIEW_LOCATION_DISCOUNTS,
			isVisible: hasQuoteLocationDiscountPermission,
		},
	};

	get quoteRecordId() {
		return this.recordId;
	}

	groupedTotals = {};

	get quoteNamedRange() {
		return this._quoteTotals.laborTotal;
	}

	get unbilledQuoteNamedRange() {
		return this._quoteTotals.unbilledLaborTotal;
	}

	disableSections() {
		return !this.sectionHierarchy;
	}

	publishGridTotalChange() {
		const payload = Object.values(this.groupedTotals);
		this._gridUpdateChannel.publish({ key: 'totalschange', value: payload });
	}

	handleStateReport(event) {
		const { reporter, status } = event.detail.value;
		if (reporter === 'quoteMetrics') {
			this.viewSettings.metrics.isVisible = status.visible;
			this.isMetricsAvailable = true;
		}
	}

	handleDeselect() {
		this.grid.deselectCell();
	}

	handleStatusRequest() {
		const payload = {
			reporter: this.ComponentId,
			status: {
				visible: !this.isHidden,
			},
		};

		this._componentState.publish({ key: 'report', value: payload });
	}

	async handleInvite() {
		await this.reloadCollaborationRequests();
		this.refreshGrid();
	}

	@wire(getObjectInfo, { objectApiName: QUOTE_OBJECT })
	quoteSchema;

	@wire(IsScenariosEnabled) _isScenariosEnabled;

	get isScenariosEnabled() {
		return this._isScenariosEnabled?.data;
	}

	constructor() {
		super();
		const self = this;

		const commit = {
			get enabled() { return self.hasOutstandingRequests(); },
			get visible() { return self.isCollaborationQuote(); },
			get showEnabled() { return this.visible && this.enabled; },
			get showDisabled() { return this.visible && !this.enabled; },
			label: LABEL_COMMIT,
			dataId: 'button-commit',
			handler: self.handleCommit,
		};

		const merge = {
			enabled: false,
			visible: false,
			get showEnabled() { return this.visible && this.enabled; },
			get showDisabled() { return this.visible && !this.enabled; },
			label: LABEL_MERGE,
			dataId: 'button-merge',
			handler: self.handleQuoteMerge,
		};

		this.actionsMap = {
			commit,
			merge,
		};

		this.primaryActions = [
			commit,
			merge,
		];
	}

	get channel() {
		let channel;
		if (this.nsPrefix.data !== undefined) {
			channel = `${this.nsPrefix.data}QuoteUpdate__e`;
		}

		return channel;
	}

	async connectedCallback() {
		const component = this;
		this.namespace = componentNamespace(this);
		this.onMessage = (() => async() => {
			await component.reloadCollaborationRequests();

			if (this.hasRequestsToMerge()) {
				component.actionsMap.merge.visible = component.actionsMap.merge.enabled; // show only when enabled
			}

			await this.refreshGrid();
			component.rerender();
		})();
		this.gridLibraryPromise = Promise.all([
			loadScript(this, `${baseJS}/grid/index.js`),
			loadScript(this, `${baseJS}/data/index.js`),
		]);
	}

	async renderedCallback() {
		if (!this.loaded) {
			this.loaded = true;
			this._gridUpdateChannel = this.template.querySelector('.grid-update');
			this._componentState = this.template.querySelector('.component-state');
			this._quoteService = this.template.querySelector('c-quote-service');
			this._quoteTotals = this.template.querySelector('.quote-totals');
			this._colaAdjustment = this.template.querySelector('c-cola-adjustment');

			// request the visibility of the connected components
			this._componentState.publish({ key: 'status', value: { receiver: null } });

			if (!this.initPromise) {
				await this.gridLibraryPromise;
				this.initPromise = await this.loadData(this.recordId);
			}
		}

		this.loading = false;
	}

	async initializeFrame() {
		if (!this.initPromise) {
			await this.gridLibraryPromise;
			this.initPromise = await this.loadData(this.recordId);
		}

		const data = await this.initPromise;
		this.initPromise = null;

		const container = this.template.querySelector('iframe');
		const { options, metadata, hasAddOns } = data;

		this.grid = await Provus.Grid.forFrame(container, this.origin);
		this.grid.onMovePeriods((...args) => this.onMovePeriods(...args));

		await this.grid.init(options);

		await this.initializeCells(metadata, true, hasAddOns);

		// TODO -- optimize for the scenario use case
		await this.repriceAll();

		if (Object.keys(this.quoteItems).length > 0) {
			this.baseItemSequenceNumber = Math.max(
				...Object.values(this.quoteItems)
					.map((item) => item.lineSequence),
			) || this.baseItemSequenceNumber;
		}

		if (Object.keys(this.sections).length > 0) {
			this.baseSectionSequenceNumber = Math.max(
				...Object.values(this.sections)
					.map((section) => section.sequence),
			) || this.baseSectionSequenceNumber;
		}
	}

	findSectionFor(sectionId) {
		return Object.values(this.sections).find((nextSection) => nextSection.elementDO.id === sectionId);
	}

	async addRowsToSection(rowIdx, newChildItems) {
		if (this.sectionHierarchy) {
			// if rowIdx is zero then the assumption is we don't need to reparent anything and no targetMeta is needed
			const targetMeta = await this.grid.getCellMeta(rowIdx - 1, 0); // the highlighted row is above the row index
			const targetRow = this.sections[targetMeta.$id] || this.quoteItems[targetMeta.$id];
			const parentSection = this.sections[targetMeta.$id] || targetRow?.parent;

			// item no longer belongs to a section
			newChildItems.forEach((nextItem) => {
				if (parentSection) {
					nextItem.setParent(parentSection);
				} else {
					nextItem.parent?.removeChild(nextItem);
				}
			});
		}

		this.assignChildren();

		await this.toggleTotalAmount();
		// quote attribute issue fix
		this.viewSettings.rateAttributes.isVisible = false;
		await this.handleToggleRateAttributes();

		this.viewSettings.pricingAttributes.isVisible = false;
		await this.handleTogglePricingAttributes();

		this.viewSettings.quoteItems.isVisible = false;
		await this.handleToggleQuoteItems();
	}

	async refreshGrid() {
		const columns = this.buildColumnMetadata();
		const { data, metadata } = await this.buildRows();
		const mergeCells = this.buildMergeCells(metadata);
		const cellOptions = this.buildCellOptions(metadata);

		this.renderingGrid = true;
		await this.grid.updateSettings({
			cell: cellOptions,
			columns,
			data,
			mergeCells,
			nestedHeaders: this.getColumnHeaders(), // nestedRows: true,
		});

		await this.initializeCells(metadata, true);
		this.renderingGrid = false;
	}

	newQuoteItem(quoteItemDO = this.newQuoteItemDO()) {
		const quoteItem = Provus.QuoteItem.for(quoteItemDO);
		quoteItem.insert();

		this.quoteItems[quoteItem.$id] = quoteItem;
		QuoteItemsDataService.setQuoteItem(quoteItem.$id, quoteItem);
		this.quoteItemsByLineSeq[quoteItem.lineSequence] = quoteItem;

		const { sectionId } = quoteItem.elementDO.quoteItemSO;
		if (sectionId) {
			const section = this.findSectionFor(sectionId);
			if (section) {
				section.addQuoteItem(quoteItem);
			}
		}

		return quoteItem;
	}

	async afterCreateRow(createdAt, numberOfRows) {
		await this.addRowsToSection(createdAt, this.spliceNewRows(createdAt, [...new Array(numberOfRows)]));
		await this.refreshGrid();
		await this.repriceAll();
		this._quoteService.saveSections();
	}

	spliceNewRows(at, rateCardItems = []) {
		const newItems = [];
		this.rowMetadata.splice(
			at,
			0,
			...rateCardItems.map((row, index) => {
				const quoteItem = this.newQuoteItem(this.newQuoteItemDO(row));
				newItems.push(quoteItem);

				this.grid.setCellMeta(at + index, 0, '$id', quoteItem.$id);
				return quoteItem.metadata();
			}),
		);

		return newItems;
	}

	async onMovePeriods(movedColumns, targetColumn) {
		if (movedColumns[0] !== targetColumn) {
			const lastRow = (await this.grid.countRows()) - 1;
			// get phase of the target column
			const { phase: targetPhase } = await this.grid.getCellMeta(lastRow, targetColumn);
			const targetPhaseMO = this._phasesById[targetPhase.$id];
			let isMoveable = true;
			for (let i = 0; i < movedColumns.length; i++) {
				const movedColumn = movedColumns[i];
				const { phase: movedPhase } = await this.grid.getCellMeta(lastRow, movedColumn);
				if (movedPhase) {
					const movedPhaseMO = this._phasesById[movedPhase.$id];
					if (movedPhaseMO === targetPhaseMO) {
						// cannot move within the same phase
						isMoveable = false;
						break;
					}
				}
			}

			if (isMoveable) {
				let updatedPhases = {};
				const movedRangeStart = movedColumns[0];
				const movedRangeEnd = movedColumns[movedColumns.length - 1];
				let rightToLeft = true;
				if (movedRangeStart > targetPhaseMO.endCol) {
					targetPhaseMO.endCol = movedColumns[movedColumns.length - 1];
					updatedPhases[targetPhaseMO.$id] = targetPhaseMO;
				} else if (movedRangeEnd < targetPhaseMO.endCol) {
					rightToLeft = false;
					[targetPhaseMO.startCol] = movedColumns;
					updatedPhases[targetPhaseMO.$id] = targetPhaseMO;
				}

				for (let i = 0; i < movedColumns.length; i++) {
					const movedColumn = movedColumns[i];
					const { phase: movedPhase } = await this.grid.getCellMeta(lastRow, movedColumn);
					if (movedPhase) {
						const movedPhaseMO = this._phasesById[movedPhase.$id];
						if (rightToLeft && movedColumn >= movedPhaseMO.startCol) {
							movedPhaseMO.startCol += 1;
							updatedPhases[movedPhaseMO.$id] = movedPhaseMO;
						} else if (!rightToLeft && movedColumn <= movedPhaseMO.endCol) {
							movedPhaseMO.endCol = movedColumn - 1;
							updatedPhases[movedPhaseMO.$id] = movedPhaseMO;
						}
					}
				}

				updatedPhases = Object.values(updatedPhases);

				for (let i = 0; i < updatedPhases.length; i++) {
					const updatedPhase = updatedPhases[i];
					const { startCol, endCol } = updatedPhase;
					const startColumnMeta = this.columnMetadata[startCol].data;
					const endColumnMeta = this.columnMetadata[endCol].data;
					const startPeriod = this.periods[Number(startColumnMeta) - 1];
					const endPeriod = this.periods[Number(endColumnMeta) - 1];

					updatedPhase.startDate = startPeriod?.startDate;
					updatedPhase.endDate = endPeriod?.endDate;
				}

				this._phases = this._phases.filter((phase) => phase.numberOfPeriods() > 0);

				for (let i = 0; i < movedColumns.length; i++) {
					const movedColumn = movedColumns[i];
					this.grid.setCellMeta(lastRow, movedColumn, 'phase', { $id: targetPhaseMO.$id });
				}

				await this.grid.updateSettings({
					nestedHeaders: this.getColumnHeaders(),
				});

				this._quoteService.savePhases();
			}
		}
	}

	addRowStyles(cellMetadata, rowIdx) {
		const styleMetaPromises = [];
		const hasSections = Object.values(this.sections).length > 0;

		const {
			isSectionFooter, isSectionHeader, isQuantityFooter, isAmountFooter,
		} = cellMetadata;

		if (hasSections) {
			if (!isSectionFooter && !isSectionHeader && !isQuantityFooter && !isAmountFooter) {
				styleMetaPromises.push(
					this.grid.setCellMeta(rowIdx, 0, 'className', 'sectionChildSectionColumn'),
				);
			}
		}

		return styleMetaPromises;
	}

	async repriceQuoteGrid() {
		if (this.rowMetadata.length || this._phases.length) {
			const rowCount = await this.grid.countRows();
			if (this.rowMetadata.length) {
				const rowsWhichNeedTotalsUpdate = [];
				const setMetadata = [];
				const totalsRowIdx = rowCount - 2;
				for (let i = 0; i < this.rowMetadata.length; i++) {
					const rowMeta = this.rowMetadata[i];

					const {
						isAmountFooter, isQuantityFooter, isSectionFooter, isSectionHeader,
					} = rowMeta;

					setMetadata.push(this.grid.setCellMetaObject(i, 0, rowMeta));

					if (!isSectionFooter && !isSectionHeader && !isAmountFooter && !isQuantityFooter) {
						setMetadata.push(this.setAvailablePracticeAndSkill(i), this.setPricePoints(i));

						if (i < totalsRowIdx) {
							rowsWhichNeedTotalsUpdate.push(i);
						}
					}
				}

				if (rowsWhichNeedTotalsUpdate.length) {
					await Promise.all(setMetadata).then(() => this.updateTotalsForRows(rowsWhichNeedTotalsUpdate));
				}
			}
		}
	}

	async initializeCells(cellMetadata, bypassQuoteTotals, hasAddOns) {
		if (cellMetadata.length || this._phases.length) {
			const rowCount = await this.grid.countRows();
			if (cellMetadata.length) {
				const { rowsWhichNeedTotalsUpdate, setMetadata } = await this.getRowsForReprice(cellMetadata, rowCount);
				if (rowsWhichNeedTotalsUpdate.length) {
					await Promise.all(setMetadata).then(() => this.updateTotalsForRows(rowsWhichNeedTotalsUpdate));
				}

				// refresh the charts and other related components
				this.publishGridTotalChange();

				const columnNames = {};
				this.columnMetadata.forEach((column) => {
					columnNames[column.data] = true;
				});

				await this.updateColumnsTotals(
					columnNames,
					bypassQuoteTotals,
					hasAddOns,
				);
			}

			// set phase metadata
			const lastRow = rowCount - 1;
			this._phases.forEach((phase) => {
				for (let i = phase.startCol; i < phase.endCol + 1; i++) {
					this.grid.setCellMeta(lastRow, i, 'phase', { $id: phase.$id });
				}
			});
		}
	}

	async getRowsForReprice(cellMetadata, rowCount) {
		const rowsWhichNeedTotalsUpdate = [];
		const setMetadata = [];
		const totalsRowIdx = rowCount - 2;
		for (let i = 0; i < cellMetadata.length; i++) {
			const rowMeta = cellMetadata[i];

			const {
				isAmountFooter, isQuantityFooter, isSectionFooter, isSectionHeader,
			} = rowMeta;

			setMetadata.push(this.grid.setCellMetaObject(i, 0, rowMeta));
			setMetadata.push(...this.addRowStyles(rowMeta, i));

			if (!isSectionFooter && !isSectionHeader && !isAmountFooter && !isQuantityFooter) {
				setMetadata.push(this.setAvailablePracticeAndSkill(i), this.setPricePoints(i));

				if (i < totalsRowIdx) {
					rowsWhichNeedTotalsUpdate.push(i);
				}
			} else {
				for (let j = 0; j < this.columnMetadata.length; j++) {
					setMetadata.push(this.grid.setCellMetaObject(i, j, cellMetadata[i]));
				}
			}
		}

		return {
			rowsWhichNeedTotalsUpdate,
			setMetadata,
		};
	}

	async onChange(changes, context) {
		const isSetPricePoints = context === 'setPricePoints';
		if (!isSetPricePoints && this.loaded && !this.renderingGrid) {
			if (changes) {
				const totalsRowIdx = (await this.grid.countRows()) - 2;
				const updateGrid = [];
				const changedRows = {};
				const modifiedColumns = {};
				const quoteItemsByRowIdx = {};
				for (let i = 0; i < changes.length; i++) {
					const [row, prop, oldValue, newValue] = changes[i];
					if (totalsRowIdx > row) {
						// ignore updates to the totals row
						if (oldValue !== newValue) {
							const { isSectionFooter, isSectionHeader } = await this.grid.getCellMeta(row, 0);
							const { readOnly } = this.getColumnMetadata(prop);
							if (!isSectionFooter && !isSectionHeader && !readOnly) {
								let quoteItem = quoteItemsByRowIdx[row];
								if (!quoteItem) {
									quoteItem = await this.getQuoteItemForRow(row);

									if (!quoteItem) {
										quoteItem = Provus.QuoteItem.for(this.newQuoteItemDO());

										this.quoteItems[quoteItem.$id] = quoteItem;
										QuoteItemsDataService.setQuoteItem(quoteItem.$id, quoteItem);
										this.quoteItemsByLineSeq[quoteItem.lineSequence] = quoteItem;
										await this.grid.setCellMeta(row, 0, '$id', quoteItem.$id);
									}

									quoteItemsByRowIdx[row] = quoteItem;
								}

								const columnMetadata = this.getColumnMetadata(prop);
								const nonBillable = quoteItem.quoteItemSO[QUOTE_ITEM_NONBILLABLE_FIELD.fieldApiName];
								if (columnMetadata.isPeriod) {
									quoteItem.periodValueMap[prop] = newValue;
								} else if (prop === QUOTE_ITEM_ADJUSTED_UNIT_PRICE_FIELD.fieldApiName && !nonBillable) {
									quoteItem.quoteItemSO[QUOTE_ITEM_ADJUSTED_UNIT_PRICE_FIELD.fieldApiName] = newValue;
									quoteItem.adjustment.amount = null;
									quoteItem.adjustment.type = null;
								} else if (prop === 'baseAdjustmentAmount') {
									quoteItem.adjustment.amount = newValue;
									quoteItem.adjustment.type = '% Discount';
									quoteItem.quoteItemSO[QUOTE_ITEM_ADJUSTED_UNIT_PRICE_FIELD.fieldApiName] = null;
								} else if (prop.indexOf('__mdt') < 0) {
									quoteItem.quoteItemSO[prop] = newValue;
								}

								changedRows[row] = true;
								// checks whether the old value is set or not
								modifiedColumns[prop] = !!oldValue;
							}
						}
					}
				}

				const modifiedRowIndices = [];

				Object.keys(changedRows).forEach((row) => {
					const rowIdx = Number(row);
					modifiedRowIndices.push(rowIdx);

					updateGrid.push(
						this.setAvailablePracticeAndSkill(rowIdx).then(() => this.updateRateCardItemAttributes(rowIdx)),
						this.setPricePoints(rowIdx),
					);
				});

				if (Object.keys(changedRows).length) {
					await Promise.all(updateGrid);
					await this.updateTotalsForRows(modifiedRowIndices);

					this.modifiedColumns = { ...this.modifiedColumns, ...modifiedColumns };
					this.commitChanges();
				}
			}
		}
	}

	async commitChanges() {
		this.publishGridTotalChange();
		await this.updateSectionTotals();

		const { modifiedColumns } = this;
		this.modifiedColumns = {};

		// TODO: Update columns is calling a setDataAtRowProp() that basically boots us
		// out in the middle of an edit. Need to figure out how to fix it.
		if (modifiedColumns[QUOTE_ITEM_LOCATION_DISPLAY_NAME_FIELD.fieldApiName]) {
			await this.recomputeColumnTotals();
		} else {
			await this.updateColumnsTotals(modifiedColumns);
		}

		await this.updatePeriodGroupTotals();
		this._quoteService.saveLines().catch((e) => {
			log('Failed to save lines ');
			log(e);
		});
		await this.applyAdjustments();
		await this._quoteTotals.saveTotals(true);
	}

	async applyAdjustments() {
		await this._colaAdjustment.saveCostAdjustment();
		await this.updateVolumeDiscountAdjustments();
		await this.updateLocationDiscountAdjustments();
	}

	async updateLocationDiscountAdjustments() {
		const laborAmountNamedRange = await this._quoteTotals.laborTotal;
		const quoteItemsNamedRanges = await this._quoteTotals.quoteItemTotals();

		const namedRanges = {
			laborAmount: laborAmountNamedRange,
			quoteItems: quoteItemsNamedRanges,
		};

		await this._locationDiscountAdjustment.updateLocationDiscountAdjustments({
			quoteId: this.recordId,
			namedRanges,
		});
	}

	async updateVolumeDiscountAdjustments() {
		const laborAmountNamedRange = await this._quoteTotals.laborTotal;
		const periodNamedRanges = await this._quoteTotals.periodTotals;
		const periodGroupNamedRanges = await this._quoteTotals.quotePeriodGroupTotals;

		const namedRanges = {
			laborAmount: laborAmountNamedRange,
			periods: periodNamedRanges,
			periodGroups: periodGroupNamedRanges,
		};

		await this._volumeDiscountAdjustment.updateVolumeDiscountAdjustment({
			quoteId: this.recordId,
			namedRanges,
		});
	}

	async updateRateCardItemAttributes(row) {
		const columnsToUpdate = [];
		const quoteItem = await this.getQuoteItemForRow(row);
		const rateCardAttributes = this.getRateCardAttributes();
		rateCardAttributes.forEach((rateCardAttribute) => {
			const { fieldName } = rateCardAttribute;
			columnsToUpdate.push([row, fieldName, quoteItem.quoteItemSO[fieldName]]);
		});

		this.grid.setDataAtRowProp(columnsToUpdate);
	}

	newQuoteItemDO(rateCardItem) {
		const quoteItemSO = {};
		quoteItemSO[QUOTE_ITEM_LINE_TYPE_FIELD.fieldApiName] = 'Resource';
		quoteItemSO[rateCardRNameField] = rateCardItem;

		const adjustment = {};

		const quoteItemDO = {
			rateCardItemId: rateCardItem?.Id,
			productId: rateCardItem && rateCardItem[RATE_CARD_ITEM_PRODUCT_FIELD.fieldApiName],
			lineSequence: this.getNextItemSequenceNumber(),
			periodValueMap: {},
			quoteItemSO,
			adjustment,
			location: {
				country: rateCardItem && rateCardItem[RATE_CARD_ITEM_LOCATION_COUNTRY_FIELD.fieldApiName],
				state: rateCardItem && rateCardItem[RATE_CARD_ITEM_LOCATION_STATE_PROVINCE_FIELD.fieldApiName],
				city: rateCardItem && rateCardItem[RATE_CARD_ITEM_LOCATION_CITY_FIELD.fieldApiName],
			},
		};

		if (rateCardItem) {
			const rateCardAttributes = this.getRateCardAttributes();
			rateCardAttributes.forEach((rateCardAttribute) => {
				const { fieldName } = rateCardAttribute;
				quoteItemSO[fieldName] = rateCardItem[fieldName];
			});
		}

		return quoteItemDO;
	}

	async updateQuoteTotal(
		deltaPrice,
		deltaQty,
		deltaCost,
		unbilledPrice = 0,
		unbilledQty = 0,
		unbilledCost = 0,
	) {
		if (deltaPrice !== 0
				|| deltaQty !== 0
				|| deltaCost !== 0
				|| unbilledPrice !== 0
				|| unbilledQty !== 0
				|| unbilledCost !== 0
		) {
			const rowCount = await this.grid.countRows();
			let unbilledQuoteNamedRange = await this.unbilledQuoteNamedRange;
			if (!unbilledQuoteNamedRange) {
				unbilledQuoteNamedRange = (await this._quoteTotals.newNamedRangeForUnbilledLabor())[0].namedRange;
			}

			const { relatedTotal } = await this.quoteNamedRange;
			relatedTotal.baseExtendedAmount += +deltaPrice;
			relatedTotal.adjustedBaseAmount = relatedTotal.baseExtendedAmount;
			relatedTotal.baseExtendedCost += +deltaCost;
			relatedTotal.totalQuantity += +deltaQty;

			// set the named range for unbilled labor ( no delta totaling for non-billable)
			const { relatedTotal: unbilledRelatedTotal } = unbilledQuoteNamedRange;
			unbilledRelatedTotal.baseExtendedAmount = unbilledPrice;
			unbilledRelatedTotal.adjustedBaseAmount = unbilledPrice;
			unbilledRelatedTotal.baseExtendedCost = unbilledCost;
			unbilledRelatedTotal.totalQuantity = unbilledQty;

			this.grid.setDataAtRowProp([
				[rowCount - 1, 'NamedRange__GrandTotal__mdt', relatedTotal.baseExtendedAmount],
				[rowCount - 2, 'NamedRange__GrandTotalPerson__mdt', relatedTotal.totalQuantity],
			]);
		}
	}

	async updateColumnsTotals(modifiedColumns, bypassGrandTotals, hasAddOns) {
		const columnTotalUpdates = {};
		const modifiedColumnNames = Object.keys(modifiedColumns);

		const isPriceModified = modifiedColumnNames.indexOf('baseAdjustmentAmount') > -1
			|| modifiedColumnNames.indexOf(QUOTE_ITEM_ADJUSTED_UNIT_PRICE_FIELD.fieldApiName) > -1;

		if (isPriceModified === true) {
			const periodGroupIds = Object.keys(this.periodsByGroup);
			let periodColIdx = this.periodColumnsOffset();
			for (let i = 0; i < periodGroupIds.length; i++) {
				const periods = this.periodsByGroup[periodGroupIds[i]];
				for (let j = 0; j < periods.length; j++) {
					columnTotalUpdates[periodColIdx] = this.updateColumnTotal(
						this.columnMetadata[periodColIdx].data,
						periodColIdx,
					);
					periodColIdx += 1;
				}

				// Add one for the period group totals column
				periodColIdx += 1;
			}
		} else {
			for (let i = 0; i < modifiedColumnNames.length; i++) {
				const columnAPIName = modifiedColumnNames[i];
				// eslint-disable-next-line no-await-in-loop
				const colIdx = await this.grid.propToCol(columnAPIName);
				if (colIdx >= this.periodColumnsOffset()) {
					columnTotalUpdates[colIdx] = this.updateColumnTotal(columnAPIName, colIdx);
				}
			}
		}

		let result;
		const updateResults = Object.values(columnTotalUpdates);
		if (updateResults.length) {
			const columnsToUpdate = await Promise.all(updateResults);
			const newValues = [];
			let deltaPrice = 0;
			let deltaQty = 0;
			let deltaCost = 0;
			let deltaUnbilledPrice = 0;
			let deltaUnbilledQty = 0;
			let deltaUnbilledCost = 0;
			for (let i = 0; i < Object.keys(columnTotalUpdates).length; i++) {
				const { columnUpdates, delta } = columnsToUpdate[i];
				newValues.push(...columnUpdates);
				deltaPrice += delta.TotalPrice;
				deltaQty += delta.HeadCount;
				deltaCost += delta.TotalCost;
				deltaUnbilledPrice += (delta.UnbilledTotal || 0);
				deltaUnbilledQty += (delta.UnbilledHeadcount || 0);
				deltaUnbilledCost += (delta.UnbilledCost || 0);
			}

			result = this.grid.setDataAtRowProp(newValues);

			const quoteNamedRange = await this.quoteNamedRange;
			if (bypassGrandTotals !== true) {
				await this.updateQuoteTotal(
					deltaPrice,
					deltaQty,
					deltaCost,
					deltaUnbilledPrice,
					deltaUnbilledQty,
					deltaUnbilledCost,
				);
			} else if (quoteNamedRange && hasAddOns !== true) {
				const { relatedTotal } = quoteNamedRange;
				const previousQty = +relatedTotal.totalQuantity;
				const previousTotal = +relatedTotal.baseExtendedAmount;
				const previousCost = +relatedTotal.baseExtendedCost;
				let previousUnbilledQty = 0;
				let previousUnbilledTotal = 0;
				let previousUnbilledCost = 0;
				const unbilledQuoteNamedRange = await this.unbilledQuoteNamedRange;
				if (unbilledQuoteNamedRange) {
					const { relatedTotal: unbilledRelatedTotal } = unbilledQuoteNamedRange;
					previousUnbilledQty = +unbilledRelatedTotal.totalQuantity;
					previousUnbilledTotal = +unbilledRelatedTotal.baseExtendedAmount;
					previousUnbilledCost = +unbilledRelatedTotal.baseExtendedCost;
				}

				await this.updateQuoteTotal(
					deltaPrice - previousTotal,
					deltaQty - previousQty,
					deltaCost - previousCost,
					deltaUnbilledPrice - previousUnbilledTotal,
					deltaUnbilledQty - previousUnbilledQty,
					deltaUnbilledCost - previousUnbilledCost,
				);
			}
		}

		return result;
	}

	async updatePhaseTotals() {
		const phaseTotals = {};
		const lastRowIdx = (await this.grid.countRows()) - 1;
		for (let i = 0; i < this.columnMetadata.length; i++) {
			const { isPeriod } = this.columnMetadata[i];
			if (isPeriod) {
				const { phase } = await this.grid.getCellMeta(lastRowIdx, i);
				if (phase) {
					const phaseMO = this._phasesById[phase.$id];
					if (phaseMO.isPersisted()) {
						let totalsForPhase = phaseTotals[phase.$id];
						if (!totalsForPhase) {
							totalsForPhase = {
								totalCost: 0,
								marginPercent: 0,
								totalAmount: 0,
								totalQuantity: 0,
							};

							phaseTotals[phaseMO.$id] = totalsForPhase;
						}

						const periodTotal = (await this.grid.getDataAtCell(lastRowIdx, i)) || 0;
						const periodQty = (await this.grid.getDataAtCell(lastRowIdx - 1, i)) || 0;
						const periodCost = (await this.grid.getCellMeta(lastRowIdx - 1, i)).TotalCost || 0;

						totalsForPhase.baseExtendedAmount += periodTotal;
						totalsForPhase.totalCost += periodCost;
						totalsForPhase.totalQuantity += periodQty;
						totalsForPhase.marginPercent = QuoteConfigurator.marginPercentage(periodTotal, periodCost);
					}
				}
			}
		}

		const phaseIdsToUpdate = Object.keys(phaseTotals);
		for (let i = 0; i < phaseIdsToUpdate.length; i++) {
			const phaseTxnId = phaseIdsToUpdate[i];
			const phase = this._phasesById[phaseTxnId];
			const totalsForPhase = phaseTotals[phaseTxnId];
			let phaseNamedRange = this._phaseNamedRanges[phase.id];
			if (!phaseNamedRange) {
				phaseNamedRange = await this.newNamedRange({
					name: `Phase: ${phase.name}`,
					quoteId: this.recordId,
					projectPhaseId: phase.id,
					type: 'Project Phase',
				});
			}

			const { relatedTotal } = phaseNamedRange;
			relatedTotal.baseExtendedAmount = totalsForPhase.baseExtendedAmount;
			relatedTotal.adjustedBaseAmount = totalsForPhase.baseExtendedAmount;
			relatedTotal.totalQuantity = totalsForPhase.totalQuantity;
			relatedTotal.baseExtendedCost = totalsForPhase.totalCost;
			relatedTotal.marginPercent = QuoteConfigurator.marginPercentage(relatedTotal.baseExtendedAmount, relatedTotal.baseExtendedCost);
		}
	}
	async updateColumnTotal(columnAPIName, colIdx) {
		const rowCount = (await this.grid.countRows()) - 2;
		let columnTotal = 0;
		let headCountTotal = 0;
		let costTotal = 0;
		let unbilledTotal = 0;
		let unbilledCostTotal = 0;
		let unbilledHeadcountTotal = 0;
		const columnUpdates = [];
		for (let i = 0; i < rowCount; i++) {
			const meta = await this.grid.getCellMeta(i, colIdx);

			const {
				isSectionHeader, isSectionFooter, HeadCount, TotalPrice, TotalCost,
				UnbilledTotal, UnbilledCost, UnbilledHeadcount,
			} = meta;

			if (!isSectionHeader && !isSectionFooter) {
				headCountTotal += HeadCount || 0;
				columnTotal += TotalPrice || 0;
				costTotal += TotalCost || 0;
				unbilledTotal += UnbilledTotal || 0;
				unbilledCostTotal += UnbilledCost || 0;
				unbilledHeadcountTotal += UnbilledHeadcount || 0;
			}
		}

		const period = this.periods[Number(+columnAPIName - 1)];
		let periodTotal = await this._quoteTotals.periodTotal(period.id);
		if (!periodTotal) {
			periodTotal = await this._quoteTotals.newNamedRangeForPeriod(period);
			periodTotal[0].namedRange.name = `Period: ${columnAPIName}`;
			periodTotal = periodTotal[0].namedRange;
		}

		periodTotal.quotePeriodGroupId = period.periodGroupId;

		const { relatedTotal } = periodTotal;
		relatedTotal.baseExtendedAmount = columnTotal;
		relatedTotal.adjustedBaseAmount = columnTotal;
		relatedTotal.totalQuantity = headCountTotal;
		relatedTotal.baseExtendedCost = costTotal;

		const previousTotalAmount = (await this.grid.getDataAtRowProp(rowCount + 1, columnAPIName)) || 0;
		const previousTotalQty = (await this.grid.getDataAtRowProp(rowCount, columnAPIName)) || 0;
		const previousTotalCost = (await this.grid.getCellMeta(rowCount, colIdx)).TotalCost || 0;

		await this.grid.setCellMeta(rowCount, colIdx, 'TotalCost', costTotal);
		columnUpdates.push(
			[rowCount + 1, columnAPIName, columnTotal],
			[rowCount, columnAPIName, headCountTotal],
		);

		return {
			columnUpdates,
			delta: {
				TotalPrice: columnTotal - previousTotalAmount,
				HeadCount: headCountTotal - previousTotalQty,
				TotalCost: costTotal - previousTotalCost,
				UnbilledTotal: unbilledTotal,
				UnbilledCost: unbilledCostTotal,
				UnbilledHeadcount: unbilledHeadcountTotal,
			},
		};
	}

	getRateCardAttributes() {
		return this._quoteFields.filter((quoteField) => quoteField.sourceObject === RATE_CARD_ITEM_OBJECT.objectApiName);
	}

	async getSelectedRateCard(quoteItem) {
		let selectedRateCard;
		const { productId } = quoteItem;
		let rateCardItems = [];
		if (productId) {
			rateCardItems = await this.getRateCardItemsFor(productId);

			if (rateCardItems.length > 0) {
				selectedRateCard = rateCardItems.find((rateCardItem) => rateCardItem.Id === quoteItem.rateCardItemId);
			}
		}

		return selectedRateCard;
	}

	async setPricePoints(row, reset) {
		let quotedRate = 0;
		const quoteItem = await this.getQuoteItemForRow(row);
		if (reset) {
			quoteItem.quoteItemSO[QUOTE_ITEM_ADJUSTED_UNIT_PRICE_FIELD.fieldApiName] = null;
			quoteItem.adjustment.amount = null;
			quoteItem.adjustment.type = null;
		}

		const selectedRateCardItem = await this.getSelectedRateCard(quoteItem);
		// If rate card changes, wipe out any possible adjustments
		if (selectedRateCardItem?.Id !== quoteItem.rateCardItemId) {
			quoteItem.quoteItemSO[QUOTE_ITEM_ADJUSTED_UNIT_PRICE_FIELD.fieldApiName] = null;
			quoteItem.adjustment.amount = null;
		}

		quoteItem.rateCardItemId = selectedRateCardItem ? selectedRateCardItem.Id : null;

		if (selectedRateCardItem) {
			let unitPrice = parseFloat(selectedRateCardItem[QUOTE_ITEM_UNIT_PRICE_FIELD.fieldApiName]) * this.currencyConversionRatio;
			let unitCost = parseFloat(selectedRateCardItem[QUOTE_ITEM_UNIT_COST_FIELD.fieldApiName]) * this.currencyConversionRatio;
			const priceUom = selectedRateCardItem[RATE_CARD_ITEM_PRICE_UOM_FIELD.fieldApiName];
			// convert unit price and cost to hourly UOM
			let hourlyRateConversionFactor = 1;
			switch (priceUom) {
				case RateCardItem.PriceUom.DAILY:
					hourlyRateConversionFactor = this._scheduleSettings.standardDayHours;
					break;
				case RateCardItem.PriceUom.WEEKLY:
					hourlyRateConversionFactor = this._scheduleSettings.standardWeekHours;
					break;
				case RateCardItem.PriceUom.MONTHLY:
					hourlyRateConversionFactor = this._scheduleSettings.standardMonthHours;
					break;
				case RateCardItem.PriceUom.YEARLY:
					hourlyRateConversionFactor = this._scheduleSettings.standardYearHours;
					break;
				default: break;
			}

			// convert unit price and cost to hourly UOM
			const unitPricePerHour = unitPrice / hourlyRateConversionFactor;
			const unitCostPerHour = unitCost / hourlyRateConversionFactor;
			let numberOfHoursForTimePeriod = 1;
			switch (this.quoteTimePeriod) {
				case Quote.TimePeriod.DAYS:
					numberOfHoursForTimePeriod = this._scheduleSettings.standardDayHours;
					break;
				case Quote.TimePeriod.WEEKS:
					numberOfHoursForTimePeriod = this._scheduleSettings.standardWeekHours;
					break;
				case Quote.TimePeriod.MONTHS:
					numberOfHoursForTimePeriod = this._scheduleSettings.standardMonthHours;
					break;
				case Quote.TimePeriod.QUARTERS:
					numberOfHoursForTimePeriod = this._scheduleSettings.standardMonthHours * 3;
					break;
				default: // do nothing
			}

			// convert unit price and cost to hourly UOM
			unitPrice = unitPricePerHour * numberOfHoursForTimePeriod;
			unitCost = unitCostPerHour * numberOfHoursForTimePeriod;
			quotedRate = unitPrice;

			let discountPercentage = null;
			if (Number.isNaN(parseFloat(quoteItem.adjustment.amount))) {
				quoteItem.adjustment.amount = null;
			}

			const nonBillable = quoteItem.quoteItemSO[QUOTE_ITEM_NONBILLABLE_FIELD.fieldApiName];
			const adjustedUnitPrice = quoteItem.quoteItemSO[QUOTE_ITEM_ADJUSTED_UNIT_PRICE_FIELD.fieldApiName];
			const adjustedUnitPriceIsEmpty = QuoteConfigurator.isNullOrUndefined(adjustedUnitPrice);
			const baseAdjustmentAmountIsEmpty = QuoteConfigurator.isNullOrUndefined(quoteItem.adjustment.amount);
			// The user has changed either the discount or the quoted rate, recalculate using the given input value
			if (nonBillable) {
				quotedRate = 0;
			} else if (!adjustedUnitPriceIsEmpty && baseAdjustmentAmountIsEmpty) {
				quotedRate = parseFloat(adjustedUnitPrice);
				discountPercentage = QuoteConfigurator.marginPercentage(unitPrice, quotedRate);
				discountPercentage = discountPercentage === 0 ? null : discountPercentage;
			} else if (!baseAdjustmentAmountIsEmpty && adjustedUnitPriceIsEmpty) {
				discountPercentage = parseFloat(quoteItem.adjustment.amount);
				quotedRate = ((100 - discountPercentage) / 100) * unitPrice;
			} else if (!baseAdjustmentAmountIsEmpty && adjustedUnitPrice !== null) {
				discountPercentage = parseFloat(quoteItem.adjustment.amount);
				quotedRate = parseFloat(adjustedUnitPrice);
			}

			let marginPercent = null;
			if (unitCost !== null && quotedRate !== null) {
				marginPercent = QuoteConfigurator.marginPercentage(quotedRate, unitCost);
			}

			quoteItem.quoteItemSO[QUOTE_ITEM_MARGIN_PERCENT_FIELD.fieldApiName] = marginPercent;
			quoteItem.quoteItemSO[QUOTE_ITEM_LOCATION_COUNTRY_FIELD.fieldApiName] = selectedRateCardItem[QUOTE_ITEM_LOCATION_COUNTRY_FIELD.fieldApiName];
			quoteItem.quoteItemSO[QUOTE_ITEM_UNIT_PRICE_FIELD.fieldApiName] = unitPrice;

			if (nonBillable === true) { // when non-billable blank out adjusted unit price field
				quoteItem.quoteItemSO[QUOTE_ITEM_ADJUSTED_UNIT_PRICE_FIELD.fieldApiName] = 0;
			} else {
				quoteItem.quoteItemSO[QUOTE_ITEM_ADJUSTED_UNIT_PRICE_FIELD.fieldApiName] = quotedRate;
				quoteItem.adjustment.amount = discountPercentage;
			}

			quoteItem.quoteItemSO[QUOTE_ITEM_UNIT_COST_FIELD.fieldApiName] = unitCost;
		} else {
			quoteItem.quoteItemSO[QUOTE_ITEM_LOCATION_COUNTRY_FIELD.fieldApiName] = null;
			quoteItem.quoteItemSO[QUOTE_ITEM_UNIT_PRICE_FIELD.fieldApiName] = null;
			quoteItem.quoteItemSO[QUOTE_ITEM_ADJUSTED_UNIT_PRICE_FIELD.fieldApiName] = null;
			quoteItem.quoteItemSO[QUOTE_ITEM_UNIT_COST_FIELD.fieldApiName] = null;
			quoteItem.adjustment.amount = null;
			quoteItem.quoteItemSO[QUOTE_ITEM_MARGIN_PERCENT_FIELD.fieldApiName] = null;
		}

		const data = [
			[row, QUOTE_ITEM_UNIT_PRICE_FIELD.fieldApiName, quoteItem.quoteItemSO[QUOTE_ITEM_UNIT_PRICE_FIELD.fieldApiName]],
			[row, QUOTE_ITEM_ADJUSTED_UNIT_PRICE_FIELD.fieldApiName, quoteItem.quoteItemSO[QUOTE_ITEM_ADJUSTED_UNIT_PRICE_FIELD.fieldApiName]],
			[row, QUOTE_ITEM_UNIT_COST_FIELD.fieldApiName, quoteItem.quoteItemSO[QUOTE_ITEM_UNIT_COST_FIELD.fieldApiName]],
			[row, 'baseAdjustmentAmount', quoteItem.adjustment.amount],
			[row, QUOTE_ITEM_MARGIN_PERCENT_FIELD.fieldApiName, quoteItem.quoteItemSO[QUOTE_ITEM_MARGIN_PERCENT_FIELD.fieldApiName]],
		];

		this.grid.setDataAtRowProp(data, 'setPricePoints');
	}

	async getRateCardItemsFor(productId) {
		if (!this.rateCardItems[productId]) {
			this.rateCardItems[productId] = JSON.parse(
				await getRateCardItemsForProduct({
					quoteId: this.recordId,
					productId,
				}),
			).map((item) => item.fieldValueMap);
		}

		return this.rateCardItems[productId];
	}

	async getQuoteItemForRow(row) {
		const { $id } = await this.grid.getCellMeta(row, 0);
		return this.quoteItems[$id];
	}

	getPropIdx(propName) {
		return this.columnMetadata.findIndex((item) => item.data === propName);
	}

	getSelectedRateCardAttributes(quoteItem) {
		const rateCardAttributes = this.getRateCardAttributes();
		const selectedAttributes = [];
		for (let i = 0; i < rateCardAttributes.length; i++) {
			const { fieldName } = rateCardAttributes[i];
			const attributeValue = quoteItem[fieldName];
			if (!isNullOrUndefined(attributeValue)) {
				selectedAttributes.push(fieldName);
			}
		}

		return selectedAttributes;
	}

	async setAvailablePracticeAndSkill(row) {
		const quoteItem = await this.getQuoteItemForRow(row);
		const rateCardAttributes = this.getRateCardAttributes();
		const { productId } = quoteItem;
		const selectableValues = {};
		if (!productId) {
			// If no product is selected, then all values are selectable
			for (let i = 0; i < rateCardAttributes.length; i++) {
				const { fieldName, dataType, pickListValues } = rateCardAttributes[i];
				const isPicklist = dataType === 'PICKLIST';
				const optionsForAttribute = { '': true };
				if (isPicklist) {
					for (let j = 0; j < pickListValues.length; j++) {
						const picklistValue = pickListValues[j];
						optionsForAttribute[picklistValue] = true;
					}
				}

				selectableValues[fieldName] = optionsForAttribute;
			}
		} else {
			let validRateCards = await this.getRateCardItemsFor(productId);
			if (rateCardAttributes.length > 0) {
				validRateCards = validRateCards.filter((item) => {
					let matches = true;
					for (let i = 0; i < rateCardAttributes.length; i++) {
						const { fieldName } = rateCardAttributes[i];
						const attributeValue = quoteItem.quoteItemSO[fieldName] || '';
						matches = matches
							&& (attributeValue === ''
								|| (item[fieldName] || '') === attributeValue);
					}

					return matches;
				});

				for (let i = 0; i < rateCardAttributes.length; i++) {
					const { fieldName } = rateCardAttributes[i];
					const fieldMeta = this.getFieldMeta(QUOTE_ITEM_OBJECT.objectApiName, fieldName);
					let optionsForAttribute = selectableValues[fieldName];
					if (!optionsForAttribute) {
						optionsForAttribute = {};
						selectableValues[fieldName] = optionsForAttribute;
					}

					if (!fieldMeta || fieldMeta.dataType === 'PICKLIST') {
						optionsForAttribute[''] = true;
					}
				}
			}

			validRateCards.forEach((rateCard) => {
				for (let i = 0; i < rateCardAttributes.length; i++) {
					const { fieldName } = rateCardAttributes[i];
					const columnsMetadata = this.getColumnMetadata(fieldName);
					const optionsForAttribute = selectableValues[fieldName];
					const rateCardAttributeValue = rateCard[fieldName];
					const isPicklist = columnsMetadata.type === 'PICKLIST';
					if (!isPicklist || columnsMetadata.source.indexOf(rateCardAttributeValue) > -1) {
						optionsForAttribute[rateCardAttributeValue] = true;
					}
				}
			});
		}

		const attributesToUpdate = Object.keys(selectableValues);
		for (let i = 0; i < attributesToUpdate.length; i++) {
			const attributeName = attributesToUpdate[i];
			const selectableOptions = selectableValues[attributeName];
			const attributeColIdx = this.getPropIdx(attributeName);
			// Assumed that all atributes are displayed as a picklist
			await this.grid.setCellMeta(row, attributeColIdx, 'source', Object.keys(selectableOptions)
				.sort());
		}
	}

	getRateCardItemAttributeColumnMeta() {
		const columns = [];
		for (let i = 0; i < this._quoteFields.length; i++) {
			const fieldMetadata = this._quoteFields[i];

			const {
				dataType, fieldName, fieldLabel, sourceObject,
			} = fieldMetadata;

			if (sourceObject === RATE_CARD_ITEM_OBJECT.objectApiName) {
				const column = {
					group: ColumnGroup.RATE_ATTRIBUTE,
					data: fieldName,
					apiName: fieldName,
					type: 'text',
					label: fieldLabel,
					readOnly: true,
				};

				if (dataType === 'PICKLIST') {
					column.source = fieldMetadata.pickListValues;
				} else if (dataType === 'CURRENCY') {
					column.type = 'numeric';
					column.numericFormat = {
						pattern: '$0,0.00',
						culture: 'en-US',
					};
				}

				columns.push(column);
			}
		}

		this._rateCardColumnCount = columns.length;
		return columns;
	}

	getFieldMeta(forObject, forField) {
		if (!this._fieldsByTypeByName) {
			this._fieldsByTypeByName = {};

			for (let i = 0; i < this._quoteFields.length; i++) {
				const fieldMeta = this._quoteFields[i];
				const { sourceObject, fieldName } = fieldMeta;
				let fieldsForObject = this._fieldsByTypeByName[sourceObject];
				if (!fieldsForObject) {
					fieldsForObject = {};
					this._fieldsByTypeByName[sourceObject] = fieldsForObject;
				}

				fieldsForObject[fieldName] = fieldMeta;
			}
		}

		return this._fieldsByTypeByName[forObject] && this._fieldsByTypeByName[forObject][forField];
	}

	getPricingColumnMetadata() {
		return [{
			group: ColumnGroup.PRICING_ATTRIBUTE,
			data: QUOTE_ITEM_UNIT_PRICE_FIELD.fieldApiName,
			apiName: QUOTE_ITEM_UNIT_PRICE_FIELD.fieldApiName,
			type: 'numeric',
			label: this.getFieldMeta(QUOTE_ITEM_OBJECT.objectApiName, QUOTE_ITEM_UNIT_PRICE_FIELD.fieldApiName).fieldLabel,
			numericFormat: {
				pattern: '$0,0.00',
				culture: 'en-US',
			},
			readOnly: true,
		},
		{
			group: ColumnGroup.PRICING_ATTRIBUTE,
			data: QUOTE_ITEM_UNIT_COST_FIELD.fieldApiName,
			apiName: QUOTE_ITEM_UNIT_COST_FIELD.fieldApiName,
			type: 'numeric',
			label: this.getFieldMeta(QUOTE_ITEM_OBJECT.objectApiName, QUOTE_ITEM_UNIT_COST_FIELD.fieldApiName).fieldLabel,
			numericFormat: {
				pattern: '$0,0.00',
				culture: 'en-US',
			},
			readOnly: true,
		},
		{
			group: ColumnGroup.PRICING_ATTRIBUTE,
			data: 'baseAdjustmentAmount',
			apiName: 'baseAdjustmentAmount',
			label: LABEL_DISCOUNT_PERCENT,
			type: 'numeric',
			numericFormat: {
				pattern: '0,0.00',
				culture: 'en-US',
			},
		},
		{
			group: ColumnGroup.PRICING_ATTRIBUTE,
			data: QUOTE_ITEM_ADJUSTED_UNIT_PRICE_FIELD.fieldApiName,
			apiName: QUOTE_ITEM_ADJUSTED_UNIT_PRICE_FIELD.fieldApiName,
			type: 'numeric',
			label: this.getFieldMeta(QUOTE_ITEM_OBJECT.objectApiName, QUOTE_ITEM_ADJUSTED_UNIT_PRICE_FIELD.fieldApiName).fieldLabel,
			numericFormat: {
				pattern: '$0,0.00',
				culture: 'en-US',
			},
		},
		{
			group: ColumnGroup.PRICING_ATTRIBUTE,
			data: QUOTE_ITEM_MARGIN_PERCENT_FIELD.fieldApiName,
			apiName: QUOTE_ITEM_MARGIN_PERCENT_FIELD.fieldApiName,
			label: this.getFieldMeta(QUOTE_ITEM_OBJECT.objectApiName, QUOTE_ITEM_MARGIN_PERCENT_FIELD.fieldApiName).fieldLabel,
			type: 'numeric',
			numericFormat: {
				pattern: '0,0.00',
				culture: 'en-US',
			},
			readOnly: true,
		}];
	}

	getColumnMetadata(columnName) {
		if (!this._columnsByName) {
			this._columnsByName = {};

			for (let i = 0; i < this.columnMetadata.length; i++) {
				const columnMeta = this.columnMetadata[i];
				this._columnsByName[columnMeta.data] = columnMeta;
			}
		}

		return this._columnsByName[columnName];
	}

	buildColumnMetadata() {
		this.columnMetadata = [];

		if (Object.values(this.sections).length) {
			this.columnMetadata.push({
				data: 'sectionName',
				renderer: 'sectionName',
				label: LABEL_SECTION,
				readOnly: true,
			});
		}

		this.columnMetadata.push({
			data: 'productName',
			type: 'text',
			label: LABEL_ROLE,
			isRoleColumn: true,
			readOnly: true,
		});

		this.columnMetadata.push(...this.getRateCardItemAttributeColumnMeta());
		this.columnMetadata.push(...this.getPricingColumnMetadata());
		// divider between attributes and periods
		this.columnMetadata.push({
			data: 'Empty__mdt',
			readOnly: true,
			label: '',
		});

		this.columnMetadata.push(...generatePeriodColumnMetadata(this.periodsByGroup, this.periodGroups, this._isReadOnly || this.isEstimateSync));
		this.columnMetadata.push({
			data: 'NamedRange__GrandTotalPerson__mdt',
			type: 'numeric',
			readOnly: true,
			isTotal: true,
			label: `${LABEL_GRAND_TOTAL_PERSON} ${this.quoteTimePeriod}`,
			numericFormat: {
				pattern: '0,0.00',
				culture: 'en-US',
			},
		});
		this.columnMetadata.push({
			data: 'NamedRange__GrandTotal__mdt',
			type: 'numeric',
			readOnly: true,
			isTotal: true,
			label: LABEL_GRAND_TOTAL,
			numericFormat: {
				pattern: '$0,0.00',
				culture: 'en-US',
			},
		});

		return this.columnMetadata;
	}

	periodColumnsOffset() {
		if (this._periodColumnsOffset === null || this._periodColumnsOffset === undefined) {
			let i = 0;
			for (; i < this.columnMetadata.length; i++) {
				const { isPeriod } = this.columnMetadata[i];
				if (isPeriod === true) {
					break;
				}
			}

			this._periodColumnsOffset = i;
		}

		return this._periodColumnsOffset;
	}

	async newNamedRange(initialProperties) {
		return (await this._quoteTotals.newNamedRange(initialProperties))[0].namedRange;
	}

	getColumnHeaders() {
		const hasSections = Object.values(this.sections).length > 0;
		const lastRow = [...this.columnMetadata.map((meta) => meta.label)];
		const sortedPeriodGroups = [];
		this.periods.forEach((period) => {
			if (sortedPeriodGroups.indexOf(period.periodGroupId) < 0) {
				sortedPeriodGroups.push(period.periodGroupId);
			}
		});

		const periodRow = QuoteConfigurator.padColumns(
			[
				{ label: '', colspan: this.periodColumnsOffset() },
				...sortedPeriodGroups.map((periodGroupId) => {
					const { name } = this.periodGroups[periodGroupId];
					return {
						label: name,
						colspan: this.periodsByGroup[periodGroupId].length + 1,
					};
				}),
			],
			lastRow.length,
		);

		const headerRows = [periodRow];
		const phaseHeaders = this.getPhaseHeaders();
		if (phaseHeaders.length) {
			// section + role + rate card attributes
			const initalColumnSpan = (hasSections ? 1 : 0) + 1 + this._rateCardColumnCount;
			headerRows.push(
				QuoteConfigurator.padColumns(
					[
						{ label: '', colspan: initalColumnSpan },
						{ label: this.quoteTimePeriod, colspan: 2 },
						{ label: '', colspan: 4 },
						...phaseHeaders,
						'',
					],
					lastRow.length,
				),
			);
		}

		headerRows.push(lastRow);
		return headerRows;
	}

	async performNameModalAction() {
		const { start } = this.selectedRange;
		const sectionName = this.template.querySelector('.nameInput');
		switch (this.modalAction) {
			case 'create_section':
				if (!sectionName.value) {
					return;
				}

				this.createSection(start.row + 1, sectionName.value);
				break;
			case 'rename_role':
				this.renameRole();
				break;
			case 'edit_section':
				this.editSection();
				break;
			default:
				this.createOrUpdatePhase();
		}
	}

	async renameRole() {
		try {
			const { start } = this.selectedRange;
			const selectedRow = this.rowMetadata[start.row];
			const newResourceName = this.template.querySelector('.nameInput').value;
			this.isNameModalOpen = false;

			if (newResourceName && selectedRow?.productId) {
				this.updateRoleDisplayNames(start.row, newResourceName);
			}
		} catch (e) {
			this.toastError(e);
		}
	}

	async editSection() {
		const { start } = this.selectedRange;
		const selectedRow = this.rowMetadata[start.row];
		const newSectionName = this.template.querySelector('.nameInput').value;
		const newSectionStartPeriodIndex = this.template.querySelector('.start-period-select').value;
		const oldName = this.sections[selectedRow.$id].elementDO.name;
		const sectionId = this.sections[selectedRow.$id].elementDO.id;
		this.isModalActionInProgress = true;

		if (this.startPeriod !== newSectionStartPeriodIndex) {
			const shiftFactor = newSectionStartPeriodIndex - this.startPeriod;
			const result = await shiftQuoteItemSection({ sectionId, shiftFactor });
			for (let i = start.row + 1; i < this.rowMetadata.length; i++) {
				const item = this.quoteItems[this.rowMetadata[i].$id];
				if (!item) {
					break;
				}

				item.elementDO.periodValueMap = result[item.id];
			}

			await this.refreshGrid();
			await this.repriceAll();
		}

		if (newSectionName !== oldName) {
			this.sections[selectedRow.$id].elementDO.name = newSectionName;
			const sectionHeaderData = await this.grid.getDataAtCell(start.row, 0);
			// 1.2.[regex matches this empty space]Section Name
			const spaceMatch = /\s/;
			const match = sectionHeaderData.match(spaceMatch);
			this.grid.setDataAtCell(start.row, 0, `${sectionHeaderData.substring(0, match.index)} ${newSectionName}`);

			try {
				await this._quoteService.saveSections();
			} catch (e) {
				// in case of error revert back to original name
				this.sections[selectedRow.$id].elementDO.name = oldName;
				this.grid.setDataAtCell(start.row, 0, oldName);
				this.toastError(e);
			}
		}

		this.isNameModalOpen = false;
		this.isModalActionInProgress = false;
	}

	async batchRender(callback) {
		await this.grid.suspendRender();
		callback();
		this.grid.resumeRender();
	}

	async updateRoleDisplayNames(rowIdx, newValue) {
		const roleNameColumnIndex = Object.keys(this.sections).length > 0 ? 1 : 0; // column index is pushed over when sections exist, otherwise the zero-index column
		const rowMeta = this.rowMetadata[rowIdx];
		const product = this.productsById[rowMeta.productId];
		const quoteItem = this.quoteItems[rowMeta.$id];
		quoteItem.quoteItemSO[QUOTE_ITEM_ROLE_NAME_OVERRIDE_FIELD.fieldApiName] = newValue;
		this.grid.setDataAtCell(rowIdx, roleNameColumnIndex, `${newValue} (${product.name})`);
		this._quoteService.saveLines();
	}

	getRowItems() {
		return this.rowMetadata
			.filter(QuoteConfigurator.isQuoteItem)
			.map(({ $id }) => this.quoteItems[$id]);
	}

	getSortedRowItems() {
		return this.rowMetadata
			.filter(QuoteConfigurator.isQuoteItem)
			.map(({ $id }) => this.quoteItems[$id])
			.sort((a, b) => (a.elementDO.lineSequence > b.elementDO.lineSequence ? 1 : -1));
	}

	getQuoteItemsRowIndices() {
		const rowIndices = [];
		for (let i = 0; i < this.rowMetadata.length; i++) {
			const rowMeta = this.rowMetadata[i];
			if (QuoteConfigurator.isQuoteItem(rowMeta)) {
				rowIndices.push(i);
			}
		}

		return rowIndices;
	}

	columnIndicesFor(group) {
		const columnIndices = [];
		for (let i = 0; i < this.columnMetadata.length; i++) {
			const column = this.columnMetadata[i];
			if (column.group === group) {
				columnIndices.push(i);
			}
		}

		return columnIndices;
	}

	getRowItem(meta) {
		return QuoteConfigurator.isQuoteItem(meta) ? this.quoteItems[meta.$id] : null;
	}

	static isQuoteItem(meta) {
		return !meta.isSectionHeader && !meta.isSectionFooter && !meta.isQuantityFooter && !meta.isAmountFooter;
	}

	newSection(at, name) {
		const newSection = Provus.Section.for(this.newSectionDO());
		newSection.name = name;
		newSection.quoteId = this.recordId;
		newSection.startRow = at;
		this.sections[newSection.$id] = newSection;
		this.rowMetadata.splice(at, 0, newSection.metadata());
		return newSection;
	}

	newSectionDO() {
		return {
			...Provus.Section.newDO({}),
			sequence: this.getNextSectionSequenceNumber(),
			quoteId: this.recordId,
		};
	}

	createSectionRelationship(child, parent) {
		const from = child;
		const to = parent;
		from.elementDO.parentSectionId = to.elementDO.id;
		to.childSections.unshift(from);
		from.setParent(to);
		return this;
	}

	async createSection(at, name) {
		const newSection = this.newSection(at, name);
		if (this.sectionHierarchy === 'Nested') {
			const targetMeta = await this.grid.getCellMeta(at, 0);
			const targetRow = this.sections[targetMeta.$id] || this.quoteItems[targetMeta.$id];
			const parentSection = targetRow?.parent;
			if (parentSection) {
				newSection.setParent(parentSection);
			}
		}

		this.assignChildren();
		const sections = Object.values(this.sections).sort(Provus.Section.ascendingBySequence);
		if (sections.length) {
			const lastSection = sections[sections.length - 1];
			const lastSectionRowNumber = this.findSectionRowNumberFor(lastSection);
			if (lastSectionRowNumber + lastSection.quoteItems.length < newSection.startRow) {
				newSection.startRow = lastSectionRowNumber + lastSection.quoteItems.length + 3;
			}
		}

		if (!Object.keys(this.sections).length) {
			this._periodColumnsOffset = undefined; // force recalc
		}

		// rebuild the column metadata
		const columns = this.buildColumnMetadata();
		const { data, metadata } = await this.buildRows();
		const mergeCells = this.buildMergeCells(metadata);
		const cellOptions = this.buildCellOptions(metadata);

		this.isNameModalOpen = false;
		this.selectedRange = null;

		await this.grid.updateSettings({
			cell: cellOptions,
			data,
			columns,
			mergeCells,
			fixedColumnsLeft: 2,
			nestedHeaders: this.getColumnHeaders(),
		});

		await this.initializeCells(metadata, true);

		this.updateSectionTotals();
		this.updatePeriodGroupTotals();
		this._quoteService.saveSections();
	}

	buildSectionRowData() {
		const self = this;
		const newRows = [];
		const rootItems = this.rootItems.sort(Provus.Section.ascendingByDisplaySequence);
		const lockedQuoteSectionIds = [];
		const collaborationRequestsMap = {};
		this.rowMetadata = [];
		this.collaborationRequests.forEach((collabRequest) => {
			if (this.isSectionLocked(collabRequest)) {
				lockedQuoteSectionIds.push(collabRequest.sectionId);
				collaborationRequestsMap[collabRequest.sectionId] = collabRequest;
			}
		});

		let nextIndex = 0;
		rootItems.forEach((nextChild) => {
			if (nextChild.$type === Provus.Section.TYPE) {
				buildSectionTree(nextChild, nextIndex);
				nextIndex += 1;
			} else {
				newRows.push(...self.buildQuoteItemRowData([nextChild]));
				self.rowMetadata.push(nextChild.metadata());
			}
		});

		function buildSectionTree(nextSection, index, parentHeading = '') {
			const section = nextSection;
			section.setLocked(lockedQuoteSectionIds.includes(section.id));
			section.setRevocable(lockedQuoteSectionIds.includes(section.id));

			const sectionNumber = `${parentHeading}${index + 1}.`;
			let sectionName = `${sectionNumber} ${section.name}`;
			let collaborationQuoteId;
			let collaborationQuoteName;
			if (lockedQuoteSectionIds.includes(section.id)) {
				sectionName += ` - ${collaborationRequestsMap[section.id].status}: 
				${collaborationRequestsMap[section.id].collaboratorUserName}`;
				collaborationQuoteId = collaborationRequestsMap[section.id].collaborationQuoteId;
				collaborationQuoteName = collaborationRequestsMap[section.id].collaborationQuoteName;
			}

			const headerRow = self.buildSectionRow(section);
			headerRow.sectionName = sectionName;
			headerRow.collaborationQuoteId = collaborationQuoteId;
			headerRow.collaborationQuoteName = collaborationQuoteName;
			newRows.push(headerRow);
			self.rowMetadata.push(section.metadata());

			if (nextSection.children.length > 0) {
				let nextChildIndex = 0;
				nextSection.children.forEach((nextChild) => {
					if (nextChild.$type === Provus.Section.TYPE) {
						buildSectionTree(nextChild, nextChildIndex, `${sectionNumber}`);
						nextChildIndex += 1;
					} else {
						newRows.push(...self.buildQuoteItemRowData([nextChild]));
						self.rowMetadata.push(nextChild.metadata());
					}
				});
			}

			// newRows.push(...self.buildSectionFooter(section));
		}

		return newRows;
	}

	buildSectionFooter(section) {
		const headCountFooter = {
			canAddRowAbove: true,
			canAddRowBelow: false,
		};

		headCountFooter[QUOTE_ITEM_MARGIN_PERCENT_FIELD.fieldApiName] = `${section.name} Total Person ${this.quoteTimePeriod}`;

		const amountFooter = {
			canAddRowAbove: false,
			canAddRowBelow: true,
		};

		amountFooter[QUOTE_ITEM_MARGIN_PERCENT_FIELD.fieldApiName] = `${section.name} ${LABEL_TOTAL}`;

		this.rowMetadata.push(
			{
				isSectionFooter: true,
				isQuantityFooter: true,
				readOnly: true,
				className: 'sectionFooter',
			},
			{
				isSectionFooter: true,
				isAmountFooter: true,
				readOnly: true,
				className: 'sectionFooter',
			},
		);

		return [headCountFooter, amountFooter];
	}

	/**
	 * Section is locked in the following collaboration scenarios:
	 * Collaboration Quote - Status is Merged or Ready to Merge
	 * Main Quote - Status is Accepted, Ready to Merge, or Assigned
	 * @param {object} request
	 * @returns {boolean}
	 */
	isSectionLocked(request) {
		if (this.isCollaborationQuote()) {
			return request.status === CollaborationRequest.Status.MERGED
				|| request.status === CollaborationRequest.Status.READY_TO_MERGE;
		}

		return request.status === CollaborationRequest.Status.ACCEPTED
			|| request.status === CollaborationRequest.Status.READY_TO_MERGE
			|| request.status === CollaborationRequest.Status.ASSIGNED;
	}

	buildSectionRow(section) {
		const headerRow = {};
		for (let i = 0; i < this.columnMetadata.length; i++) {
			const columnName = this.columnMetadata[i].data;
			headerRow[columnName] = null;
		}

		headerRow.locked = section?.isLocked();
		headerRow.isRevocable = section?.isRevocable();
		headerRow.canAddRowAbove = true;
		headerRow.canAddRowBelow = !section?.isLocked();
		headerRow.$treeLevel = section?.$treeLevel || 0;

		return headerRow;
	}

	buildCellOptions(rowMetadata) {
		const cellOptions = [];
		const periodOffset = this.periodColumnsOffset();
		rowMetadata.forEach((rowMeta, rowIdx) => {
			const { isAmountFooter, isQuantityFooter, $id } = rowMeta;
			const quoteItem = this.quoteItems[$id];
			if (isAmountFooter) {
				cellOptions.push({
					row: rowIdx,
					col: periodOffset - 2,
					readOnly: true,
					type: 'text',
				});

				for (let i = periodOffset; i < this.columnMetadata.length; i++) {
					cellOptions.push({
						row: rowIdx,
						col: i,
						numericFormat: {
							pattern: '$0,0.00',
							culture: 'en-US',
						},
						type: 'numeric',
					});
				}
			} else if (isQuantityFooter) {
				const periodsByGroup = Object.values(this.periodsByGroup);
				let periodCounter = 0;
				for (let i = 0; i < periodsByGroup.length; i++) {
					const columnIdx = periodOffset + periodCounter + periodsByGroup[i].length + i;
					cellOptions.push({
						row: rowIdx,
						col: columnIdx,
						numericFormat: {
							pattern: '0.00',
							culture: 'en-US',
						},
					});

					periodCounter += periodsByGroup[i].length;
				}

				cellOptions.push({
					row: rowIdx,
					col: this.columnMetadata.length - 1,
					numericFormat: {
						pattern: '0.00',
						culture: 'en-US',
					},
				});
			} else if (quoteItem?.parent?.isLocked()) {
				for (let i = 0; i < this.columnMetadata.length; i++) {
					cellOptions.push({
						row: rowIdx,
						col: i,
						readOnly: true,
					});
				}
			}
		});

		// Make sure the dropdown toggle is hidden for the last 2 rows
		for (let i = 1; i < 3; i++) {
			cellOptions.push({
				row: rowMetadata.length - i,
				col: 0,
				type: 'text',
			});
		}

		return cellOptions;
	}

	buildMergeCells(rowMetadata) {
		const mergeCells = [];
		const periodOffset = this.periodColumnsOffset();
		rowMetadata.slice(0, rowMetadata.length - 2).forEach((rowMeta, rowIdx) => {
			const { isSectionFooter, isSectionHeader } = rowMeta;
			if (isSectionFooter || isSectionHeader) {
				mergeCells.push({
					row: rowIdx,
					col: 0,
					rowspan: 1,
					colspan: isSectionFooter ? periodOffset - 2 : this.columnMetadata.length,
				});
			}
		});

		mergeCells.push(
			{
				row: rowMetadata.length - 2,
				col: 0,
				rowspan: 1,
				colspan: periodOffset - 2,
			},
			{
				row: rowMetadata.length - 1,
				col: 0,
				rowspan: 1,
				colspan: periodOffset - 2,
			},
		);

		return mergeCells;
	}

	async buildRows() {
		const data = this.buildSectionRowData();
		// totals row
		let quoteTotalAmount = 0;
		let quoteTotalQty = 0;
		const quoteNamedRange = await this.quoteNamedRange;
		if (quoteNamedRange) {
			const { baseExtendedAmount, totalQuantity } = quoteNamedRange.relatedTotal;
			quoteTotalAmount = baseExtendedAmount;
			quoteTotalQty = totalQuantity;
		}

		const headCountFooter = {
			NamedRange__GrandTotalPerson__mdt: quoteTotalQty,
			canAddRowAbove: true,
			canAddRowBelow: false,
		};

		headCountFooter[QUOTE_ITEM_MARGIN_PERCENT_FIELD.fieldApiName] = `Total Person ${this.quoteTimePeriod}`;

		const amountFooter = {
			NamedRange__GrandTotal__mdt: quoteTotalAmount,
			canAddRowAbove: false,
			canAddRowBelow: false,
		};

		amountFooter[QUOTE_ITEM_MARGIN_PERCENT_FIELD.fieldApiName] = 'Total Amount';

		data.push(
			headCountFooter,
			amountFooter,
		);

		this.rowMetadata.push(
			{ isQuantityFooter: true, readOnly: true, className: 'quantityFooter' },
			{ isAmountFooter: true, readOnly: true },
		);

		return {
			data,
			metadata: this.rowMetadata,
		};
	}

	buildQuoteItemRowData(rowItems) {
		return rowItems.map((item) => {
			const product = this.productsById[item.productId];
			const isSectionLocked = item.parent?.isLocked();
			const overrideRoleName = item.quoteItemSO[QUOTE_ITEM_ROLE_NAME_OVERRIDE_FIELD.fieldApiName];

			return {
				...item.quoteItemSO,
				...item.periodValueMap,
				isQuoteItem: true,
				baseAdjustmentAmount: item.adjustment.amount,
				productName: overrideRoleName ? `${overrideRoleName} (${product.name})` : product?.name,
				canAddRowAbove: !isSectionLocked,
				canAddRowBelow: !isSectionLocked,
				locked: isSectionLocked,
				hideActivities: !this.estimateId,
			};
		});
	}

	async calculateRowTotals(startRow, colIdx, numberOfRows) {
		let totalPrice = 0;
		let totalHeadCount = 0;
		for (let rowIdx = startRow, rowCount = 0; rowCount < numberOfRows; rowCount++) {
			const { HeadCount, TotalPrice } = await this.grid.getCellMeta(rowIdx, colIdx);
			totalPrice += TotalPrice || 0;
			totalHeadCount += HeadCount || 0;
			rowIdx += 1;
		}

		return {
			HeadCount: totalHeadCount,
			TotalPrice: totalPrice,
		};
	}

	/**
	 * Finds the section row number for the given section
	 * using rowMetadata. Row numbers start from 1.
	 * @param {object} section
	 * @returns {number}
	 */
	findSectionRowNumberFor(section) {
		return this.rowMetadata.findIndex((row) => row.$id === section.$id) + 1;
	}

	async updateSectionTotals() {
		const isDisabled = true; // disabled for now
		if (isDisabled) {
			return;
		}

		const columnUpdates = [];
		const sections = Object.values(this.sections).sort(Provus.Section.ascendingBySequence);
		if (sections.length) {
			for (let i = 0; i < sections.length; i++) {
				const section = sections[i];
				for (
					let colIdx = this.periodColumnsOffset();
					colIdx < this.columnMetadata.length;
					colIdx++
				) {
					const sectionRowNumber = this.findSectionRowNumberFor(section);
					const sectionQuoteItemCount = section.quoteItems.length;

					const { HeadCount, TotalPrice } = await this.calculateRowTotals(
						sectionRowNumber,
						colIdx,
						sectionQuoteItemCount,
					);

					columnUpdates.push(
						[sectionRowNumber + sectionQuoteItemCount, colIdx, HeadCount],
						[sectionRowNumber + sectionQuoteItemCount + 1, colIdx, TotalPrice],
					);
				}
			}

			const rowCount = await this.grid.countRows();
			const lastSection = sections[sections.length - 1];
			const lastSectionRowNumber = this.findSectionRowNumberFor(lastSection);
			const endSlice = lastSectionRowNumber + lastSection.quoteItems.length + 3;
			for (let colIdx = this.periodColumnsOffset(); colIdx < this.columnMetadata.length; colIdx++) {
				const { HeadCount, TotalPrice } = await this.calculateRowTotals(
					endSlice,
					colIdx,
					rowCount - endSlice - 5,
				);

				columnUpdates.push([rowCount - 4, colIdx, TotalPrice], [rowCount - 5, colIdx, HeadCount]);
			}

			if (columnUpdates.length) {
				this.grid.setDataAtCell(columnUpdates);
			}
		}
	}

	validateDialogInput() {
		const textInput = this.template.querySelector('.nameInput').value.trim();
		this.disableButton = textInput.length === 0;
	}

	async createOrUpdatePhase() {
		const { start } = this.selectedRange;
		const lastRowIdx = (await this.grid.countRows()) - 1;
		const { phase } = await this.grid.getCellMeta(lastRowIdx, start.col);
		if (phase) {
			await this.updatePhase(phase.$id);
		} else {
			await this.createPhase();
		}

		this.isNameModalOpen = false;
		this.selectedRange = null;

		this.grid.updateSettings({
			nestedHeaders: this.getColumnHeaders(),
		});

		this._quoteService.savePhases();
	}

	updatePhase(phaseId) {
		const contextPhase = this._phasesById[phaseId];
		const phaseNameInput = this.template.querySelector('.nameInput');

		contextPhase.name = phaseNameInput.value;
		contextPhase.parentProjectName = phaseNameInput.value;
		this._quoteService.savePhases();
	}

	async createPhase() {
		const { start, end } = this.selectedRange;
		const { col: startCol } = start;
		const { col: endCol } = end;
		const phaseName = this.template.querySelector('.nameInput').value;
		const startColumnMeta = this.columnMetadata[startCol].data;
		const endColumnMeta = this.columnMetadata[endCol].data;
		const startPeriod = this.periods[Number(startColumnMeta) - 1];
		const endPeriod = this.periods[Number(endColumnMeta) - 1];
		let sequence = 1;
		if (this._phases.length !== 0) {
			sequence = this._phases[this._phases.length - 1].sequence + 1;
		}

		const phase = Provus.Phase.for(
			Provus.Phase.newDO({
				name: phaseName,
				quoteId: this.recordId,
				sequence,
				startDate: startPeriod.startDate,
				endDate: endPeriod.endDate,
				parentProjectName: phaseName,
			}),
		);

		phase.periodGroupId = endPeriod.periodGroupId;
		phase.startCol = startCol;
		phase.endCol = endCol;

		for (let i = startCol; i < endCol + 1; i++) {
			const periodNumber = this.columnMetadata[i].data;
			const period = this.periods[Number(periodNumber) - 1];
			phase.quotePeriodIdList.push(period.id);
		}

		this._phasesById[phase.$id] = phase;
		this._phases.push(phase);

		// mark as ready to insert
		phase.insert();

		const lastRow = (await this.grid.countRows()) - 1;
		for (let i = startCol; i < endCol + 1; i++) {
			this.grid.setCellMeta(lastRow, i, 'phase', { $id: phase.$id });
		}

		await this._quoteService.savePhases();
		this.updatePhaseTotals();
	}

	rebuildPhases(phaseMOs) {
		const periodById = {};
		this.periods.forEach((period) => {
			periodById[period.id] = period;
		});

		const columnIdxByPeriodId = {};
		for (let i = 0; i < this.columnMetadata.length; i++) {
			const meta = this.columnMetadata[i];
			if (meta.isPeriod === true) {
				columnIdxByPeriodId[meta.id] = i;
			}
		}

		this._phases = Provus.Phases.for(phaseMOs);

		for (let i = 0; i < this._phases.length; i++) {
			const phaseMO = this._phases[i];
			let startCol = null;
			let endCol = null;
			let startPeriod;

			phaseMO.quotePeriodIdList.forEach((periodId) => {
				const periodIdx = columnIdxByPeriodId[periodId];
				if (startCol === null || startCol > periodIdx) {
					startCol = periodIdx;
					startPeriod = periodById[periodId];
				}

				if (endCol === null || endCol < periodIdx) {
					endCol = periodIdx;
				}
			});

			phaseMO.startCol = startCol;
			phaseMO.endCol = endCol;
			phaseMO.periodGroupId = startPeriod && startPeriod.periodGroupId;
			this._phasesById[phaseMO.$id] = phaseMO;
		}

		return this._phases;
	}

	openNameModal(action, phaseRange) {
		this.isNameModalOpen = true;
		this.modalAction = action;
		[this.selectedRange] = phaseRange;
		this.grid.deselectCell();

		this.dialogInputTitle = 'Enter a name';
		this.dialogInputPlaceholder = 'Enter a name...';
		this.dialogInitialValue = '';

		// set action button label
		switch (action) {
			case 'create_section':
				this.dialogActionLabel = 'Create Section';
				break;
			case 'rename_phase':
				this.dialogActionLabel = 'Rename Phase';
				break;
			case 'create_phase':
				this.dialogActionLabel = 'Create Phase';
				break;
			case 'rename_role':
				this.dialogActionLabel = 'Rename Resource Role';
				break;

			case 'edit_section': {
				const { start } = this.selectedRange;
				const selectedRow = this.rowMetadata[start.row];
				this.dialogInitialValue = this.sections[selectedRow.$id].elementDO.name;
				this.dialogActionLabel = LABEL_EDIT_SECTION;

				const sectionItemPeriodValues = [];
				for (let i = start.row + 1; i < this.rowMetadata.length; i++) {
					const item = this.quoteItems[this.rowMetadata[i].$id];
					if (!item) {
						break;
					}

					sectionItemPeriodValues.push(item.elementDO.periodValueMap);
				}

				this.generateStartPeriodOptions(sectionItemPeriodValues);
				break;
			}

			default:
				this.dialogActionLabel = 'Create Phase';
		}
	}

	generateStartPeriodOptions(periodValues) {
		const startPeriodOptions = [];
		const orderedPeriods = flattenPeriodGroups(this.periodsByGroup);
		this.startPeriod = `${firstValueIndex(periodValues, orderedPeriods.length)}`;
		const shift = shiftableAmount(periodValues, orderedPeriods.length);
		for (let i = 0; i <= shift + Number(this.startPeriod); i++) {
			const period = orderedPeriods[i];
			startPeriodOptions.push({ label: period.name, value: `${i}` });
		}

		this.startPeriodOptions = startPeriodOptions;
	}

	closeNameModal() {
		this.isNameModalOpen = false;
		this.startPeriodOptions = [];
		this.startPeriod = undefined;
	}

	getPhaseHeaders() {
		const phaseHeaders = [];
		if (this._phases.length) {
			const periodGroups = [];
			const phasesByGroup = {};
			const periodGroupSpan = {};
			const periodGroupStart = {};
			this._phases.forEach((phase) => {
				let groupSpanCount = periodGroupSpan[phase.periodGroupId];
				if (typeof groupSpanCount === 'undefined') {
					groupSpanCount = 0;
					phasesByGroup[phase.periodGroupId] = {};
				}

				phasesByGroup[phase.periodGroupId][phase.startCol] = phase;
				groupSpanCount += phase.numberOfPeriods();

				periodGroupSpan[phase.periodGroupId] = groupSpanCount;
			});

			this.periods.forEach((period, index) => {
				const touchedPeriodGroup = periodGroups.indexOf(period.periodGroupId) > -1;
				if (!touchedPeriodGroup) {
					for (let i = this.periodColumnsOffset(); i < this.columnMetadata.length; i++) {
						const periodNumber = Number(this.columnMetadata[i].data);
						if (periodNumber === index + 1) {
							periodGroupStart[period.periodGroupId] = i;
							break;
						}
					}

					periodGroups.push(period.periodGroupId);
				}
			});

			periodGroups.forEach((groupId) => {
				const phasesForGroup = phasesByGroup[groupId];
				if (phasesForGroup) {
					// build headers in order ascending order by start column
					const phaseTokens = Object.keys(phasesForGroup).sort((a, b) => (Number(a) < Number(b) ? -1 : 1));

					phaseTokens.forEach((token, index) => {
						const phase = phasesForGroup[token];
						let gap = 0;
						if (index !== 0) {
							const prevPhase = phasesForGroup[phaseTokens[index - 1]];
							gap = phase.startCol - prevPhase.endCol - 1;
						} else if (periodGroupStart[groupId] < phase.startCol) {
							gap = phase.startCol - periodGroupStart[groupId];
						}

						if (gap > 0) {
							periodGroupSpan[groupId] += gap;
							// Add an empty phase header to fill the gap between group starts
							phaseHeaders.push({
								label: '',
								colspan: gap,
							});
						}

						phaseHeaders.push({
							label: `${phase.name}`,
							colspan: phase.numberOfPeriods(),
						});
					});
				}

				// Add a blank header row from the last period end up to the end of the period group
				const remainingPeriodGroupLen = this.periodsByGroup[groupId].length - (periodGroupSpan[groupId] || 0) + 1;

				phaseHeaders.push({
					label: '',
					colspan: remainingPeriodGroupLen,
				});
			});
		}

		return phaseHeaders;
	}

	rebuildNamedRanges(namedRangeDOs) {
		if (namedRangeDOs && namedRangeDOs.length) {
			namedRangeDOs.forEach((namedRange) => {
				this.namedRanges[namedRange.$id] = namedRange;

				switch (namedRange.type) {
					case 'Project Phase':
						this._phaseNamedRanges[namedRange.projectPhaseId] = namedRange;
						break;
					default:
						break;
				}
			});
		}
	}

	/**
	 * Reloads the collaboration requests for this quote from the server.
	 * @returns {Promise<void>}
	 */
	async reloadCollaborationRequests() {
		this.collaborationRequests = await getCollaborationRequestsForQuote({ quoteId: this.recordId });
	}

	toastError(error) {
		this.dispatchEvent(
			new ShowToastEvent({
				title: 'Application Exception',
				message: reduceErrors(error).join(', '),
				variant: 'error',
			}),
		);
	}

	async executeAndDisplayErrors(fn, args) {
		let result;
		try {
			result = await fn(args);
		} catch (e) {
			this.toastError(e);
		}

		return result;
	}

	async reloadNamedRanges() {
		const namedRanges = await this.executeAndDisplayErrors(getNamedRangesForQuote, { quoteId: this.recordId });
		this.rebuildNamedRanges(JSON.parse(namedRanges), this.quoteItems);
	}

	async handleReloadGrid() {
		const sections = await getQuoteSectionsForQuote({ quoteId: this.recordId });
		await this.reloadQuoteItems();
		this.sections = {};
		this.associateQuoteItems(Provus.Sections.for(JSON.parse(sections)));
		await this.refreshGrid();
	}

	async reloadQuoteItems() {
		const quoteItems = await getQuoteItemsForQuote({ quoteId: this.recordId });
		this.quoteItems = {};
		this.rootItems = [];
		this.quoteItemsByLineSeq = {};
		this.quoteItemsById = {};
		this.processQuoteItems(quoteItems);
	}

	processQuoteItems(quoteItems) {
		Provus.QuoteItems.for(JSON.parse(quoteItems))
			.filter((item) => item.isMiscellaneous !== true)
			.forEach((item) => {
				this.quoteItems[item.$id] = item;
				QuoteItemsDataService.setQuoteItem(item.$id, item);
				this.quoteItemsById[item.id] = item;
				this.quoteItemsByLineSeq[item.lineSequence] = item;

				if (!item.sectionId) {
					this.rootItems.push(item);
				}
			});
	}

	async loadData(quoteId) {
		const [quote, products, items, phases, sections, totals, collabRequests, colaRates] = await Promise.all([
			this.executeAndDisplayErrors(getQuoteTemplate, { quoteId }),
			this.executeAndDisplayErrors(getAllProductsForQuote, { quoteId }),
			this.executeAndDisplayErrors(getQuoteItemsForQuote, { quoteId }),
			this.executeAndDisplayErrors(getProjectPhasesForQuote, { quoteId }),
			this.executeAndDisplayErrors(getQuoteSectionsForQuote, { quoteId }),
			this._quoteTotals.getNamedRangesForQuote(quoteId),
			this.executeAndDisplayErrors(getCollaborationRequestsForQuote, { quoteId }),
			this.executeAndDisplayErrors(getColaRatesForQuote, { quoteId }),
		]);

		const {
			currencyFields,
			estimateId,
			fieldsList = [],
			groupName,
			hasAddOns,
			isEstimateSync,
			isScenarioPricePending,
			laborUnits,
			marginPercent,
			practiceName,
			quotePeriodList: periods,
			quoteTimePeriod,
			rateCardId,
			recordType,
			scheduleSettings,
			sectionHierarchy,
			totalAmount,
		} = quote;

		this.currencyISOCode = currencyFields.currencyISOCode;
		this.currencyConversionRatio = currencyFields.currencyConversionRatio;
		this.practice = practiceName;
		this.group = groupName;
		this.estimateId = estimateId;
		this.laborUnits = laborUnits;
		this.rateCardId = rateCardId;
		this.isEstimateSync = isEstimateSync;
		this.collaborationRequests = collabRequests;
		this.recordType = recordType;
		this.sectionHierarchy = sectionHierarchy;
		this._scheduleSettings = {
			standardDayHours: Number(scheduleSettings.standardDayHours),
			standardWeekHours: Number(scheduleSettings.standardWeekHours),
			standardMonthHours: Number(scheduleSettings.standardMonthHours),
			standardYearHours: Number(scheduleSettings.standardYearHours),
		};
		this._quoteFields = fieldsList;
		this.quoteTimePeriod = quoteTimePeriod;
		this.recurringHoursTimePeriod = quoteTimePeriod;
		this.periods = periods;

		if (this.laborUnits !== LaborUnits.HEADCOUNT) {
			this.quoteTimePeriod = this.laborUnits;
		}

		if (this.isCollaborationQuote() && !this.hasOutstandingRequests()) {
			this._isReadOnly = true;
		}

		const startPeriod = this.periods[0].startDate;
		const endPeriod = this.periods[this.periods.length - 1].startDate;
		const currentYear = getYearFromDate(endPeriod) - getYearFromDate(startPeriod);
		this.showColaRatesMenu = colaRates.length > 0 && currentYear > 0;

		this.quoteProducts = JSON.parse(products).filter(
			(product) => product.isMiscellaneous !== true,
		);
		this.quoteProducts.forEach((product) => {
			this.productsById[product.id] = product;
		});

		this.quoteItems = {};
		this.quoteItemsByLineSeq = {};
		this.quoteItemsById = {};
		this.processQuoteItems(items);

		this.associateQuoteItems(Provus.Sections.for(JSON.parse(sections)));

		// ensure a quote item/section when loading an empty/new quote
		if (this.rootItems.length === 0) {
			// set first row/cell as default selection for starting place
			const defaultSelectionRange = [{
				start: { row: 0, col: 0 },
				end: { row: 0, col: 0 },
			}];

			if (this.sectionHierarchy) {
				// allow cancellation of add resource role dialog
				this.handleOpenRoleDialog(ContextMenuActions.ROW_BELOW, defaultSelectionRange);
				this.rootItems.push(this.newSection(0, LABEL_DEFAULT_SECTION));
			} else {
				// disable cancellation of add resource dialog
				this.handleOpenRoleDialog(ContextMenuActions.ROW_BELOW, defaultSelectionRange, { showCloseButton: false });
			}
		}

		this.periodsByGroup = {};
		this.periodGroups = {};
		this.periodsBySequence = {};
		this.periods.forEach((period) => {
			let periodsForGroup = this.periodsByGroup[period.periodGroupId];
			if (!periodsForGroup) {
				periodsForGroup = [];
				this.periodsByGroup[period.periodGroupId] = periodsForGroup;
			}

			periodsForGroup.push(period);
			this.periodGroups[period.periodGroupId] = {
				name: period.periodGroupName,
			};
			this.periodsBySequence[period.sequence] = period.term;
		});

		const columns = this.buildColumnMetadata();
		this.rebuildNamedRanges(totals, this.quoteItemsById);
		const { data, metadata } = await this.buildRows();
		this.rebuildPhases(JSON.parse(phases));

		const locationMeta = this.getFieldMeta(QUOTE_ITEM_OBJECT.objectApiName, QUOTE_ITEM_LOCATION_DISPLAY_NAME_FIELD.fieldApiName);
		this.groupedTotals[QUOTE_ITEM_LOCATION_DISPLAY_NAME_FIELD.fieldApiName] = {
			marginPercent: {},
			totalAmount: {},
			totalCost: {},
			totalQuantity: {},
			field: QUOTE_ITEM_LOCATION_DISPLAY_NAME_FIELD.fieldApiName,
			label: locationMeta.fieldLabel,
		};

		if (!this.isCollaborationQuote()) {
			this.actionsMap.merge.enabled = true;

			if (this.hasRequestsToMerge()) {
				this.actionsMap.merge.visible = true;
			}
		}

		this.rerender();

		return {
			options: this.initGridOptions(data, columns, metadata),
			metadata,
			isScenarioPricePending,
			totalAmount,
			marginPercent,
			hasAddOns,
		};
	}

	associateQuoteItems(sections) {
		const self = this;
		let nextDisplaySequence = 1;
		sections.forEach((section) => {
			if (!section.parent) {
				const contextSection = section;
				self.rootItems.push(section);
				contextSection.elementDO.displaySequence = nextDisplaySequence;
				nextDisplaySequence += 1;
			}

			self.sections[section.$id] = section;

			if (section.quoteItemIdList || section.childSections) {
				// will be null if there are no children in this section
				const childItems = section.quoteItemIdList
					? section.quoteItemIdList
						.map((itemId) => self.quoteItemsById[itemId])
						.filter((item) => !!item)
					: [];

				section.spliceQuoteItems(0, 0, ...childItems);
			}

			if (section.children.length > 0) {
				section.children.forEach((nextChild) => {
					if (nextChild.$type === Provus.Section.TYPE) {
						self.associateQuoteItems(nextChild);
					}
				});
			}
		});
	}

	initGridOptions(data, columns, metadata) {
		const gridOptions = {
			afterChange: (...args) => this.onChange(...args),
			afterCreateRow: (...args) => this.afterCreateRow(...args),
			afterRowMove: (...args) => this.onRowMove(...args),
			beforeColumnMove: Provus.Grid.IFrameFnFor(onColumnDrag),
			beforeOnCellMouseOver: Provus.Grid.IFrameFnFor(onMouseOver),
			beforeRemoveRow: (...args) => this.onRemoveRows(...args),
			beforeRowMove: Provus.Grid.IFrameFnFor(beforeRowMove),
			cell: this.buildCellOptions(metadata),
			className: 'slds-table',
			colHeaders: true,
			collapsibleColumns: false,
			columns,
			colWidth: [200],
			contextMenu: new ContextMenu(this),
			data: data.length ? data : null,
			fixedColumnsLeft: Object.keys(this.sections).length > 0 ? 2 : 1,
			fixedRowsBottom: 2,
			licenseKey: 'non-commercial-and-evaluation',
			manualColumnFreeze: true,
			manualColumnMove: true,
			manualRowMove: true,
			mergeCells: this.buildMergeCells(metadata),
			minSpareRows: 0,
			nestedHeaders: this.getColumnHeaders(),
			rowHeaders: true,
			search: true,
			startRows: 1,

			hiddenRows: {
				rows: [],
			},

			hiddenColumns: {
				columns: [],
			},
		};

		if (this._isReadOnly) {
			gridOptions.comments = false;
			gridOptions.contextMenu = false;
			gridOptions.disableVisualSelection = true;
			gridOptions.manualColumnMove = false;
			gridOptions.manualColumnResize = false;
			gridOptions.manualRowMove = false;
			gridOptions.manualRowResize = false;
			gridOptions.readOnly = true;
		}

		return gridOptions;
	}

	async updateTotalsFor(row) {
		return this.updateTotalsForRows([row]);
	}

	async onRemoveRows(startIdx, numberOfRows, deletedRows) {
		const deletePromises = [];
		for (let i = 0; i < deletedRows.length; i++) {
			const row = deletedRows[i];
			const { $id } = this.rowMetadata[row];
			const quoteItem = this.quoteItems[$id];
			if (quoteItem && !isEmpty(quoteItem.id)) {
				deletePromises.push(this._quoteService.deleteQuoteItem(quoteItem));
				delete this.quoteItems[$id];
				QuoteItemsDataService.removeQuoteItem($id);
				this._quoteTotals.deleteQuoteItemNamedRange(quoteItem.id);
			}

			delete this.rowMetadata[row];

			if (quoteItem.parent) {
				quoteItem.parent.removeChild(quoteItem);
			}
		}

		if (Object.keys(this.quoteItems).length === 0
				&& !this.sectionHierarchy) {
			const defaultSelectionRange = [{
				start: { row: 0, col: 0 },
				end: { row: 0, col: 0 },
			}];

			this.handleOpenRoleDialog(ContextMenuActions.ROW_BELOW, defaultSelectionRange, { showCloseButton: false });
		}

		this.rowMetadata = this.rowMetadata.filter((element) => !!element);
		await this.repriceAll();
		await Promise.all(deletePromises).catch((e) => {
			log('Failed to delete line items.');
			log(e);
		});
	}

	async updatePeriodGroupTotals() {
		const rowCount = await this.grid.countRows();
		const periodGroupIds = Object.keys(this.periodsByGroup);
		const updateColumns = [];
		let totalColIdx = this.periodColumnsOffset();
		for (let groupIdx = 0; groupIdx < periodGroupIds.length; groupIdx++) {
			let totalPrice = 0;
			let totalQty = 0;
			let totalCost = 0;
			const periodGroupId = periodGroupIds[groupIdx];
			const periodGroupName = this.periodGroups[periodGroupId].name;
			totalColIdx += this.periodsByGroup[periodGroupId].length;

			for (let row = 0; row < rowCount; row++) {
				const { TotalPrice, HeadCount, TotalCost } = await this.grid.getCellMeta(row, totalColIdx);
				totalPrice += TotalPrice || 0;
				totalQty += HeadCount || 0;
				totalCost += TotalCost || 0;
			}

			updateColumns.push(
				[rowCount - 1, totalColIdx, totalPrice],
				[rowCount - 2, totalColIdx, totalQty],
			);

			totalColIdx += 1;

			let namedRangeForGroup = await this._quoteTotals.quotePeriodGroupTotal(periodGroupId);
			if (!namedRangeForGroup) {
				namedRangeForGroup = await this._quoteTotals.newNamedRangeForQuotePeriodGroup(periodGroupId);
				namedRangeForGroup[0].namedRange.name = `Quote Period Group: ${periodGroupName}`;
				namedRangeForGroup = namedRangeForGroup[0].namedRange;
			}

			// set total value
			const { relatedTotal } = namedRangeForGroup;
			relatedTotal.baseExtendedAmount = totalPrice;
			relatedTotal.adjustedBaseAmount = totalPrice;
			relatedTotal.totalQuantity = totalQty;
			relatedTotal.baseExtendedCost = totalCost;
		}

		if (updateColumns.length) {
			await this.grid.setDataAtCell(updateColumns);
		}
	}

	async updateTotalsForRows(rows) {
		this._quoteTotals.resetQuoteTotals(this.quoteRecordId);
		const totalUpdates = [];
		const groupedTotals = Object.values(this.groupedTotals);
		for (let i = 0; i < rows.length; i++) {
			const row = rows[i];
			// eslint-disable-next-line no-await-in-loop
			const { id: quoteItemId, quoteItemSO } = await this.getQuoteItemForRow(row);
			const rateCardItemSO = quoteItemSO[rateCardRNameField];

			const location = {
				country: rateCardItemSO[RATE_CARD_ITEM_LOCATION_COUNTRY_FIELD.fieldApiName],
				state: rateCardItemSO[RATE_CARD_ITEM_LOCATION_STATE_PROVINCE_FIELD.fieldApiName],
				city: rateCardItemSO[RATE_CARD_ITEM_LOCATION_CITY_FIELD.fieldApiName],
			};

			const rowDetails = await this.getDataAtRow(row);
			const { periods } = rowDetails;
			const totalsForGroup = {};
			let grandTotal = 0;
			let grandTotalQty = 0;
			let grandTotalCost = 0;
			let periodCounter = 0;
			let columnCounter = 0;
			const periodGroupIds = Object.keys(this.periodsByGroup);
			const priceFieldIdx = this.columnMetadata.findIndex((colMeta) => colMeta.data === QUOTE_ITEM_UNIT_PRICE_FIELD.fieldApiName);
			const baseAdjustmentAmountFieldIdx = this.columnMetadata.findIndex((colMeta) => colMeta.data === 'baseAdjustmentAmount');
			for (let groupIdx = 0; groupIdx < periodGroupIds.length; groupIdx++) {
				const periodGroupId = periodGroupIds[groupIdx];
				const periodGroupName = this.periodGroups[periodGroupId].name;
				const isNonBillable = quoteItemSO[QUOTE_ITEM_NONBILLABLE_FIELD.fieldApiName];
				let groupTotal = 0;
				let groupTotalQty = 0;
				let groupTotalCost = 0;
				for (let j = 0; j < this.periodsByGroup[periodGroupId].length; j++) {
					const periodMetadata = this.periodsByGroup[periodGroupId][j];
					const periodNumber = `${periodCounter + 1}`.padStart(3, '0');
					const periodValue = periods[periodNumber] || 0;
					let unitPrice = rowDetails[QUOTE_ITEM_ADJUSTED_UNIT_PRICE_FIELD.fieldApiName];
					if (isNonBillable) {
						// adjusted unit price is zero for non-billable
						unitPrice = rowDetails[QUOTE_ITEM_UNIT_PRICE_FIELD.fieldApiName];
						this.grid.setCellMeta(row, priceFieldIdx, 'className', 'strike-out');
						this.grid.setCellMeta(row, baseAdjustmentAmountFieldIdx, 'className', 'strike-out');
					} else {
						this.grid.removeCellMeta(row, priceFieldIdx, 'className');
						this.grid.removeCellMeta(row, baseAdjustmentAmountFieldIdx, 'className');
					}

					const periodPrice = periodMetadata.term * periodValue * unitPrice;
					const periodCost = periodMetadata.term * periodValue * rowDetails[QUOTE_ITEM_UNIT_COST_FIELD.fieldApiName];
					const currentCol = this.periodColumnsOffset() + columnCounter;
					this.grid.setCellMeta(
						row,
						currentCol,
						'TotalPrice',
						isNonBillable ? 0 : periodPrice,
					);
					this.grid.setCellMeta(
						row,
						currentCol,
						'HeadCount',
						periodValue,
					);
					this.grid.setCellMeta(
						row,
						currentCol,
						'TotalCost',
						periodCost,
					);
					this.grid.setCellMeta(
						row,
						currentCol,
						'UnbilledTotal',
						isNonBillable ? periodPrice : 0,
					);
					this.grid.setCellMeta(
						row,
						currentCol,
						'UnbilledHeadcount',
						isNonBillable ? periodValue : 0,
					);
					this.grid.setCellMeta(
						row,
						currentCol,
						'UnbilledCost',
						isNonBillable ? periodCost : 0,
					);

					groupTotalCost += periodCost;
					groupTotal += periodPrice;
					groupTotalQty += periodValue;

					this._quoteTotals.updateQuoteTotals({
						quoteId: this.quoteRecordId,
						location,
						periodIndex: periodCounter,
						revenueAmount: periodPrice,
					});

					periodCounter += 1;
					columnCounter += 1;
				}

				let namedRangeForGroup = await this._quoteTotals.itemPeriodGroupTotal(periodGroupId, quoteItemId);
				if (!namedRangeForGroup) {
					namedRangeForGroup = await this._quoteTotals.newNamedRangeForItemPeriodGroup(periodGroupId, quoteItemId);
					namedRangeForGroup[0].namedRange.name = `Row: ${row}, Period Group: ${periodGroupName}`;
					namedRangeForGroup = namedRangeForGroup[0].namedRange;
				}

				// when line is non-billable current period group total should be zero
				if (isNonBillable) {
					groupTotal = 0;
				}

				this._quoteTotals.updateQuoteTotals({
					quoteId: this.quoteRecordId,
					location,
					groupIndex: groupIdx,
					revenueAmount: groupTotal,
				});

				// set total value
				const { relatedTotal } = namedRangeForGroup;
				relatedTotal.baseExtendedAmount = groupTotal;
				relatedTotal.adjustedBaseAmount = groupTotal;
				relatedTotal.totalQuantity = groupTotalQty;
				relatedTotal.baseExtendedCost = groupTotalCost;

				const groupTotalColumn = this.periodColumnsOffset() + (periodCounter + (groupIdx + 1) - 1);
				this.grid.setCellMeta(row, groupTotalColumn, 'TotalPrice', groupTotal);
				this.grid.setCellMeta(row, groupTotalColumn, 'HeadCount', groupTotalQty);
				this.grid.setCellMeta(row, groupTotalColumn, 'TotalCost', groupTotalCost);

				totalsForGroup[`NamedRange__${periodGroupId.replace(/\s+/g, '')}__mdt`] = groupTotal;
				grandTotal += isNonBillable ? 0 : groupTotal;
				grandTotalQty += groupTotalQty;
				grandTotalCost += groupTotalCost;
				columnCounter += 1;
			}

			totalsForGroup.NamedRange__GrandTotalPerson__mdt = grandTotalQty;
			Object.keys(totalsForGroup).forEach((groupToken) => {
				const computedTotal = totalsForGroup[groupToken];
				totalUpdates.push([row, groupToken, computedTotal]);
			});

			let namedRangeForItem = await this._quoteTotals.getQuoteItemTotal(quoteItemId);
			if (!namedRangeForItem) {
				namedRangeForItem = await this._quoteTotals.newNamedRangeForQuoteItem(quoteItemId);
				namedRangeForItem[0].namedRange.name = `Row: ${row}`;
				namedRangeForItem = namedRangeForItem[0].namedRange;
			}

			const { relatedTotal } = namedRangeForItem;
			relatedTotal.baseExtendedAmount = grandTotal;
			relatedTotal.adjustedBaseAmount = grandTotal;

			relatedTotal.totalQuantity = grandTotalQty;
			relatedTotal.baseExtendedCost = grandTotalCost;

			quoteItemSO[QUOTE_ITEM_QUANTITY_FIELD.fieldApiName] = relatedTotal.totalQuantity;
			quoteItemSO[QUOTE_ITEM_NETEXTENDEDAMOUNT_FIELD.fieldApiName] = relatedTotal.baseExtendedAmount;
			quoteItemSO[QUOTE_ITEM_NETEXTENDEDCOST_FIELD.fieldApiName] = relatedTotal.baseExtendedCost;
			quoteItemSO[QUOTE_ITEM_MARGIN_PERCENT_FIELD.fieldApiName] = relatedTotal.marginPercent;
			totalUpdates.push([row, 'NamedRange__GrandTotal__mdt', grandTotal]);

			// set cell meta for the grand totals
			const {
				TotalPrice: previousAmt,
				HeadCount: previousQty,
				TotalCost: previousCost,
			} = await this.grid.getCellMeta(row, this.columnMetadata.length - 1);

			this.grid.setCellMeta(row, this.columnMetadata.length - 1, 'TotalPrice', grandTotal);
			this.grid.setCellMeta(row, this.columnMetadata.length - 1, 'HeadCount', grandTotalQty);
			this.grid.setCellMeta(row, this.columnMetadata.length - 1, 'TotalCost', grandTotalCost);

			quoteItemSO[QUOTE_ITEM_MARGIN_PERCENT_FIELD.fieldApiName] = QuoteConfigurator.marginPercentage(
				grandTotal,
				grandTotalCost,
			);

			for (let j = 0; j < groupedTotals.length; j++) {
				const groupedTotal = groupedTotals[j];
				const columnValue = quoteItemSO[groupedTotal.field];
				const totalTypes = Object.keys(groupedTotal);
				for (let p = 0; p < totalTypes.length; p++) {
					const totalType = totalTypes[p];
					if (totalType !== 'field' && totalType !== 'label') {
						switch (totalType) {
							case 'totalAmount':
								if (!groupedTotal[totalType][columnValue]) {
									groupedTotal[totalType][columnValue] = 0;
								}

								groupedTotal[totalType][columnValue] += grandTotal - (previousAmt || 0);
								break;
							case 'totalCost':
								if (!groupedTotal[totalType][columnValue]) {
									groupedTotal[totalType][columnValue] = 0;
								}

								groupedTotal[totalType][columnValue] += grandTotalCost - (previousCost || 0);
								break;
							case 'totalQuantity':
								if (!groupedTotal[totalType][columnValue]) {
									groupedTotal[totalType][columnValue] = 0;
								}

								groupedTotal[totalType][columnValue] += grandTotalQty - (previousQty || 0);
								break;
							default:
								break;
						}
					}
				}
			}
		}

		this.grid.setDataAtRowProp(totalUpdates);
		await this._quoteService.saveLines();
	}

	getNextItemSequenceNumber() {
		this.baseItemSequenceNumber += 1;
		return this.baseItemSequenceNumber;
	}

	getNextSectionSequenceNumber() {
		this.baseSectionSequenceNumber += 1;
		return this.baseSectionSequenceNumber;
	}

	async getDataAtRow(rowIdx) {
		const gridArray = await this.grid.getDataAtRow(rowIdx);

		const rowData = {
			periods: {},
		};

		gridArray.forEach((gridValue, index) => {
			const columnMetadata = this.columnMetadata[index];
			const apiName = columnMetadata.data;
			if (index < this.periodColumnsOffset()
			) {
				rowData[columnMetadata.data] = gridValue;
			} else if (apiName.indexOf('__mdt') < 0) {
				if (!Number.isNaN(Number(apiName))) {
					rowData.periods[apiName] = gridValue;
				}
			}
		});

		return rowData;
	}

	handleOpenContingencies() {
		const dialogServicePayload = getContingenciesDialog(this.recordId, this.namespace);
		this._componentState.dialogService(dialogServicePayload);
	}

	handleOpenCola() {
		const dialogServicePayload = getColaDialog(this.recordId, this.namespace, LABEL_COLA_ADJUSTMENT_WORKSHEET);
		this._componentState.dialogService(dialogServicePayload);
	}

	handleOpenReviewVolumeDiscounts() {
		const dialogServicePayload = getReviewVolumeDiscountsDialog(this.recordId, this.namespace, LABEL_VOLUME_DISCOUNT_SUMMARY);
		this._componentState.dialogService(dialogServicePayload);
	}

	handleOpenReviewLocationDiscounts() {
		const dialogServicePayload = getReviewLocationDiscountsDialog(this.recordId, this.namespace, LABEL_REVIEW_LOCATION_DISCOUNTS);
		this._componentState.dialogService(dialogServicePayload);
	}

	async onRowMove(movedRows, finalIndex) {
		const movedItemRows = this.rowMetadata
			.splice(movedRows[0], movedRows.length);

		const movedItemRowData = movedItemRows.map(({ $id }) => this.quoteItems[$id]);
		movedItemRowData.forEach((nextItem) => {
			if (nextItem.parent) {
				nextItem.parent.removeChild(nextItem);
			}
		});

		this.rowMetadata.splice(finalIndex, 0, ...movedItemRows);
		await this.addRowsToSection(finalIndex, movedItemRowData);

		if (this.sectionHierarchy) {
			const mergeCells = this.buildMergeCells(this.rowMetadata);

			this.grid.updateSettings({
				mergeCells,
			});

			await this.initializeCells(this.rowMetadata, true);
		}

		await this._quoteService.saveSections();
	}

	handleToggleTotalAmount() {
		const toggledVisible = !this.viewSettings.totals.isVisible;
		this.viewSettings.totals.isVisible = toggledVisible;
		this.viewSettings.totals.label = toggledVisible ? LABEL_HIDE_TOTALS : LABEL_SHOW_TOTALS;
		this.toggleTotalAmount();
	}

	handleToggleQuoteItems() {
		const toggledVisible = !this.viewSettings.quoteItems.isVisible;
		this.viewSettings.quoteItems.isVisible = toggledVisible;
		this.viewSettings.quoteItems.label = toggledVisible ? LABEL_HIDE_QUOTE_ITEMS : LABEL_SHOW_QUOTE_ITEMS;

		const quoteRowIndices = this.getQuoteItemsRowIndices();
		this.setRowColumnVisible(quoteRowIndices, [], toggledVisible);
	}

	handleToggleRateAttributes() {
		const toggledVisible = !this.viewSettings.rateAttributes.isVisible;
		this.viewSettings.rateAttributes.isVisible = toggledVisible;
		this.viewSettings.rateAttributes.label = toggledVisible ? LABEL_HIDE_RATE_ATTRIBUTES : LABEL_SHOW_RATE_ATTRIBUTES;
		this.setRowColumnVisible([], this.columnIndicesFor(ColumnGroup.RATE_ATTRIBUTE), toggledVisible);
	}

	handleTogglePricingAttributes() {
		const toggledVisible = !this.viewSettings.pricingAttributes.isVisible;
		this.viewSettings.pricingAttributes.isVisible = toggledVisible;
		this.viewSettings.pricingAttributes.label = toggledVisible ? LABEL_HIDE_PRICING_ATTRIBUTES : LABEL_SHOW_PRICING_ATTRIBUTES;
		this.setRowColumnVisible([], this.columnIndicesFor(ColumnGroup.PRICING_ATTRIBUTE), toggledVisible);
	}

	toggleMetrics() {
		const toggledVisible = !this.viewSettings.metrics.isVisible;
		this.viewSettings.metrics.isVisible = toggledVisible;
		this.viewSettings.metrics.label = toggledVisible ? LABEL_HIDE_METRICS : LABEL_SHOW_METRICS;

		const action = toggledVisible ? 'show' : 'hide';
		const payload = { receiver: 'quoteMetrics' };
		this._componentState.publish({ key: action, value: payload });
	}

	handleRateChange(event) {
		const { reporter, rateOverrideValues } = event.detail.value;
		if (reporter === 'rateConversionFactors') {
			const overrideValues = JSON.parse(rateOverrideValues);
			for (let i = 0; i < overrideValues.length; i++) {
				const overrideValue = overrideValues[i];
				let resultingVal;
				if (overrideValue.fieldValue && overrideValue.fieldValue.length > 0) {
					resultingVal = Number.parseInt(overrideValue.fieldValue, 10);
				} else {
					resultingVal = Number.parseInt(overrideValue.defaultFieldValue, 10);
				}

				if (overrideValue.fieldApiName.includes(ScheduleSettingFields.STANDARD_DAY_HOURS)) {
					this._scheduleSettings.standardDayHours = resultingVal;
				} else if (overrideValue.fieldApiName.includes(ScheduleSettingFields.STANDARD_WEEK_HOURS)) {
					this._scheduleSettings.standardWeekHours = resultingVal;
				} else if (overrideValue.fieldApiName.includes(ScheduleSettingFields.STANDARD_MONTH_HOURS)) {
					this._scheduleSettings.standardMonthHours = resultingVal;
				} else if (overrideValue.fieldApiName.includes(ScheduleSettingFields.STANDARD_YEAR_HOURS)) {
					this._scheduleSettings.standardYearHours = resultingVal;
				}
			}

			this.resetAndReprice();
		}
	}

	async handleFlowFinish() {
		const { quotePeriodList } = await getQuoteTemplate({ quoteId: this.recordId });

		this.periods = quotePeriodList;
		this.periodsByGroup = {};
		this.periodGroups = {};
		this.periodsBySequence = {};
		this.periods.forEach((period) => {
			let periodsForGroup = this.periodsByGroup[period.periodGroupId];
			if (!periodsForGroup) {
				periodsForGroup = [];
				this.periodsByGroup[period.periodGroupId] = periodsForGroup;
			}

			periodsForGroup.push(period);
			this.periodGroups[period.periodGroupId] = {
				name: period.periodGroupName,
			};
			this.periodsBySequence[period.sequence] = period.term;
		});

		this._columnsByName = null; // force rebuild of columnsByName map
		this.refreshGrid();
	}

	async toggleTotalAmount() {
		const rows = await this.getTotalRows();
		const cols = this.getTotalCols();
		this.setRowColumnVisible(rows, cols, this.viewSettings.totals.isVisible);
	}

	async getTotalRows() {
		const rowCount = await this.grid.countRows();
		const quoteItemsCount = Object.keys(this.quoteItems).length;
		const rows = [];
		let quoteItemRow = -3;
		let quoteItemsCountTmp = 0;
		Object.keys(this.sections).forEach((section) => {
			const sectionQuoteItemsCount = this.sections[section].quoteItems.length;
			quoteItemRow += sectionQuoteItemsCount + 3;
			quoteItemsCountTmp += sectionQuoteItemsCount;
			// head count and total rows of the section
			rows.push(quoteItemRow + 1, quoteItemRow + 2);
		});

		// ungrouped items
		if (quoteItemsCount > quoteItemsCountTmp) {
			quoteItemRow += quoteItemsCount - quoteItemsCountTmp + 3;
			rows.push(quoteItemRow + 1, quoteItemRow + 2);
		}

		for (let row = rowCount - 3; row < rowCount; row++) {
			// Column total of Head count and Amount
			rows.push(row);
		}

		return rows;
	}

	getTotalCols() {
		const periodColOffset = this.periodColumnsOffset();
		const cols = [];
		let colStart = periodColOffset - 1;
		Object.keys(this.periodsByGroup).forEach((group) => {
			colStart += this.periodsByGroup[group].length + 1;
			cols.push(colStart);
		});
		cols.push(cols[cols.length - 1] + 1);
		return cols;
	}

	async setRowColumnVisible(
		rows = [],
		cols = [],
		isVisible,
	) {
		let methodNameRow = 'showRows';
		let methodNameCol = 'showColumns';
		if (!isVisible) {
			methodNameRow = 'hideRows';
			methodNameCol = 'hideColumns';
		}

		// hide the total rows
		if (rows.length) {
			await this.grid.invokeMethods({
				methodName: 'getPlugin',
				args: ['hiddenRows'],
				then: {
					methodName: methodNameRow,
					args: [rows],
				},
			});
		}

		if (cols.length) {
			await this.grid.invokeMethods({
				methodName: 'getPlugin',
				args: ['HiddenColumns'],
				then: {
					methodName: methodNameCol,
					args: [cols],
				},
			});
		}

		this.grid.render();
	}

	/**
	 * Launches add/edit resrouce role dialog
	 *
	 * @param action
	 * @param selectedRange
	 * @param options
	 */
	async handleOpenRoleDialog(action, selectedRange, options) {
		this.modalAction = action;
		[this.selectedRange] = selectedRange;
		let headerLabel = LABEL_ADD_RESOURCE;
		let quoteItem;
		const showCloseButton = !(options && options.showCloseButton === false);
		const { start } = this.selectedRange;
		const componentName = 'resourceRoleDialog';
		const auraId = 'resource-role-dialog';
		if (action === 'edit_row') {
			headerLabel = LABEL_EDIT_RESOURCE;
			quoteItem = await this.getQuoteItemForRow(start.row);
		}

		const dialogServicePayload = {
			method: 'bodyModalLarge',
			config: {
				auraId,
				headerLabel,
				showCloseButton,
				component: `${this.namespace}:${componentName}`,
				componentParams: {
					quote: this.recordId,
					group: this.group,
					practice: this.practice,
					rateCard: this.rateCardId,
					selectedRole: quoteItem?.productId,
					rateCardItemId: quoteItem?.rateCardItemId,
					showCloseButton,
				},
			},
		};

		this._componentState.dialogService(dialogServicePayload);
	}

	/**
	 * Launches the dialog for recurring hours
	 *
	 * @param action
	 * @param selectedRange
	 * @param options
	 */
	async handleOpenRecurringHoursDialog(action, selectedRange, options) {
		[this.selectedRange] = selectedRange;
		this.modalAction = action;
		const dialogServicePayload = getRecurringHoursDialog(this.namespace, this.recurringHoursTimePeriod, LABEL_ADD_RECURRING_HOURS, options);
		this._componentState.dialogService(dialogServicePayload);
	}

	/**
	 * Handles resource role selected event from resource role dialog once user has accepted a selection
	 * @param event
	 * @returns {Promise<void>}
	 */
	async handleRoleSelected(event) {
		const { start } = this.selectedRange;
		switch (this.modalAction) {
			case ContextMenuActions.ROW_BELOW: {
				const newRow = this.spliceNewRows(start.row + 1, [event.detail.value]);
				await this._quoteService.saveLines();
				await this.addRowsToSection(start.row + 1, newRow);
				await this.refreshGrid();
				await this.repriceAll();
				await this._quoteService.saveSections();
				break;
			}

			case ContextMenuActions.EDIT_ROW: {
				await this.changeResourceRole(start.row, event.detail.value);
				await this.refreshGrid();
				await this.updateTotalsFor(start.row);
				await this.repriceAll();

				this._quoteService.saveLines().catch((e) => {
					log('Failed to save lines ');
					log(e);
				});
				break;
			}

			default:
		}
	}

	async handleRecurringHours(event) {
		const { start } = this.selectedRange;
		switch (this.modalAction) {
			case 'recurring_hours': {
				// updating cells
				await updateRecurringHours({
					row: start.row,
					recurringInfo: event.detail.value,
					rowMetadata: this.rowMetadata,
					quoteItems: this.quoteItems,
					recurringHoursTimePeriod: this.recurringHoursTimePeriod,
					laborUnits: this.laborUnits,
					periodColumnMetadata: this.columnMetadata.filter((column) => column.isPeriod),
					quoteScheduleSettings: this._scheduleSettings,
				});
				await this.refreshGrid();
				this._quoteService.saveLines().catch((e) => {
					log('Failed to save lines ');
					log(e);
				});
				await this.repriceAll();
				break;
			}

			default:
		}
	}

	/**
	 * toggles billable/non-billable for current row
	 *
	 * @param action
	 * @param selectedRange
	 */
	async handleToggleBilling(action, selectedRange) {
		[this.selectedRange] = selectedRange;
		const { start } = this.selectedRange;
		const { row } = start;
		const targetMeta = await this.grid.getCellMeta(row, 0);
		const quoteItem = this.quoteItems[targetMeta.$id];
		const adjustedUnitPriceIdx = this.getPropIdx(QUOTE_ITEM_ADJUSTED_UNIT_PRICE_FIELD.fieldApiName);
		if (action === 'toggle_billable') {
			quoteItem.quoteItemSO[QUOTE_ITEM_NONBILLABLE_FIELD.fieldApiName] = false;
			quoteItem.quoteItemSO[QUOTE_ITEM_ADJUSTED_UNIT_PRICE_FIELD.fieldApiName] = null;
			this.grid.setCellMetaObject(row, adjustedUnitPriceIdx, { readOnly: false });
			this.grid.setSourceDataAtCell(row, QUOTE_ITEM_NONBILLABLE_FIELD.fieldApiName, false);
		} else {
			quoteItem.quoteItemSO[QUOTE_ITEM_NONBILLABLE_FIELD.fieldApiName] = true;
			this.grid.setCellMetaObject(row, adjustedUnitPriceIdx, { readOnly: true });
			this.grid.setSourceDataAtCell(row, QUOTE_ITEM_NONBILLABLE_FIELD.fieldApiName, true);
		}

		try {
			await this.repriceQuoteGrid(); // calls updateTotalsForRows and saves quote items
			await this.repriceAll();
		} catch (e) {
			// in case of error revert non-billable flag
			const revertedNonBillableVal = !quoteItem.quoteItemSO[QUOTE_ITEM_NONBILLABLE_FIELD.fieldApiName];
			quoteItem.quoteItemSO[QUOTE_ITEM_NONBILLABLE_FIELD.fieldApiName] = revertedNonBillableVal;
			this.grid.setSourceDataAtCell(row, QUOTE_ITEM_NONBILLABLE_FIELD.fieldApiName, revertedNonBillableVal);
			this.toastError(e);
		}
	}

	async changeResourceRole(row, rateCardItem) {
		const targetMeta = await this.grid.getCellMeta(row, 0);
		const targetRow = this.quoteItems[targetMeta.$id];

		targetRow.elementDO.rateCardItemId = rateCardItem.Id;
		targetRow.elementDO.productId = rateCardItem[RATE_CARD_ITEM_PRODUCT_FIELD.fieldApiName];

		const rateCardAttributes = this.getRateCardAttributes();
		rateCardAttributes.forEach((rateCardAttribute) => {
			const { fieldName } = rateCardAttribute;
			targetRow.elementDO.quoteItemSO[fieldName] = rateCardItem[fieldName];
		});

		await this.setPricePoints(row, true);
	}

	async findFirstValidRateCardItem(productId, skillLevel, locationCountry) {
		const rateCardItems = await this.getRateCardItemsFor(productId);
		let rateCardItem;
		if (rateCardItems?.length) {
			rateCardItem = rateCardItems.find(
				(item) => item[QUOTE_ITEM_LOCATION_COUNTRY_FIELD.fieldApiName] === (locationCountry || null)
					&& item[QUOTE_ITEM_SKILL_LEVEL_FIELD.fieldApiName] === (skillLevel || null),
			);
		}

		return rateCardItem;
	}

	async recomputeColumnTotals() {
		const columnNames = {};
		this.columnMetadata.forEach((column) => {
			if (column.isPeriod) {
				columnNames[column.data] = true;
			}
		});
		await this.updateColumnsTotals(columnNames, false);
	}

	async handleOpenAdjustment() {
		await this.grid.deselectCell();
		this.disableAdjustment = false;

		if (!this._modal) {
			this._modal = this.template.querySelector('c-modal');
		}

		this._modal.show();
	}

	handleCloseModal() {
		if (!this._modal) {
			this._modal = this.template.querySelector('c-modal');
		}

		this._modal.hide();
	}

	async handleQuoteMerge() {
		const collabSectionIds = this.collaborationRequests.map((nextRequest) => nextRequest.sectionId);
		if (collabSectionIds.length === 0) {
			return;
		}

		let results;
		try {
			results = await mergeSections({
				quoteId: this.recordId,
				sectionIds: collabSectionIds,
			});
		} catch (e) {
			this._componentState.notifySingleError('Failed to merge sections', e);
			return;
		}

		for (let i = 0; i < this.collaborationRequests.length; i++) {
			this.collaborationRequests[i].status = CollaborationRequest.Status.MERGED;
		}

		if (results) {
			this.mergeCollaboratedQuoteItems(JSON.parse(results), collabSectionIds);
		}

		this.actionsMap.merge.enabled = false;
		await this.refreshGrid();
		this.rerender();

		const evt = new ShowToastEvent({
			title: LABEL_COLLABORATION_MERGED,
			variant: 'success',
		});

		this.dispatchEvent(evt);
	}

	mergeCollaboratedQuoteItems(resultQuoteItems, collabSectionIds) {
		const sections = collabSectionIds.map((nextSectionId) => this.findSectionFor(nextSectionId));
		const sectionItemsById = new Map();
		sections.forEach((nextSection) => {
			nextSection.quoteItems.forEach((nextItem) => {
				sectionItemsById.set(nextItem.elementDO.id, nextItem);
			});
		});

		this._quoteService.mergeItemsBy(
			resultQuoteItems,
			(item) => item.id,
			Object.fromEntries(sectionItemsById),
		);

		this.processItemChanges(resultQuoteItems, sectionItemsById);
	}

	/**
	 * Processes the quote item additions and removals of the collaboration merge.
	 * @param {QuoteItemDTO[]} resultQuoteItems
	 * @param {Object}sectionItemsById
	 */
	processItemChanges(resultQuoteItems, sectionItemsById) {
		const quoteItemsById = new Map();
		Object.values(this.quoteItems).forEach((nextItem) => {
			quoteItemsById.set(nextItem.id, nextItem);
		});

		resultQuoteItems.forEach((nextItem) => {
			const quoteItem = quoteItemsById.get(nextItem.id);
			if (quoteItem) {
				sectionItemsById.delete(quoteItem.id);
			} else {
				const newQuoteItem = this.newQuoteItem(nextItem);
				const section = this.findSectionFor(newQuoteItem.sectionId);
				section.addQuoteItem(newQuoteItem);
			}
		});

		// any remaining items in the map signifies that the server
		// no longer has this item and should be deleted
		sectionItemsById.forEach((item) => {
			if (item.parent) {
				item.parent.removeChild(item);
				item.commit(OBSERVER_NAME_SFDC); // clear from dirty observers to avoid future updates
			}

			const quoteItem = quoteItemsById.get(item.id);
			delete this.quoteItems[quoteItem.$id];
			QuoteItemsDataService.removeQuoteItem(quoteItem.$id);
		});
	}

	/**
	 * Commits the current collaboration quote.
	 */
	handleCommit() {
		for (let i = 0; i < this.collaborationRequests.length; i++) {
			this.collaborationRequests[i].status = CollaborationRequest.Status.READY_TO_MERGE;
		}

		const targetSectionIds = this.collaborationRequests.map((nextRequest) => nextRequest.sectionId);
		targetSectionIds.push(...this.collaborationRequests.map((nextRequest) => nextRequest.sectionDerivedFromId));

		try {
			commitChanges({ quoteId: this.recordId, sectionIds: targetSectionIds.filter((x) => x) });
			this.disableGrid();
			this.rerender();
		} catch (e) {
			this._componentState.notifySingleError('Failed to commit changes', e);
			return;
		}

		const evt = new ShowToastEvent({
			title: LABEL_COLLABORATION_COMMITTED,
			variant: 'success',
		});

		this.dispatchEvent(evt);
	}

	/**
	 * Disables all interaction with the grid.
	 */
	disableGrid() {
		this._isReadOnly = true;
		this.grid.updateSettings({
			comments: false,
			contextMenu: false,
			disableVisualSelection: true,
			manualColumnMove: false,
			manualColumnResize: false,
			manualRowMove: false,
			manualRowResize: false,
			readOnly: true,
		});
		this.refreshGrid();
	}

	/**
	 * Returns true if there are outstanding collaboration requests, that is, if any request
	 * tied to this quote is not yet Ready to Merge.
	 * @returns {boolean} True, if there are outstanding requests, false otherwise
	 */
	hasOutstandingRequests() {
		return this.collaborationRequests
			.some((nextRequest) => nextRequest.status !== CollaborationRequest.Status.READY_TO_MERGE);
	}

	/**
	 * Returns true if there are any Ready to Merge collaboration requests.
	 * @returns {boolean} True, if there are any collaborations to merge, false otherwise
	 */
	hasRequestsToMerge() {
		return this.collaborationRequests
			.some((nextRequest) => nextRequest.status === CollaborationRequest.Status.READY_TO_MERGE);
	}

	/**
	 * Returns true if the quote is a collaboration quote.
	 * @returns {boolean} True if collaboration quote, false otherwise
	 */
	isCollaborationQuote() {
		return this.recordType === RecordType.COLLABORATION;
	}

	/**
	 * Forces a DOM rerender. Typically used when enabling/disabling buttons.
	 */
	rerender() {
		this.render = Date.now();
	}

	async resetAndReprice() {
		const pricePromises = [];
		const updatedRows = [];
		for (let i = 0; i < this.rowMetadata.length; i++) {
			const meta = this.rowMetadata[i];
			if (QuoteConfigurator.isQuoteItem(meta)) {
				pricePromises.push(this.setPricePoints(i, true));
				updatedRows.push(i);
			}
		}

		await Promise.all(pricePromises);
		await this.updateTotalsForRows(updatedRows);
		await this.repriceAll();
	}

	async repriceAll() {
		await this.recomputeColumnTotals();
		await this.updateSectionTotals();
		await this.updatePeriodGroupTotals();
		await this.applyAdjustments();
		await this._quoteTotals.saveTotals(true);
	}

	async handleRevoke(action, phaseRange) {
		const { start } = phaseRange[0];
		const sectionMeta = await this.grid.getCellMeta(start.row, 0);
		try {
			await revokeSections({
				quoteId: this.recordId,
				sectionIds: [this.sections[sectionMeta.$id].id],
			});
		} catch (e) {
			this._componentState.notifySingleError('Failed to revoke section', e);
			return;
		}

		await this.reloadCollaborationRequests();
		this.refreshGrid();
	}

	assignChildren() {
		const newRoots = [];
		let nextSequence = 1;
		this.rowMetadata.forEach((nextItem) => {
			const item = this.quoteItems[nextItem.$id] || this.sections[nextItem.$id];
			if (item?.$treeLevel === 0) {
				item.displaySequence = nextSequence;
				nextSequence += 1;
				newRoots.push(item);
			}
		});

		this.rootItems = newRoots;

		let contextSection;
		let newChildren = [];
		// read through the metadata and reparent quote items below every section
		this.rowMetadata.forEach((nextItem) => {
			const item = this.quoteItems[nextItem.$id] || this.sections[nextItem.$id];
			if (item?.$type === Provus.Section.TYPE) {
				contextSection?.setChildren(newChildren);
				contextSection = item;
				newChildren = [];
			} else if (item?.$type === Provus.QuoteItem.TYPE) {
				newChildren.push(item);
			}
		});

		// last section
		contextSection?.setChildren(newChildren);
	}

	async handleAddPeriods() {
		const dialogServicePayload = {
			method: 'flow',
			config: {
				auraId: 'add-period-flow',
				headerLabel: LABEL_ADD_PERIODS,
				componentParams: {
					flowApiName: `${this.nsPrefix.data}AddPeriodsToQuote`,
					uniqueBoundary: 'component-state',
					inputVariables: [
						{ name: 'quoteId', type: 'String', value: this.recordId },
						{ name: 'numOfQuotePeriods', type: 'Number', value: this.periods.length }],
				},
			},
		};

		this._componentState.dialogService(dialogServicePayload);
	}

	async handleAfterDelinkEstimate() {
		this.isEstimateSync = false;
		this.template.querySelector('c-message-service').forceRefreshView();
		this._columnsByName = null;
		await this.refreshGrid();
	}

	async handleShowImportResources(action, position) {
		const { start } = position[0];
		// start position is 0th index
		const dialogServicePayload = getImportResourcesDialog(this.namespace, LABEL_IMPORT_RESOURCES, this.recordId, start.row + 2);
		this._componentState.dialogService(dialogServicePayload);
	}

	async showResourceRoleActivities(action, selectedRange) {
		[this.selectedRange] = selectedRange;
		const { start } = this.selectedRange;
		const { row } = start;
		const targetMeta = this.rowMetadata[row];
		const quoteItem = this.quoteItems[targetMeta.$id];
		const resourceRole = this.productsById[quoteItem.elementDO.productId];
		const componentName = 'resourceRoleActivities';
		const auraId = 'resource-role-activities';
		const headerLabel = `${resourceRole.name} - ${LABEL_ACTIVITIES_TASKS}`;

		const dialogServicePayload = {
			method: 'bodyModalLarge',
			config: {
				auraId,
				headerLabel,
				component: `${this.namespace}:${componentName}`,
				componentParams: {
					resourceRoleId: resourceRole.id,
					timePeriod: this.quoteTimePeriod,
					quoteId: this.recordId,
					periods: this.periods,
					sections: this.sections,
					quoteItems: this.quoteItems,
				},
				footerActions: [
					{ label: LABEL_CLOSE, eventName: 'close', class: '' },
				],
			},
		};

		this._componentState.dialogService(dialogServicePayload);
	}

	static marginPercentage(revenue, cost) {
		if (revenue === 0 && cost > 0) {
			return 0;
		}

		const relativeDifference = revenue - cost || 0;
		return relativeDifference === 0 ? 0 : (relativeDifference / revenue) * 100;
	}

	static isNullOrUndefined(obj) {
		return obj === null || typeof obj === 'undefined';
	}

	static padColumns(columnToPad, totalLength) {
		const columns = columnToPad;
		let totalSpan = 0;

		columns.forEach((column) => {
			if (typeof column === 'string') {
				totalSpan += 1;
			} else {
				totalSpan += column.colspan;
			}
		});

		const remainingColSpan = totalLength - totalSpan;
		if (remainingColSpan) {
			if (remainingColSpan !== 1) {
				const lastEntry = columns[columns.length - 1];
				if (typeof lastEntry === 'string') {
					columns[columns.length - 1] = {
						label: '',
						colspan: 1 + (remainingColSpan - 2),
					};
				} else {
					lastEntry.colspan += remainingColSpan - 2;
				}
			}

			columns.push({ label: '', colspan: 2 }); // blank entry for totals column
		}

		return columns;
	}
}
