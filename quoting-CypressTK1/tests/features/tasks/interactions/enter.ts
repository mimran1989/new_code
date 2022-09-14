import { createCypressTask } from '../../support/task';
import { CypressSelectorFn } from '../../support/types/cypressSelectorFn';

const Enter = {
	theValue: (textValue: string) => ({
		into: (selector: string | CypressSelectorFn) => createCypressTask((cy) => {
			const element = typeof selector === 'string' ? cy.get(selector) : selector();
			element.type(textValue);
		}),
	}),
};

export default Enter;
