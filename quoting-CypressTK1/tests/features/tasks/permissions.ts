import { AuthenticatedUser } from '../abilities/authenticate';
import { createTask } from '../support/task';
import World from '../../support/world';

export const Assign = {
	permissionSets: createTask<AuthenticatedUser>(AuthenticatedUser, (authUser, cy) => {
		cy.task('assignPermissionSets', { authUser }, { log: false });
	}),
	features: createTask<AuthenticatedUser>(AuthenticatedUser, (authUser, cy) => {
		cy.task('turnOffAllAvailableFeatures', { authUser }, { log: false });
		cy.task('turnOnFeatures', { authUser, features: World.features }, { log: false });
	}),
};

export default Assign;
