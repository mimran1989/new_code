/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import { Given, Then, When } from '@badeball/cypress-cucumber-preprocessor';
import { Actor } from '../features/support/actor';
import { Create } from '../features/tasks/create';
import EstimateTemplate from '../features/support/sObject/estimateTemplate';
import Browse from '../features/tasks/interactions/browse';
import { Last } from '../features/tasks/interactions/crud';
import EstimateTemplateCreator from '../features/tasks/view-models/estimateTemplateCreator.view';
import Click from '../features/tasks/interactions/click';
import ActivityGroupModal from '../features/tasks/view-models/activityGroupModal.view';
import Ensure from '../features/questions/ensure';
import ActivitiesModal from '../features/tasks/view-models/activitiesModal.view';
import { addAnActivity, addAnActivityGroup } from '../features/tasks/estimateTemplate.tasks';

Given('{actor} have/has created an estimate template', async(actor: Actor) => actor.attemptsTo(
	Create.anEstimateTemplate.thatIsEmpty,
));

Given('{actor} is/am viewing a new estimate template', async(actor: Actor) => actor.attemptsTo(
	Create.anEstimateTemplate.thatIsEmpty,
	Browse.toThe(Last.created(EstimateTemplate)),
	Ensure.the(EstimateTemplateCreator.component).exists,
));

When('{actor} visit(s) the estimate template', async(actor: Actor) => actor.attemptsTo(
	Browse.toThe(Last.created(EstimateTemplate)),
	Ensure.the(EstimateTemplateCreator.component).exists,
));

When('{actor} click(s) on the activity group creation button', (actor: Actor) => actor.attemptsTo(
	Click.on(EstimateTemplateCreator.createActivityGroupButton),
));

When('{actor} click(s) on the activities button', (actor: Actor) => actor.attemptsTo(
	Click.on(EstimateTemplateCreator.addEditActivitiesButton),
));

When('{actor} add an activity group named {string}', (actor: Actor, groupName: string) => actor.attemptsTo(
	addAnActivityGroup(groupName),
));

When('{actor} add an activity named {string}', (actor: Actor, activityName: string) => actor.attemptsTo(
	addAnActivity(activityName),
));
Then('{actor} can see the activity group creation button', (actor: Actor) => actor.attemptsTo(
	Ensure.the(EstimateTemplateCreator.createActivityGroupButton).exists,
));

Then('{actor} can see the activity group creation modal', (actor: Actor) => actor.attemptsTo(
	Ensure.the(ActivityGroupModal.header).exists,
));

Then('{actor} can see the activities modal for {string}', (actor: Actor, groupName: string) => actor.attemptsTo(
	Ensure.the(ActivitiesModal.headerFor(groupName)).exists,
));

Then('{actor} can see a row named {string} in the table', async(actor: Actor, rowName: string) => actor.attemptsTo(
	Ensure.the(EstimateTemplateCreator.treeGridRowFor(rowName)).exists,
));
