import QuoteGridTable from '../tasks/view-models/quoteGridTable.view';

const TheGrid = {
	has: {
		aRoleNamed: (roleName: string) => () => QuoteGridTable.roleColumnCellForName(roleName)().should('have.text', roleName),
		aSectionNamed: (sectionName: string) => () => QuoteGridTable.sectionForName(sectionName)().should('have.text', sectionName),
		aDefaultSection: () => TheGrid.has.aSectionNamed('1. Default Section'),
	},
};

export default TheGrid;
