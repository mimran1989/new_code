import { defineParameterType } from '@badeball/cypress-cucumber-preprocessor';
import World from '../../../support/world';
import { Actor } from '../actor';

export default function init() {
	defineParameterType({
		name: 'actor',
		regexp: /[A-Z][a-z]+|I|He|he|She|she/,
		transformer: function transformFunction(actorName: string) {
			const actor: Actor = World.findOrCreateActor(actorName);
			return actor;
		},
	});
}
