trigger RateCardItemTrigger on RateCardItem__c(
	before insert,
	before update,
	before delete,
	after insert,
	after update,
	after delete
) {
	RateCardItemTriggers.processTrigger(Trigger.oldMap, Trigger.new, Trigger.isBefore);
}
