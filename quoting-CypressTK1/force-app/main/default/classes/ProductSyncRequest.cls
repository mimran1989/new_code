/**
 *  Provus Services Quoting
 *  ProductSyncRequest
 *  @2021 Provus Inc. All rights reserved.
 */
public with sharing class ProductSyncRequest extends ManagedObject {
	// constants
	public static final String SOBJECT_NAME = 'ProductSyncRequest__e';
	public static final String OBJECT_TYPE_PRODUCT = 'Product__c';
	public static final String OBJECT_TYPE_PRODUCT2 = 'Product2';

	public ProductSyncRequest(ProductSyncRequest__e syncRequestSO) {
		super(syncRequestSO);
	}
}
