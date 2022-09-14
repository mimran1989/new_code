import World from '../../../support/world';
import { AuthenticatedUser } from '../../abilities/authenticate';
import { Actor } from '../../support/actor';
import { SObjectSOCallback } from '../../support/sObject';
import { createCypressTask, createTask } from '../../support/task';

const Browse = {
	to: {
		theUrl: (url: string) => createCypressTask((cy) => {
			cy.visit(url);
		}),
		theSObject: browseToTheSObject,
		theHomePage: createTask<AuthenticatedUser>(AuthenticatedUser, (authInfo, cy) => {
			let appNamespace = World.namespacePrefix;
			if (!appNamespace) {
				appNamespace = 'c__';
			}

			cy.visit(`${authInfo.loginUrl}/lightning/app/${appNamespace}ProvusQuoting`);
		}),
		theTabNamed: (tabName: string) => createTask<AuthenticatedUser>(AuthenticatedUser, (authInfo, cy) => {
			cy.visit(`${authInfo.loginUrl}/lightning/n/${World.namespacePrefix}${tabName}`);
		}),
	},
	toThe: (callback: SObjectSOCallback) => browseToTheSObject(callback).recordPage,
};

function browseToTheSObject(getSObject: SObjectSOCallback) {
	return {
		recordPage: createTask<AuthenticatedUser>(AuthenticatedUser, (authInfo: AuthenticatedUser, cy, actor: Actor) => {
			actor.attemptsTo(getSObject).then(
				({ sObjectSO, sObjectType }) => cy.visit(
					`${authInfo.loginUrl}/lightning/r/${World.namespacePrefix}${sObjectType.apiName}/${sObjectSO.id}/view`,
				),
			);
		}),
	};
}

export default Browse;
