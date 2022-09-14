import { Actor } from '../features/support/actor';
import ActorLookup from '../features/support/actorLookup';

class World {
	features: Record<string, boolean>;
	parameters: Record<string, any> = {};
	private actorLookup = new ActorLookup();
	// eslint-disable-next-line class-methods-use-this
	get namespacePrefix() {
		const namespacePrefix = Cypress.env('namespacePrefix');
		return namespacePrefix ? `${namespacePrefix}__` : '';
	}

	// eslint-disable-next-line class-methods-use-this
	get componentNSPrefix() {
		const namespacePrefix = Cypress.env('namespacePrefix') || 'c';
		return `${namespacePrefix}__`;
	}

	get isDeployedInPackage(): boolean {
		return !!this.namespacePrefix;
	}

	findOrCreateActor(actorName: string): Actor {
		return this.actorLookup.findOrCreateActor(this, actorName);
	}

	reset() {
		this.actorLookup = new ActorLookup();
	}
}

const worldInstance = new World();
export default worldInstance;

// Cucumber.setWorldConstructor(World);
