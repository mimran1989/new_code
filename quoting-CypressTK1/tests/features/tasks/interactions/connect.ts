import { UserInfo } from 'jsforce';
import { AuthenticatedUser } from '../../abilities/authenticate';
import { createTask } from '../../support/task';

const Connect = {
	withCredentials: createTask<AuthenticatedUser>(AuthenticatedUser, (authUserInfo, cy) => cy.task('loginToSfdc', authUserInfo, { log: false })
		.then<AuthenticatedUser>((authInfo: { accessToken: string, instanceUrl: string, userInfo: UserInfo }) => {
			authUserInfo.connected(authInfo);
			return authUserInfo;
		})),
};

export default Connect;
