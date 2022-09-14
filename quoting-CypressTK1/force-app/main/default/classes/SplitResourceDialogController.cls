/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class SplitResourceDialogController {
	@AuraEnabled
	public static List<ResourceSplitDTO> getSplitsForRoleSummary(Id roleSummaryId) {
		List<ResourceSplitDTO> splits = new List<ResourceSplitDTO>();
		for (ResourceSplit__c splitSO : ResourceSplitService.getSplitsForRoleSummary(roleSummaryId)) {
			splits.add(new ResourceSplitDTO(splitSO));
		}
		return splits;
	}

	@AuraEnabled
	public static List<ResourceSplitDTO> saveSplits(Id roleSummaryId, List<ResourceSplitDTO> splits) {
		List<ResourceSplit__c> updateSplits = new List<ResourceSplit__c>();
		List<Id> validSplitIds = new List<Id>();
		for (ResourceSplitDTO split : splits) {
			if (split.id != null) {
				validSplitIds.add(split.id);
			}

			updateSplits.add((ResourceSplit__c) split.refreshSo());
		}

		deleteInvalidSplits(roleSummaryId, validSplitIds);
		CRUDUtility.upsertRecords(updateSplits);
		return splits;
	}

	private static void deleteInvalidSplits(Id roleSummaryId, List<Id> validSplitIds) {
		CRUDUtility.deleteRecords(
			[
				SELECT Id
				FROM ResourceSplit__c
				WHERE TaskRoleSummaryId__c = :roleSummaryId AND Id NOT IN :validSplitIds
				WITH SECURITY_ENFORCED
				LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
			]
		);
	}
}
