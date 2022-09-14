/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
@IsTest
private class ResourceDefaultServiceTest extends TestBase {
	@IsTest
	static void shouldReturnMappedRateCardItems() {
		Id resourceRoleTypeId = SObjectUtility.getRecordTypeIdbyName(
			Schema.SObjectType.Product__c.getName(),
			'Resource Role'
		);

		Product__c productSo = newProduct('Software Engineer', resourceRoleTypeId);
		CRUDUtility.insertRecords(new List<Product__c>{ productSo });

		RateCard__c rateCard = newRateCard();
		RateCardItem__c rateCardItem = newRateCardItem(rateCard.Id, productSo.Id);
		rateCardItem.SkillLevel__c = 'L1';
		rateCardItem.LocationCountry__c = 'United States';
		rateCardItem.LocationStateProvince__c = 'California';
		rateCardItem.LocationCity__c = 'San Jose';
		CRUDUtility.updateRecords(rateCardItem);

		EstimateTemplate__c templateSo = EstimateTemplateTestBase.newEstimateTemplate();
		templateSo.RateCardId__c = rateCard.Id;
		CRUDUtility.updateRecords(templateSo);

		ResourceDefault__c resourceDefaultSo = ResourceDefaultTestBase.newResourceDefault(
			productSo.Id,
			rateCardItem.Id
		);

		resourceDefaultSo.EstimateTemplateId__c = templateSo.Id;

		CRUDUtility.updateRecords(new List<ResourceDefault__c>{ resourceDefaultSo });

		Test.startTest();
		{
			Map<Id, Id> rateCardItemIdByRoleId = ResourceDefaultService.getRateCardItemIdByRoleId(
				templateSo.Id
			);
			System.assertEquals(
				rateCardItem.Id,
				rateCardItemIdByRoleId.get(productSo.Id),
				'should have the matching rate card item id'
			);
		}
		Test.stopTest();
	}
}
