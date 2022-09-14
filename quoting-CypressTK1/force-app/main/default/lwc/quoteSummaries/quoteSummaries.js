import {
	LightningElement, api, track, wire,
} from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import getQuoteSummaries from '@salesforce/apex/QuoteSummariesController.getQuoteSummaries';
import { formatLabel } from 'c/util';
import SOBJECT_NAME_PROJECT_PHASE from '@salesforce/schema/ProjectPhase__c';

// labels
import LABEL_COST from '@salesforce/label/c.Cost';
import LABEL_MARGIN from '@salesforce/label/c.Margin';
import LABEL_PERCENT_OF_TOTAL_COST from '@salesforce/label/c.PercentOfTotalCost';
import LABEL_PERCENT_OF_TOTAL_HEAD_COUNT from '@salesforce/label/c.PercentOfTotalHeadCount';
import LABEL_PERCENT_OF_TOTAL_REVENUE from '@salesforce/label/c.PercentOfTotalRevenue';
import LABEL_PERIOD_GROUP from '@salesforce/label/c.PeriodGroup';
import LABEL_PERSON_MONTHS from '@salesforce/label/c.PersonMonths';
import LABEL_PROJECT_PHASE from '@salesforce/label/c.ProjectPhase';
import LABEL_RESOURCE_ROLE from '@salesforce/label/c.ResourceRole';
import LABEL_REVENUE from '@salesforce/label/c.Revenue';
import LABEL_SUMMARY from '@salesforce/label/c.Summary';
import LABEL_LOCATION from '@salesforce/label/c.Location';
import LABEL_SECTION from '@salesforce/label/c.Section';
import LABEL_LOCATIONSUMMARY from '@salesforce/label/c.LocationSummary';
import LABEL_SECTIONSUMMARY from '@salesforce/label/c.SectionSummary';

export default class QuoteSummaries extends LightningElement {
	@api recordId;
	@track resourceRoleSummaries = [];
	@track resourceRoleOverrideSummaries = [];
	@track projectPhaseSummaries = [];
	@track periodGroupSummaries = [];
	@track locationSummaries = [];
	@track sectionSummaries =[];
	@track showSpinner = false;

	LABEL_SUMMARY = LABEL_SUMMARY;
	LABEL_LOCATIONSUMMARY = LABEL_LOCATIONSUMMARY;
	LABEL_SECTIONSUMMARY = LABEL_SECTIONSUMMARY;
	@wire(getObjectInfo, { objectApiName: SOBJECT_NAME_PROJECT_PHASE })
	projectPhaseSchema;

	baseColumns = [
		{ label: LABEL_PERSON_MONTHS, fieldName: 'totalQuantity', type: 'decimal' },
		{ label: LABEL_PERCENT_OF_TOTAL_HEAD_COUNT, fieldName: 'percentageTotalQuantity', type: 'percent' },
		{ label: LABEL_REVENUE, fieldName: 'totalAmount', type: 'currency' },
		{ label: LABEL_PERCENT_OF_TOTAL_REVENUE, fieldName: 'percentageTotalAmount', type: 'percent' },
		{ label: LABEL_COST, fieldName: 'totalCost', type: 'currency' },
		{ label: LABEL_PERCENT_OF_TOTAL_COST, fieldName: 'percentageTotalCost', type: 'percent' },
		{ label: LABEL_MARGIN, fieldName: 'marginPercent', type: 'percent' },
	];

	resourceRoleColumns = [{ label: LABEL_RESOURCE_ROLE, fieldName: 'rowName' }, ...this.baseColumns];

	projectPhaseColumns = [
		{ label: LABEL_PROJECT_PHASE, fieldName: 'rowName', type: 'text' },
		...this.baseColumns,
	];

	periodGroupColumns = [
		{ label: LABEL_PERIOD_GROUP, fieldName: 'rowName', type: 'text' },
		...this.baseColumns,
	];

	locationColumns = [
		{ label: LABEL_LOCATION, fieldName: 'rowName', type: 'text' },
		...this.baseColumns,
	];
	sectionColumns = [
		{ label: LABEL_SECTION, fieldName: 'rowName', type: 'text' },
		...this.baseColumns,
	];
	/* eslint-disable max-lines-per-function */
	async connectedCallback() {
		this.loadData();
	}
	changeTimePeriod(timeperiod) {
		this.baseColumns[0].label = formatLabel(this.baseColumns[0].label, [timeperiod]);
	}
	async loadData() {
		const data = await getQuoteSummaries({ quoteId: this.recordId });
		const allSummaries = JSON.parse(data);
		this.changeTimePeriod(allSummaries[0].timePeriod);
		this.loadLocationSummary(allSummaries);
		this.loadSectionSummary(allSummaries);
		const resourceRoleTotals = [];
		const periodGroupTotals = [];
		const projectPhaseTotals = [];
		const resourceRoleOverrideTotals = [];
		if (allSummaries) {
			allSummaries.forEach((nextSummary) => {
				switch (nextSummary.type) {
					case 'role':
						this.resourceRoleSummaries.push(nextSummary);
						break;
					case 'role_override':
						this.resourceRoleOverrideSummaries.push(nextSummary);
						break;
					case 'resourceRoleTotals':
						resourceRoleTotals.push(nextSummary);
						break;
					case 'periodGroup':
						this.periodGroupSummaries.push(nextSummary);
						break;
					case 'periodGroupTotals':
						periodGroupTotals.push(nextSummary);
						break;
					case 'projectPhase':
						this.projectPhaseSummaries.push(nextSummary);
						break;
					case 'projectPhaseTotals':
						projectPhaseTotals.push(nextSummary);
						break;
					case 'resourceRoleOverrideTotals':
						resourceRoleOverrideTotals.push(nextSummary);
						break;
					default:
				}
			});

			this.resourceRoleSummaries.sort((a, b) => ((a.rowName > b.rowName) ? 1 : -1));
			this.resourceRoleSummaries.push(...resourceRoleTotals);
			this.periodGroupSummaries.push(...periodGroupTotals);
			this.projectPhaseSummaries.push(...projectPhaseTotals);
			this.resourceRoleOverrideSummaries.sort((a, b) => ((a.rowName > b.rowName) ? 1 : -1));
			this.resourceRoleOverrideSummaries.push(...resourceRoleOverrideTotals);
		}

		this.showSpinner = false;
	}

	async loadSectionSummary(allSummaries) {
		const sectionTotals = [];
		if (allSummaries) {
			allSummaries.forEach((nextSummary) => {
				switch (nextSummary.type) {
					case 'section':
						this.sectionSummaries.push(nextSummary);
						break;
					case 'sectionTotals':
						sectionTotals.push(nextSummary);
						break;
					default:
				}
			});
			this.sectionSummaries.push(...sectionTotals);
		}
	}

	async loadLocationSummary(allSummaries) {
		const locationTotals = [];
		if (allSummaries) {
			allSummaries.forEach((nextSummary) => {
				switch (nextSummary.type) {
					case 'location':
						this.locationSummaries.push(nextSummary);
						break;
					case 'locationTotals':
						locationTotals.push(nextSummary);
						break;
					default:
				}
			});
			this.locationSummaries.push(...locationTotals);
		}

		this.showSpinner = false;
	}

	refreshSummaryTab(event) {
		if (event.type === 'update') {
			this.showSpinner = true;
			this.resourceRoleSummaries = [];
			this.periodGroupSummaries = [];
			this.projectPhaseSummaries = [];
			this.resourceRoleOverrideSummaries = [];
			this.locationSummaries = [];
			this.sectionSummaries = [];
			this.loadData();
		}
	}
}
