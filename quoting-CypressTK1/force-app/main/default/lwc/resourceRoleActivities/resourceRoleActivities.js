import {
	LightningElement, track, api, wire,
} from 'lwc';
import getActivitiesAndTasks from '@salesforce/apex/QuoteConfiguratorController.getActivitiesAndTasks';
import NamespacePrefix from '@salesforce/apex/SystemUtility.getNamespacePrefix';
import { formatLabel } from 'c/util';
import { Quote } from 'c/constantUtil';
import LABEL_PROJECT_PHASE from '@salesforce/label/c.ProjectPhase';
import LABEL_ACTIVITY_GROUP from '@salesforce/label/c.ActivityGroup';
import LABEL_ACTIVITY from '@salesforce/label/c.Activity';
import LABEL_TASK from '@salesforce/label/c.Task';
import LABEL_HOURS from '@salesforce/label/c.Hours';
import LABEL_PERCENT_OF_TOTAL_HOURS from '@salesforce/label/c.PercentOfTotalHours';
import LABEL_HOURS_PER_PERIOD from '@salesforce/label/c.HoursPerQuotePeriod';
import LABEL_GRAND_TOTAL from '@salesforce/label/c.GrandTotal';
import LABEL_TOTAL_AMOUNT from '@salesforce/label/c.TotalAmount';
import LABEL_RATE from '@salesforce/label/c.Rate';
import LABEL_HOURLY from '@salesforce/label/c.Hourly';
import LABEL_DAILY from '@salesforce/label/c.Daily';
import LABEL_WEEKLY from '@salesforce/label/c.Weekly';
import LABEL_MONTHLY from '@salesforce/label/c.Monthly';
import LABEL_QUARTERLY from '@salesforce/label/c.Quarterly';
import LABEL_HEADCOUNTVIEW from '@salesforce/label/c.ShowHeadCountView';
import QUOTE_ITEM_ADJUSTED_UNIT_PRICE_FIELD from '@salesforce/schema/QuoteItem__c.AdjustedUnitPrice__c';

export default class ResourceRoleActivities extends LightningElement {
	@track columns;
	@track data = [];
	@track width;
	@api resourceRoleId;
	@api timePeriod;
	@api quoteId;
	@api periods;
	@api sections;
	@api quoteItems;
	nsPrefix = '';
	lastPeriodHour = 0;
	lastPeriodPendingHours = 0;
	subtotal = {};
	grandTotal = {};
	Label = {
		SHOWHEADCOUNTVIEW: LABEL_HEADCOUNTVIEW,
	}

	@wire(NamespacePrefix)
	assignPrefix({ data }) { this.nsPrefix = data; }

	renderedCallback() {
		this._componentState = this.template.querySelector('c-message-service');
	}

	async connectedCallback() {
		this.createColumns();
		await this.loadData();
	}

	showHeadCountView(event) {
		this.headCountView = event.target.checked;
		this.createColumns();
	}

	setWidth() {
		this.width = `width: ${this.columns.length * 125}px`;
	}

	createColumns() {
		this.columns = [];
		const types = ['text', 'text', 'text', 'number', 'number', 'number', 'number'];
		const fieldNames = ['activityGroupName', 'activityName', 'name'];

		const labels = [LABEL_ACTIVITY_GROUP, LABEL_ACTIVITY, LABEL_TASK, LABEL_HOURS, LABEL_PERCENT_OF_TOTAL_HOURS,
			formatLabel(LABEL_HOURS_PER_PERIOD, [this.timePeriod]), `# ${this.timePeriod}`];

		if (!this.headCountView) {
			fieldNames.push(...['taskHours', 'percentOfTotalHours', 'hoursPerPeriod', 'noOfPeriods']);
		}

		let subTotalIndex = 1;
		if (this.isPhasesEnabled) {
			fieldNames.unshift('phaseName');
			labels.unshift(LABEL_PROJECT_PHASE);
			types.unshift('text');
			subTotalIndex = 2;
		}

		let idx;
		for (idx = 0; idx < fieldNames.length; idx++) {
			const columnInfo = {
				type: types[idx],
				fieldName: fieldNames[idx],
				label: labels[idx],
			};

			if (idx > subTotalIndex) {
				columnInfo.cellAttributes = { class: { fieldName: 'format' } };
			}

			this.columns.push(columnInfo);
		}

		this.loadPeriodColumn();
		this.loadTotalColumn();
		this.setWidth();
	}

	loadTotalColumn() {
		const rateColumnInfo = {
			type: 'currency',
			fieldName: this.headCountFieldName('rate'),
			label: `${this.getQuotePeriodLabel()} ${LABEL_RATE}`,
			cellAttributes: {
				class: {
					fieldName: 'format',
				},
			},
		};

		this.columns.push(rateColumnInfo);

		const totalColumnInfo = {
			type: 'currency',
			fieldName: 'totalAmount',
			label: LABEL_TOTAL_AMOUNT,
			cellAttributes: {
				class: {
					fieldName: 'format',
				},
			},
		};

		this.columns.push(totalColumnInfo);
	}

	getQuotePeriodLabel() {
		if (this.headCountView) {
			switch (this.timePeriod) {
				case Quote.TimePeriod.DAYS:
					return LABEL_DAILY;
				case Quote.TimePeriod.WEEKS:
					return LABEL_WEEKLY;
				case Quote.TimePeriod.MONTHS:
					return LABEL_MONTHLY;
				case Quote.TimePeriod.QUARTERS:
					return LABEL_QUARTERLY;
				default:
					return LABEL_HOURLY;
			}
		} else {
			return LABEL_HOURLY;
		}
	}

