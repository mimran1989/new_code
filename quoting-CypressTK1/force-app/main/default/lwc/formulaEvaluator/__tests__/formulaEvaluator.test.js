/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import { createElement } from 'lwc';
import FormulaEvaluator from 'c/formulaEvaluator';

const hfInstance = {
	addSheet: jest.fn(),
	isItPossibleToAddNamedExpression: jest.fn(() => true),
};

window.HyperFormula = {
	buildEmpty() {
		return hfInstance;
	},
};

describe('FormulaEvaluator', () => {
	describe('isNamedExpressionValid', () => {
		// eslint-disable-next-line jest/no-test-callback
		it('should allow #test to be a valid hashtag', async(done) => {
			const element = createElement('c-formula-evaluator', {
				is: FormulaEvaluator,
			});

			document.body.appendChild(element);
			await Promise.resolve();

			// eslint-disable-next-line @lwc/lwc/no-async-operation
			setTimeout(() => {
				const formulaEvaluator = document.body.querySelector('c-formula-evaluator');
				expect(formulaEvaluator.isNamedExpressionValid('#test')).toBeTruthy();
				expect(hfInstance.isItPossibleToAddNamedExpression).toBeCalledWith('_test');
				done();
			}, 1);
		});
	});
});
