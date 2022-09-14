/**
 *  Provus Services Quoting
 *  ServiceRecommendationsControllerTest
 *  @2021 Provus Inc. All rights reserved.
 */
@isTest
public with sharing class ServiceRecommendationsControllerTest extends ServiceRecommendationsTestsBase {
	private static final String PRODUCT_MAIN_PRODUCT = 'Main Product';
	private static final String PRODUCT_SERVICE_PRODUCT = 'Service Product';
	private static final String QUOTE_TEMPLATE_NAME = 'Test Quote Template';

	@testSetup
	static void setup() {
		setupData();
		createProductOpportunityLineItem();
	}

	@isTest
	static void itShouldGetServiceRecommendations() {
		Test.startTest();
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test' LIMIT 1];
		Map<Id, ServiceRecommendationsController.ServiceRecommendation> serviceRecommendations = ServiceRecommendationsController.getServiceRecommendations(
			opp.Id
		);
		System.assertEquals(1, serviceRecommendations.size(), 'There is 1 service recommendation');
		Test.stopTest();
	}

	@isTest
	static void itShouldGetNoServiceRecommendations() {
		Test.startTest();
		Opportunity opp = newOpportunity();
		Map<Id, ServiceRecommendationsController.ServiceRecommendation> serviceRecommendations = ServiceRecommendationsController.getServiceRecommendations(
			opp.Id
		);
		System.assertEquals(0, serviceRecommendations.size(), 'There are no service recommendation');
		Test.stopTest();
	}

	@isTest
	static void itShouldAddServiceRecommendations() {
		Test.startTest();
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test' LIMIT 1];
		Product2 product = [SELECT Id, Name FROM Product2 WHERE Name = :PRODUCT_MAIN_PRODUCT];
		Product2 service = [SELECT Id, Name FROM Product2 WHERE Name = :PRODUCT_SERVICE_PRODUCT];
		ServiceRecommendationsController.ServiceOpportunity serviceOpportunity = ServiceRecommendationsController.addServiceToOpportunity(
			opp.Id,
			service.Id,
			product.Id
		);
		System.assert(serviceOpportunity.success, 'Service recommendation was added successfully');
		Test.stopTest();
	}

	@isTest
	static void itShouldFailServiceRecommendationsForMissingEstimate() {
		Test.startTest();
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test' LIMIT 1];
		Product2 product = [SELECT Id, Name FROM Product2 WHERE Name = :PRODUCT_MAIN_PRODUCT];
		Product2 service = [SELECT Id, Name FROM Product2 WHERE Name = :PRODUCT_SERVICE_PRODUCT];
		Product__c cservice = [
			SELECT Id, Name
			FROM Product__c
			WHERE StandardProductId__c = :service.Id
		];
		Estimate__c estimate = [SELECT Id FROM Estimate__c WHERE ServiceId__c = :cservice.Id LIMIT 1];
		delete estimate;
		// ignore initial setup data
		List<Quote__c> quotes = [SELECT Id FROM Quote__c WHERE ServiceId__c = :cservice.Id];
		delete quotes;
		ServiceRecommendationsController.ServiceOpportunity serviceOpportunity = ServiceRecommendationsController.addServiceToOpportunity(
			opp.Id,
			service.Id,
			product.Id
		);
		System.assert(
			!serviceOpportunity.success,
			'It should have failed to return any service recommendations'
		);
		Test.stopTest();
	}

	@isTest
	static void itShouldGenerateFromEstimateForServiceRecommendations() {
		Test.startTest();
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test' LIMIT 1];
		Product2 product = [SELECT Id, Name FROM Product2 WHERE Name = :PRODUCT_MAIN_PRODUCT];
		Product2 service = [SELECT Id, Name FROM Product2 WHERE Name = :PRODUCT_SERVICE_PRODUCT];
		Product__c cservice = [
			SELECT Id, Name
			FROM Product__c
			WHERE StandardProductId__c = :service.Id
		];
		Estimate__c estimate = [SELECT Id FROM Estimate__c WHERE ServiceId__c = :cservice.Id LIMIT 1];
		Quote__c quote = [SELECT Id FROM Quote__c WHERE EstimateId__c = :estimate.Id LIMIT 1];
		delete quote;
		ServiceRecommendationsController.ServiceOpportunity serviceOpportunity = ServiceRecommendationsController.addServiceToOpportunity(
			opp.Id,
			service.Id,
			product.Id
		);
		System.assert(
			serviceOpportunity.success,
			'It should have created a quote and associated to opportunity for an estimate'
		);
		Test.stopTest();
	}

	@isTest
	static void itShouldGenerateFromUniqueEstimatesForServiceRecommendations() {
		Test.startTest();
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test' LIMIT 1];
		Product2 product = [SELECT Id, Name FROM Product2 WHERE Name = :PRODUCT_MAIN_PRODUCT];
		Product2 service = [SELECT Id, Name FROM Product2 WHERE Name = :PRODUCT_SERVICE_PRODUCT];
		ServiceRecommendationsController.ServiceOpportunity serviceOpportunity = ServiceRecommendationsController.addServiceToOpportunity(
			opp.Id,
			service.Id,
			product.Id
		);

		Opportunity opp2 = newOpportunity();
		opp2.Name = 'Test2';
		update opp2;
		ServiceRecommendationsController.ServiceOpportunity serviceOpportunity2 = ServiceRecommendationsController.addServiceToOpportunity(
			opp2.Id,
			service.Id,
			product.Id
		);

		Quote__c quoteSO1 = [
			SELECT Id
			FROM Quote__c
			WHERE OpportunityId__c = :opp.Id AND ServiceId__r.StandardProductId__c = :service.Id
			LIMIT 1
		];
		Quote__c quoteSO2 = [
			SELECT Id
			FROM Quote__c
			WHERE OpportunityId__c = :opp2.Id AND ServiceId__r.StandardProductId__c = :service.Id
			LIMIT 1
		];
		System.assertNotEquals(quoteSO1.Id, quoteSO2.Id, 'Quotes should be unique from each other');

		Test.stopTest();
	}
}
