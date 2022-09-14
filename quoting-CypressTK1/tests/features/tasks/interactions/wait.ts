import { createCypressTask } from '../../support/task';

const Wait = {
	for: (timeToWait: number) => ({
		seconds: createCypressTask((cy) => { cy.wait(timeToWait * 1000); }),
	}),
};

export default Wait;
