/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class ScopeParameterTemplateService {
	public static List<ScopeParameterTemplateDto> getParamsForParentId(Id parentId) {
		List<ScopeParameterTemplateDto> scopeParameterDtos = new List<ScopeParameterTemplateDto>();

		for (ScopeParameterTemplate__c paramSo : [
			SELECT
				Id,
				Name,
				DeveloperName__c,
				Sequence__c,
				Guidance__c,
				DataType__c,
				EstimateTemplateId__c,
				ActivityGroupTemplateId__c,
				ActivityTemplateId__c,
				AllowedValues__c,
				(
					SELECT Id, Sequence__c, FromValue__c, ToValue__c, Label__c
					FROM ScopeParameterValueTemplates__r
					ORDER BY Sequence__c
				)
			FROM ScopeParameterTemplate__c
			WHERE
				EstimateTemplateId__c = :parentId
				OR ActivityGroupTemplateId__c = :parentId
				OR ActivityTemplateId__c = :parentId
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		]) {
			scopeParameterDtos.add(new ScopeParameterTemplateDto(paramSo));
		}

		return scopeParameterDtos;
	}

	public static List<ScopeParameterTemplate__c> getScopeParameterTemplates(
		Id estimateTemplateId,
		Set<Id> activityGroupIds,
		Set<Id> activityIds
	) {
		List<ScopeParameterTemplate__c> scopeParameters = [
			SELECT
				Id,
				Name,
				ActivityGroupTemplateId__c,
				ActivityTemplateId__c,
				DataType__c,
				Description__c,
				DeveloperName__c,
				EstimateTemplateId__c,
				Guidance__c,
				IsActive__c,
				Sequence__c
			FROM ScopeParameterTemplate__c
			WHERE
				EstimateTemplateId__c = :estimateTemplateId
				OR ActivityGroupTemplateId__c IN :activityGroupIds
				OR ActivityTemplateId__c IN :activityIds
			WITH SECURITY_ENFORCED
		];

		return scopeParameters;
	}
}
