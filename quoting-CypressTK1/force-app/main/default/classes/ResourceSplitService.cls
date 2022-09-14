/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class ResourceSplitService {
	public static List<ResourceSplit__c> getSplitsForRoleSummary(Id taskRoleSummaryId) {
		return [
			SELECT
				Id,
				Name,
				SplitPercentage__c,
				TaskRoleSummaryId__c,
				Sequence__c,
				TotalEstimatedDuration__c,
				LevelAdjustment__c,
				TotalCalculatedDuration__c,
				TotalAdjustments__c
			FROM ResourceSplit__c
			WHERE TaskRoleSummaryId__c = :taskRoleSummaryId
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c NULLS LAST
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		];
	}
}
