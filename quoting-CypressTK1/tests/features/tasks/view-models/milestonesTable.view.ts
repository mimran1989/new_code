/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import Milestones from './milestones.view';
import RecordHomePage from './recordHomePage.view';

abstract class MilestonesTable extends RecordHomePage {
	static component = () => RecordHomePage.CONTAINER()
		.find('c-project-milestone, psq-project-milestone')
		.find('c-base-datatable-extension');

	static newButton = () => Milestones.component().find('lightning-button').eq(0).find('button');
	static deleteButton = () => Milestones.component().find('lightning-button').eq(1).find('button');

	static nameAnchorForRowNamed = (name: string) => () => MilestonesTable.component()
		.find('lightning-formatted-url')
		.contains(name);

	static cellFor = (rowKey: string, columnLabel: string) => () => MilestonesTable.component()
		.find(`tr[data-row-key-value='${rowKey}']`)
		.find(`td[data-label='${columnLabel}']`)
		.find('lightning-primitive-cell-factory');

	static selectAllRowsCheckbox = () => MilestonesTable.component()
		.find('lightning-primitive-header-factory')
		.find('span')
		.contains('Select All')
		.siblings()

	static tableRows = () => MilestonesTable.component()
		.find('tbody')
		.find('tr');
}

export default MilestonesTable;
