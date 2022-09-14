import QuoteGrid from './quoteGrid.view';

abstract class QuoteGridTable extends QuoteGrid {
	static frameContent = () => QuoteGrid.component()
		.find('iframe').its('0.contentDocument.body');

	static fixedLeftPanel = () => QuoteGridTable
		.frameContent()
		.find('div.ht_clone_left');

	static roleColumn = () => QuoteGridTable.fixedLeftPanel()
		.find('tbody');

	static roleColumnCellForName = (roleName: string) => () => QuoteGridTable.roleColumn().contains('td', roleName);

	static roleColumnCellForRow = (rowNumber: number) => () => QuoteGridTable.roleColumn()
		.children('tr')
		.eq(rowNumber - 1);

	static sectionForName = (sectionName: string) => () => QuoteGridTable.roleColumn().contains('td', sectionName);
}

export default QuoteGridTable;
