/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

import { api, LightningElement, track } from 'lwc';
import getTasks from '@salesforce/apex/TaskDiscoveryController.getTasks';
import saveTasks from '@salesforce/apex/TaskDiscoveryController.saveTasks';
import { TemplateDataType } from 'c/constantUtil';

export default class TaskDiscovery extends LightningElement {
	@api recordId;
	@api initialTaskId;
	@api uniqueBoundary;

	_messageService;

	data = [];
	@track currentTask = {};
	currentIndex = 0;

	get indexPosition() {
		return `${this.currentIndex + 1} / ${this.data.length}`;
	}

	async connectedCallback() {
		this.data = await getTasks({ estimateId: this.recordId });
		this.currentIndex = this.data.findIndex((nextTask) => nextTask.id === this.initialTaskId);
		this.currentTask = this.data[this.currentIndex];
	}

	renderedCallback() {
		this._messageService = this.template.querySelector('c-message-service');
	}

	@api
	handleNext() {
		this.currentIndex += 1;

		if (this.currentIndex > this.data.length - 1) {
			this.currentIndex = this.data.length - 1;
		}

		this.currentTask = this.data[this.currentIndex];
	}

	@api
	handlePrevious() {
		this.currentIndex -= 1;

		if (this.currentIndex < 0) {
			this.currentIndex = 0;
		}

		this.currentTask = this.data[this.currentIndex];
	}

	@api
	async save() {
		await saveTasks({ tasks: this.data });
		this._messageService.publish({ key: 'resourceupdate' });
		this._messageService.notifyBoundaryClose();
	}

	toggleApplicable(event) {
		this.currentTask.isNotApplicable = event.target.checked;
		// TODO: recalc durations when this is false
	}

	handleChange(event) {
		const fieldName = event.target.dataset.name;
		this.currentTask[fieldName] = event.target.value;

		if (fieldName === 'levelAdjustment') {
			this.currentTask.levelAdjustment = +this.currentTask.levelAdjustment;
			this.currentTask.totalEstimatedDuration = this.currentTask.totalCalculatedDuration + this.currentTask.levelAdjustment;
		}
	}

	handleParameterChange = (function handleChange(event) {
		const paramTemplate = this.currentTask.parameterTemplates[event.target.dataset.index];
		const paramValue = paramTemplate.parameterValue;
		if (paramTemplate.dataType === TemplateDataType.CHECKBOX) {
			paramValue.booleanValue = event.detail.checked;
		} else {
			paramValue.integerValue = +event.detail.value;
		}

		if (paramTemplate.dataType === TemplateDataType.PICKLIST) {
			const matchingParamValue = paramTemplate.parameterValueTemplates.find((nextValueTemplate) => nextValueTemplate.perUnitDuration === +event.detail.value);
			paramValue.textValue = matchingParamValue.label;
		}

		this.updateCalculatedDuration();

		return this;
	}
	).bind(this);

	updateCalculatedDuration() {
		let totalCalculatedDuration = 0;
		this.currentTask.parameterTemplates.forEach((parameterTemplate) => {
			const {
				parameterValue: {
					booleanValue,
					integerValue,
				},
				parameterValueTemplates,
			} = parameterTemplate;

			const perUnitDuration = parameterValueTemplates[0]?.perUnitDuration || 0;
			if (parameterTemplate.dataType === TemplateDataType.INTEGER) {
				totalCalculatedDuration += (integerValue * perUnitDuration);
			} else if (parameterTemplate.dataType === TemplateDataType.PICKLIST) {
				totalCalculatedDuration += perUnitDuration;
			} else if (parameterTemplate.dataType === TemplateDataType.CHECKBOX) {
				totalCalculatedDuration += booleanValue ? perUnitDuration : 0;
			} else if (parameterTemplate.dataType === TemplateDataType.INTEGER_TIERS) {
				const matchTier = parameterValueTemplates.find((template) => +template.fromValue <= integerValue && integerValue <= template.toValue);
				if (matchTier) {
					totalCalculatedDuration += (integerValue * matchTier.perUnitDuration);
				}
			}
		});
		this.currentTask.totalCalculatedDuration = totalCalculatedDuration;
		this.currentTask.totalEstimatedDuration = this.currentTask.totalCalculatedDuration + this.currentTask.levelAdjustment;
	}
}
