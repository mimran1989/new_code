// import { createElement } from 'lwc';
// import QuoteAncillaries from 'c/quoteAncillaries';

// jest.mock(
// 	'lightning/platformResourceLoader',
// 	() => ({
// 		loadScript() {
// 			return new Promise((resolve) => {
// 				global.Provus = {};
// 				global.Provus.Queue = jest.fn().mockImplementation(() => ({ registerActions: jest.fn() }));

// 				global.Provus.Sync = {};
// 				global.Provus.Sync.forType = jest.fn(() => ({ watch: jest.fn() }));

// 				resolve();
// 			});
// 		},
// 	}),
// 	{ virtual: true },
// );

describe('quoteAncillaries', () => {
	it('is element created', async() => {
		// const element = createElement('c-quote-ancillaries', {
		// 	is: QuoteAncillaries,
		// });

		// document.body.appendChild(element);

		// await expect(element).toBeTruthy();
	});
});
