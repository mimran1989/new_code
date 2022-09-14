/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import { IRecordInput, SObjectDO, SObjectSO } from '.';
import Util from '../util';

const FIELD_NAME_RATE_CARD_ID = 'RateCardId__c';
const FIELD_NAME_SERVICE_ID = 'ServiceId__c';
const FIELD_NAME_ACTIVE = 'IsActive__c';

interface EstimateTemplateRecordInput extends IRecordInput {
	rateCardId: string;
	serviceProductId: string;
}

function getRecordCreateDefaults(isDeployedInPackage = false, { rateCardId, serviceProductId }: EstimateTemplateRecordInput) {
	const qualifier = Util.nameQualifier(isDeployedInPackage);

	const estimateTemplateSO: SObjectSO = {
		Name: Util.getRandomString(18),
	};

	estimateTemplateSO[qualifier(FIELD_NAME_RATE_CARD_ID)] = rateCardId;
	estimateTemplateSO[qualifier(FIELD_NAME_SERVICE_ID)] = serviceProductId;
	estimateTemplateSO[qualifier(FIELD_NAME_ACTIVE)] = true;

	return estimateTemplateSO;
}

const EstimateTemplate: SObjectDO = {
	apiName: 'EstimateTemplate__c',
	getRecordCreateDefaults,
};

export default EstimateTemplate;
