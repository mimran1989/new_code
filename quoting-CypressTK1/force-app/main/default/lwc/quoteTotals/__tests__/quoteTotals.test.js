import { createElement } from 'lwc';
import QuoteTotals from 'c/quoteTotals';

jest.useFakeTimers();

class Queue {
	/* eslint-disable class-methods-use-this */
	registerActions() {}
}

global.Provus = {
	NamedRange: {
		for: jest.fn(),
		newDO: jest.fn(),
	},
	Queue,
	Sync: {
		forType: jest.fn().mockReturnValue({
			watch: jest.fn(),
		}),
	},
};
jest.mock('@salesforce/resourceUrl/Provus', () => 'baseURl', { virtual: true });
jest.mock(
	'lightning/platformResourceLoader',
	() => ({
		loadScript() {
			return new Promise((resolve) => {
				resolve();
			});
		},
	}),
	{ virtual: true },
);
jest.mock('lightning/platformShowToastEvent', () => {}, { virtual: true });
jest.mock('@salesforce/apex/NamedRangeService.getNamedRangesForQuote',
	() => ({
		default: jest.fn().mockReturnValue([]),
	}),
	{ virtual: true });

describe('quoteTotals', () => {
	describe('location period tallying', () => {
		it('same period and location two times amount is summed', async() => {
			const element = createElement('c-quote-totals', {
				is: QuoteTotals,
			});

			element.resetQuoteTotals('quoteId1');
			element.updateQuoteTotals({
				quoteId: 'quoteId1',
				location: {
					country: 'United States',
				},
				periodColumn: 1,
				revenueAmount: 100,
			});
			element.updateQuoteTotals({
				quoteId: 'quoteId1',
				location: {
					country: 'United States',
				},
				periodColumn: 1,
				revenueAmount: 100,
			});
			const { locationByPeriodTallies } = element.getQuoteTotals('quoteId1');
			document.body.appendChild(element);
			await Promise.resolve();
			const locationPeriodTallyKeys = Object.keys(locationByPeriodTallies);
			expect(locationPeriodTallyKeys.length).toEqual(1);
			expect(locationByPeriodTallies[locationPeriodTallyKeys[0]]).toEqual(200);
		});

		it('same period different locations two unique entries with corresponding amounts', async() => {
			const element = createElement('c-quote-totals', {
				is: QuoteTotals,
			});

			element.resetQuoteTotals('quoteId1');
			element.updateQuoteTotals({
				quoteId: 'quoteId1',
				location: {
					country: 'United States',
				},
				periodIndex: 1,
				revenueAmount: 100,
			});
			element.updateQuoteTotals({
				quoteId: 'quoteId1',
				location: {
					country: 'India',
				},
				periodIndex: 1,
				revenueAmount: 50,
			});
			const { locationByPeriodTallies } = element.getQuoteTotals('quoteId1');
			document.body.appendChild(element);
			await Promise.resolve();
			expect(locationByPeriodTallies.Period1L1).toEqual(100);
			expect(locationByPeriodTallies.Period1L2).toEqual(50);
		});
	});

	describe('revenue by quote item locations', () => {
		it('should track different location type', async() => {
			const element = createElement('c-quote-totals', {
				is: QuoteTotals,
			});

			element.quoteId = 'quoteId1';
			element.resetQuoteTotals('quoteId1');

			element.updateQuoteTotals({
				quoteId: 'quoteId1',
				location: {
					country: 'India',
				},
				groupIndex: 1,
				revenueAmount: 100,
			});
			element.updateQuoteTotals({
				quoteId: 'quoteId1',
				location: {
					country: 'United States',
					state: 'California',
				},
				groupIndex: 1,
				revenueAmount: 200,
			});

			const { locationByPeriodTallies } = element.getQuoteTotals('quoteId1');
			document.body.appendChild(element);
			await Promise.resolve();

			expect(locationByPeriodTallies.L1).toEqual(100);
			expect(locationByPeriodTallies.L2).toEqual(200);
			expect(locationByPeriodTallies.L3).toEqual(200);
		});
	});
});
