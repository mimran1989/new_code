/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import EstimateTemplateCreator from './estimateTemplateCreator.view';

abstract class ActivityGroupModal {
	static header = () => EstimateTemplateCreator.component().contains('h2', 'Activity Groups');
	static table = () => EstimateTemplateCreator.component().find('tbody');
	static rowFor = (rowNumber: number) => () => ActivityGroupModal.table().children().eq(rowNumber);
	static nameFieldForLastRow = () => ActivityGroupModal.rowFor(-1)().children().eq(1).find('input');
	static saveButton = () => EstimateTemplateCreator.component().contains('button', 'Save');
}

export default ActivityGroupModal;
