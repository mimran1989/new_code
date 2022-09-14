import { DataTable } from '@badeball/cypress-cucumber-preprocessor';
import World from '../../support/world';
import { Actor } from '../support/actor';
import {
	Quote, RateCard, SObjectSO, SObjectSOCallback,
} from '../support/sObject';
import { createActorTask, Task } from '../support/task';
import { createAnEmptyEstimateTemplate } from './estimateTemplate.tasks';
import Insert, { Last } from './interactions/crud';
import { createRoles } from './product.tasks';
import { addRolesToARateCard, createAnEmptyRateCard, createARateCardWithRoles } from './ratecard.tasks';

export const Create = {
	aQuote: ({
		thatIsEmpty: createActorTask<Cypress.Chainable<SObjectSO[]>>((actor: Actor) => actor.attemptsTo<Cypress.Chainable<SObjectSO[]>>(
			Create.aRateCard.thatIsEmpty,
			Create.aQuote.withRateCard(Last.created(RateCard)),
		)),
		withRateCard: createAnEmptyQuoteWithRateCard,
		usingDataTree,
		withParameters,
		withSimpleSections,
	}),
	aRateCard: ({
		thatIsEmpty: createAnEmptyRateCard,
		withRoles: createARateCardWithRoles,
		with: (numRoles: number) => ({ roles: createARateCardWithRoles(numRoles) }),
	}),
	anEstimateTemplate: {
		thatIsEmpty: createAnEmptyEstimateTemplate,
	},
	roles: createRoles,
};

export const Add = {
	roles: (roles: SObjectSO[]) => ({
		toRateCard: (rateCardSO: SObjectSO) => addRolesToARateCard(rateCardSO.id as string, roles),
	}),
};

function withSimpleSections() {
	return createActorTask<Cypress.Chainable<SObjectSO[]>>((actor) => {
		const params = {
			sectionHierarchy: 'Simple',
		};

		return withParameters(actor, params);
	});
}

function usingDataTree(tree: DataTable) {
	return createActorTask<Cypress.Chainable<SObjectSO[]>>((actor) => {
		const params = {};

		tree.hashes().forEach((nextParam) => {
			params[nextParam.field] = nextParam.value;
		});

		return withParameters(actor, params);
	});
}

function withParameters(actor: Actor, params: Record<string, any>) {
	const createParams = { ...params };
	if (params.rateCardId) {
		return actor.attemptsTo<Cypress.Chainable<SObjectSO>>(
			Insert.record(`${World.namespacePrefix}${Quote.apiName}`, Quote.getRecordCreateDefaults(World.isDeployedInPackage, createParams)),
		);
	}

	return actor.attemptsTo<Cypress.Chainable<SObjectSO>>(Create.aRateCard.thatIsEmpty)
		.then((rateCard) => {
			createParams.rateCardId = rateCard.id;
			return null;
		})
		.then(() => actor.attemptsTo<Cypress.Chainable<SObjectSO>>(
			Insert.record(`${World.namespacePrefix}${Quote.apiName}`, Quote.getRecordCreateDefaults(World.isDeployedInPackage, createParams)),
		));
}

function createAnEmptyQuoteWithRateCard(rateCardGetter: SObjectSOCallback): Task<Cypress.Chainable<SObjectSO[]>> {
	return createActorTask((actor: Actor): Cypress.Chainable<SObjectSO[]> => actor.attemptsTo(rateCardGetter).then(
		({ sObjectSO: rateCard }: SObjectSO) => actor.attemptsTo<Cypress.Chainable<SObjectSO[]>>(
			Insert.record(
				`${World.namespacePrefix}${Quote.apiName}`,
				Quote.getRecordCreateDefaults(World.isDeployedInPackage,
					{
						rateCardId: rateCard.id,
					}),
			),
		),
	));
}
