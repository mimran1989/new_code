trigger ProductSyncRequestTrigger on ProductSyncRequest__e(after insert) {
	ProductSyncRequestTriggers.processTrigger(Trigger.new);
}
