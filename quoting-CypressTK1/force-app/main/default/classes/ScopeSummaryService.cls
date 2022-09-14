/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class ScopeSummaryService {
	public static List<ScopeSummaryDto> getScopeSummariesForEstimate(Id estimateId) {
		List<ScopeSummaryDto> paramValues = new List<ScopeSummaryDto>();
		List<TaskParameterValue__c> paramValueSos = [
			SELECT
				Id,
				BooleanValue__c,
				IntegerValue__c,
				TextValue__c,
				TemplateId__r.Name,
				TemplateId__r.DataType__c,
				TaskId__r.IsNotApplicable__c,
				TaskId__r.Name,
				TaskId__r.ActivityId__r.Name,
				TaskId__r.ActivityId__r.ActivityGroupId__r.Name,
				TaskId__r.ActivityGroupId__r.PhaseId__r.Name,
				TaskId__r.EstimatedDuration__c,
				Name
			FROM TaskParameterValue__c
			WHERE TaskId__r.EstimateId__c = :estimateId
			WITH SECURITY_ENFORCED
			ORDER BY TaskId__r.Path__c ASC
		];

		for (TaskParameterValue__c paramValueSo : paramValueSos) {
			paramValues.add(new ScopeSummaryDto(paramValueSo));
		}

		return paramValues;
	}
}
