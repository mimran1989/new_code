/**
 *  Provus Services Quoting
 *  ProductServiceTest
 *  @2021 Provus Inc. All rights reserved.
 */
@isTest
private class ProductServiceTest extends TestBase {
	@testSetup
	static void setup() {
		Id resourceRoleTypeId = SObjectUtility.getRecordTypeIdbyName(
			Schema.SObjectType.Product__c.getName(),
			'Resource Role'
		);
		Product__c product = new Product__c(
			Name = 'SLA: Silver',
			ProductCode__c = 'SL9040',
			IsActive__c = true,
			RecordTypeId = resourceRoleTypeId
		);
		CRUDUtility.insertRecords(product);

		RateCard__c rateCard = newRateCard();
		newRateCardItem(rateCard.Id, product.Id);

		Quote__c quote = newQuote();
		quote.Name = 'Product Service Test';
		quote.RateCardId__c = rateCard.Id;
		CRUDUtility.updateRecords(quote);
	}

	@isTest
	static void itShouldGetProductsFromQuote() {
		Test.startTest();
		Quote__c quote = [SELECT Id FROM Quote__c WHERE Name = 'Product Service Test' LIMIT 1];
		Set<ProductService.ProductStruct> products = ProductService.getAllProductsForQuote(quote.Id);
		System.assertEquals(1, products.size(), 'expect to have 1 product');
		Test.stopTest();
	}

	@isTest
	static void itShouldGetProductsFromRateCardItems() {
		Test.startTest();
		List<RateCardItem__c> rateCardItemList = [
			SELECT Id, Name, ProductId__r.Id, ProductId__r.Name
			FROM RateCardItem__c
			WHERE ProductId__r.Name = 'SLA: Silver'
		];
		Set<Product__c> products = ProductService.getProductsFromRateCardItems(rateCardItemList);
		System.assertEquals(1, products.size(), 'expect to have 1 product');
		Test.stopTest();
	}
}
