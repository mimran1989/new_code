/**
 *  Provus Services Quoting
 *  ProductTriggers
 *  @2022 Provus Inc. All rights reserved.
 *
 */
public with sharing class ProductTriggers extends TriggerHandler {
	public static void processTrigger(
		Map<Id, Product__c> oldMap,
		List<Product__c> newObjs,
		Boolean isBefore
	) {
		final ProductTriggers myTrigger = new ProductTriggers(oldMap, newObjs, isBefore);
		if (!isBefore) {
			myTrigger.syncProductToProduct2();
		}
	}

	public ProductTriggers(Map<Id, Product__c> oldMap, List<Product__c> newObjs, Boolean isBefore) {
		super(oldMap, newObjs, isBefore);
	}

	public void syncProductToProduct2() {
		if (!RuntimeContext.isSyncProductMode && !isDelete) {
			SyncProductService.scheduleSync(newObjs);
		}
	}
}
