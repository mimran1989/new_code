import {
	DataTable, Given, Then, When,
} from '@badeball/cypress-cucumber-preprocessor';
import Ensure from '../features/questions/ensure';
import TheGrid from '../features/questions/grid.questions';
import { Actor } from '../features/support/actor';
import { Quote, RateCard } from '../features/support/sObject';
import { Create } from '../features/tasks/create';
import Browse from '../features/tasks/interactions/browse';
import { Last } from '../features/tasks/interactions/crud';
import Wait from '../features/tasks/interactions/wait';
import QuoteGrid from '../features/tasks/view-models/quoteGrid.view';

Given('{actor} have/has created a quote', async(actor: Actor) => {
	actor.attemptsTo(
		Create.aQuote.thatIsEmpty,
	);
});

Given('{actor} have/has created a quote with fields:', async(actor: Actor, params: DataTable) => actor.attemptsTo(
	Create.aQuote.usingDataTree(params),
));

Given('{actor} have/has created a quote with a Section Hierarchy of "Simple"', async(actor: Actor) => actor.attemptsTo(
	Create.aQuote.withSimpleSections(),
));

Given('{actor} have/has created an empty quote with this rate card', (actor: Actor) => actor.attemptsTo(Create.aQuote.withRateCard(Last.created(RateCard))));

When('{actor} visit(s) the quote', async(actor: Actor) => actor.attemptsTo(
	Browse.toThe(Last.created(Quote)),
	Ensure.the(QuoteGrid.component).exists,
));

Then('{actor} can see that a default section has been created', (actor: Actor) => actor.attemptsTo(
	Wait.for(5).seconds,
	Ensure.the(TheGrid.has.aSectionNamed('1. Default Section')).exists,
));

Then('{actor} will see the resource role {string} in the order sheet',
	(actor: Actor, roleName: string) => actor.attemptsTo(Ensure.that(TheGrid.has.aRoleNamed(roleName))));
