/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

@IsTest
private class ScopeParameterServiceTest {
	@IsTest
	static void shouldUpdateScopeParamTextValue() {
		ScopeParameter__c paramSo = new ScopeParameter__c();
		paramSo.Sequence__c = 1;
		paramSo.DeveloperName__c = 'test';
		paramSo.TextValue__c = 'test';
		paramSo.DataType__c = EstimatorConstants.PICKLIST;
		CRUDUtility.insertRecords(paramSo);

		ScopeParameterValueDto paramDto = new ScopeParameterValueDto(paramSo);
		paramDto.textValue = 'new value';

		ActivityGroupTemplate__c activityGroupSo = new ActivityGroupTemplate__c();
		CRUDUtility.insertRecords(activityGroupSo);

		ActivityTemplate__c activityTemplateSo = new ActivityTemplate__c(
			ActivityGroupTemplateId__c = activityGroupSo.Id
		);
		CRUDUtility.insertRecords(activityTemplateSo);

		TaskTemplate__c taskTemplateSo = new TaskTemplate__c(
			ActivityTemplateId__c = activityTemplateSo.Id
		);
		CRUDUtility.insertRecords(taskTemplateSo);

		TaskParameterTemplate__c parameterTemplateSo = new TaskParameterTemplate__c(
			TaskTemplateId__c = taskTemplateSo.Id,
			IsActive__c = true
		);
		CRUDUtility.insertRecords(parameterTemplateSo);

		TaskParameterValue__c paramValueSo = new TaskParameterValue__c(
			ScopeParameterId__c = paramSo.Id,
			TemplateId__c = parameterTemplateSo.Id
		);
		CRUDUtility.insertRecords(paramValueSo);

		Test.startTest();
		{
			ScopeParameterService.saveScopeParameters(new List<ScopeParameterValueDto>{ paramDto });
			ScopeParameter__c updatedParamSo = [
				SELECT TextValue__c
				FROM ScopeParameter__c
				WHERE Id = :paramSo.Id
			];
			System.assertEquals('new value', updatedParamSo.TextValue__c);
		}
		Test.stopTest();
	}
}
