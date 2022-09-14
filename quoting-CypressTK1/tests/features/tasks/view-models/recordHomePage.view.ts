const CONTAINER = () => cy.get('one-record-home-flexipage2');
abstract class RecordHomePage {
	static CONTAINER = CONTAINER;
	static highlightsPanelActionButton = (buttonApiName: string) => () => CONTAINER()
		.find(`[apiname="${buttonApiName}"]`)
		.find('button');

	static tabFor = (tabName: string) => () => CONTAINER()
		.find('flexipage-tabset2')
		.find('lightning-tabset')
		.find('lightning-tab-bar')
		.contains(tabName);

	static toastMessage = (containing: string) => () => cy.get('div').contains(containing);
}

export default RecordHomePage;
