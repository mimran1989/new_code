/**
 *  Provus Services Quoting
 *  provusCombobox
 *  @2022 Provus Inc. All rights reserved.
 */
import { LightningElement, api } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import ProvusStyles from '@salesforce/resourceUrl/ProvusStyles';

export default class ProvusCombobox extends LightningElement {
	@api name;
	@api value;
	@api indexKey;
	@api customOnChange;
	@api options;
	@api required;
	@api variant;
	@api showOnTop;
	comboboxClass;
	rendered = false;

	async renderedCallback() {
		if (!this.rendered) {
			await loadStyle(this, `${ProvusStyles}/provusCombobox.css`);

			if (this.showOnTop.toLowerCase() === 'true') {
				this.comboboxClass = 'combobox-list-above';
			}

			this.rendered = true;
		}
	}

	comboboxOnChange(event) {
		this.customOnChange(event);
	}
}
