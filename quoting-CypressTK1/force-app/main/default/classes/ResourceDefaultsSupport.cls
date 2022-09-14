/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class ResourceDefaultsSupport {
	public static List<Map<String, String>> getTableColumns(Id rateCardId) {
		List<Map<String, String>> tableColumns = new List<Map<String, String>>();
		RateCard__c rateCardSo = [
			SELECT AttributeGroupId__c
			FROM RateCard__c
			WHERE Id = :rateCardId
			WITH SECURITY_ENFORCED
		];

		Id estimateAttrGroupId = rateCardSo.AttributeGroupId__c;
		String rateCardRField = (Schema.TaskRoleSummary__c.RateCardItemId__c + '')
			.replace('__c', '__r');
		if (estimateAttrGroupId != null) {
			for (
				RateCardAttribute__c attr : RateCardAttributeGroupService.getAttributesForGroups(
						new List<Id>{ estimateAttrGroupId }
					)
					.get(estimateAttrGroupId)
			) {
				tableColumns.add(
					new Map<String, String>{
						'label' => attr.Name,
						'fieldName' => rateCardRField +
						'.' +
						attr.FieldAPIName__c
					}
				);
			}
		}

		return tableColumns;
	}

	public static Map<String, Object> buildDependencies(
		Id rateCardId,
		Set<Id> roleIds,
		List<String> fields
	) {
		Map<String, Object> dependentValuesByControllingValue = new Map<String, Object>();

		// The requested fields determine the order in which the decision tree will be created. We should always start with the product id.
		List<String> requestedFields = new List<String>{ Schema.RateCardItem__c.ProductId__c + '' };
		requestedFields.addAll(fields);
		requestedFields.add('Id');

		QueryRequest queryRequest = new QueryRequest(Schema.RateCardItem__c.SObjectType);
		queryRequest.requestedFields = new Set<String>(requestedFields);
		queryRequest.filterBy.addFilterBy(Schema.RateCardItem__c.RateCardId__c + '', rateCardId);
		queryRequest.filterBy.addFilterBy(Schema.RateCardItem__c.ProductId__c + '', roleIds);

		for (
			RateCardItem__c nextRateItem : (List<RateCardItem__c>) SOQLUtility.querySObject(queryRequest)
		) {
			Map<String, Object> contextMap = dependentValuesByControllingValue;
			for (Integer i = 0; i < requestedFields.size() - 1; i++) {
				String controllingField = requestedFields[i];
				String dependentField = requestedFields[i + 1];
				String controllingFieldValue = (String) nextRateItem.get(controllingField);
				String dependentFieldValue = (String) nextRateItem.get(dependentField);
				Map<String, Object> dependentValuesForControllingValue;

				try {
					dependentValuesForControllingValue = (Map<String, Object>) contextMap.get(
						controllingFieldValue
					);
				} catch (TypeException e) {
					continue; // type exception occurs for duplicates
				}

				if (dependentValuesForControllingValue == null) {
					dependentValuesForControllingValue = new Map<String, Object>();
				}

				// dependent field is the last item
				if (i + 1 == requestedFields.size() - 1) {
					contextMap.put(controllingFieldValue, dependentFieldValue);
				} else {
					contextMap.put(controllingFieldValue, dependentValuesForControllingValue);
				}
				contextMap = dependentValuesForControllingValue;
			}
		}

		return dependentValuesByControllingValue;
	}
}
