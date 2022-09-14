/**
 *  Provus Services Quoting
 *  RateCardItemTriggers
 *  @2022 Provus Inc. All rights reserved.
 *
 */
public with sharing class RateCardItemTriggers extends TriggerHandler {
	public static void processTrigger(
		Map<Id, RateCardItem__c> oldMap,
		List<RateCardItem__c> newObjs,
		Boolean isBefore
	) {
		final RateCardItemTriggers myTrigger = new RateCardItemTriggers(oldMap, newObjs, isBefore);
		if (isBefore) {
			myTrigger.setLocationDisplayName();
		} else {
			// save the available options in this rate card to be used for filter
			// searches in the future
			myTrigger.saveRateCardAttributeOptions();
		}
	}

	public RateCardItemTriggers(
		Map<Id, RateCardItem__c> oldMap,
		List<RateCardItem__c> newObjs,
		Boolean isBefore
	) {
		super(oldMap, newObjs, isBefore);
	}

	public void setLocationDisplayName() {
		if (isDelete) {
			return;
		}

		for (RateCardItem__c rateCardItem : (List<RateCardItem__c>) newObjs) {
			rateCardItem.LocationDisplayName__c = rateCardItem.LocationCountry__c;
			if (String.isNotBlank(rateCardItem.LocationStateProvince__c)) {
				// location state is dependent on location country. so if state is populated, the country
				// is also populated with a value
				rateCardItem.LocationDisplayName__c += '/' + rateCardItem.LocationStateProvince__c;
			}

			if (
				String.isNotBlank(rateCardItem.LocationDisplayName__c) &&
				String.isNotBlank(rateCardItem.LocationCity__c)
			) {
				rateCardItem.LocationDisplayName__c += '/' + rateCardItem.LocationCity__c;
			} else if (String.isNotBlank(rateCardItem.LocationCity__c)) {
				rateCardItem.LocationDisplayName__c = rateCardItem.LocationCity__c;
			}
		}
	}

	private void saveRateCardAttributeOptions() {
		if (isDelete) {
			return;
		}

		Set<Id> ctxRateCardIds = new Set<Id>();
		for (RateCardItem__c existingItem : (List<RateCardItem__c>) newObjs) {
			ctxRateCardIds.add(existingItem.RateCardId__c);
		}

		Map<Id, Id> rateCardToAttributeGroupId = RateCardService.getAttributeGroupIdsForRateCards(
			ctxRateCardIds
		);
		Map<Id, List<RateCardAttribute__c>> attributesByGroupId = RateCardAttributeGroupService.getAttributesForGroups(
			rateCardToAttributeGroupId.values()
		);

		associateRateCardItemsToAttributeOptions(
			newObjs,
			rateCardToAttributeGroupId,
			attributesByGroupId
		);
	}

	private void associateRateCardItemsToAttributeOptions(
		List<RateCardItem__c> ctxRateCardItems,
		Map<Id, Id> rateCardToAttributeGroupId,
		Map<Id, List<RateCardAttribute__c>> attributesByGroupId
	) {
		Map<String, RateCardAttributeOption__c> rateCardAttributeOptionsToUpsert = new Map<String, RateCardAttributeOption__c>();
		List<RateCardItemAttributeOption__c> rateCardItemAttributeOptionsToUpsert = new List<RateCardItemAttributeOption__c>();
		Set<String> rateCardItemOptionsToDelete = new Set<String>();
		for (RateCardItem__c existingItem : ctxRateCardItems) {
			Id attributeGroupId = rateCardToAttributeGroupId.get(existingItem.RateCardId__c);
			List<RateCardAttribute__c> rateCardAttributes = attributesByGroupId.get(attributeGroupId);

			if (rateCardAttributes == null) {
				continue;
			}

			for (RateCardAttribute__c attribute : rateCardAttributes) {
				Object attributeValue = existingItem.get(attribute.FieldAPIName__c);
				String attributeItemKey = existingItem.Id + attribute.FieldAPIName__c;
				if (attributeValue == null) {
					rateCardItemOptionsToDelete.add(attributeItemKey);
				} else {
					String attributeOptionKey =
						existingItem.RateCardId__c +
						':' +
						attribute.FieldAPIName__c +
						':' +
						attributeValue;
					RateCardAttributeOption__c attributeOption = new RateCardAttributeOption__c(
						RateCardAttributeOptionKey__c = attributeOptionKey,
						TextValue__c = String.valueOf(attributeValue),
						AttributeGroupId__c = attribute.AttributeGroupId__c,
						RateCardAttributeId__c = attribute.Id,
						RateCardId__c = existingItem.RateCardId__c
					);
					rateCardAttributeOptionsToUpsert.put(attributeOptionKey, attributeOption);

					RateCardItemAttributeOption__c rateCardItemOption = new RateCardItemAttributeOption__c(
						AttributeOptionId__r = new RateCardAttributeOption__c(
							RateCardAttributeOptionKey__c = attributeOptionKey
						),
						RateCardItemId__c = existingItem.Id,
						RateCardItemAttributeKey__c = attributeItemKey
					);
					rateCardItemAttributeOptionsToUpsert.add(rateCardItemOption);
				}
			}
		}

		CRUDUtility.upsertRecords(
			rateCardAttributeOptionsToUpsert.values(),
			RateCardAttributeOption__c.RateCardAttributeOptionKey__c
		);
		CRUDUtility.upsertRecords(
			rateCardItemAttributeOptionsToUpsert,
			RateCardItemAttributeOption__c.RateCardItemAttributeKey__c
		);
	}
}
