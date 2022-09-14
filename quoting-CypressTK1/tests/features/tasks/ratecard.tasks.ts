import World from '../../support/world';
import { RateCard, SObjectSO } from '../support/sObject';
import { ProductRecordInput } from '../support/sObject/product';
import RateCardItem from '../support/sObject/rateCardItem';
import { createActorTask, Task } from '../support/task';
import Insert from './interactions/crud';
import { createNRoles, createRoles } from './product.tasks';

export interface IRateCardProduct {
	Name?: string;
	SkillLevel?: string;
	Location?: string;
}

export const createAnEmptyRateCard = createActorTask<Cypress.Chainable<SObjectSO>>((actor) => actor.attemptsTo<Cypress.Chainable<SObjectSO>>(
	Insert.record(`${World.namespacePrefix}${RateCard.apiName}`, RateCard.getRecordCreateDefaults(World.isDeployedInPackage)),
));

export function createARateCardWithRoles(rolesOrNumRoles: number | IRateCardProduct[]) {
	return createActorTask(async(actor) => {
		const createRolesTask = prepareCreateRoles(rolesOrNumRoles);

		actor.attemptsTo<Cypress.Chainable<SObjectSO>>(createAnEmptyRateCard)
			.then((rateCardSO) => {
				const rolesChainable = actor.attemptsTo<Cypress.Chainable<SObjectSO[]>>(createRolesTask);
				rolesChainable.then((roles) => {
					actor.attemptsTo<Cypress.Chainable<SObjectSO[]>>(
						addRolesToARateCard(rateCardSO.id, roles, Array.isArray(rolesOrNumRoles) ? rolesOrNumRoles as IRateCardProduct[] : null),
					);
				});
			});
	});
}

function prepareCreateRoles(rolesOrNumRoles: number | IRateCardProduct[]): Task<undefined> {
	let createRolesTask: Task<undefined>;
	if (!Array.isArray(rolesOrNumRoles)) {
		createRolesTask = createNRoles(rolesOrNumRoles);
	} else {
		const rolesToCreate = [...rolesOrNumRoles.reduce((accumulator: Map<string, ProductRecordInput>, role: IRateCardProduct) => {
			accumulator.set(role.Name, { productName: role.Name });
			return accumulator;
		}, new Map<string, ProductRecordInput>()).values()];

		createRolesTask = createRoles(rolesToCreate);
	}

	return createRolesTask;
}

export function addRolesToARateCard(rateCardId: string, roles: SObjectSO[], rates?: IRateCardProduct[]) {
	return createActorTask<Cypress.Chainable<SObjectSO[]>>((actor) => {
		let rateCardItemsForRoles: SObjectSO[];
		if (!rates) {
			rateCardItemsForRoles = roles.map((role: SObjectSO) => RateCardItem.getRecordCreateDefaults(World.isDeployedInPackage, {
				rateCardId, productId: role.id,
			}));
		} else {
			const rolesByName = roles.reduce((accumulator: Map<string, SObjectSO>, role: SObjectSO) => {
				accumulator.set(role.Name, role);
				return accumulator;
			}, new Map<string, SObjectSO>());

			rateCardItemsForRoles = rates.map((rateCardProduct: IRateCardProduct) => RateCardItem.getRecordCreateDefaults(World.isDeployedInPackage, {
				rateCardId,
				productId: rolesByName.get(rateCardProduct.Name).id,
			}));
		}

		return actor.attemptsTo<Cypress.Chainable<SObjectSO[]>>(Insert.records(`${World.namespacePrefix}${RateCardItem.apiName}`, rateCardItemsForRoles));
	});
}
