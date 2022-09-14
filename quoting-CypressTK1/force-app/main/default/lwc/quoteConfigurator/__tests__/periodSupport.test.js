/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import { firstValueIndex, shiftableAmount } from '../periodSupport';

describe('periodSupport', () => {
	describe('shiftableAmount', () => {
		it('should return a shift amount of 1', () => {
			const periodValues = [
				{ '001': 1, '002': 1 },
			];

			expect(shiftableAmount(periodValues, 3)).toBe(1);
		});
		it('should return a shift amount of 1 with multiple period values', () => {
			const periodValues = [
				{ '001': 1 },
				{ '002': 1 },
			];

			expect(shiftableAmount(periodValues, 3)).toBe(1);
		});
		it('should return a shift amount of 1 with a period value starting in a middle period', () => {
			const periodValues = [
				{ '003': 1 },
			];

			expect(shiftableAmount(periodValues, 4)).toBe(1);
		});
	});
	describe('firstValueIndex', () => {
		it('should return a first value index of 0', () => {
			const periodValues = [
				{ '001': 1, '002': 1 },
			];

			expect(firstValueIndex(periodValues, 3)).toBe(0);
		});
		it('should return a first value index of 2 with a period value starting in a middle period', () => {
			const periodValues = [
				{ '003': 1 },
			];

			expect(firstValueIndex(periodValues, 4)).toBe(2);
		});
	});
});
