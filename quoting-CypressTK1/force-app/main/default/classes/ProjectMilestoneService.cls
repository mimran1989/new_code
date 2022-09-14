/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class ProjectMilestoneService {
	public static List<ProjectMilestoneDto> getMilestonesForQuote(Id quoteId) {
		List<ProjectMilestoneDto> projectMilestoneDtos = new List<ProjectMilestoneDto>();
		for (ProjectMilestone__c milestoneSO : [
			SELECT
				Id,
				Name,
				AlignToActivityOrMilestone__c,
				ActivityDate__c,
				ActivityName__c,
				Offset__c,
				OffsetUnit__c,
				EstimatedOccurrenceDate__c,
				Type__c
			FROM ProjectMilestone__c
			WHERE QuoteId__c = :quoteId
			WITH SECURITY_ENFORCED
		]) {
			projectMilestoneDtos.add(new ProjectMilestoneDto(milestoneSO));
		}

		return projectMilestoneDtos;
	}

	public static void deleteMilestoneFromQuote(List<Id> milestoneIds, Id quoteId) {
		List<ProjectMilestone__c> records = new List<ProjectMilestone__c>();
		for (Id removeRecordIds : milestoneIds) {
			records.add(new ProjectMilestone__c(Id = removeRecordIds));
		}
		CRUDUtility.deleteRecords(records);
	}
}
