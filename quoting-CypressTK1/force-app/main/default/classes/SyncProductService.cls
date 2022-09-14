/**
 *  Provus Services Quoting
 *  SyncProductService
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class SyncProductService {
	public static void syncProduct2ToProvus(Set<Id> product2Ids) {
		ProvusSetup__mdt provusSetup = ProvusSetup__mdt.getInstance('Standard');
		if (product2Ids.isEmpty() || provusSetup.DisableProductSync__c) {
			return;
		}

		List<Product2> product2s = (List<Product2>) getSourceRecordsForSync(
			product2Ids,
			Schema.Product2.SObjectType
		);
		Map<Id, Id> provusProductIdByProduct2Id = getProvusProductsIdsForProduct2s(product2Ids);
		Map<Id, Product__c> associatedProducts = new Map<Id, Product__c>();
		List<Product__c> provusProductsToUpsert = new List<Product__c>();
		List<ProvusProductMappingDTO> productFieldMappings = SettingsService.getProvusProductMapping();
		for (Product2 product : product2s) {
			Product__c provusProduct = new Product__c(
				Id = provusProductIdByProduct2Id.get(product.Id),
				Name = product.Name,
				StandardProductId__c = product.Id
			);

			for (ProvusProductMappingDTO fieldMapping : productFieldMappings) {
				switch on fieldMapping.name {
					when 'AssociatedProductId' {
						setAssociatedProductId(
							associatedProducts,
							provusProduct,
							product.get(fieldMapping.product2FieldName)
						);
					}
					when 'RecordTypeId' {
						provusProduct.put(
							fieldMapping.fieldName,
							SObjectUtility.getRecordTypeIdbyName(
								Schema.SObjectType.Product__c.getName(),
								(String) product.get(fieldMapping.product2FieldName)
							)
						);
					}
					when else {
						provusProduct.put(fieldMapping.fieldName, product.get(fieldMapping.product2FieldName));
					}
				}
			}

			provusProductsToUpsert.add(provusProduct);
		}

		CRUDUtility.upsertRecords(provusProductsToUpsert);

		if (!associatedProducts.isEmpty()) {
			for (Product__c existingProduct : [
				SELECT Id, StandardProductId__c
				FROM Product__c
				WHERE StandardProductId__c IN :associatedProducts.keySet()
				WITH SECURITY_ENFORCED
			]) {
				if (associatedProducts.containsKey(existingProduct.StandardProductId__c)) {
					associatedProducts.get(existingProduct.StandardProductId__c)
						.AssociatedProductId__c = existingProduct.Id;
				}
			}

			CRUDUtility.upsertRecords(provusProductsToUpsert);
		}
	}

	private static void setAssociatedProductId(
		Map<Id, SObject> associatedProducts,
		SObject product,
		Object fieldValue
	) {
		Id associatedId = (Id) fieldValue;
		if (associatedId != null) {
			associatedProducts.put(associatedId, product);
		}
	}

	public static void syncProvusToProduct2(Set<Id> provusProductIds) {
		ProvusSetup__mdt provusSetup = ProvusSetup__mdt.getInstance('Standard');
		if (provusProductIds.isEmpty() || provusSetup.DisableProductSync__c) {
			return;
		}

		List<Product__c> provusProducts = (List<Product__c>) getSourceRecordsForSync(
			provusProductIds,
			Schema.Product__c.SObjectType
		);
		Map<Id, Product2> associatedProducts = new Map<Id, Product2>();
		Map<Id, Product2> product2sByProvusProductId = new Map<Id, Product2>();
		List<ProvusProductMappingDTO> productFieldMappings = SettingsService.getProvusProductMapping();
		for (Product__c provusProduct : provusProducts) {
			Product2 matchingProduct2 = new Product2(
				Id = provusProduct.StandardProductId__c,
				Name = provusProduct.Name
			);

			for (ProvusProductMappingDTO fieldMapping : productFieldMappings) {
				switch on fieldMapping.name {
					when 'AssociatedProductId' {
						setAssociatedProductId(
							associatedProducts,
							matchingProduct2,
							provusProduct.get(fieldMapping.fieldName)
						);
					}
					when else {
						matchingProduct2.put(
							fieldMapping.product2FieldName,
							provusProduct.get(fieldMapping.fieldName)
						);
					}
				}
			}

			product2sByProvusProductId.put(provusProduct.Id, matchingProduct2);
		}

		CRUDUtility.upsertRecords(product2sByProvusProductId.values());
		updateStandardProductIds(provusProducts, product2sByProvusProductId);
		updateAssociatedProductIds(associatedProducts);
	}

	private static void updateAssociatedProductIds(Map<Id, Product2> associatedProducts) {
		if (associatedProducts.isEmpty()) {
			return;
		}

		List<Product2> updateProducts = new List<Product2>();
		for (Product__c existingProduct : [
			SELECT Id, StandardProductId__c
			FROM Product__c
			WHERE Id IN :associatedProducts.keySet()
			WITH SECURITY_ENFORCED
		]) {
			if (associatedProducts.containsKey(existingProduct.Id)) {
				associatedProducts.get(existingProduct.Id)
					.AssociatedProductId__c = existingProduct.StandardProductId__c;
				updateProducts.add(associatedProducts.get(existingProduct.Id));
			}
		}

		CRUDUtility.upsertRecords(updateProducts);
	}

	private static void updateStandardProductIds(
		List<Product__c> provusProducts,
		Map<Id, Product2> product2sByProvusProductId
	) {
		List<Product__c> updateProducts = new List<Product__c>();
		for (Product__c existingProvusProductSO : provusProducts) {
			Product2 correspondingProduct2SO = product2sByProvusProductId.get(existingProvusProductSO.Id);
			if (String.isBlank(existingProvusProductSO.StandardProductId__c)) {
				existingProvusProductSO.StandardProductId__c = correspondingProduct2SO.Id;
				updateProducts.add(existingProvusProductSO);
			}
		}

		CRUDUtility.upsertRecords(updateProducts);
	}

	public static void runProductSync(List<ProductSyncRequest__e> syncRequests) {
		Set<Id> provusProductIds = new Set<Id>();
		Set<Id> product2Ids = new Set<Id>();
		String nsPrefix = SystemUtility.getNamespacePrefix();
		for (ProductSyncRequest__e syncRequest : syncRequests) {
			if (syncRequest.SourceObjectType__c == ProductSyncRequest.OBJECT_TYPE_PRODUCT2) {
				product2Ids.add(syncRequest.SourceObjectId__c);
			} else if (
				syncRequest.SourceObjectType__c == nsPrefix + ProductSyncRequest.OBJECT_TYPE_PRODUCT
			) {
				provusProductIds.add(syncRequest.SourceObjectId__c);
			}
		}

		//disable sync triggers during commit
		RuntimeContext.isSyncProductMode = true;

		syncProduct2ToProvus(product2Ids);
		syncProvusToProduct2(provusProductIds);

		RuntimeContext.isSyncProductMode = false;
	}

	public static void scheduleSync(List<SObject> productsToSync) {
		List<ProductSyncRequest__e> syncRequests = new List<ProductSyncRequest__e>();
		for (SObject productSO : productsToSync) {
			ProductSyncRequest__e syncRequest = new ProductSyncRequest__e(
				SourceObjectType__c = productSO.Id.getSobjectType() + '',
				SourceObjectId__c = productSO.Id
			);
			syncRequests.add(syncRequest);
		}

		EventBus.publish(syncRequests);
	}

	private static List<SObject> getSourceRecordsForSync(Set<Id> productIds, SObjectType objectType) {
		QueryRequest queryRequest = new QueryRequest(objectType);
		queryRequest.requestedFields = new Set<String>{ 'Id', 'Name' };
		queryRequest.setFilterBy(new Map<String, Set<Id>>{ 'Id' => productIds });

		List<ProvusProductMappingDTO> productFieldMappings = SettingsService.getProvusProductMapping();
		for (ProvusProductMappingDTO productFieldMapping : productFieldMappings) {
			queryRequest.requestedFields.add(
				objectType == Schema.Product__c.sObjectType
					? productFieldMapping.fieldName
					: productFieldMapping.product2FieldName
			);
		}

		if (objectType == Schema.Product__c.sObjectType) {
			queryRequest.requestedFields.add(Schema.Product__c.StandardProductId__c + '');
		}

		return SOQLUtility.querySObject(queryRequest);
	}

	private static Map<Id, Id> getProvusProductsIdsForProduct2s(Set<Id> product2Ids) {
		Map<Id, Id> provusProductIdByProduct2Id = new Map<Id, Id>();
		for (Product__c provusProduct : [
			SELECT Id, StandardProductId__c
			FROM Product__c
			WHERE StandardProductId__c = :product2Ids
			WITH SECURITY_ENFORCED
		]) {
			provusProductIdByProduct2Id.put(provusProduct.StandardProductId__c, provusProduct.Id);
		}

		return provusProductIdByProduct2Id;
	}
}
