/**
 *  Provus Services Quoting
 *  Product2Triggers
 *  @2022 Provus Inc. All rights reserved.
 *
 */
public with sharing class Product2Triggers extends TriggerHandler {
	public static void processTrigger(
		Map<Id, Product2> oldMap,
		List<Product2> newObjs,
		Boolean isBefore
	) {
		final Product2Triggers myTrigger = new Product2Triggers(oldMap, newObjs, isBefore);
		if (!isBefore) {
			myTrigger.syncProduct2ToProduct();
		}
	}

	public Product2Triggers(Map<Id, Product2> oldMap, List<Product2> newObjs, Boolean isBefore) {
		super(oldMap, newObjs, isBefore);
	}

	public void syncProduct2ToProduct() {
		if (!RuntimeContext.isSyncProductMode && !isDelete) {
			SyncProductService.scheduleSync(newObjs);
		}
	}
}
