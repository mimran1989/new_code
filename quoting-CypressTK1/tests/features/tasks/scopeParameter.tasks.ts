/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

import EstimateTemplateCreator from './view-models/estimateTemplateCreator.view';
import { Actor } from '../support/actor';
import Enter from './interactions/enter';
import Click from './interactions/click';
import RecordHomePage from './view-models/recordHomePage.view';
import { createActorTask } from '../support/task';
import World from '../../support/world';
import Ensure from '../questions/ensure';

const addAScopeParameter = (paramName: string) => createActorTask((actor: Actor) => actor.attemptsTo(
	Click.on(RecordHomePage.highlightsPanelActionButton(`${World.namespacePrefix}EstimateTemplate__c.${World.namespacePrefix}ScopeParameters`)),
	Enter.theValue(paramName).into(EstimateTemplateCreator.scopeParameterRowNumber(1).field('name')),
	Enter.theValue(`#${paramName}`).into(EstimateTemplateCreator.scopeParameterRowNumber(1).field('developerName')),
	Click.on(EstimateTemplateCreator.scopeParameterRowNumber(1).dropdownLabeled('Data Type')),
	Click.on(EstimateTemplateCreator.scopeParameterRowNumber(1).dropdownItem('Data Type', 'Checkbox')),
	Click.on(EstimateTemplateCreator.scopeParameterSaveButton),
	Ensure.the(RecordHomePage.toastMessage('Scope Parameters successfully saved')).exists,
));

const addAScopeParameterWithoutDataType = (paramName: string) => createActorTask((actor: Actor) => actor.attemptsTo(
	Click.on(RecordHomePage.highlightsPanelActionButton(`${World.namespacePrefix}EstimateTemplate__c.${World.namespacePrefix}ScopeParameters`)),
	Enter.theValue(paramName).into(EstimateTemplateCreator.scopeParameterRowNumber(1).field('name')),
	Enter.theValue(`#${paramName}`).into(EstimateTemplateCreator.scopeParameterRowNumber(1).field('developerName')),
	Click.on(EstimateTemplateCreator.scopeParameterSaveButton),
));

export {
	addAScopeParameter, addAScopeParameterWithoutDataType,
};
