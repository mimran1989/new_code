/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class ProjectMilestoneTriggers {
	public static void processTrigger(List<ProjectMilestone__c> newMilestones) {
		for (ProjectMilestone__c milestoneSO : newMilestones) {
			if (
				milestoneSO.Type__c == ProjectMilestone.TYPE_MILESTONE ||
				milestoneSO.Type__c == ProjectMilestone.TYPE_ACTIVITY
			) {
				milestoneSO.AlignmentDate__c = milestoneSO.EstimatedOccurrenceDate__c;
			}
		}
	}
}
