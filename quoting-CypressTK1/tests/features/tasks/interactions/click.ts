import { createCypressTask } from '../../support/task';
import { CypressSelectorFn } from '../../support/types/cypressSelectorFn';

const Click = {
	on: (selector: string | CypressSelectorFn) => createCypressTask(() => {
		const element = typeof selector === 'string' ? cy.get(selector) : selector();
		element.click({ force: true });
	}),
};

export default Click;
