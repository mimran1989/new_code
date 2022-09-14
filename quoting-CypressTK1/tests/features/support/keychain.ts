import { Authenticate, AuthenticatedUser } from '../abilities/authenticate';
import { Actor } from './actor';

export type KeyChainEntry = {
	loginUrl: string;
	username: string;
	password: string;
	permissionSets: string[];
	features: string[];
	role: string;
};

let availableKeys: AuthenticatedUser[] = Cypress.env('keys')
	.map((key: KeyChainEntry) => Authenticate.withKeys(key));

const checkedOutKeys: AuthenticatedUser[] = [];

export class KeyChain {
	static checkout(actor: Actor) {
		const authKeys = this.checkoutNextAvailableKey();
		actor.whoCan(authKeys); // give actor the ability
	}

	static checkoutNextAvailableKey() {
		if (!availableKeys) {
			// TODO: improve intelligence by allowing 1 key to be checkout out once per scenario but many times when being run in parallel
			throw Error('There are no credentials defined. Please add credentials to keys.json.');
		}

		const keyToCheckout = availableKeys.shift();
		if (!keyToCheckout) {
			// TODO: improve intelligence by allowing 1 key to be checkout out once per scenario but many times when being run in parallel
			// eslint-disable-next-line no-console
			console.log(`All keys are checked out. Keys checked-out: ${checkedOutKeys.length}`);
			throw Error('There are no available credentials. Please add credentials to keys.json or reduce the number of parallel runs.');
		}

		checkedOutKeys.push(keyToCheckout as AuthenticatedUser);
		return keyToCheckout;
	}

	static checkInAllKeys() {
		availableKeys = [...availableKeys, ...checkedOutKeys.map((key) => {
			key.logout();
			return key;
		})];
	}
}
