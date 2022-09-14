/**
 *  Provus Services Quoting
 *  RateCardServiceTest
 *  @2021 Provus Inc. All rights reserved.
 */
@isTest
private class RateCardServiceTest extends TestBase {
	@testSetup
	static void setup() {
		RateCardAttributeGroup__c rateCardAttributeGroup = newRateCardAttributeGroup();
		newRateCardAttribute(rateCardAttributeGroup.Id); // create attribute and related it to attribute group
		RateCard__c rateCard = newRateCard();
		rateCard.AttributeGroupId__c = rateCardAttributeGroup.Id;
		update rateCard;
	}

	@IsTest
	static void itShouldGetRateCard() {
		Test.startTest();
		RateCard__c rateCardSO = [
			SELECT Id
			FROM RateCard__c
			WHERE Name = 'Skill & Resource Location'
			LIMIT 1
		];
		RateCardService rateCardService = new RateCardService(rateCardSO.Id);
		System.assertNotEquals(rateCardService, null, 'should not be null');
		Test.stopTest();
	}

	@IsTest
	static void itShouldGetRateCardAttributes() {
		Test.startTest();
		RateCard__c rateCardSO = [
			SELECT Id
			FROM RateCard__c
			WHERE Name = 'Skill & Resource Location'
			WITH SECURITY_ENFORCED
			LIMIT 1
		];
		RateCardService rateCardService = new RateCardService(rateCardSO.Id);
		Set<String> attributes = rateCardService.getAttributes();
		System.assert(
			attributes.contains(Schema.RateCardItem__c.SkillLevel__c + ''),
			'should contain skill level as an attribute'
		);
		Test.stopTest();
	}

	@IsTest
	static void itShouldGetRateCardWithSequence() {
		Test.startTest();
		RateCard__c rateCardSO = [
			SELECT Id
			FROM RateCard__c
			WHERE Name = 'Skill & Resource Location'
			LIMIT 1
		];
		RateCardService rateCardService = new RateCardService(rateCardSO.Id);
		Map<String, Decimal> attributesWithSequence = rateCardService.getAttributesWithSequence();
		System.assertEquals(
			attributesWithSequence.get(Schema.RateCardItem__c.SkillLevel__c + ''),
			1,
			'should be the first attribute'
		);
		Test.stopTest();
	}

	@IsTest
	static void itShouldcheckIfRateCardIsExpired() {
		Test.startTest();
		RateCard__c rateCardSO = [
			SELECT Id
			FROM RateCard__c
			WHERE Name = 'Skill & Resource Location'
			LIMIT 1
		];

		Quote__c quoteSO = newQuote();
		quoteSO.RateCardId__c = rateCardSO.Id;
		Map<Boolean, String> rateCardStatusMap = RateCardService.checkIfRateCardIsExpired(quoteSO.Id);
		System.assertEquals(rateCardStatusMap.size(), 1, 'size should be one');
		Test.stopTest();
	}

	@IsTest
	static void itShouldReturnFiltersForRateCard() {
		RateCard__c rateCardSO = newRateCard();
		RateCardAttributeGroup__c testAtributeGroup = newRateCardAttributeGroup();
		RateCardAttribute__c testAttribute = newRateCardAttribute(testAtributeGroup.Id);
		String skillLevelAPIName = Schema.RateCardItem__c.SkillLevel__c + '';

		RateCardAttributeOption__c attributeOption = new RateCardAttributeOption__c(
			RateCardAttributeOptionKey__c = 'TestKey',
			TextValue__c = 'Some Option',
			AttributeGroupId__c = testAtributeGroup.Id,
			RateCardAttributeId__c = testAttribute.Id,
			RateCardId__c = rateCardSO.Id
		);
		insert attributeOption;

		List<SObjectUtility.SObjectFieldInfo> rateCardItemFields = SObjectUtility.getSObjectFields(
			new Map<Schema.SObjectType, Set<String>>{
				RateCardItem__c.SObjectType => new Set<String>{ skillLevelAPIName }
			}
		);
		SObjectUtility.SObjectFieldInfo skillLevelFieldInfo = rateCardItemFields[0];

		Test.startTest();
		List<RateCardAttributeOptionDto> rateCardAttributeOptions = RateCardService.getRateCardFilters(
			rateCardSO.Id
		);
		System.assertEquals(rateCardAttributeOptions.size(), 1, 'should return 1 attribute option');
		System.assertEquals(
			rateCardAttributeOptions[0].name,
			skillLevelAPIName,
			'the api name should match'
		);
		System.assertEquals(
			rateCardAttributeOptions[0].label,
			skillLevelFieldInfo.fieldLabel,
			'the field label should match'
		);
		System.assertEquals(rateCardAttributeOptions[0].options.size(), 1, 'it should have one option');
		System.assertEquals(
			rateCardAttributeOptions[0].options[0],
			attributeOption.TextValue__c,
			'the option should match'
		);
		Test.stopTest();
	}

	static void itShouldNotReturnFiltersForRateCard() {
		RateCard__c rateCardSO = newRateCard();

		Test.startTest();
		List<RateCardAttributeOptionDto> rateCardAttributeOptions = RateCardService.getRateCardFilters(
			rateCardSO.Id
		);
		System.assertEquals(rateCardAttributeOptions.size(), 0, 'should return empty array');
		Test.stopTest();
	}
}
