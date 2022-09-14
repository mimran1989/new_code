import { createCypressQuestion } from '../support/question';
import { createActorTask, createCypressTask } from '../support/task';
import { CypressSelectorFn } from '../support/types/cypressSelectorFn';

export class Assert {
	private selector: CypressSelectorFn;
	private message?: string;
	constructor(selector: CypressSelectorFn, message?: string) {
		this.selector = selector;
		this.message = message;
	}

	doesNotExist = createCypressQuestion(() => assert.isOk(this.selector().should('not.exist'), this.message));
	exists = createCypressQuestion(() => assert.isOk(this.selector().should('exist'), this.message));
	isVisible = createCypressQuestion(() => assert.isOk(this.selector().should('be.visible'), this.message));
	isNotVisible = createCypressQuestion(() => assert.isOk(this.selector().should('not.be.visible'), this.message));
	isDisabled = createCypressQuestion(() => assert.isOk(this.selector().should('be.disabled'), this.message));
	isNotDisabled = createCypressQuestion(() => assert.isOk(this.selector().should('not.be.disabled'), this.message));
}

const Ensure = {
	that: (theQuestion: () => void) => createActorTask(() => theQuestion),
	the: (selector: CypressSelectorFn, message?: string) => new Assert(selector, message),
	theValueOf: ((selector: CypressSelectorFn) => ({
		equals: (expected: string) => createCypressTask(() => selector().should('have.value', expected)),
	})),
	theUrlContains: (match: string) => createCypressTask((cy) => {
		cy.url().should('contain', match);
	}),
};

export default Ensure;
