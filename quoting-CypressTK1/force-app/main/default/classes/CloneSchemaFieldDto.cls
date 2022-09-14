/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class CloneSchemaFieldDto {
	public String mergeValue;

	public CloneSchemaFieldDto(CloneSchemaField__mdt schemaField) {
		this.mergeValue = schemaField.MergeValue__c;
	}
}
