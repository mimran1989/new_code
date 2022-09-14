/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { reduceErrors } from 'c/sparkUtils';
import {
	subscribe,
	onError,
} from 'lightning/empApi';

import getIsExperimentalFeaturesEnabled from '@salesforce/apex/ExperimentalFeaturesController.getIsExperimentalFeaturesEnabled';
import getExperimentalFeatures from '@salesforce/apex/ExperimentalFeaturesController.getExperimentalFeatures';
import getExperimentalUsers from '@salesforce/apex/ExperimentalFeaturesController.getExperimentalUsers';
import saveFeatureSettings from '@salesforce/apex/ExperimentalFeaturesController.saveFeatureSettings';
import NamespacePrefix from '@salesforce/apex/SystemUtility.getNamespacePrefix';

import LABEL_SETTINGS_SUCCESSFULLY_SAVED from '@salesforce/label/c.SettingSuccessfullySaved';
import LABEL_SUCCESS from '@salesforce/label/c.Success';

const expirementalFeaturesColumns = [
	{ label: 'Feature', fieldName: 'name' },
	{ label: 'Description', fieldName: 'description' },
];

const experimentalUersColumns = [
	{ label: 'First Name', fieldName: 'FirstName' },
	{ label: 'Last Name', fieldName: 'LastName' },
];

export default class ExperimentalFeatures extends LightningElement {
	_userList;
	_selectedUserList;
	_experimentalFeatures;
	selectedFeatures = [];

	expirementalFeaturesColumns = expirementalFeaturesColumns;
	experimentalUersColumns = experimentalUersColumns;

	@wire(getExperimentalFeatures)
	wireFeature({ data, error }) {
		if (error) {
			this.dispatchEvent(
				new ShowToastEvent({
					title: 'Application Exception',
					message: reduceErrors(error).join(', '),
					variant: 'error',
				}),
			);
		}

		if (data) {
			this._experimentalFeatures = [];
			this.selectedFeatures = [];
			data.forEach((feature) => {
				if (feature.isSelected === true) {
					this.selectedFeatures.push(feature.id);
				}

				this._experimentalFeatures.push(feature);
			});
		}
	}
	@wire(getExperimentalUsers)
	wireUsers({ data, error }) {
		if (error) {
			this.dispatchEvent(
				new ShowToastEvent({
					title: 'Application Exception',
					message: reduceErrors(error).join(', '),
					variant: 'error',
				}),
			);
		}

		if (data) {
			this._selectedUserList = [];
			this._userList = [];
			data.forEach((user) => {
				if (user.isSelected === true) {
					this._selectedUserList.push(user.id);
				}

				this._userList.push({
					label: user.name,
					value: user.id,
				});
			});
		}
	}

	@wire(getIsExperimentalFeaturesEnabled) _isExperimentalFeaturesEnabled;

	connectedCallback() {
		// Register error listener
		this.registerErrorListener();
	}

	handleUserSelection(event) {
		const selectedOptionsList = event.detail.value;
		this._selectedUserList = selectedOptionsList;
	}

	async handleSave() {
		try {
			const selectedFeatures = this.template.querySelector('lightning-datatable').getSelectedRows();

			await saveFeatureSettings({
				userIds: [...this._selectedUserList],
				features: [...selectedFeatures],
			});

			this.dispatchEvent(
				new ShowToastEvent({
					title: LABEL_SUCCESS,
					message: LABEL_SETTINGS_SUCCESSFULLY_SAVED,
					variant: 'success',
				}),
			);
		} catch (exception) {
			this.dispatchEvent(
				new ShowToastEvent({
					title: 'Application Exception',
					message: reduceErrors(exception).join(', '),
					variant: 'error',
				}),
			);
		}
	}

	registerErrorListener() {
		// Invoke onError empApi method
		onError((error) => {
			// console.log('Received error from server: ', JSON.stringify(error));
			this.dispatchEvent(
				new ShowToastEvent({
					title: 'Application Exception',
					message: JSON.stringify(error),
					variant: 'error',
				}),
			);
		});
	}

	get userList() {
		return this._userList;
	}

	get selectedUserList() {
		return this._selectedUserList;
	}

	get experimentalFeatures() {
		return this._experimentalFeatures;
	}

	get isExperimentalFeaturesEnabled() {
		return this._isExperimentalFeaturesEnabled?.data;
	}

	@wire(NamespacePrefix)
	wireMetadataDeploymentListener({ data }) {
		if (data) {
			const channel = `/event/${data}MetadataDeployment__e`;
			const dispatch = this.dispatchEvent;
			const messageCallback = function messageCallback(response) {
				// console.log('New message received: ', JSON.stringify(response));
				const { payload } = response.data;
				const resultant = JSON.parse(JSON.stringify(payload))[`${data}Result__c`];
				if (!resultant.success) {
					dispatch(
						new ShowToastEvent({
							title: 'Application Exception',
							message: JSON.stringify(resultant),
							variant: 'error',
						}),
					);
				}
			};

			subscribe(channel, -1, messageCallback);
		}
	}
}
