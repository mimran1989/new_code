/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class HashtagDictionaryService {
	public static Map<String, Decimal> generateDictionaryForEstimate(Id estimateId) {
		List<ScopeParameterDto> scopeParameterDtos = ScopeParameterService.getScopeParameters(
			estimateId
		);
		Map<String, Decimal> valueByHashtag = new Map<String, Decimal>();
		for (ScopeParameterDto scopeParameterDto : scopeParameterDtos) {
			if (scopeParameterDto.dataType == ScopeParameterService.DATATYPE_INTEGER) {
				// other types are unsupported for now
				valueByHashtag.put(scopeParameterDto.hashtag, scopeParameterDto.value.integerValue);
			}
		}

		return valueByHashtag;
	}

	public static String[] getHashtagsForEstimateTemplate(Id estimateTemplateId) {
		String[] hashtags = new String[0];
		for (ScopeParameterTemplate__c paramSo : [
			SELECT DeveloperName__c
			FROM ScopeParameterTemplate__c
			WHERE
				EstimateTemplateId__c = :estimateTemplateId
				OR ActivityGroupTemplateId__r.EstimateTemplateId__c = :estimateTemplateId
				OR ActivityTemplateId__r.ActivityGroupTemplateId__r.EstimateTemplateId__c = :estimateTemplateId
			WITH SECURITY_ENFORCED
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		]) {
			if (!String.isBlank(paramSo.DeveloperName__c)) {
				hashtags.add(paramSo.DeveloperName__c);
			}
		}

		return hashtags;
	}

	public static Map<String, ScopeParameterTemplateDto> getHashtagDictionaryForEstimateTemplate(
		Id estimateTemplateId
	) {
		Map<String, ScopeParameterTemplateDto> templateDtosByHashtag = new Map<String, ScopeParameterTemplateDto>();

		for (ScopeParameterTemplate__c paramSo : [
			SELECT Id, DeveloperName__c, DataType__c
			FROM ScopeParameterTemplate__c
			WHERE
				EstimateTemplateId__c = :estimateTemplateId
				OR ActivityGroupTemplateId__r.EstimateTemplateId__c = :estimateTemplateId
				OR ActivityTemplateId__r.ActivityGroupTemplateId__r.EstimateTemplateId__c = :estimateTemplateId
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		]) {
			templateDtosByHashtag.put(paramSo.DeveloperName__c, new ScopeParameterTemplateDto(paramSo));
		}

		return templateDtosByHashtag;
	}
}
