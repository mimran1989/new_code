import { Then, When } from '@badeball/cypress-cucumber-preprocessor';
import Ensure from '../features/questions/ensure';
import { Actor } from '../features/support/actor';
import Click from '../features/tasks/interactions/click';
import ResourceRoleDialog from '../features/tasks/view-models/resourceRoleDialog.view';

When('{actor} close(s) the resource role dialog', (actor: Actor) => actor.attemptsTo(Click.on(ResourceRoleDialog.cancelButton)));

When('{actor} select(s) the {string} resource role', (actor: Actor, roleName: string) => actor.attemptsTo(
	Click.on(ResourceRoleDialog.roleDropdown),
	Click.on(ResourceRoleDialog.roleDropDownItem.labeled(roleName)),
));

When('{actor} select(s) a rate', (actor: Actor) => actor.attemptsTo(
	Click.on(ResourceRoleDialog.rateItem.number(1).radioButton),
	Click.on(ResourceRoleDialog.addToQuoteButton),
));

Then('{actor} can see the resource role dialog', (actor: Actor) => actor.attemptsTo(
	Ensure.the(ResourceRoleDialog.component).exists,
));

Then('{actor} should not see the resource role dialog', (actor: Actor) => actor.attemptsTo(Ensure.the(ResourceRoleDialog.component).doesNotExist));

Then('{actor} can see that he/she/they/I cannot close the resource role dialog', (actor: Actor) => actor
	.attemptsTo(Ensure.the(ResourceRoleDialog.cancelButton).isNotVisible));

Then('{actor} can see that they/I can close the resource role dialog', (actor: Actor) => actor
	.attemptsTo(
		Ensure.the(ResourceRoleDialog.cancelButton).isNotDisabled,
	));

Then('{actor} can can see the no available roles info message', (actor: Actor) => actor.attemptsTo(Ensure.the(ResourceRoleDialog.noRolesAvailableText).isVisible));
