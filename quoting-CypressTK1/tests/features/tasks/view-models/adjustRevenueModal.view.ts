/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import QuoteGrid from './quoteGrid.view';

abstract class AdjustRevenueModal extends QuoteGrid {
	static colaAdjustmentButton = () => QuoteGrid.createScenarioModal().find('lightning-radio-group').contains('span', 'COLA Adjustment');
	static colaYoyAdjustmentField = () => QuoteGrid.createScenarioModal().find('input[name=\'ColaYoyCostAdjustment\'');
	static colaPassThroughField = () => QuoteGrid.createScenarioModal().find('input[name=\'ColaPassThroughAdjustment\'');
}

export default AdjustRevenueModal;
