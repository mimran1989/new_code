/**
 *  Provus Services Quoting
 *  SyncProductServiceTests
 *  @2022 Provus Inc. All rights reserved.
 */

@isTest
public with sharing class SyncProductServiceTests extends TestBase {
	static List<Product2> setupProduct2s() {
		List<Product2> product2s = new List<Product2>();
		for (integer i = 0; i < 5; i++) {
			Product2 product = new Product2(
				Name = 'SyncTest: Product2 ' + i,
				ProductCode = 'ST00' + i,
				IsActive = true
			);
			product2s.add(product);
		}
		CRUDUtility.insertRecords(product2s);
		return product2s;
	}

	static List<Product__c> setupProducts() {
		List<Product__c> products = new List<Product__c>();
		for (integer i = 0; i < 5; i++) {
			Product__c product = new Product__c(
				Name = 'SyncTest: Product__c ' + i,
				ProductCode__c = 'STP00' + i,
				IsActive__c = true
			);
			products.add(product);
		}
		CRUDUtility.insertRecords(products);
		return products;
	}

	@isTest
	static void isAdditionalProduct2Synced() {
		setupProduct2s();
		Test.startTest();
		Map<Id, Product2> product2s = new Map<Id, Product2>(
			[SELECT Id, Name FROM Product2 WHERE Name LIKE 'SyncTest: Product2%' LIMIT 5]
		);

		SyncProductService.syncProduct2ToProvus(product2s.keySet());
		List<Product__c> products = [
			SELECT Id, Name
			FROM Product__c
			WHERE StandardProductId__c IN :product2s.keySet()
		];
		System.assertEquals(5, product2s.size(), 'expect to have 5 product2s');
		System.assertEquals(5, products.size(), 'expect to have 5 products');

		Product2 product = new Product2(
			Name = 'SyncTest: Product2 6',
			ProductCode = 'ST006',
			IsActive = true
		);

		CRUDUtility.insertRecords(product);
		product2s = new Map<Id, Product2>(
			[SELECT Id, Name FROM Product2 WHERE Name LIKE 'SyncTest: Product2%' LIMIT 6]
		);

		SyncProductService.syncProduct2ToProvus(product2s.keySet());
		products = [SELECT Id, Name FROM Product__c WHERE StandardProductId__c IN :product2s.keySet()];
		System.assertEquals(6, product2s.size(), 'expect to have 6 product2s');
		System.assertEquals(6, products.size(), 'expect to have 6 products');
		Test.stopTest();
	}

	@isTest
	static void itShouldAddProvusProductRecords() {
		setupProduct2s();
		Test.startTest();
		Map<Id, Product2> product2s = new Map<Id, Product2>(
			[SELECT Id, Name FROM Product2 WHERE Name LIKE 'SyncTest: Product2%' LIMIT 5]
		);
		System.assertEquals(5, product2s.size(), 'expected to have 5 product2s');
		SyncProductService.syncProduct2ToProvus(product2s.keySet());
		List<Product__c> products = [
			SELECT Id, Name, AssociatedProductId__c
			FROM Product__c
			WHERE StandardProductId__c IN :product2s.keySet()
			ORDER BY Name
		];

		System.assertEquals(5, products.size(), 'expected to have 5 products');
		System.assertEquals(5, products.size(), 'expected to have 5 products');
		Test.stopTest();
	}

	@isTest
	static void itShouldAddProvusProductRecordsWithAssociatedProduct() {
		List<Product2> product2s = setupProduct2s();
		List<Product2> associatedProduct2s = new List<Product2>();
		for (integer i = 0; i < 5; i++) {
			Product2 product = new Product2(
				Name = 'SyncTest: Product2 Service' + i,
				ProductCode = 'ST00' + i,
				IsActive = true,
				AssociatedProductId__c = product2s[i].Id
			);
			associatedProduct2s.add(product);
		}
		CRUDUtility.insertRecords(associatedProduct2s);

		Test.startTest();
		Map<Id, Product2> product2sById = new Map<Id, Product2>(
			[SELECT Id, Name FROM Product2 WHERE Name LIKE 'SyncTest: Product2%' LIMIT 10]
		);
		SyncProductService.syncProduct2ToProvus(product2sById.keySet());
		List<Product__c> products = [
			SELECT Id, Name, AssociatedProductId__c
			FROM Product__c
			WHERE StandardProductId__c IN :product2sById.keySet()
			ORDER BY Name
		];

		System.assertEquals(10, product2sById.size(), 'expected to have 10 product2s');
		System.assertEquals(10, products.size(), 'expected to have 10 products');
		System.assertEquals(
			null,
			products[0].AssociatedProductId__c,
			'not expected associated productid'
		);
		System.assertNotEquals(
			null,
			products[5].AssociatedProductId__c,
			'expected associated productid'
		);
		Test.stopTest();
	}

	@isTest
	static void isShouldAddProduct2s() {
		setupProducts();
		Test.startTest();
		Map<Id, Product__c> products = new Map<Id, Product__c>(
			[SELECT Id, Name FROM Product__c WHERE Name LIKE 'SyncTest: Product__c%' LIMIT 5]
		);

		SyncProductService.syncProvusToProduct2(products.keySet());
		List<String> externalIds = new List<String>();
		for (Product__c product : [
			SELECT Id, Name, StandardProductId__c
			FROM Product__c
			WHERE Name LIKE 'SyncTest: Product__c%'
			LIMIT 10
		]) {
			externalIds.add(product.StandardProductId__c);
		}

		List<Product2> product2s = [
			SELECT Id, Name, AssociatedProductId__c
			FROM Product2
			WHERE Id IN :externalIds
		];
		System.assertEquals(5, product2s.size(), 'expect to have 5 product2s');
		System.assertEquals(5, products.size(), 'expect to have 5 products');

		Product__c newProduct = new Product__c(
			Name = 'SyncTest: Product__c 6',
			ProductCode__c = 'STP006',
			IsActive__c = true
		);
		CRUDUtility.insertRecords(newProduct);
		products = new Map<Id, Product__c>(
			[SELECT Id, Name FROM Product__c WHERE Name LIKE 'SyncTest: Product__c%' LIMIT 6]
		);

		SyncProductService.syncProvusToProduct2(products.keySet());
		for (Product__c product : [
			SELECT Id, Name, StandardProductId__c
			FROM Product__c
			WHERE Name LIKE 'SyncTest: Product__c%'
			LIMIT 11
		]) {
			externalIds.add(product.StandardProductId__c);
		}
		product2s = [SELECT Id, Name FROM Product2 WHERE Id IN :externalIds];
		System.assertEquals(6, product2s.size(), 'expect to have 6 product2s');
		System.assertEquals(6, products.size(), 'expect to have 6 products');
		Test.stopTest();
	}

	@isTest
	static void itShouldAddProduct2RecordsWithAssociatedProduct() {
		List<Product__c> products = setupProducts();
		List<Product__c> associatedProducts = new List<Product__c>();
		for (integer i = 0; i < 5; i++) {
			Product__c product = new Product__c(
				Name = 'SyncTest: Product__c Service' + i,
				ProductCode__c = 'STP00' + i,
				IsActive__c = true,
				AssociatedProductId__c = products[i].Id
			);
			associatedProducts.add(product);
		}
		CRUDUtility.insertRecords(associatedProducts);

		Test.startTest();
		Map<Id, Product__c> productsById = new Map<Id, Product__c>(
			[SELECT Id, Name FROM Product__c WHERE Name LIKE 'SyncTest: Product__c%' LIMIT 10]
		);
		System.assertEquals(10, productsById.size(), 'expected to have 10 products');
		SyncProductService.syncProvusToProduct2(productsById.keySet());
		List<String> externalIds = new List<String>();
		for (Product__c product : [
			SELECT Id, Name, StandardProductId__c
			FROM Product__c
			WHERE Name LIKE 'SyncTest: Product__c%'
			LIMIT 10
		]) {
			externalIds.add(product.StandardProductId__c);
		}
		List<Product2> product2s = [
			SELECT Id, Name, AssociatedProductId__c
			FROM Product2
			WHERE Id IN :externalIds
		];

		System.assertEquals(10, productsById.size(), 'expected to have 10 products');
		System.assertEquals(10, product2s.size(), 'expected to have 10 product2s');
		System.assertEquals(
			null,
			product2s[0].AssociatedProductId__c,
			'not expected associated productid'
		);
		System.assertNotEquals(
			null,
			product2s[5].AssociatedProductId__c,
			'expected associated productid'
		);
		Test.stopTest();
	}
}
