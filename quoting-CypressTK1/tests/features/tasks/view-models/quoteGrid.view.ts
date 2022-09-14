import Util from '../../support/util';
import RecordHomePage from './recordHomePage.view';

abstract class QuoteGrid extends RecordHomePage {
	static component = () => RecordHomePage.CONTAINER()
		.find(Util.componentSelector('quote-configurator'), { timeout: 100000 });

	static adjustRevenueMarginButton = () => QuoteGrid.component()
		.contains('button', 'Adjust Revenue/Margin');

	static createScenarioModal = () => QuoteGrid.component()
		.find('c-create-scenario');
}

export default QuoteGrid;
