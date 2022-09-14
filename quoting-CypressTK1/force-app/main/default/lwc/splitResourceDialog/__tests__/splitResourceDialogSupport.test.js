/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import { formatSplitPercentage } from '../splitResourceDialogSupport';

describe('splitResourceDialogSupport', () => {
	describe('formatSplit', () => {
		it('should round the decimal to the closest hundredths place', () => {
			expect(formatSplitPercentage(1.2345)).toEqual(1.23);
		});
		it('should return 1 if 0 is passed in', () => {
			expect(formatSplitPercentage(0.00)).toEqual(1);
		});
		it('should return a number if a long decimal is passed in', () => {
			expect(typeof formatSplitPercentage(1.234567890)).toEqual('number');
		});
		it('should format if a string representation of a number is passed in', () => {
			expect(formatSplitPercentage('1')).toEqual(1);
		});
	});
});
