import { Then, When } from '@badeball/cypress-cucumber-preprocessor';
import Ensure from '../features/questions/ensure';
import { Actor } from '../features/support/actor';
import Click from '../features/tasks/interactions/click';
import AdjustRevenueModal from '../features/tasks/view-models/adjustRevenueModal.view';
import QuoteGrid from '../features/tasks/view-models/quoteGrid.view';
import ResourceRoleDialog from '../features/tasks/view-models/resourceRoleDialog.view';

When('{actor} click(s) on the Adjust Revenue Margin button', (actor: Actor) => {
	actor.attemptsTo(
		Click.on(ResourceRoleDialog.cancelButton),
		Click.on(QuoteGrid.adjustRevenueMarginButton),
	);
});

When('{actor} click(s) on the COLA Adjustment tab', (actor: Actor) => {
	actor.attemptsTo(
		Click.on(AdjustRevenueModal.colaAdjustmentButton),
	);
});

Then('{actor} can see input fields for COLA Adjustment', (actor: Actor) => {
	actor.attemptsTo(
		Ensure.the(AdjustRevenueModal.colaYoyAdjustmentField).exists,
		Ensure.the(AdjustRevenueModal.colaPassThroughField).exists,
	);
});
