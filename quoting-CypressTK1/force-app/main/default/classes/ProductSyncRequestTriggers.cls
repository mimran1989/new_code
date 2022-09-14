/**
 *  Provus Services Quoting
 *  ProductSyncRequestTriggers
 *  @2022 Provus Inc. All rights reserved.
 *
 */
public with sharing class ProductSyncRequestTriggers extends TriggerHandler {
	public static void processTrigger(List<ProductSyncRequest__e> newObjs) {
		final ProductSyncRequestTriggers myTrigger = new ProductSyncRequestTriggers(newObjs);
		myTrigger.runBiDirectionalProductSync();
	}

	public ProductSyncRequestTriggers(List<ProductSyncRequest__e> newObjs) {
		// platform trigger only supports after insert
		super(null, newObjs, false);
	}

	public void runBiDirectionalProductSync() {
		SyncProductService.runProductSync(newObjs);
	}
}
