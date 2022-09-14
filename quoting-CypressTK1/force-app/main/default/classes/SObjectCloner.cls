/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class SObjectCloner {
	private class Context {
		public String[] mergeObjectNames;
		public Map<Id, Id> sourceIdByTargetId = new Map<Id, Id>();
		public Map<Id, Id> targetIdBySourceId = new Map<Id, Id>();
		public Map<Id, SObject> sourceById = new Map<Id, SObject>();
		public Map<Id, SObject> targetById = new Map<Id, SObject>();

		public void addReferences(SObject[] sourceRecords, SObject[] targetRecords) {
			this.sourceById.putAll(sourceRecords);
			this.targetById.putAll(targetRecords);
			for (Integer i = 0; i < sourceRecords.size(); i++) {
				SObject source = sourceRecords.get(i);
				SObject target = targetRecords.get(i);
				this.targetIdBySourceId.put(source.Id, target.Id);
				this.sourceIdByTargetId.put(target.Id, source.Id);
			}
		}
	}

	public static Id clone(Id sourceId, String schemaName) {
		Context refs = new Context();
		CloneSchemaDto schemaDto = CloneSchemaService.createSchemaTree(schemaName);
		refs.mergeObjectNames = schemaDto.getMergeValueReferences();

		return cloneObject(sourceId, schemaDto, refs);
	}

	public static Id clone(Id sourceId, CloneSchemaDto schemaDto) {
		Context refs = new Context();
		refs.mergeObjectNames = schemaDto.getMergeValueReferences();

		return cloneObject(sourceId, schemaDto, refs);
	}

	private static Id cloneObject(Id sourceId, CloneSchemaDto schemaDto, Context state) {
		QueryRequest queryRequest = new QueryRequest(schemaDto.targetObjectName);
		queryRequest.requestedFields = schemaDto.schemaFieldByName.keySet();
		queryRequest.filterBy.setWhereClause(
			schemaDto.filterClause.replaceAll(':inputId', '\'' + sourceId + '\'')
		);

		SObject[] sourceRecords = SOQLUtility.querySObject(queryRequest);
		SObject[] targetRecords = new SObject[0];

		if (!SystemUtility.nullOrEmpty(sourceRecords)) {
			for (SObject sourceObj : sourceRecords) {
				targetRecords.add(cloneWithFields(sourceObj, state, schemaDto.schemaFieldByName));
			}

			CRUDUtility.insertRecords(targetRecords);

			// store objects if used as referential merge field
			if (state.mergeObjectNames.contains(schemaDto.targetObjectName)) {
				state.addReferences(sourceRecords, targetRecords);
			}

			// clone children
			for (CloneSchemaDto childSchema : schemaDto.childSchemas) {
				cloneObject(sourceId, childSchema, state);
			}
		}

		return targetRecords.size() > 0 ? targetRecords[0].Id : null;
	}

	private static SObject cloneWithFields(
		SObject source,
		Context state,
		Map<String, CloneSchemaFieldDto> schemaFieldByName
	) {
		SObject target = source.clone();

		for (String fieldName : schemaFieldByName.keySet()) {
			CloneSchemaFieldDto schemaField = schemaFieldByName.get(fieldName);
			String transformValue = schemaField.mergeValue;

			if (isReferentialField(transformValue, state)) {
				String status = transformValue.split('\\.')[1]; // old or new
				if (status != 'old') {
					String fieldValue = (String) target.get(fieldName);
					target.put(fieldName, state.targetIdBySourceId.get(fieldValue));
				}
			} else if (String.isNotBlank(transformValue)) {
				target.put(fieldName, transformValue);
			}
		}

		return target;
	}

	private static Boolean isReferentialField(String value, Context state) {
		if (String.isBlank(value)) {
			return false;
		}

		String[] splitStr = value.split('\\.');
		if (splitStr.size() != 3) {
			return false;
		}

		String firstToken = CloneSchemaService.transformApiNames(splitStr[0]);
		if (!state.mergeObjectNames.contains(firstToken)) {
			return false;
		}

		return true;
	}
}
