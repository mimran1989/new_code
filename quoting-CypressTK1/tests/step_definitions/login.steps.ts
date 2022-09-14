import { Given } from '@badeball/cypress-cucumber-preprocessor';
import { Actor } from '../features/support/actor';
import Login from '../features/tasks/login';

Given('{actor} (has )logs(ed) in', async(actor: Actor) => {
	await actor.attemptsTo(Login.withCredentials);
});
