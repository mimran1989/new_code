import { LightningElement, api } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import ProvusStyles from '@salesforce/resourceUrl/ProvusStyles';

export default class QuickActionPanel extends LightningElement {
	@api header;
	rendered = false;

	async renderedCallback() {
		if (!this.rendered) {
			await loadStyle(this, `${ProvusStyles}/quickActionModal.css`);
			this.rendered = true;
		}
	}
}
