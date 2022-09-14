trigger TaskRoleSummaryTrigger on TaskRoleSummary__c(before update, after update) {
	TaskRoleSummaryTriggers.processTrigger(Trigger.oldMap, Trigger.newMap, Trigger.isBefore);
}
