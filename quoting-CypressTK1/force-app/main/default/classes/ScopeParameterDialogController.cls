/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class ScopeParameterDialogController {
	@AuraEnabled
	public static List<ScopeParameterTemplateDto> getScopeParameters(Id parentId) {
		return ScopeParameterTemplateService.getParamsForParentId(parentId);
	}

	@AuraEnabled
	public static List<String> getHashtagsForEstimate(Id estimateId) {
		return HashtagDictionaryService.getHashtagsForEstimateTemplate(estimateId);
	}

	@AuraEnabled
	public static List<ScopeParameterTemplateDto> saveScopeParameters(
		Id parentId,
		List<ScopeParameterTemplateDto> params
	) {
		List<ScopeParameterTemplate__c> paramSos = new List<ScopeParameterTemplate__c>();
		Map<Decimal, List<ScopeParameterValueTemplate__c>> paramValueSosByParentSequence = new Map<Decimal, List<ScopeParameterValueTemplate__c>>();
		for (ScopeParameterTemplateDto param : params) {
			if (parentId.getSobjectType() == Schema.EstimateTemplate__c.SObjectType) {
				param.estimateTemplateId = parentId;
			} else if (parentId.getSobjectType() == Schema.ActivityGroupTemplate__c.SObjectType) {
				param.activityGroupTemplateId = parentId;
			} else if (parentId.getSobjectType() == Schema.ActivityTemplate__c.SObjectType) {
				param.activityTemplateId = parentId;
			}

			if (!SystemUtility.nullOrEmpty(param.paramValues)) {
				List<String> allowedValues = new List<String>();
				List<ScopeParameterValueTemplate__c> paramValueSos = new List<ScopeParameterValueTemplate__c>();
				for (ScopeParameterValueTemplateDto paramValueDto : param.paramValues) {
					allowedValues.add(
						param.dataType == ScopeParameterService.DATATYPE_PICKLIST
							? paramValueDto.label
							: paramValueDto.fromValue + '-' + paramValueDto.toValue
					);
					paramValueSos.add((ScopeParameterValueTemplate__c) paramValueDto.refreshSo());
				}
				param.allowedValues = String.join(allowedValues, '; ');
				paramValueSosByParentSequence.put(param.sequence, paramValueSos);
			}

			paramSos.add((ScopeParameterTemplate__c) param.refreshSo());
		}

		CRUDUtility.upsertRecords(
			associateParentToParameterValues(
				CRUDUtility.upsertRecords(paramSos),
				paramValueSosByParentSequence
			)
		);
		return getScopeParameters(parentId);
	}

	private static List<ScopeParameterValueTemplate__c> associateParentToParameterValues(
		List<ScopeParameterTemplate__c> paramSos,
		Map<Decimal, List<ScopeParameterValueTemplate__c>> paramValueSosByParentSequence
	) {
		List<ScopeParameterValueTemplate__c> updateParamValueSos = new List<ScopeParameterValueTemplate__c>();
		for (ScopeParameterTemplate__c paramSo : paramSos) {
			List<ScopeParameterValueTemplate__c> paramValuesForParam = paramValueSosByParentSequence.get(
				paramSo.Sequence__c
			);
			if (!SystemUtility.nullOrEmpty(paramValuesForParam)) {
				for (ScopeParameterValueTemplate__c paramValueSo : paramValuesForParam) {
					if (paramValueSo.Id == null) {
						paramValueSo.ScopeParameterTemplateId__c = paramSo.Id;
					}
					updateParamValueSos.add(paramValueSo);
				}
			}
		}

		return updateParamValueSos;
	}

	@AuraEnabled
	public static void deleteScopeParameters(List<ScopeParameterTemplateDto> templateDtos) {
		List<ScopeParameterTemplate__c> paramSos = new List<ScopeParameterTemplate__c>();
		for (ScopeParameterTemplateDto paramDtos : templateDtos) {
			paramSos.add((ScopeParameterTemplate__c) paramDtos.refreshSo());
		}

		CRUDUtility.deleteRecords(paramSos);
	}

	@AuraEnabled
	public static void deleteScopeParameterValues(
		List<ScopeParameterValueTemplateDto> valueTemplateDtos
	) {
		List<ScopeParameterValueTemplate__c> valueTemplateSos = new List<ScopeParameterValueTemplate__c>();
		for (ScopeParameterValueTemplateDto valueTemplateDto : valueTemplateDtos) {
			valueTemplateSos.add((ScopeParameterValueTemplate__c) valueTemplateDto.refreshSo());
		}

		CRUDUtility.deleteRecords(valueTemplateSos);
	}
}
