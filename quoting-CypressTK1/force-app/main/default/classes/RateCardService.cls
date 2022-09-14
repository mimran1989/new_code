/**
 *  Provus Services Quoting
 *  RateCardService
 *  @2021-2022 Provus Inc. All rights reserved.
 */
public with sharing class RateCardService {
	// constants
	public static final String SOBJECT_NAME = 'RateCard__c';

	// runtime context
	public static RateCard__c rateCardSO;

	// constructor
	public RateCardService(Id rateCardId) {
		rateCardSO = [
			SELECT Id, AttributeGroupId__c
			FROM RateCard__c
			WHERE Id = :rateCardId
			WITH SECURITY_ENFORCED
			LIMIT 1
		];
	}

	public static Map<Id, Id> getAttributeGroupIdsForRateCards(Set<Id> rateCardIds) {
		Map<Id, Id> rateCardToAttributeGroupId = new Map<Id, Id>();
		for (RateCard__c ctxRateCard : [
			SELECT AttributeGroupId__c
			FROM RateCard__c
			WHERE Id = :rateCardIds
			WITH SECURITY_ENFORCED
		]) {
			rateCardToAttributeGroupId.put(ctxRateCard.Id, ctxRateCard.AttributeGroupId__c);
		}
		return rateCardToAttributeGroupId;
	}

	/**
	 * Gets the list of attributes for a rate card
	 * @param
	 * @return Set<String>  list of attributes
	 */
	@AuraEnabled(cacheable=true)
	public static List<String> getAttributesFor(Id rateCardId) {
		Set<String> attributes = new Set<String>();
		for (RateCardAttribute__c att : [
			SELECT FieldAPIName__c, Sequence__c, AttributeGroupId__c
			FROM RateCardAttribute__c
			WHERE
				AttributeGroupId__c IN (SELECT AttributeGroupId__c FROM RateCard__c WHERE Id = :rateCardId)
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c ASC
		]) {
			attributes.add(att.FieldAPIName__c);
		}
		return new List<String>(attributes);
	}

	/**
	 * Gets the list of attributes for a rate card
	 * @param
	 * @return Set<String>  list of attributes
	 */
	public Set<String> getAttributes() {
		Set<String> attributes = new Set<String>();
		for (RateCardAttribute__c att : [
			SELECT FieldAPIName__c, Sequence__c, AttributeGroupId__c
			FROM RateCardAttribute__c
			WHERE AttributeGroupId__c = :rateCardSO.AttributeGroupId__c
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c ASC
		]) {
			attributes.add(att.FieldAPIName__c);
		}
		return attributes;
	}

	/**
	 * Gets the list of attributes for a rate card with their sequence
	 * @param
	 * @return Map<String, Decimal>  list of attributes
	 */
	public Map<String, Decimal> getAttributesWithSequence() {
		Map<String, Decimal> attributesWithSequence = new Map<String, Decimal>();
		for (RateCardAttribute__c att : [
			SELECT FieldAPIName__c, Sequence__c, AttributeGroupId__c
			FROM RateCardAttribute__c
			WHERE AttributeGroupId__c = :rateCardSO.AttributeGroupId__c
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c ASC
		]) {
			attributesWithSequence.put(att.FieldAPIName__c, att.Sequence__c);
		}
		return attributesWithSequence;
	}

	/**
	 * Checks if the rate card associated with a quote is expired or not
	 * @param
	 * @return Boolean true, if ratecard expired else false
	 */
	@AuraEnabled(cacheable=true)
	public static Map<Boolean, String> checkIfRateCardIsExpired(Id quoteId) {
		Map<Boolean, String> rateCardStatusMap = new Map<Boolean, String>();
		Boolean isExpired = true;
		Boolean isValidEffectiveDate;
		Boolean isValidExpirationDate;
		Boolean isActive;
		for (Quote__c quote : [
			SELECT
				Id,
				RateCardId__r.Name,
				AccountId__r.Name,
				RateCardId__r.EffectiveDate__c,
				RateCardId__r.ExpirationDate__c,
				RateCardId__r.IsActive__c,
				ServiceStartDate__c
			FROM Quote__c
			WHERE ID = :quoteId
			WITH SECURITY_ENFORCED
		]) {
			isValidEffectiveDate =
				quote.RateCardId__r.EffectiveDate__c == null ||
				quote.ServiceStartDate__c >= quote.RateCardId__r.EffectiveDate__c;
			isValidExpirationDate =
				quote.RateCardId__r.EffectiveDate__c == null ||
				quote.ServiceStartDate__c <= quote.RateCardId__r.ExpirationDate__c;
			isActive =
				quote.RateCardId__r.IsActive__c && quote.RateCardId__r.ExpirationDate__c >= Date.Today();
			isExpired = !(isValidEffectiveDate && isValidExpirationDate && isActive);
			rateCardStatusMap.put(isExpired, quote.AccountId__r.Name);
		}
		return rateCardStatusMap;
	}

	/**
	 * Get the list of selectable rate card attribute options
	 * @return Set<String>  list of selectable rate card attribute options
	 */
	public static List<RateCardAttributeOptionDto> getRateCardFilters(Id rateCardId) {
		Set<String> attributeAPINames = new Set<String>();

		List<RateCardAttributeOption__c> attributeOptionsForRateCard = [
			SELECT Id, AttributeAPIName__c, TextValue__c
			FROM RateCardAttributeOption__c
			WHERE RateCardId__c = :rateCardId
			WITH SECURITY_ENFORCED
		];

		if (attributeOptionsForRateCard.isEmpty()) {
			return new List<RateCardAttributeOptionDto>();
		}

		for (RateCardAttributeOption__c attributeOption : attributeOptionsForRateCard) {
			attributeAPINames.add(attributeOption.AttributeAPIName__c);
		}

		Map<String, String> fieldLabelsByName = new Map<String, String>();
		for (
			SObjectUtility.SObjectFieldInfo fieldInfo : SObjectUtility.getSObjectFields(
				new Map<Schema.SObjectType, Set<String>>{ RateCardItem__c.SObjectType => attributeAPINames }
			)
		) {
			fieldLabelsByName.put(fieldInfo.fieldName, fieldInfo.fieldLabel);
		}

		Map<String, RateCardAttributeOptionDto> attributeOptions = new Map<String, RateCardAttributeOptionDto>();
		for (RateCardAttributeOption__c attributeOption : attributeOptionsForRateCard) {
			RateCardAttributeOptionDto optionsForAttribute = attributeOptions.get(
				attributeOption.AttributeAPIName__c
			);

			if (optionsForAttribute == null) {
				optionsForAttribute = new RateCardAttributeOptionDto();
				optionsForAttribute.name = attributeOption.AttributeAPIName__c;
				optionsForAttribute.label = fieldLabelsByName.get(attributeOption.AttributeAPIName__c);
				optionsForAttribute.options = new List<String>();
				attributeOptions.put(attributeOption.AttributeAPIName__c, optionsForAttribute);
			}

			optionsForAttribute.options.add(attributeOption.TextValue__c);
		}

		return attributeOptions.values();
	}
}
