trigger Product2Trigger on Product2(
	before insert,
	after insert,
	before update,
	after update,
	before delete,
	after delete
) {
	Product2Triggers.processTrigger(Trigger.oldMap, Trigger.new, Trigger.isBefore);
}
