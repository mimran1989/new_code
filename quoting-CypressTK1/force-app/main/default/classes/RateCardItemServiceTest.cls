/**
 *  Provus Services Quoting
 *  RateCardItemServiceTest
 *  @2021 Provus Inc. All rights reserved.
 */

@isTest
private class RateCardItemServiceTest extends TestBase {
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
		quote.Name = 'Rate Card Item Service Test';
		quote.RateCardId__c = rateCard.Id;
		CRUDUtility.updateRecords(quote);
	}

	@isTest
	static void itShouldGetProductsFromQuote() {
		Test.startTest();
		Quote__c quote = [SELECT Id FROM Quote__c WHERE Name = 'Rate Card Item Service Test' LIMIT 1];
		List<RateCardItem__c> rateCardItems = RateCardItemService.getRateCardItemsProducts(quote.Id);
		System.assertEquals(1, rateCardItems.size(), 'expect to have 1 product');
		Test.stopTest();
	}

	@isTest
	static void itShouldGetRateCardItemForProduct() {
		Test.startTest();
		Quote__c quote = [SELECT Id FROM Quote__c WHERE Name = 'Rate Card Item Service Test' LIMIT 1];
		Product__c prod = [SELECT Id FROM Product__c WHERE Name = 'SLA: Silver' LIMIT 1];
		List<RateCardItemService.RateCardItemStruct> rateCardItems = RateCardItemService.getAllRateCardItemsForProduct(
			quote.Id,
			prod.Id
		);
		System.assertEquals(1, rateCardItems.size(), 'expect to have 1 product');
		Test.stopTest();
	}

	@isTest
	static void itShouldGetRateCardItem() {
		Test.startTest();
		RateCard__c rateCard = [
			SELECT Id
			FROM RateCard__c
			WHERE Name = 'Skill & Resource Location'
			LIMIT 1
		];
		Product__c prod = [SELECT Id FROM Product__c WHERE Name = 'SLA: Silver' LIMIT 1];
		List<RateCardItem__c> rateCardItems = RateCardItemService.getRateCardItems(
			rateCard.Id,
			new Set<Id>{ prod.Id }
		);
		System.assertEquals(1, rateCardItems.size(), 'expect to have 1 product');
		Test.stopTest();
	}
}
