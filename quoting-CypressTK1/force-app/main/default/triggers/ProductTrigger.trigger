trigger ProductTrigger on Product__c(
	before insert,
	after insert,
	before update,
	after update,
	before delete,
	after delete
) {
	ProductTriggers.processTrigger(Trigger.oldMap, Trigger.new, Trigger.isBefore);
}
