/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class ProjectMilestoneController {
	@AuraEnabled
	public static List<ProjectMilestoneDto> getMilestonesForQuote(Id quoteId) {
		return ProjectMilestoneService.getMilestonesForQuote(quoteId);
	}

	@AuraEnabled
	public static void deleteMilestoneFromQuote(List<Id> milestoneIds, Id quoteId) {
		ProjectMilestoneService.deleteMilestoneFromQuote(milestoneIds, quoteId);
	}
}
