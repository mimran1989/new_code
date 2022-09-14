import { AuthenticatedUser } from '../abilities/authenticate';
import { createTask } from '../support/task';
import World from '../../support/world';

const Login = {
	withCredentials: createTask<AuthenticatedUser>(AuthenticatedUser, (authUserInfo, cy) => {
		const {
			loginUrl, password, username,
		} = authUserInfo;

		cy.session([loginUrl, password, username], () => {
			cy.request({
				body: {
					pw: password,
					un: username,
					useSecure: 'true',
					username,
				},
				form: true,
				method: 'POST',
				url: loginUrl,
			});

			cy.visit(`${loginUrl}/lightning/app/${World.componentNSPrefix}ProvusQuoting`);
		});
	}),
};

export default Login;
