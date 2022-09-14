/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import Util from '../../support/util';
import RecordHomePage from './recordHomePage.view';

const BASE_FLOW_MODAL = () => cy.get('.modal-container');

const BASE_LIGHTNING_INPUT = () => 	cy.get('flowruntime-flow-screen-input')
	.find('flowruntime-input-wrapper2')
	.find('lightning-input');

abstract class Milestones extends RecordHomePage {
	static component = () => RecordHomePage.CONTAINER()
		.find(Util.componentSelector('project-milestone'));

	static tab = () => RecordHomePage.tabFor('Milestones')();
	static flowModal = BASE_FLOW_MODAL;
	static flowModalNextButton = () => cy.get('button').contains('Next');

	static nameField = () => BASE_FLOW_MODAL()
		.find('input[name="milestoneName"]');

	static dateField = () => cy.get('input[name="alignmentDate"]');

	static milestoneOffsetField = () => BASE_LIGHTNING_INPUT()
		.find('input[name=\'milestoneOffset\']');

	static typeRadioButton = {
		for: (buttonName: string) => () => BASE_FLOW_MODAL()
			.find('lightning-formatted-rich-text')
			.contains(buttonName),
	};

	static dropdown = {
		named: (name: string) => () => cy.get('flowruntime-picklist-input-lwc')
			.find(`select[name='${name}']`),
	}

	static dropdownItem = {
		labeled: (dropdownName: string, label: string) => () => Milestones.dropdown.named(dropdownName)()
			.contains('option', label),
		number: (dropdownName: string, itemNumber: number) => () => Milestones.dropdown.named(dropdownName)()
			.children('option')
			.eq(itemNumber),
	}

	static tableRow = {
		named: (name: string) => () => Milestones.component()
			.find('c-soql-datatable')
			.find(`tr[data-row-key-value='${name}'`),
	};

	static deleteConfirmationText = () => Milestones.component()
		.find('c-confirmation-modal')
		.contains('Are you sure you want to delete this Milestone?');

	static deleteConfirmationButton = () => Milestones.component()
		.find('c-confirmation-modal')
		.contains('button', 'Proceed');
}

export default Milestones;
