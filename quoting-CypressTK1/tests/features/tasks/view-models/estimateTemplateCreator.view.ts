/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import Util from '../../support/util';
import RecordHomePage from './recordHomePage.view';

abstract class EstimateTemplateCreator {
	static component = () => RecordHomePage.CONTAINER()
		.find(Util.componentSelector('estimate-template-creator'), { timeout: 8000 });

	static treeGridTable = () => EstimateTemplateCreator.component()
		.find('lightning-datatable')
		.find('tbody');

	static scopeParametersTable = () => cy.get('div.modal-container.slds-modal__container');

	static addEditActivitiesButton = () => EstimateTemplateCreator.treeGridTable()
		.find('button')
		.contains('Add/edit activities');

	static addEditTasksButton = () => EstimateTemplateCreator.treeGridTable()
		.find('button[title="Add/edit tasks"]');

	static addEditScopeParametersButtonFor = () => EstimateTemplateCreator.treeGridTable()
		.find('button')
		.contains('Add/edit scope parameters')
		.eq(-1);

	static treeGridRowFor = (rowName) => () => EstimateTemplateCreator.treeGridTable()
		.find('lightning-base-formatted-text')
		.contains(rowName);

	static createActivityGroupButton = () => EstimateTemplateCreator.component()
		.find('button')
		.contains('Create/edit activity groups');

	static scopeParameterRowNumber = (rowNumber) => ({
		element: () => cy.get(Util.componentSelector('parameter-dialog')).find('tr').eq(rowNumber - 1),
		field: (fieldName) => () => EstimateTemplateCreator.scopeParameterRowNumber(rowNumber - 1).element()
			.find(`input[name="${fieldName}"]`),
		dropdownLabeled: (fieldLabel) => () => EstimateTemplateCreator.scopeParameterRowNumber(rowNumber - 1).element()
			.find(`td[data-label="${fieldLabel}"]`)
			.find('button'),
		dropdownItem: (fieldLabel, fieldValue) => () => EstimateTemplateCreator.scopeParameterRowNumber(rowNumber - 1).element()
			.find(`td[data-label="${fieldLabel}"]`)
			.find(`lightning-base-combobox-item[data-value="${fieldValue}"]`)
			.contains(fieldValue),
		errorField: (fieldLabel) => () => EstimateTemplateCreator.scopeParameterRowNumber(rowNumber - 1).element()
			.find(`td[data-label="${fieldLabel}"]`)
			.contains('Complete this field.'),
	});

	static scopeParameterSaveButton = () => EstimateTemplateCreator.scopeParametersTable().find('button').contains('Save');
}

export default EstimateTemplateCreator;
