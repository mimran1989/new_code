/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

import { api, LightningElement } from 'lwc';

import getScopeParameters from '@salesforce/apex/ScopeParameterDialogController.getScopeParameters';
import saveScopeParameters from '@salesforce/apex/ScopeParameterDialogController.saveScopeParameters';
import deleteScopeParameterValues from '@salesforce/apex/ScopeParameterDialogController.deleteScopeParameterValues';
import deleteScopeParameters from '@salesforce/apex/ScopeParameterDialogController.deleteScopeParameters';
import getHashtagsForEstimate from '@salesforce/apex/ScopeParameterDialogController.getHashtagsForEstimate';

import LABEL_DUPLICATE_HASHTAG_ERROR from '@salesforce/label/c.DuplicateHashtagError';
import LABEL_ERROR_SAVING_TITLE from '@salesforce/label/c.ErrorSavingNotificationTitle';
import LABEL_SUCCESS_MESSAGE from '@salesforce/label/c.SuccessfullySaved';
import LABEL_SCOPE_PARAMETERS from '@salesforce/label/c.ScopeParameters';
import LABEL_SCOPE_PARAMETER_VALUE from '@salesforce/label/c.ScopeParameterValue';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ScopeParameterDialog extends LightningElement {
	@api estimateId;
	@api uniqueBoundary;
	@api recordId;
	params;
	rendered = false;

	updatedRows = [];
	hashtags = [];

	async connectedCallback() {
		this.hashtags = await getHashtagsForEstimate({ estimateId: this.estimateId });
	}

	async renderedCallback() {
		this._messageService = this.template.querySelector('c-message-service');

		if (!this.rendered && this.recordId) {
			this.params = await getScopeParameters({ parentId: this.recordId });

			const omitHashtags = this.params.map((nextParam) => nextParam.developerName);
			this.hashtags = this.hashtags
				.filter((nextHashtag) => omitHashtags.indexOf(nextHashtag) === -1)
				.map((nextHashtag) => nextHashtag.toLowerCase());
			this.rendered = true;
		}

		const style = document.createElement('style');
		style.innerText = `
				.slds-modal__content {
					overflow: visible !important;
				}
		`;
		this._parameterDialog = this.template.querySelector('c-parameter-dialog');
		this.template.querySelector('.parameter-dialog')?.appendChild(style);
	}

	@api
	save() {
		this._parameterDialog.save();
	}

	async handleSaveParams(event) {
		if (this.recordId) {
			const deletedParamValues = [];
			const params = event.detail.value.data;
			if (!this.hasValidParams(params)) {
				return;
			}

			params.forEach((nextValue) => {
				if (nextValue.deletedParamValues?.length) {
					deletedParamValues.push(...nextValue.deletedParamValues);
				}
			});

			try {
				if (deletedParamValues.length) {
					await deleteScopeParameterValues({ valueTemplateDtos: deletedParamValues });
				}

				const { deleted } = event.detail.value;
				if (deleted?.length) {
					await deleteScopeParameters({ templateDtos: deleted });
				}

				this.params = await saveScopeParameters({ parentId: this.recordId, params });
				this.notifyUpdateData();
				this.notifyUpdateHashtagsData(this.params, deleted);
				this.notifySaveSuccess(event);
			} catch (e) {
				this._messageService.notifySingleError(LABEL_ERROR_SAVING_TITLE, e);
			}
		}
	}

	hasValidParams(params) {
		const hashtags = new Map();
		const dupes = new Set();
		params.forEach((nextValue) => {
			if (this.hashtags.indexOf(nextValue.developerName.toLowerCase()) >= 0 || hashtags.has(nextValue.developerName.toLowerCase())) {
				dupes.add(nextValue.developerName);
			}

			hashtags.set(nextValue.developerName.toLowerCase(), true);
			return undefined;
		});

		if (dupes.size) {
			this.dispatchEvent(
				new ShowToastEvent({
					title: LABEL_DUPLICATE_HASHTAG_ERROR,
					message: Array.from(dupes).join(', '),
					variant: 'error',
				}),
			);
		}

		return !dupes.size;
	}

	notifyUpdateData() {
		this._messageService.publish({
			key: 'updatedata',
			value: this.params,
		});
	}

	notifyUpdateHashtagsData(updatedParams, deletedParams) {
		const hashtagsData = { updatedParams, deletedParams };
		this._messageService.publish({
			key: 'updatehashtagsdata',
			value: hashtagsData,
		});
	}

	notifySaveSuccess(event) {
		if (event.detail.value.close) {
			this._messageService.notifySuccess(LABEL_SUCCESS_MESSAGE.replace('{0}', LABEL_SCOPE_PARAMETERS));
			this._messageService.notifyBoundaryClose();
		} else {
			this._messageService.notifySuccess(LABEL_SUCCESS_MESSAGE.replace('{0}', LABEL_SCOPE_PARAMETER_VALUE));
		}
	}
}
