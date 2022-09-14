import { AbilityFactory } from '../support/actor';

export default class UseCypress implements AbilityFactory<Cypress.Chainable<any>> {
	// eslint-disable-next-line class-methods-use-this
	create() {
		return cy;
	}
}
