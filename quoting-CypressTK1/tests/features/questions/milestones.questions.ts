/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import MilestonesTable from '../tasks/view-models/milestonesTable.view';

const TheMilestonesTable = {
	has: {
		aRowNamed: (name: string) => ({
			alignedToAMilestoneNamed: (milestoneName: string) => TheMilestonesTable
				.has.aRowNamed(name)
				.withExactColumnValue('Align to Activity or Milestone', milestoneName),
			alignedToAnActivityNamed: (activityName: string) => TheMilestonesTable
				.has.aRowNamed(name)
				.withExactColumnValue('Activity Name', activityName),
			withExactColumnValue: (columnLabel: string, testFieldValue: string) => async() => {
				MilestonesTable.nameAnchorForRowNamed(name)().invoke('attr', 'href').then((href) => {
					// get data-row key from anchor by the given name
					const dataRowKey = href?.replace('/', '');
					// get the row from the row key
					MilestonesTable.cellFor(dataRowKey, columnLabel)().should('have.text', testFieldValue);
				});
			},
		}),

	},
};

export default TheMilestonesTable;
