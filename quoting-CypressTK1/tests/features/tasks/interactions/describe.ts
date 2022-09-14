import { AuthenticatedUser } from '../../abilities/authenticate';
import { createTask } from '../../support/task';

export const Describe = {
	theRecordTypes: {
		for: (objectName: string) => createTask<AuthenticatedUser>(AuthenticatedUser,
			(authUser) => cy.task< Map<string, string>>('describeSObject', { authUser, objectName })),
	},
};

export default Describe;
