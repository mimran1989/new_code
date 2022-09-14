/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import { Given, Then, When } from '@badeball/cypress-cucumber-preprocessor';
import { Actor } from '../features/support/actor';
import { createEstimateTemplateWithSampleData } from '../features/tasks/estimateTemplateToEstimate.tasks';
import Click from '../features/tasks/interactions/click';
import RecordHomePage from '../features/tasks/view-models/recordHomePage.view';
import Ensure from '../features/questions/ensure';
import World from '../support/world';

Given('{actor} am/is viewing an estimate template with data', async(actor: Actor) => actor.attemptsTo(
	createEstimateTemplateWithSampleData,
));

When('{actor} click(s) the New Estimate button', (actor: Actor) => actor.attemptsTo(
	Click.on(RecordHomePage.highlightsPanelActionButton(`${World.namespacePrefix}EstimateTemplate__c.${World.namespacePrefix}NewEstimate`)),
));

Then('{actor} should be redirected to the created estimate', (actor: Actor) => actor.attemptsTo(
	Ensure.theUrlContains('Estimate__c'),
));
