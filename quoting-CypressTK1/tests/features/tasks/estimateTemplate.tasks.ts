/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import { Actor } from '../support/actor';
import {
	RateCard, SObjectSO, SObjectSOCallback,
} from '../support/sObject';
import EstimateTemplate from '../support/sObject/estimateTemplate';
import { Product } from '../support/sObject/product';
import { createActorTask } from '../support/task';
import World from '../../support/world';
import { Create } from './create';
import Click from './interactions/click';
import Insert, { Last } from './interactions/crud';
import Enter from './interactions/enter';
import { createService } from './product.tasks';
import ActivitiesModal from './view-models/activitiesModal.view';
import ActivityGroupModal from './view-models/activityGroupModal.view';
import EstimateTemplateCreator from './view-models/estimateTemplateCreator.view';

const createEstimateTemplateWithRateCard = (
	getRateCard: SObjectSOCallback,
	getServiceProduct: SObjectSOCallback,
) => createActorTask((actor: Actor): Cypress.Chainable<SObjectSO[]> => actor.attemptsTo(getRateCard).then(
	({ sObjectSO: rateCard }: SObjectSO) => actor.attemptsTo(getServiceProduct).then(({ sObjectSO: serviceProduct }) => actor.attemptsTo<Cypress.Chainable<SObjectSO[]>>(
		Insert.record(
			`${World.namespacePrefix}${EstimateTemplate.apiName}`,
			EstimateTemplate.getRecordCreateDefaults(World.isDeployedInPackage,
				{
					rateCardId: rateCard.id,
					serviceProductId: serviceProduct.id,
				}),
		),
	)),
));

const createAnEmptyEstimateTemplate = createActorTask<Cypress.Chainable<SObjectSO[]>>((actor: Actor) => actor.attemptsTo(
	Create.aRateCard.thatIsEmpty,
	createService,
	createEstimateTemplateWithRateCard(Last.created(RateCard), Last.created(Product)),
));

const addAnActivityGroup = (name: string) => createActorTask((actor: Actor) => actor.attemptsTo(
	Click.on(EstimateTemplateCreator.createActivityGroupButton),
	Enter.theValue(name).into(ActivityGroupModal.nameFieldForLastRow),
	Click.on(ActivityGroupModal.saveButton),
));

const addAnActivity = (name: string) => createActorTask((actor: Actor) => actor.attemptsTo(
	Click.on(EstimateTemplateCreator.addEditActivitiesButton),
	Enter.theValue(name).into(ActivitiesModal.nameFieldForLastRow),
	Click.on(ActivitiesModal.saveButton),
));

const addATask = (name: string, roleName: string) => createActorTask((actor: Actor) => actor.attemptsTo(
	Click.on(EstimateTemplateCreator.addEditTasksButton),
	Enter.theValue(name).into(ActivitiesModal.nameFieldForLastRow),
	Enter.theValue(roleName).into(ActivitiesModal.resourceFieldForLastRow.textBox),
	Click.on(ActivitiesModal.resourceFieldForLastRow.dropdownItem(roleName)),
	Click.on(ActivitiesModal.saveButton),
));

export {
	createAnEmptyEstimateTemplate, createEstimateTemplateWithRateCard, addAnActivityGroup, addAnActivity, addATask,
};