	headCountFieldName(fieldName) {
		if (this.headCountView) {
			return `${fieldName}_hc`;
		}

		return fieldName;
	}

	loadPeriodColumn() {
		this.periods.forEach((record) => {
			const columnInfo = {
				type: 'number',
				fieldName: this.headCountFieldName(record.id),
				label: record.name,
				cellAttributes: {
					class: {
						fieldName: 'format',
					},
				},
			};

			this.columns.push(columnInfo);
		});
	}

	findSectionFor(activityGroupId) {
		return Object.values(this.sections).find((nextSection) => nextSection.elementDO.activityGroupId === activityGroupId);
	}

	findQuoteItemsFor(activityGroupId, resourceRoleId) {
		const section = this.findSectionFor(activityGroupId);
		return Object.values(this.quoteItems).filter((item) => item.elementDO.sectionId === section.elementDO.id
			&& item.elementDO.productId === resourceRoleId);
	}

	findPeriodFor(startDate) {
		return Object.values(this.periods).find((nextPeriod) => nextPeriod.startDate === startDate);
	}

	findSubtotalFor(activityGroupId) {
		return Object.values(this.data).find((nextRecord) => nextRecord.id === activityGroupId);
	}

	findStartPeriodIndex(activityGroupId) {
		const section = this.findSectionFor(activityGroupId);
		const period = this.findPeriodFor(section.elementDO.startDate);
		return this.periods.indexOf(period);
	}

	async loadData() {
		this.data = await getActivitiesAndTasks({ resourceRoleId: this.resourceRoleId, quoteId: this.quoteId });
		let startPeriod = this.findStartPeriodIndex(this.data[0].activityGroupId);
		let groupPeriodIdx = startPeriod;
		this.grandTotal = { id: 'grandtotal', name: LABEL_GRAND_TOTAL, format: 'slds-text-title_bold slds-color__background_gray-4' };
		this.data.forEach((record) => {
			const current = record;
			if (!record.activityGroupName) {
				current.format = 'slds-text-title_bold slds-color__background_gray-4';
				startPeriod = groupPeriodIdx;
				this.lastPeriodPendingHours = current.hoursPerPeriod - this.lastPeriodHour;

				if (this.lastPeriodPendingHours === 0) {
					startPeriod += 1;
				} else {
					this.lastPeriodPendingHours = this.lastPeriodHour;
				}

				groupPeriodIdx = 0;
				this.grandTotal.taskHours = (this.grandTotal.taskHours || 0) + current.taskHours;
				this.grandTotal.noOfPeriods = (this.grandTotal.noOfPeriods || 0) + current.noOfPeriods;
				this.grandTotal.totalAmount = (this.grandTotal.totalAmount || 0) + current.totalAmount;
				return;
			}

			const lastIndex = this.populatePeriodHours(record, startPeriod);
			if (lastIndex > groupPeriodIdx) {
				groupPeriodIdx = lastIndex;
			}
		});
		this.data.push(this.grandTotal);
	}

	populatePeriodHours(record, startPeriod) {
		const current = record;
		let { taskHours } = current;
		let idx = startPeriod;
		const subtotal = this.findSubtotalFor(current.activityGroupId);
		const quoteItems = this.findQuoteItemsFor(current.activityGroupId, this.resourceRoleId);
		while (Math.round(taskHours) > 0) {
			const period = this.periods[idx] || { term: 1, id: `period-${idx}` };
			const periodHour = current.hoursPerPeriod * this.getPeriodHours(quoteItems, idx);
			current[period.id] = periodHour;
			current[`${period.id}_hc`] = current[period.id] / subtotal.hoursPerPeriod;
			taskHours -= current[period.id];
			subtotal[period.id] = (subtotal[period.id] || 0) + current[period.id];
			subtotal[`${period.id}_hc`] = (subtotal[`${period.id}_hc`] || 0) + current[`${period.id}_hc`];
			this.lastPeriodHour = Math.round(subtotal[period.id]);
			this.grandTotal[period.id] = (this.grandTotal[period.id] || 0) + current[period.id];
			this.grandTotal[`${period.id}_hc`] = (this.grandTotal[`${period.id}_hc`] || 0) + current[`${period.id}_hc`];
			this.lastPeriodPendingHours = 0;
			idx += 1;
		}

		const price = quoteItems[0].elementDO.quoteItemSO[QUOTE_ITEM_ADJUSTED_UNIT_PRICE_FIELD.fieldApiName];
		current.rate = price / subtotal.hoursPerPeriod;
		current.rate_hc = price;
		current.totalAmount = current.rate * current.taskHours;
		subtotal.totalAmount = (subtotal.totalAmount || 0) + current.totalAmount;

		return idx - 1;
	}

	getPeriodHours(quoteItems, idx) {
		return quoteItems.reduce((r, quoteItem) => {
			let current = r || 0;
			const cell = quoteItem.elementDO.quoteItemSO[`${this.nsPrefix}QuoteItemCells__r`].records[0];
			current += cell[this.getCellFieldName(idx)];
			return current;
		}, 0);
	}

	getCellFieldName(idx) {
		return `${this.nsPrefix}C${(`00${idx + 1}`).slice(-3)}__c`;
	}
}
