/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

import Click from './interactions/click';
import Milestones from './view-models/milestones.view';
import MilestonesTable from './view-models/milestonesTable.view';
import Enter from './interactions/enter';
import { Actor } from '../support/actor';
import { createActorTask } from '../support/task';
import Select from './select';
import Ensure from '../questions/ensure';

const ALIGN_MILESTONE = 'Aligned to another Milestone';
const ALIGN_PROJECT_ACTIVITY = 'Aligned to Project Activity';

const addDateAligned = (name: string, date: string) => createActorTask((actor: Actor) => actor.attemptsTo(
	Click.on(MilestonesTable.newButton),
	Enter.theValue(name).into(Milestones.nameField),
	Click.on(Milestones.flowModalNextButton),
	Enter.theValue(date).into(Milestones.dateField),
	Click.on(Milestones.flowModalNextButton),
	Ensure.the(Milestones.flowModal).doesNotExist,
));

const addMilestoneAligned = (name: string, milestone: string) => createActorTask((actor: Actor) => actor.attemptsTo(
	Ensure.the(Milestones.flowModal).doesNotExist,
	Click.on(MilestonesTable.newButton),
	Enter.theValue(name).into(Milestones.nameField),
	Click.on(Milestones.typeRadioButton.for(ALIGN_MILESTONE)),
	Click.on(Milestones.flowModalNextButton),
	Select.value(milestone).inComboBox(Milestones.dropdown.named('alignToMilestone')),
	Click.on(Milestones.flowModalNextButton),
));

const addMilestoneAlignedWithOffset = (name: string, milestone: string, offset: number, offsetUnit: string) => createActorTask((actor: Actor) => actor.attemptsTo(
	Ensure.the(Milestones.flowModal).doesNotExist,
	Click.on(MilestonesTable.newButton),
	Enter.theValue(name).into(Milestones.nameField),
	Click.on(Milestones.typeRadioButton.for(ALIGN_MILESTONE)),
	Click.on(Milestones.flowModalNextButton),
	Select.value(milestone).inComboBox(Milestones.dropdown.named('alignToMilestone')),
	Enter.theValue(`${offset}`).into(Milestones.milestoneOffsetField),
	Select.value(offsetUnit).inComboBox(Milestones.dropdown.named('milestoneOffsetUnit')),
	Click.on(Milestones.flowModalNextButton),
));

const addActivityAligned = (name: string, alignment: string, dropdownName: string, itemNumber: number) => createActorTask((actor: Actor) => actor.attemptsTo(
	Ensure.the(Milestones.flowModal).doesNotExist,
	Click.on(MilestonesTable.newButton),
	Enter.theValue(name).into(Milestones.nameField),
	Click.on(Milestones.typeRadioButton.for(ALIGN_PROJECT_ACTIVITY)),
	Click.on(Milestones.flowModalNextButton),
	Select.value(alignment).inComboBox(Milestones.dropdown.named('activityAlignment')),
	Select.value(itemNumber).inComboBox(Milestones.dropdown.named(dropdownName)),
	createActorTask(() => {
		Milestones.dropdownItem.number(dropdownName, itemNumber)().then((dropDownItem) => {
			actor.remember(dropdownName, dropDownItem.text());
		});
	}),
	Click.on(Milestones.flowModalNextButton),
));

export {
	addActivityAligned, addMilestoneAligned, addMilestoneAlignedWithOffset, addDateAligned,
};
