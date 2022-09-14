/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
@IsTest
public class TaskRoleSummaryTestBase {
	public static TaskSummary__c newTaskSummary() {
		TaskSummary__c newSummary = new TaskSummary__c();
		CRUDUtility.insertRecords(newSummary);

		return newSummary;
	}

	public static TaskRoleSummary__c newTaskRoleSummary() {
		TaskSummary__c taskSummary = newTaskSummary();
		TaskRoleSummary__c roleSummary = new TaskRoleSummary__c(SummaryId__c = taskSummary.Id);

		CRUDUtility.insertRecords(roleSummary);
		return roleSummary;
	}
}
