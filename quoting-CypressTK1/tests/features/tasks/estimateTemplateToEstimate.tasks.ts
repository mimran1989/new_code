/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

import {
	addAnActivity, addAnActivityGroup, addATask, createEstimateTemplateWithRateCard,
} from './estimateTemplate.tasks';
import { Actor } from '../support/actor';
import Browse from './interactions/browse';
import { Last } from './interactions/crud';
import EstimateTemplateCreator from './view-models/estimateTemplateCreator.view';
import EstimateTemplate from '../support/sObject/estimateTemplate';
import { createARateCardWithRoles } from './ratecard.tasks';
import RateCard from '../support/sObject/rateCard';
import { createService } from './product.tasks';
import { Product } from '../support/sObject/product';
import Ensure from '../questions/ensure';
import { createActorTask } from '../support/task';
import { SObjectSO } from '../support/sObject';

const createEstimateTemplateWithSampleData = createActorTask<Cypress.Chainable<SObjectSO[]>>((actor: Actor) => {
	const role = {
		Name: 'Test Role',
		SkillLevel: 'L1',
	};

	return actor.attemptsTo<Cypress.Chainable<SObjectSO[]>>(
		createARateCardWithRoles([role]),
		createService,
		createEstimateTemplateWithRateCard(Last.created(RateCard), Last.created(Product)),
		Browse.toThe(Last.created(EstimateTemplate)),
		Ensure.the(EstimateTemplateCreator.component).exists,
		addAnActivityGroup('Test Group'),
		addAnActivity('Test Activity'),
		addATask('Test Task', 'Test Role'),
	);
});

// TODO: remove eslint below when we have another function
// eslint-disable-next-line import/prefer-default-export
export { createEstimateTemplateWithSampleData };
