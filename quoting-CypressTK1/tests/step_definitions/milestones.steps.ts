/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import { Then, When } from '@badeball/cypress-cucumber-preprocessor';
import Ensure from '../features/questions/ensure';
import TheMilestonesTable from '../features/questions/milestones.questions';
import { Actor } from '../features/support/actor';
import Click from '../features/tasks/interactions/click';
import {
	addActivityAligned, addDateAligned, addMilestoneAligned, addMilestoneAlignedWithOffset,
} from '../features/tasks/milestones.tasks';
import Milestones from '../features/tasks/view-models/milestones.view';
import MilestonesTable from '../features/tasks/view-models/milestonesTable.view';
import ResourceRoleDialog from '../features/tasks/view-models/resourceRoleDialog.view';

When('{actor} visit(s) the Milestones tab', (actor: Actor) => actor.attemptsTo(
	Click.on(ResourceRoleDialog.cancelButton),
	Click.on(Milestones.tab),
));

When('{actor} click(s) New', (actor: Actor) => actor.attemptsTo(
	Click.on(MilestonesTable.newButton),
));

When('{actor} add a new milestone {string} aligned to date on {string}', (actor: Actor, name: string, date: string) => actor.attemptsTo(
	addDateAligned(name, date),
));

Then('{actor} can see the milestones table', (actor: Actor) => actor.attemptsTo(
	Ensure.the(MilestonesTable.component).exists,
));

Then('{actor} can see the Create new milestones modal', (actor: Actor) => actor.attemptsTo(
	Ensure.the(Milestones.flowModal).exists,
));

Then('{actor} can see a milestone named {string} in the milestones table', (actor: Actor, name: string) => actor.attemptsTo(
	Ensure.the(MilestonesTable.nameAnchorForRowNamed(name)).exists,
));

Then('{actor} can see a milestone named {string} aligned to a milestone named {string} in the milestones table',
	(actor: Actor, name: string, milestoneName: string) => actor.attemptsTo(
		Ensure.that(TheMilestonesTable.has.aRowNamed(name).alignedToAMilestoneNamed(milestoneName)),
	));

Then('{actor} can see a milestone named {string} aligned to last selected period in the milestones table',
	async(actor: Actor, name: string) => actor.attemptsTo(
		Ensure.that(TheMilestonesTable.has.aRowNamed(name).alignedToAnActivityNamed(actor.recall('activityPeriod'))),
	));

Then('{actor} can see a milestone named {string} aligned to last selected period group in the milestones table',
	async(actor: Actor, name: string) => actor.attemptsTo(
		Ensure.that(TheMilestonesTable.has.aRowNamed(name).alignedToAnActivityNamed(actor.recall('activityPeriodGroup'))),
	));

Then('{actor} can see a milestone named {string} with a/an {string} of {string} in the table',
	(actor: Actor, name: string, fieldLabel: string, estimatedDate: string) => actor.attemptsTo(
		Ensure.that(TheMilestonesTable.has.aRowNamed(name).withExactColumnValue(fieldLabel, estimatedDate)),
	));

When('{actor} add(s) a new milestone {string} aligned to milestone {string}',
	(actor: Actor, name: string, milestone: string) => actor.attemptsTo(addMilestoneAligned(name, milestone)));

When('{actor} add(s) a new milestone {string} aligned to milestone {string} with a/an {int} {string} offset',
	(actor: Actor, name: string, milestone: string, offset: number, offsetUnit: string) => actor.attemptsTo(
		addMilestoneAlignedWithOffset(name, milestone, offset, offsetUnit),
	));

When('{actor} add(s) a new milestone {string} aligned to {string} of period {int}',
	(actor: Actor, name: string, activityType: string, itemNumber: number) => actor.attemptsTo(
		addActivityAligned(name, activityType, 'activityPeriod', itemNumber),
	));

When('{actor} add(s) a new milestone {string} aligned to {string} of period group {int}',
	(actor: Actor, name: string, activityType: string, itemNumber: number) => actor.attemptsTo(
		addActivityAligned(name, activityType, 'activityPeriodGroup', itemNumber),
	));

When('{actor} select(s) all milestones', (actor: Actor) => actor.attemptsTo(
	Click.on(MilestonesTable.selectAllRowsCheckbox),
));

When('{actor} delete(s) the milestones', (actor: Actor) => actor.attemptsTo(
	Click.on(MilestonesTable.deleteButton),
));

When('{actor} will see a confirmation to delete the milestones', (actor: Actor) => actor.attemptsTo(
	Ensure.the(Milestones.deleteConfirmationText).isVisible,
));

When('{actor} confirm(s) that he/she/they/I want to delete the milestones', (actor: Actor) => actor.attemptsTo(
	Click.on(Milestones.deleteConfirmationButton),
));

Then('{actor} can no longer see milestones in the table', (actor: Actor) => actor.attemptsTo(
	Ensure.the(MilestonesTable.tableRows).doesNotExist,
));
When('{actor} delete all the milestones', (actor: Actor) => actor.attemptsTo(
	Click.on(MilestonesTable.selectAllRowsCheckbox),
	Click.on(MilestonesTable.deleteButton),
	Click.on(Milestones.deleteConfirmationButton),
));
