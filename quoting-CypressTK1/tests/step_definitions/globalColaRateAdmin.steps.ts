/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import { Given, Then, When } from '@badeball/cypress-cucumber-preprocessor';
import Browse from '../features/tasks/interactions/browse';
import { Actor } from '../features/support/actor';
import GlobalColaRateAdmin from '../features/tasks/view-models/globalColaRateAdmin.view';
import Ensure from '../features/questions/ensure';
import Click from '../features/tasks/interactions/click';

Given('{actor} visit(s) the COLA Rates by Location tab', (actor: Actor) => actor.attemptsTo(
	Browse.to.theTabNamed('COLARatesByLocation'),
));

Then('{actor} should see the COLA Rates table', (actor: Actor) => actor.attemptsTo(
	Ensure.the(GlobalColaRateAdmin.table).exists,
));

When('{actor} add(s) a new row', (actor: Actor) => actor.attemptsTo(
	Click.on(GlobalColaRateAdmin.addRowButton),
));

Then('{actor} should see a blank row added to the table', (actor: Actor) => actor.attemptsTo(
	Ensure.the(GlobalColaRateAdmin.tableRow).exists,
));
