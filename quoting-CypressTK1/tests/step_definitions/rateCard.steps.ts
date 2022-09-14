import { DataTable, Given } from '@badeball/cypress-cucumber-preprocessor';
import { Actor } from '../features/support/actor';
import { Create } from '../features/tasks/create';
import Browse from '../features/tasks/interactions/browse';
import Click from '../features/tasks/interactions/click';
import Enter from '../features/tasks/interactions/enter';
import RateCardPage from '../features/tasks/rateCardPage';

Given('{actor} have/has created a rate card with {int} role(s)', (actor: Actor, numberOfRoles: number) => actor.attemptsTo(
	Create.aRateCard.with(numberOfRoles).roles,
));

Given('{actor} have/has created a rate card with roles', (actor: Actor, dataTable: DataTable) => {
	const roles = dataTable.hashes().map((row) => ({
		Name: row.Name,
		SkillLevel: row['Skill Level'],
	}));

	return actor.attemptsTo(Create.aRateCard.withRoles(roles));
});

Given('{actor} click rate card header button', (actor: Actor) => actor.attemptsTo(
	// Click.on(RateCardPage.rateCardButton),
	Browse.to.theUrl('https://provus-qa-next.lightning.force.com/lightning/o/PSQ__RateCard__c/list?filterName=Recent'),
	Click.on(RateCardPage.rateCardButton),
));

Given('{actor} enter new rate card name only {string}', (actor: Actor, rateCardNameInput: string) => actor.attemptsTo(
	Browse.to.theUrl('https://provus-qa-next.lightning.force.com/lightning/o/PSQ__RateCard__c/list?filterName=Recent'),
	Click.on(RateCardPage.newButton),
	Enter.theValue(rateCardNameInput).into(RateCardPage.rateCardTextBox),
	Click.on(RateCardPage.activeCheckbox),
	// Click.on(RateCardPage.attributeGroup),
	// Click.on(RateCardPage.skillAndresource),
	Click.on(RateCardPage.saveButton),
));
