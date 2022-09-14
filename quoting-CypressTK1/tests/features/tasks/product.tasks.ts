import { Actor } from '../support/actor';
import { SObjectSO } from '../support/sObject';
import {
	Product, ProductRecordInput, RECORD_TYPE_RESOURCE_ROLE, RECORD_TYPE_SERVICE,
} from '../support/sObject/product';
import { createActorTask } from '../support/task';
import Insert from './interactions/crud';
import Describe from './interactions/describe';
import World from '../../support/world';

export function createRoles(roles: ProductRecordInput[]) {
	return createActorTask((actor: Actor) => {
		const productObjectQualifiedName = `${World.namespacePrefix}${Product.apiName}`;
		return actor.attemptsTo(Describe.theRecordTypes.for(productObjectQualifiedName))
			.then((recordTypeIdsByName): Cypress.Chainable<SObjectSO[]> => {
				const rolesToCreate: SObjectSO[] = [];
				for (let i = 0; i < roles.length; i++) {
					rolesToCreate.push(Product.getRecordCreateDefaults(World.isDeployedInPackage, {
						...roles[i],
						recordTypeId: recordTypeIdsByName[RECORD_TYPE_RESOURCE_ROLE],
					}));
				}

				return actor.attemptsTo(Insert.records(productObjectQualifiedName, rolesToCreate));
			});
	});
}

export function createNRoles(numberOfRoles: number) {
	return createActorTask((actor: Actor) => {
		const productObjectQualifiedName = `${World.namespacePrefix}${Product.apiName}`;
		return actor.attemptsTo(Describe.theRecordTypes.for(productObjectQualifiedName))
			.then((recordTypeIdsByName): Cypress.Chainable<SObjectSO[]> => {
				const rolesToCreate: SObjectSO[] = [];
				for (let i = 0; i < numberOfRoles; i++) {
					rolesToCreate.push(Product.getRecordCreateDefaults(World.isDeployedInPackage, {
						recordTypeId: recordTypeIdsByName[RECORD_TYPE_RESOURCE_ROLE],
					}));
				}

				return actor.attemptsTo(Insert.records(`${World.namespacePrefix}${Product.apiName}`, rolesToCreate));
			});
	});
}

const createService = createActorTask((actor: Actor) => {
	const productObjectQualifiedName = `${World.namespacePrefix}${Product.apiName}`;
	return actor.attemptsTo(Describe.theRecordTypes.for(productObjectQualifiedName))
		.then((recordTypeIdsByName) => {
			const newProduct = Product.getRecordCreateDefaults(World.isDeployedInPackage, {
				recordTypeId: recordTypeIdsByName[RECORD_TYPE_SERVICE],
			});

			return actor.attemptsTo(Insert.record(`${World.namespacePrefix}${Product.apiName}`, newProduct));
		});
});

export { createService };
