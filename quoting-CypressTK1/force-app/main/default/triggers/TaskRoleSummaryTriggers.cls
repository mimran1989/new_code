/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class TaskRoleSummaryTriggers extends TriggerHandler {
	public static void processTrigger(
		Map<Id, TaskRoleSummary__c> oldMap,
		Map<Id, TaskRoleSummary__c> newMap,
		Boolean isBefore
	) {
		if (isBefore) {
			TaskRoleSummarySupport.rollupSummaries(newMap, oldMap);
		}
	}

	public TaskRoleSummaryTriggers(
		Map<Id, TaskRoleSummary__c> oldMap,
		List<TaskRoleSummary__c> newObjs,
		Boolean isBefore
	) {
		super(oldMap, newObjs, isBefore);
	}
}
