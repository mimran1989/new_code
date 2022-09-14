/**
 *  Provus Services Quoting
 *  RateCardItemTriggersTest
 *  @2022 Provus Inc. All rights reserved.
 */

@isTest
private class RateCardItemTriggersTest extends TestBase {
	@isTest
	static void itShouldCreateRateCardAttributeOptionsForRateCards() {
		RateCard__c testRateCard1 = newRateCard();
		RateCard__c testRateCard2 = newRateCard();

		RateCardAttributeGroup__c testAttributeGroup = newRateCardAttributeGroup();
		testRateCard1.AttributeGroupId__c = testAttributeGroup.Id;
		testRateCard2.AttributeGroupId__c = testAttributeGroup.Id;
		update new List<RateCard__c>{ testRateCard1, testRateCard2 };

		RateCardAttribute__c testAttribute = newRateCardAttribute(testAttributeGroup.Id);

		Product__c testProduct = newProduct('Test Resource', 'Resource Role');
		RateCardItem__c testRateCardItem1 = new RateCardItem__c(
			IsActive__c = true,
			RateCardId__c = testRateCard1.Id,
			ProductId__c = testProduct.Id,
			SkillLevel__c = 'L1'
		);
		RateCardItem__c testRateCardItem2 = new RateCardItem__c(
			IsActive__c = true,
			RateCardId__c = testRateCard2.Id,
			ProductId__c = testProduct.Id,
			SkillLevel__c = 'L2'
		);

		Test.startTest();
		insert new List<RateCardItem__c>{ testRateCardItem1, testRateCardItem2 };
		List<RateCardAttributeOption__c> optionsForRateCard1 = [
			SELECT
				Id,
				RateCardAttributeOptionKey__c,
				TextValue__c,
				AttributeGroupId__c,
				RateCardAttributeId__c,
				(SELECT RateCardItemAttributeKey__c, RateCardItemId__c FROM RateCardItemAttributeOptions__r)
			FROM RateCardAttributeOption__c
			WHERE RateCardId__c = :testRateCard1.Id
		];

		List<RateCardAttributeOption__c> optionsForRateCard2 = [
			SELECT
				Id,
				RateCardAttributeOptionKey__c,
				TextValue__c,
				AttributeGroupId__c,
				RateCardAttributeId__c,
				(SELECT RateCardItemAttributeKey__c, RateCardItemId__c FROM RateCardItemAttributeOptions__r)
			FROM RateCardAttributeOption__c
			WHERE RateCardId__c = :testRateCard2.Id
		];

		System.assertEquals(
			optionsForRateCard1[0].RateCardAttributeId__c,
			testAttribute.Id,
			'should have the right attribute associated'
		);
		System.assertEquals(
			optionsForRateCard2[0].RateCardAttributeId__c,
			testAttribute.Id,
			'should have the right attribute associated'
		);

		System.assertEquals(
			optionsForRateCard1[0].TextValue__c,
			testRateCardItem1.SkillLevel__c,
			'text value should match'
		);
		System.assertEquals(
			optionsForRateCard2[0].TextValue__c,
			testRateCardItem2.SkillLevel__c,
			'text value should match'
		);
	}

	@isTest
	static void itShouldNotCreateAttributeOptionsWhenRateCardAttributesAreNotDefined() {
		RateCard__c testRateCard = newRateCard();
		RateCardAttributeGroup__c testAttributeGroup = newRateCardAttributeGroup();
		testRateCard.AttributeGroupId__c = testAttributeGroup.Id;
		update testRateCard;

		Product__c testProduct = newProduct('Test Resource', 'Resource Role');
		RateCardItem__c testRateCardItem = new RateCardItem__c(
			IsActive__c = true,
			RateCardId__c = testRateCard.Id,
			ProductId__c = testProduct.Id,
			SkillLevel__c = 'L1'
		);

		Test.startTest();
		insert testRateCardItem;
		List<RateCardAttributeOption__c> optionsForRateCard = [
			SELECT
				Id,
				RateCardAttributeOptionKey__c,
				TextValue__c,
				AttributeGroupId__c,
				RateCardAttributeId__c,
				(SELECT RateCardItemAttributeKey__c, RateCardItemId__c FROM RateCardItemAttributeOptions__r)
			FROM RateCardAttributeOption__c
			WHERE RateCardId__c = :testRateCard.Id
		];

		System.assertEquals(optionsForRateCard.size(), 0, 'should not create attribute options');
	}
}
