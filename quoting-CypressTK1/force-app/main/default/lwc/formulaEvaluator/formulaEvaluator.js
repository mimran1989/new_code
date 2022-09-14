/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import hyperFormula from '@salesforce/resourceUrl/HyperFormula';
import { loadScript } from 'lightning/platformResourceLoader';
import { api, LightningElement } from 'lwc';
import log from 'c/log';

export default class FormulaEvaluator extends LightningElement {
	_hfPromise;
	_hfInstance;

	connectedCallback() {
		this._hfPromise = this.init();
	}

	async init() {
		await loadScript(this, `${hyperFormula}/HyperFormula.js`);

		const options = {
			licenseKey: 'gpl-v3',
		};

		this._hfInstance = window.HyperFormula.buildEmpty(options);
		this._hfInstance.addSheet();
	}

	@api
	async loadExpressions(dictionary) {
		await this._hfPromise;
		Object.keys(dictionary).forEach((expression) => {
			this.addNamedExpression(expression, dictionary[expression]);
		});
	}

	/**
	 * @param {string} formula
	 * @returns {*}
	 */
	@api
	evaluateFormula(formula = '') {
		let formattedString = formula;
		if (formattedString.indexOf('=') !== 0) {
			formattedString = `=${formattedString}`;
		}

		// strip hashtag from strings
		formattedString = FormulaEvaluator.formatValue(formattedString);

		this._hfInstance.setCellContents({ col: 0, row: 0, sheet: 0 }, [[formattedString]]);
		// call getCellValue to get the calculation results
		return this._hfInstance.getCellValue({ col: 0, row: 0, sheet: 0 });
	}

	@api
	addNamedExpression(expression, value) {
		let cleanedExpression = FormulaEvaluator.formatValue(expression);
		if (cleanedExpression.indexOf('_') !== 0) {
			cleanedExpression = `_${cleanedExpression}`;
		}

		try {
			if (this._hfInstance.isItPossibleToAddNamedExpression(cleanedExpression)) {
				this._hfInstance.addNamedExpression(cleanedExpression, value);
			} else {
				// named expression already exists, just change it
				this._hfInstance.changeNamedExpression(cleanedExpression, value);
			}
		} catch (error) {
			log(error);
		}
	}

	/**
	 * formats value by
	 * 1. keeping it case insensivity by making it lowercase
	 * 2. remove hashtags and replacing them with underscore
	 */
	static formatValue(value) {
		return value.replace(/#/g, '_').toLowerCase();
	}

	@api
	isNamedExpressionValid(expression) {
		return this._hfInstance.isItPossibleToAddNamedExpression(FormulaEvaluator.formatValue(expression));
	}

	@api
	isFormulaValid(formula) {
		const expressionToTest = formula.replace(/#[\w]+/g, '1 ');
		const evaluation = this.evaluateFormula(expressionToTest);
		if (typeof (evaluation) === 'number' || (typeof (evaluation) === 'object' && evaluation.type === 'DIV_BY_ZERO')) {
			return true;
		}

		return false;
	}
}
