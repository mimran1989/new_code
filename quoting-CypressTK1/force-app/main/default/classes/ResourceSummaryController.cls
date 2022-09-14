/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class ResourceSummaryController {
	@AuraEnabled
	public static void addResource(List<TaskRoleSummaryDto> roleSummaryDtos) {
		List<TaskRoleSummary__c> roleSummaries = new List<TaskRoleSummary__c>();
		for (TaskRoleSummaryDto roleSummaryDto : roleSummaryDtos) {
			roleSummaries.add((TaskRoleSummary__c) roleSummaryDto.refreshSo());
		}

		EstimateTreeSummarySupport.createSummaryRecords(
			roleSummaries[0],
			roleSummaries[0].SummaryLevel__c
		);
	}

	@AuraEnabled
	public static void adjustHours(TaskRoleSummaryDto roleSummaryDto) {
		TaskRoleSummary__c roleSummarySo = (TaskRoleSummary__c) roleSummaryDto.refreshSo();
		CRUDUtility.updateRecords(
			new TaskRoleSummary__c(
				Id = roleSummarySo.Id,
				LevelAdjustment__c = roleSummarySo.LevelAdjustment__c
			)
		);
	}

	@AuraEnabled
	public static List<TaskRoleSummaryDto> getRoleSummaries(String type, Id recordId) {
		List<TaskRoleSummaryDto> roleSummaryDtos = new List<TaskRoleSummaryDto>();
		for (TaskRoleSummary__c roleSummarySo : [
			SELECT
				ActivityGroupId__c,
				ActivityId__c,
				CalculatedDuration__c,
				EstimatedAmount__c,
				EstimatedCost__c,
				EstimatedDuration__c,
				EstimateId__c,
				Id,
				LevelAdjustment__c,
				LevelAdjustments__c,
				PhaseId__c,
				RateCardItemId__c,
				ResourceRole__c,
				ResourceRoleId__c,
				RolledUpAdjustments__c,
				RolledUpCalculatedDuration__c,
				RolledUpEstimatedDuration__c,
				SummaryId__c,
				SummaryLevel__c,
				TaskRoleSummaryId__c,
				TotalAdjustments__c,
				TotalCalculatedDuration__c,
				TotalEstimatedAmount__c,
				TotalEstimatedCost__c,
				TotalEstimatedDuration__c,
				(
					SELECT
						Name,
						TaskRoleSummaryId__c,
						TotalEstimatedDuration__c,
						TotalAdjustments__c,
						TotalCalculatedDuration__c,
						LevelAdjustment__c,
						SplitPercentage__c,
						Sequence__c
					FROM ResourceSplits__r
					ORDER BY Name
				)
			FROM TaskRoleSummary__c
			WHERE
				SummaryLevel__c = :type
				AND (EstimateId__c = :recordId
				OR ActivityGroupId__c = :recordId
				OR ActivityId__c = :recordId)
			WITH SECURITY_ENFORCED
		]) {
			roleSummaryDtos.add(new TaskRoleSummaryDto(roleSummarySo));
		}

		return roleSummaryDtos;
	}

	@AuraEnabled
	public static void updateNotApplicableField(
		String recordId,
		Boolean isNotApplicable,
		String type
	) {
		if (type == EstimatorConstants.ACTIVITY_GROUP) {
			EstimateTreeService.notApplicableForActivityGroup(recordId, isNotApplicable);
		} else if (type == EstimatorConstants.ACTIVITY) {
			EstimateTreeService.notApplicableForActivity(recordId, isNotApplicable);
		} else if (type == EstimatorConstants.PHASE) {
			EstimateTreeService.notApplicableForPhase(recordId, isNotApplicable);
		}
	}
}
