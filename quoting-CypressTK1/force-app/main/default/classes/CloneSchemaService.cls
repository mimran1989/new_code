/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class CloneSchemaService {
	public static Map<String, CloneSchemaField__mdt> getCloneSchemaFieldByName(String schemaName) {
		Map<String, CloneSchemaField__mdt> schemaFieldByName = new Map<String, CloneSchemaField__mdt>();
		CloneSchema__mdt parentSchema = [
			SELECT (SELECT FieldApiName__c, MergeValue__c FROM CloneSchemaFields__r)
			FROM CloneSchema__mdt
			WHERE DeveloperName = :schemaName
			WITH SECURITY_ENFORCED
		];

		for (CloneSchemaField__mdt schemaField : parentSchema.CloneSchemaFields__r) {
			schemaFieldByName.put(transformApiNames(schemaField.FieldApiName__c), schemaField);
		}

		return schemaFieldByName;
	}

	public static String transformApiNames(String api) {
		return api.replaceAll('PSQ__', SystemUtility.getNamespacePrefix());
	}

	public static CloneSchema__mdt getParentSchema(String schemaName) {
		CloneSchema__mdt parentSchema = [
			SELECT
				TargetObjectApiName__c,
				Criteria__c,
				(SELECT MergeValue__c FROM CloneSchemaFields__r),
				(
					SELECT Sequence__c, ChildCloneSchemaId__r.DeveloperName
					FROM CloneSchemas__r
					ORDER BY Sequence__c
				)
			FROM CloneSchema__mdt
			WHERE DeveloperName = :schemaName
			WITH SECURITY_ENFORCED
		];
		return parentSchema;
	}

	public static void createCloneSchema(String objectApiName, String objectLabel) {
		CustomMetadata.Operations
			.callback(
				// Platform event for deploy status
				MetadataDeployment__e.getSObjectType(),
				MetadataDeployment__e.DeploymentId__c,
				MetadataDeployment__e.Result__c
			)
			.enqueueUpsertRecords(
				// Custom Metadata object type
				CloneSchema__mdt.getSObjectType(),
				new List<Map<SObjectField, Object>>{
					// Custom Metadata record
					new Map<SObjectField, Object>{
						CloneSchema__mdt.DeveloperName => objectLabel,
						CloneSchema__mdt.TargetObjectApiName__c => 'PSQ__' + objectApiName,
						CloneSchema__mdt.Label => objectLabel,
						CloneSchema__mdt.IsRootCloneSchema__c => false
					}
				}
			);

		List<Map<SObjectField, Object>> schemaFields = new List<Map<SObjectField, Object>>();
		Set<String> fieldNames = SObjectUtility.getCustomFieldsForSObjectOriginalCasing(objectApiName);
		for (String fieldName : fieldNames) {
			if (fieldName.contains('__c')) {
				String label = fieldName.replace('__c', '');
				schemaFields.add(
					new Map<SObjectField, Object>{
						CloneSchemaField__mdt.DeveloperName => objectLabel +
						'_' +
						label,
						CloneSchemaField__mdt.CloneSchemaId__c => objectLabel,
						CloneSchemaField__mdt.Label => objectLabel +
						'_' +
						label,
						CloneSchemaField__mdt.FieldApiName__c => 'PSQ__' + fieldName
					}
				);
			}
		}

		CustomMetadata.Operations
			.callback(
				// Platform event for deploy status
				MetadataDeployment__e.getSObjectType(),
				MetadataDeployment__e.DeploymentId__c,
				MetadataDeployment__e.Result__c
			)
			.enqueueUpsertRecords(
				// Custom Metadata object type
				CloneSchemaField__mdt.getSObjectType(),
				schemaFields
			);
	}

	public static CloneSchemaDto createSchemaTree(String schemaName) {
		CloneSchema__mdt parentSchema = CloneSchemaService.getParentSchema(schemaName);
		CloneSchemaDto schemaDto = new CloneSchemaDto(parentSchema);
		schemaDto.setFields(CloneSchemaService.getCloneSchemaFieldByName(schemaName).values());

		for (CloneSchemaParentChild__mdt childSchemaJunction : parentSchema.CloneSchemas__r) {
			String childSchemaName = childSchemaJunction.ChildCloneSchemaId__r.DeveloperName;
			CloneSchema__mdt childSchema = CloneSchemaService.getParentSchema(childSchemaName);
			CloneSchemaDto childSchemaDto = new CloneSchemaDto(childSchema);
			childSchemaDto.setFields(
				CloneSchemaService.getCloneSchemaFieldByName(childSchemaName).values()
			);
			schemaDto.childSchemas.add(childSchemaDto);
		}
		return schemaDto;
	}
}
