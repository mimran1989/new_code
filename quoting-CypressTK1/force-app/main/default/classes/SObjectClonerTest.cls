/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
@IsTest
private class SObjectClonerTest extends TestBase {
	@IsTest
	static void shouldCloneTheRootObject() {
		Quote__c quoteSo = newQuote();

		CloneSchema__mdt parentSchema = new CloneSchema__mdt(
			TargetObjectApiName__c = 'PSQ__Quote__c',
			Criteria__c = 'Id = :inputId'
		);
		CloneSchemaDto parentSchemaDto = new CloneSchemaDto(parentSchema);

		CloneSchemaField__mdt[] schemaFields = new CloneSchemaField__mdt[0];
		schemaFields.add(new CloneSchemaField__mdt(FieldApiName__c = 'PSQ__ServiceStartDate__c'));
		schemaFields.add(new CloneSchemaField__mdt(FieldApiName__c = 'PSQ__ServiceEndDate__c'));
		schemaFields.add(new CloneSchemaField__mdt(FieldApiName__c = 'PSQ__TimePeriod__c'));
		schemaFields.add(new CloneSchemaField__mdt(FieldApiName__c = 'PSQ__TimePeriodsGroupMethod__c'));
		parentSchemaDto.setFields(schemaFields);

		Test.startTest();
		{
			Id cloneId = SObjectCloner.clone(quoteSo.Id, parentSchemaDto);
			Quote__c clonedQuote = [
				SELECT Id, ServiceEndDate__c, ServiceStartDate__c, TimePeriod__c, TimePeriodsGroupMethod__c
				FROM Quote__c
				WHERE Id = :cloneId
			];
			System.assertEquals(quoteSo.ServiceStartDate__c, clonedQuote.ServiceStartDate__c);
			System.assertEquals(quoteSo.ServiceEndDate__c, clonedQuote.ServiceEndDate__c);
			System.assertEquals(quoteSo.TimePeriod__c, clonedQuote.TimePeriod__c);
			System.assertEquals(quoteSo.TimePeriodsGroupMethod__c, clonedQuote.TimePeriodsGroupMethod__c);
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldCloneOnlyTheSpecifiedFields() {
		Quote__c quoteSo = newQuote();
		quoteSo.Description__c = 'test';
		update quoteSo;

		CloneSchema__mdt parentSchema = new CloneSchema__mdt(
			TargetObjectApiName__c = 'PSQ__Quote__c',
			Criteria__c = 'Id = :inputId'
		);
		CloneSchemaDto parentSchemaDto = new CloneSchemaDto(parentSchema);

		CloneSchemaField__mdt[] schemaFields = new CloneSchemaField__mdt[0];
		schemaFields.add(new CloneSchemaField__mdt(FieldApiName__c = 'PSQ__ServiceStartDate__c'));
		schemaFields.add(new CloneSchemaField__mdt(FieldApiName__c = 'PSQ__ServiceEndDate__c'));
		schemaFields.add(new CloneSchemaField__mdt(FieldApiName__c = 'PSQ__TimePeriod__c'));
		schemaFields.add(new CloneSchemaField__mdt(FieldApiName__c = 'PSQ__TimePeriodsGroupMethod__c'));
		parentSchemaDto.setFields(schemaFields);

		Test.startTest();
		{
			Id cloneId = SObjectCloner.clone(quoteSo.Id, parentSchemaDto);
			Quote__c clonedQuote = [SELECT Id, Description__c FROM Quote__c WHERE Id = :cloneId];
			System.assertNotEquals(quoteSo.Description__c, clonedQuote.Description__c);
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldOverwriteFieldWithMergeValue() {
		Quote__c quoteSo = newQuote();
		quoteSo.Description__c = 'test';
		update quoteSo;

		CloneSchema__mdt parentSchema = new CloneSchema__mdt(
			TargetObjectApiName__c = 'PSQ__Quote__c',
			Criteria__c = 'Id = :inputId'
		);
		CloneSchemaDto parentSchemaDto = new CloneSchemaDto(parentSchema);

		CloneSchemaField__mdt[] schemaFields = new CloneSchemaField__mdt[0];
		schemaFields.add(new CloneSchemaField__mdt(FieldApiName__c = 'PSQ__ServiceStartDate__c'));
		schemaFields.add(new CloneSchemaField__mdt(FieldApiName__c = 'PSQ__ServiceEndDate__c'));
		schemaFields.add(new CloneSchemaField__mdt(FieldApiName__c = 'PSQ__TimePeriod__c'));
		schemaFields.add(new CloneSchemaField__mdt(FieldApiName__c = 'PSQ__TimePeriodsGroupMethod__c'));
		schemaFields.add(
			new CloneSchemaField__mdt(FieldApiName__c = 'PSQ__Description__c', MergeValue__c = 'foo')
		);
		parentSchemaDto.setFields(schemaFields);

		Test.startTest();
		{
			Id cloneId = SObjectCloner.clone(quoteSo.Id, parentSchemaDto);
			Quote__c clonedQuote = [SELECT Id, Description__c FROM Quote__c WHERE Id = :cloneId];
			System.assertEquals('foo', clonedQuote.Description__c);
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldCloneChildObjects() {
		Quote__c quoteSo = newQuote();
		QuoteSection__c quoteSectionSo = newQuoteSection(quoteSo.Id);

		CloneSchema__mdt parentSchema = new CloneSchema__mdt(
			TargetObjectApiName__c = 'PSQ__Quote__c',
			Criteria__c = 'Id = :inputId'
		);
		CloneSchemaDto parentSchemaDto = new CloneSchemaDto(parentSchema);

		CloneSchemaField__mdt[] schemaFields = new CloneSchemaField__mdt[0];
		schemaFields.add(new CloneSchemaField__mdt(FieldApiName__c = 'PSQ__ServiceStartDate__c'));
		schemaFields.add(new CloneSchemaField__mdt(FieldApiName__c = 'PSQ__ServiceEndDate__c'));
		schemaFields.add(new CloneSchemaField__mdt(FieldApiName__c = 'PSQ__TimePeriod__c'));
		schemaFields.add(new CloneSchemaField__mdt(FieldApiName__c = 'PSQ__TimePeriodsGroupMethod__c'));
		parentSchemaDto.setFields(schemaFields);

		CloneSchema__mdt childSchema = new CloneSchema__mdt(
			TargetObjectApiName__c = 'PSQ__QuoteSection__c',
			Criteria__c = 'PSQ__QuoteId__c = :inputId'
		);
		CloneSchemaDto childSchemaDto = new CloneSchemaDto(childSchema);

		CloneSchemaField__mdt[] childSchemaFields = new CloneSchemaField__mdt[0];
		childSchemaFields.add(
			new CloneSchemaField__mdt(
				FieldApiName__c = 'PSQ__QuoteId__c',
				MergeValue__c = 'PSQ__Quote__c.new.Id'
			)
		);
		childSchemaDto.setFields(childSchemaFields);

		parentSchemaDto.childSchemas.add(childSchemaDto);

		Test.startTest();
		{
			Id cloneId = SObjectCloner.clone(quoteSo.Id, parentSchemaDto);
			QuoteSection__c clonedSection = [
				SELECT Id, QuoteId__c
				FROM QuoteSection__c
				WHERE QuoteId__c = :cloneId
			];
			System.assertEquals(cloneId, clonedSection.QuoteId__c);
		}
		Test.stopTest();
	}
}
