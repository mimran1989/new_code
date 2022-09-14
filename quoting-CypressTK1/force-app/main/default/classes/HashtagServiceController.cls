/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class HashtagServiceController {
	@AuraEnabled
	public static Map<String, ScopeParameterTemplateDto> getHashtagDictionaryForEstimateTemplate(
		Id estimateTemplateId
	) {
		return HashtagDictionaryService.getHashtagDictionaryForEstimateTemplate(estimateTemplateId);
	}

	@AuraEnabled
	public static Map<String, Decimal> getHashtagDictionaryForEstimate(Id estimateId) {
		return HashtagDictionaryService.generateDictionaryForEstimate(estimateId);
	}
}
