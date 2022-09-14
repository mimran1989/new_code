/**
 *  Provus Services Quoting
 *  provusMessagingService
 *  @2022 Provus Inc. All rights reserved.
 */
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LABEL_APPLICATION_EXCEPTION from '@salesforce/label/c.ApplicationException';
import LABEL_VALIDATION_ERROR_TITLE from '@salesforce/label/c.ValidationErrorTitle';
import LABEL_ERROR from '@salesforce/label/c.Error';
import { reduceErrors } from 'c/sparkUtils';

export default class ProvusMessagingService {
	_lightningComponentInstance;

	constructor(lightningComponentInstance) {
		this._lightningComponentInstance = lightningComponentInstance;
	}

	handleWireError(error) {
		this._lightningComponentInstance.dispatchEvent(
			new ShowToastEvent({
				title: LABEL_APPLICATION_EXCEPTION,
				message: reduceErrors(error).join(', '),
				variant: 'error',
			}),
		);
	}

	handleValidationErrors(validationResults) {
		const messages = validationResults.map((validationResult) => validationResult.message);
		if (validationResults.length > 0) {
			this._lightningComponentInstance.dispatchEvent(
				new ShowToastEvent({
					title: LABEL_VALIDATION_ERROR_TITLE,
					message: messages.join(', '),
					variant: 'error',
				}),
			);
		}
	}

	handleObjectInfoResultErrors(results) {
		const resultErrors = [];
		results.forEach((result) => {
			if (Array.isArray(result)) {
				resultErrors.push(result);
			}
		});

		let hasErrors = false;
		if (resultErrors.length > 0) {
			this._lightningComponentInstance.dispatchEvent(
				new ShowToastEvent({
					title: LABEL_ERROR,
					message: resultErrors.join(', '),
					variant: 'error',
				}),
			);
			hasErrors = true;
		}

		return hasErrors;
	}

	notifySingleError(title, error = '') {
		this._lightningComponentInstance.dispatchEvent(
			new ShowToastEvent({
				title,
				message: error,
				variant: 'error',
				mode: 'sticky',
			}),
		);
	}
}
