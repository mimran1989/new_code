import { AuthenticatedUser } from '../../abilities/authenticate';
import { Actor } from '../../support/actor';
import { SObjectDO, SObjectSO, SObjectSOCallback } from '../../support/sObject';
import { createActorTask, createTask, Task } from '../../support/task';
import World from '../../../support/world';

const CREATED_RECORDS_KEY = 'createdRecords';
const LAST_CREATED_KEY = 'lastCreated';

export const Insert = {
	record: (objectType: string, record: SObjectSO) => insertRecord(objectType, [record]),
	records: (objectType: string, records: SObjectSO[]) => insertRecords(objectType, records),
};

export const Delete = {
	record: (objectType: string, record: SObjectSO) => deleteRecords(objectType, [record]),
	records: (objectType: string, records: SObjectSO[]) => deleteRecords(objectType, records),
};

export const Last = {
	created: (sObjectType: SObjectDO): SObjectSOCallback => createActorTask((actor: Actor) => getLastCreatedRecord(actor, sObjectType)
		.then((lastCreatedRecord) => {
			if (!lastCreatedRecord) {
				throw new Error(`Could not find the last created record of type: ${sObjectType.apiName} `);
			}

			return ({ sObjectType, sObjectSO: lastCreatedRecord });
		})),
};

function getLastCreatedRecord(actor: Actor, sObjectType: SObjectDO) {
	return cy.get<SObjectSO>(`@${actor.name}-${LAST_CREATED_KEY}`, { log: false })
		.then((lastCreatedRecords) => lastCreatedRecords?.get(`${World.namespacePrefix}${sObjectType.apiName}`));
}

function insertRecord(objectType: string, records: SObjectSO[]): Task<Cypress.Chainable<SObjectSO[]>> {
	return createActorTask((actor) => actor.attemptsTo<Cypress.Chainable<SObjectSO[]>>(insertRecords(objectType, records))
		.then((insertedRecordsResp: SObjectSO[]) => insertedRecordsResp[0]));
}

function insertRecords(objectType: string, records: SObjectSO[]): Task<Cypress.Chainable<SObjectSO[]>> {
	return createTask<AuthenticatedUser>(AuthenticatedUser,
		(authUser, cy, actor): Cypress.Chainable<SObjectSO[]> => cy.task<SObjectSO[]>('insertSObjects', { authUser, objectType, records })
			.then((newRecordsWithIds) => cy.wrap(rememberCreatedRecords(actor, newRecordsWithIds), { log: false }).as(`${actor.name}-${CREATED_RECORDS_KEY}`)
				.then(() => {
					const lastCreatedRecord = newRecordsWithIds[newRecordsWithIds.length - 1];
					return cy.wrap(rememberTheLastCreatedRecord(actor, objectType, lastCreatedRecord), { log: false })
						.as(`${actor.name}-${LAST_CREATED_KEY}`).then(() => newRecordsWithIds);
				})));
}

async function deleteRecords(objectType: string, records: SObjectSO[]) {
	return createTask<AuthenticatedUser>(AuthenticatedUser, (authUser, cy) => {
		cy.task('deleteSObjects', { authUser, objectType, records });
	});
}

async function rememberCreatedRecords(actor: Actor, createdRecords: SObjectSO[]) {
	let existingRecords: SObjectSO[] | null = actor.recall(CREATED_RECORDS_KEY);
	if (!existingRecords) {
		existingRecords = [];
		actor.remember(CREATED_RECORDS_KEY, existingRecords);
	}

	existingRecords.push(...createdRecords);
}

async function rememberTheLastCreatedRecord(actor: Actor, objectType: string, lastCreatedRecord: SObjectSO) {
	let lastCreated: Map<string, SObjectSO> | undefined = actor.recall(LAST_CREATED_KEY);
	if (!lastCreated) {
		lastCreated = new Map<string, SObjectSO>();
		actor.remember(LAST_CREATED_KEY, lastCreated);
	}

	lastCreated.set(objectType, lastCreatedRecord);
	return lastCreated;
}

export default Insert;
