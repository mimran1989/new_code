/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

import { api, LightningElement } from 'lwc';
import picklistHtml from './picklist.html';
import checkboxHtml from './checkbox.html';
import integerHtml from './integer.html';

export default class TaskParameterInput extends LightningElement {
	@api fieldLabel;
	@api fieldData;
	@api type;
	@api value;

	_value = this.value;

	picklistOptions = [];

	render() {
		switch (this.type) {
			case 'Integer':
			case 'Integer Tiers':
				return integerHtml;
			case 'Checkbox':
				return checkboxHtml;
			case 'Picklist':
				return picklistHtml;
			default:
		}

		return undefined;
	}

	connectedCallback() {
		if (this.type === 'Picklist') {
			this.fieldData.forEach((nextOption) => {
				// note: using the per unit duration may not work if two labels share the same duration
				this.picklistOptions.push({ label: nextOption.label, value: `${nextOption.perUnitDuration}` });
			});
		}

		switch (this.type) {
			case 'Integer':
			case 'Integer Tiers':
				this._value = this._value?.integerValue;
				break;
			case 'Picklist':
				this._value = `${this._value?.integerValue}`;
				break;
			case 'Checkbox':
				this._value = this._value?.booleanValue;
				break;
			default:
		}
	}
}
