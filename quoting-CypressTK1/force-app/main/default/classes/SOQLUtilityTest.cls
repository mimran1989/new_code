/**
 *  Provus Services Quoting
 *  SOQLUtilityTest
 *  @2021 Provus Inc. All rights reserved.
 */
@IsTest
public with sharing class SOQLUtilityTest extends TestBase {
	private static Set<String> requestedFields = new Set<String>{
		SObjectUtility.FIELD_ID,
		SObjectUtility.FIELD_NAME,
		Schema.Product__c.Practice__c + '',
		Schema.Product__c.Group__c + ''
	};

	@TestSetup
	static void setup() {
		Id productTypeId = SObjectUtility.getRecordTypeIdbyName(
			Schema.SObjectType.Product__c.getName(),
			'Product'
		);
		List<Product__c> products = new List<Product__c>{
			newProduct('Product #1', productTypeId),
			newProduct('Product #2', productTypeId),
			newProduct('Product #3', productTypeId),
			newProduct('Product #4', productTypeId),
			newProduct('Product #5', productTypeId)
		};
		CRUDUtility.insertRecords(products);
		/* price book
		Pricebook2 pricebook = newPriceBook();
		Id standardPricebookId = Test.getStandardPricebookId();
		List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
		for (Product__c productSO : products) {
			pricebookEntries.add(newPricebookEntry(standardPricebookId, productSO.Id));
			pricebookEntries.add(newPricebookEntry(pricebook.Id, productSO.Id));
		}
		CRUDUtility.insertRecords(pricebookEntries);*/
	}

	@IsTest
	static void itShouldRetrieveList() {
		Test.startTest();
		QueryRequest queryRequest = new QueryRequest(Schema.SObjectType.Product__c.getName());
		queryRequest.requestedFields = requestedFields;
		List<Product__c> resultSet = SOQLUtility.querySObject(queryRequest);
		System.assertEquals(5, resultSet.size(), 'We should have 5 products');
		Test.stopTest();
	}

	@IsTest
	static void itShouldRetrieveListWithInnerQuery() {
		Test.startTest();
		QueryRequest queryRequest = new QueryRequest(Schema.SObjectType.Product__c.getName());
		queryRequest.requestedFields = requestedFields;
		/* List<QueryRequest> innerQueries = new List<QueryRequest>();
		PricebookEntries is the child relationship name
		QueryRequest innerQueryRequest = new QueryRequest('PricebookEntries');
		innerQueryRequest.requestedFields = new Set<String>{ Schema.PricebookEntry.UnitPrice + '' };
		innerQueries.add(innerQueryRequest);
		queryRequest.innerQueries = innerQueries;*/
		List<Product__c> resultSet = SOQLUtility.querySObject(queryRequest);
		System.assertEquals(5, resultSet.size(), 'We should have 5 products');
		Test.stopTest();
	}

	@IsTest
	static void itShouldRetrieveListWithLimit() {
		Test.startTest();
		QueryRequest queryRequest = new QueryRequest(Schema.SObjectType.Product__c.getName());
		queryRequest.requestedFields = requestedFields;
		queryRequest.querySize = 2;
		List<Product__c> resultSet = SOQLUtility.querySObject(queryRequest);
		System.assertEquals(2, resultSet.size(), 'We should have 2 products');
		Test.stopTest();
	}

	@IsTest
	static void itShouldRetrieveListWithNullOrderByValue() {
		Test.startTest();
		QueryRequest queryRequest = new QueryRequest(Schema.SObjectType.Product__c.getName());
		queryRequest.requestedFields = requestedFields;
		queryRequest.fieldBySortOrder = new Map<String, String>{ SObjectUtility.FIELD_NAME => null };
		List<Product__c> resultSet = SOQLUtility.querySObject(queryRequest);
		System.assertEquals('Product #1', resultSet[0].Name, 'Product 1 should be the first product');
		Test.stopTest();
	}

	@IsTest
	static void itShouldRetrieveListWithOrderByAsc() {
		Test.startTest();
		QueryRequest queryRequest = new QueryRequest(Schema.SObjectType.Product__c.getName());
		queryRequest.requestedFields = requestedFields;
		queryRequest.fieldBySortOrder = new Map<String, String>{
			SObjectUtility.FIELD_NAME => SOQLConstants.SORT_ASC
		};
		List<Product__c> resultSet = SOQLUtility.querySObject(queryRequest);
		System.assertEquals('Product #1', resultSet[0].Name, 'Product 1 should be the first product');
		Test.stopTest();
	}

	@IsTest
	static void itShouldRetrieveListWithOrderByDesc() {
		Test.startTest();
		QueryRequest queryRequest = new QueryRequest(Schema.SObjectType.Product__c.getName());
		queryRequest.requestedFields = requestedFields;
		queryRequest.fieldBySortOrder = new Map<String, String>{
			SObjectUtility.FIELD_NAME => SOQLConstants.SORT_DESC
		};
		List<Product__c> resultSet = SOQLUtility.querySObject(queryRequest);
		System.assertEquals('Product #5', resultSet[0].Name, 'Product 5 should be the first product');
		Test.stopTest();
	}

	@IsTest
	static void itShouldRetrieveListWithSingleFilter() {
		Test.startTest();
		QueryRequest queryRequest = new QueryRequest(Schema.SObjectType.Product__c.getName());
		queryRequest.requestedFields = requestedFields;
		queryRequest.setFilterBy(new Map<String, String>{ SObjectUtility.FIELD_NAME => 'Product #3' });
		List<Product__c> resultSet = SOQLUtility.querySObject(queryRequest);
		System.assertEquals('Product #3', resultSet[0].Name, 'Name should be Product #3');
		Test.stopTest();
	}

	@IsTest
	static void itShouldRetrieveListWithSingleFilterNullCheck() {
		Test.startTest();
		QueryRequest queryRequest = new QueryRequest(Schema.SObjectType.Product__c.getName());
		queryRequest.requestedFields = requestedFields;
		queryRequest.setFilterBy(
			new Map<String, String>{ Schema.Product__c.ProductCode__c + '' => null }
		);
		List<Product__c> resultSet = SOQLUtility.querySObject(queryRequest);
		System.assertEquals(5, resultSet.size(), 'We should have 5 products');
		Test.stopTest();
	}

	@IsTest
	static void itShouldRetrieveListWithSetFilter() {
		Test.startTest();
		Map<Id, Product__c> productsByIds = new Map<Id, Product__c>(
			[SELECT Id, Name FROM Product__c WHERE Name = 'Product #1' OR Name = 'Product #2']
		);
		QueryRequest queryRequest = new QueryRequest(Schema.SObjectType.Product__c.getName());
		queryRequest.requestedFields = requestedFields;
		queryRequest.setFilterBy(
			new Map<String, Set<Id>>{ SObjectUtility.FIELD_ID => productsByIds.keySet() }
		);
		List<Product__c> resultSet = SOQLUtility.querySObject(queryRequest);
		System.assertEquals(2, resultSet.size(), 'We should have 2 products');
		System.assertEquals('Product #1', resultSet[0].Name, 'Name should be Product #1');
		System.assertEquals('Product #2', resultSet[1].Name, 'Name should be Product #2');
		Test.stopTest();
	}
}
