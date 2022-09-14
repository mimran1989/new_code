import { createElement } from 'lwc';
import LocationDiscountSummary from 'c/locationDiscountSummary';

describe('c-location-discount-summary', () => {
	afterEach(() => {
		// The jsdom instance is shared across test cases in a single file so reset the DOM
		while (document.body.firstChild) {
			document.body.removeChild(document.body.firstChild);
		}
	});

	it('TODO: test case generated by CLI command, please fill in test logic', () => {
		// Arrange
		const element = createElement('c-location-discount-summary', {
			is: LocationDiscountSummary,
		});

		// Act
		document.body.appendChild(element);

		// Assert
		// const div = element.shadowRoot.querySelector('div');
		expect(1).toBe(1);
	});
});
