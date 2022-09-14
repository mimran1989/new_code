trigger EstimateTemplateTrigger on EstimateTemplate__c(
	before insert,
	after insert,
	before update,
	after update,
	before delete,
	after delete
) {
	EstimateTemplateTrigger.processTrigger(Trigger.oldMap, Trigger.new, Trigger.isBefore);
}
