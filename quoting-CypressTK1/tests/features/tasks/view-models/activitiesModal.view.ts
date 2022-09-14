/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import Util from '../../support/util';
import EstimateTemplateCreator from './estimateTemplateCreator.view';

abstract class ActivitiesModal {
	static headerFor = (groupName: string) => () => EstimateTemplateCreator.component().find('h2').contains(`${groupName}/ Activities`);
	static table = () => EstimateTemplateCreator.component().find('section').find('tbody');
	static rowFor = (rowNumber: number) => () => ActivitiesModal.table().children().eq(rowNumber);
	static nameFieldForLastRow = () => ActivitiesModal.table().find('input[name="Name"]');
	static resourceFieldForLastRow = {
		textBox: () => ActivitiesModal.rowFor(-1)().find(Util.componentSelector('custom-lookup')).find('input'),
		dropdownItem: (label: string) => () => ActivitiesModal.rowFor(-1)().find(Util.componentSelector('custom-lookup'))
			.contains('span', label),
	};
	static saveButton = () => EstimateTemplateCreator.component().find('footer').contains('button', 'Save');
}

export default ActivitiesModal;
