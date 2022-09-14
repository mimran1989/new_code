/**
 *  Provus Services Quoting
 *  CustomLookupController : This is a controller for Customlookup Component
 *  @2021 Provus Inc. All rights reserved.
 */
public with sharing class CustomLookupController {
	private static final string NAME_SPACE = SystemUtility.getNamespacePrefix();
	private static List<RecordsData> fetchRecordsforTasks(Map<String, String> params) {
		String objectName = String.escapeSingleQuotes(params.get(EstimatorConstants.SOBJECT_NAME));
		String filterField = String.escapeSingleQuotes(params.get(EstimatorConstants.FILTER_FIELD));

		// if filter criteria value provided escape
		String filterCriteriaValue = params.get(EstimatorConstants.FILTER_CRITERIA);
		String filterCriteria = filterCriteriaValue != null ? ' AND ' + filterCriteriaValue : '';

		String rateCard = params.get(EstimatorConstants.RATE_CARD);
		String searchWord =
			'\'%' +
			String.escapeSingleQuotes(params.get(EstimatorConstants.SEARCH_STRING).trim()) +
			'%\'';
		String query;
		if (rateCard != null) {
			query =
				'SELECT Id, ' +
				NAME_SPACE +
				'ProductId__r.Name, ' +
				NAME_SPACE +
				'ProductId__c from ' +
				NAME_SPACE +
				'RateCardItem__c WHERE ' +
				NAME_SPACE +
				'RateCardId__c=:rateCard AND ' +
				NAME_SPACE +
				'ProductId__r.RecordType.Name=\'Resource Role\' AND ' +
				NAME_SPACE +
				'ProductId__r.Name Like ' +
				searchWord +
				filterCriteria +
				' LIMIT 2000';
		} else {
			query =
				'SELECT Id,' +
				filterField +
				' FROM ' +
				objectName +
				' WHERE ' +
				filterField +
				' LIKE ' +
				searchWord +
				filterCriteria +
				' LIMIT 2000';
		}
		List<RecordsData> recordsDataList = new List<RecordsData>();
		List<SObject> records = Database.query(query); // NOPMD; query is escaped on line 14
		for (SObject record : records) {
			if (rateCard != null) {
				recordsDataList.add(
					new RecordsData(
						String.valueOf(record.getSObject(EstimatorConstants.PRODUCT_RELATION).get('Name')),
						(String) record.get(EstimatorConstants.PRODUCT_APINAME)
					)
				);
			} else {
				recordsDataList.add(
					new RecordsData((String) record.get(filterField), (String) record.get('id'))
				);
			}
		}
		return recordsDataList;
	}
	// Method to fetch lookup default value
	@AuraEnabled
	public static SObject fetchDefaultRecord(String recordId, String sObjectApiName) {
		for (
			SObject obj : Database.query(
				String.escapeSingleQuotes(
					'Select Id,Name From ' +
					sObjectApiName +
					' Where Id = : recordId LIMIT 1'
				)
			)
		) {
			return obj;
		}
		return null;
	}

	@AuraEnabled
	public static List<RecordsData> fetchRecords(Map<String, String> paramMap) {
		String objectName = paramMap.get('objectName');
		String filterField = paramMap.get(EstimatorConstants.FILTER_FIELD);
		String filterCriteria = paramMap.get(EstimatorConstants.FILTER_CRITERIA);
		String searchString = paramMap.get('searchString');
		String hierarchylevel = paramMap.containsKey('hierarchylevel')
			? paramMap.get('hierarchylevel')
			: '';
		String hierarchylevelId = paramMap.containsKey('hierarchylevelId')
			? paramMap.get('hierarchylevelId')
			: '';
		String rateCard = paramMap.containsKey('rateCard') ? paramMap.get('rateCard') : '';
		if (hierarchylevel == 'Task') {
			return fetchRecordsforTasks(
				new Map<String, String>{
					'objectName' => objectName,
					EstimatorConstants.FILTER_FIELD => filterField,
					EstimatorConstants.FILTER_CRITERIA => filterCriteria,
					'searchString' => searchString,
					'rateCard' => rateCard
				}
			);
		} else {
			return fetchRecordsExceptTasks(
				new Map<String, String>{
					'objectName' => objectName,
					'filterField' => filterField,
					'searchString' => searchString,
					'hierarchylevelId' => hierarchylevelId,
					'hierarchylevel' => hierarchylevel,
					'rateCard' => rateCard
				}
			);
		}
	}

	public static List<RecordsData> fetchRecordsExceptTasks(Map<String, String> params) {
		String hierarchylevelId = params?.get('hierarchylevelId');
		String objectName = params?.get('objectName');
		String searchString = params?.get('searchString');
		String filterField = params?.get('filterField');
		String hierarchylevel = params?.get('hierarchylevel');
		String rateCard = params.containsKey('rateCard') ? params.get('rateCard') : '';
		Set<Id> productIds = buildProductIds(hierarchylevel, hierarchylevelId);
		String searchWord = '\'%' + String.escapeSingleQuotes(searchString.trim()) + '%\'';
		List<RecordsData> recordsDataList = new List<RecordsData>();
		String query;
		Id resourceRoleTypeId = SObjectUtility.getRecordTypeIdbyName(
			Schema.SObjectType.Product__c.getName(),
			EstimatorConstants.RESOURCE_ROLE
		);
		String relatedProductName = SystemUtility.getChildRName(
			Schema.RateCardItem__c.ProductId__c,
			Schema.Product__c.Name
		);
		String relatedProductRecordType = SystemUtility.getChildRName(
			Schema.RateCardItem__c.ProductId__c,
			Schema.Product__c.RecordTypeId
		);
		if (rateCard != null) {
			query =
				'SELECT ' +
				Schema.RateCardItem__c.Id +
				',' +
				relatedProductName +
				',' +
				Schema.RateCardItem__c.ProductId__c +
				' FROM ' +
				Schema.SObjectType.RateCardItem__c.getName() +
				' WHERE ' +
				Schema.RateCardItem__c.RateCardId__c +
				' =:rateCard AND ' +
				relatedProductName +
				' LIKE ' +
				searchWord +
				' AND ' +
				relatedProductRecordType +
				' =\'' +
				resourceRoleTypeId +
				'\' LIMIT 2000 ';
		} else {
			query = 'SELECT Id, ' + filterField + ' FROM ' + objectName;
			query +=
				' WHERE recordtype.Name=\'Resource Role\' and ' +
				filterField +
				' LIKE ' +
				searchWord +
				' LIMIT 49999';
		}

		List<SObject> records = Database.query(query); // NOPMD; escaped on line 120
		for (SObject record : records) {
			if (
				!productIds.contains(
					(String) record.get(SystemUtility.getNamespacePrefix() + 'ProductId__c')
				)
			) {
				if (rateCard != null) {
					recordsDataList.add(
						new RecordsData(
							String.valueOf(record.getSObject(EstimatorConstants.PRODUCT_RELATION).get('Name')),
							(String) record.get(EstimatorConstants.PRODUCT_APINAME)
						)
					);
				} else {
					recordsDataList.add(
						new RecordsData((String) record.get(filterField), (String) record.Id)
					);
				}
			}
		}
		return recordsDataList;
	}

	public static Set<Id> buildProductIds(String hierarchylevel, String hierarchylevelId) {
		Set<Id> productIds = new Set<Id>();
		if (hierarchylevel == EstimatorConstants.ACTIVITY_GROUP) {
			for (TaskRoleSummary__c taskroleSummary : [
				SELECT Id, ResourceRoleId__c
				FROM TaskRoleSummary__c
				WHERE ActivityGroupId__c = :hierarchylevelId
				WITH SECURITY_ENFORCED
			]) {
				productIds.add(taskroleSummary.ResourceRoleId__c);
			}
		} else if (hierarchylevel == EstimatorConstants.ACTIVITY) {
			for (TaskRoleSummary__c taskroleSummary : [
				SELECT Id, ResourceRoleId__c
				FROM TaskRoleSummary__c
				WHERE ActivityId__c = :hierarchylevelId
				WITH SECURITY_ENFORCED
			]) {
				productIds.add(taskroleSummary.ResourceRoleId__c);
			}
		} else if (hierarchylevel == EstimatorConstants.ESTIMATE) {
			for (TaskRoleSummary__c taskroleSummary : [
				SELECT Id, ResourceRoleId__c
				FROM TaskRoleSummary__c
				WHERE EstimateId__c = :hierarchylevelId
				WITH SECURITY_ENFORCED
			]) {
				productIds.add(taskroleSummary.ResourceRoleId__c);
			}
		}
		return productIds;
	}

	public class RecordsData {
		@AuraEnabled
		public String label;
		@AuraEnabled
		public String value;
		public RecordsData(String label, String value) {
			this.label = label;
			this.value = value;
		}
	}
}
