/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import { Then, When } from '@badeball/cypress-cucumber-preprocessor';
import EstimateTemplateCreator from '../features/tasks/view-models/estimateTemplateCreator.view';
import { Actor } from '../features/support/actor';
import Click from '../features/tasks/interactions/click';
import RecordHomePage from '../features/tasks/view-models/recordHomePage.view';
import Ensure from '../features/questions/ensure';
import { addAScopeParameter, addAScopeParameterWithoutDataType } from '../features/tasks/scopeParameter.tasks';
import World from '../support/world';

When('{actor} click(s) on the scope parameters button', (actor: Actor) => actor.attemptsTo(
	Click.on(EstimateTemplateCreator.addEditScopeParametersButtonFor),
));
When('{actor} click(s) the global scope parameters button', (actor: Actor) => actor.attemptsTo(
	Click.on(RecordHomePage.highlightsPanelActionButton(`${World.namespacePrefix}EstimateTemplate__c.${World.namespacePrefix}ScopeParameters`)),
));

When('{actor} add(s) a scope parameter named {string}', (actor: Actor, paramName: string) => actor.attemptsTo(
	addAScopeParameter(paramName),
));

When('{actor} add(s) a scope parameter named {string} without a data type', (actor: Actor, paramName: string) => actor.attemptsTo(
	addAScopeParameterWithoutDataType(paramName),
));

Then('{actor} can see the scope parameters modal', async(actor: Actor) => actor.attemptsTo(
	Ensure.the(EstimateTemplateCreator.scopeParametersTable).exists,
));

Then('{actor} can see a blank row in the scope parameters table', async(actor: Actor) => actor.attemptsTo(
	Ensure.the(EstimateTemplateCreator.scopeParameterRowNumber(1).element).exists,
));

Then('{actor} can see a scope parameter named {string} in the scope parameter table', async(actor: Actor, rowName: string) => actor.attemptsTo(
	Ensure.theValueOf(EstimateTemplateCreator.scopeParameterRowNumber(1).field('name')).equals(rowName),
));

Then('{actor} can see an error in the scope parameters', async(actor: Actor) => actor.attemptsTo(
	Ensure.the(EstimateTemplateCreator.scopeParameterRowNumber(1).errorField('Data Type')).exists,
));
