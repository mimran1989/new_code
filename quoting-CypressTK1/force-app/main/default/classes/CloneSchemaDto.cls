/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class CloneSchemaDto {
	public String targetObjectName;
	public String filterClause;
	public Map<String, CloneSchemaFieldDto> schemaFieldByName;
	public CloneSchemaDto[] childSchemas;

	public CloneSchemaDto(CloneSchema__mdt parentSchema) {
		this.schemaFieldByName = new Map<String, CloneSchemaFieldDto>();
		childSchemas = new CloneSchemaDto[0];
		this.filterClause = CloneSchemaService.transformApiNames(parentSchema.Criteria__c);

		this.targetObjectName = CloneSchemaService.transformApiNames(
			parentSchema.TargetObjectApiName__c
		);
	}

	public void setFields(CloneSchemaField__mdt[] schemaFields) {
		for (CloneSchemaField__mdt cloneSchemaField : schemaFields) {
			this.schemaFieldByName.put(
				CloneSchemaService.transformApiNames(cloneSchemaField.FieldApiName__c),
				new CloneSchemaFieldDto(cloneSchemaField)
			);
		}
	}

	public String[] getMergeValueReferences() {
		String[] objectNames = new String[0];
		objectNames.addAll(processMergeValueReferences(new Set<String>()));
		return objectNames;
	}

	private Set<String> processMergeValueReferences(Set<String> objectNames) {
		for (CloneSchemaFieldDto schemaField : this.schemaFieldByName.values()) {
			if (String.isNotBlank(schemaField.mergeValue)) {
				String firstToken = CloneSchemaService.transformApiNames(
					schemaField.mergeValue.split('\\.')[0]
				);
				// skip if we've already added this object type
				if (!objectNames.contains(firstToken) && Type.forName(firstToken) != null) {
					objectNames.add(firstToken);
				}
			}
		}

		for (CloneSchemaDto childSchema : this.childSchemas) {
			objectNames.addAll(childSchema.processMergeValueReferences(objectNames));
		}

		return objectNames;
	}
}
