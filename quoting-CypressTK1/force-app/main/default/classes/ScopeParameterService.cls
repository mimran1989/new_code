public with sharing class ScopeParameterService {
	public static final String DATATYPE_INTEGER = 'Integer';
	public static final String DATATYPE_PICKLIST = 'Picklist';
	public static final String DATATYPE_INTEGER_TIER = 'Integer Tiers';
	public static final String DATATYPE_BOOLEAN = 'Checkbox';

	public ScopeParameterService() {
	}

	public static Boolean hasScopeParameters(Id estimateId) {
		Map<Id, ActivityGroup__c> activityGroupsById = new Map<Id, ActivityGroup__c>(
			[SELECT Id FROM ActivityGroup__c WHERE EstimateId__c = :estimateId WITH SECURITY_ENFORCED]
		);
		Map<Id, Activity__c> activitiesById = new Map<Id, Activity__c>(
			[SELECT Id FROM Activity__c WHERE EstimateId__c = :estimateId WITH SECURITY_ENFORCED]
		);

		Set<Id> activityGroupIds = activityGroupsById.keySet();
		Set<Id> activityIds = activitiesById.keySet();
		List<ScopeParameter__c> scopeParameters = [
			SELECT Id
			FROM ScopeParameter__c
			WHERE
				EstimateId__c = :estimateId
				OR ActivityGroupId__c IN :activityGroupIds
				OR ActivityId__c IN :activityIds
			WITH SECURITY_ENFORCED
			LIMIT 1
		];

		return !scopeParameters.isEmpty();
	}

	public static List<ScopeParameterDto> getScopeParameters(Id estimateId) {
		Map<Id, ActivityGroup__c> activityGroupsById = new Map<Id, ActivityGroup__c>(
			[SELECT Id FROM ActivityGroup__c WHERE EstimateId__c = :estimateId WITH SECURITY_ENFORCED]
		);
		Map<Id, Activity__c> activitiesById = new Map<Id, Activity__c>(
			[SELECT Id FROM Activity__c WHERE EstimateId__c = :estimateId WITH SECURITY_ENFORCED]
		);

		Set<Id> activityGroupIds = activityGroupsById.keySet();
		Set<Id> activityIds = activitiesById.keySet();
		List<ScopeParameter__c> scopeParameters = [
			SELECT
				Id,
				Name,
				ActivityGroupId__c,
				ActivityGroupId__r.Name,
				ActivityId__c,
				ActivityId__r.Name,
				DataType__c,
				Description__c,
				DeveloperName__c,
				EstimateId__c,
				EstimateId__r.Name,
				Guidance__c,
				IsActive__c,
				Sequence__c,
				TemplateId__c,
				BooleanValue__c,
				IntegerValue__c,
				TextValue__c
			FROM ScopeParameter__c
			WHERE
				EstimateId__c = :estimateId
				OR ActivityGroupId__c IN :activityGroupIds
				OR ActivityId__c IN :activityIds
			WITH SECURITY_ENFORCED
			ORDER BY
				EstimateId__c NULLS LAST,
				ActivityGroupId__c NULLS LAST,
				ActivityId__c NULLS LAST,
				Sequence__c
		];

		List<ScopeParameterDto> parameters = new List<ScopeParameterDto>();
		Map<Id, ScopeParameterDto> parameterByTemplateId = new Map<Id, ScopeParameterDto>();
		for (ScopeParameter__c parameter : scopeParameters) {
			ScopeParameterDto param = new ScopeParameterDto(parameter);
			parameters.add(param);
			if (
				parameter.DataType__c == DATATYPE_INTEGER_TIER ||
				parameter.DataType__c == DATATYPE_PICKLIST
			) {
				parameterByTemplateId.put(parameter.TemplateId__c, param);
			}
		}

		Set<Id> templateIds = parameterByTemplateId.keySet();
		List<ScopeParameterValueTemplate__c> templateValues = [
			SELECT Id, Sequence__c, FromValue__c, ToValue__c, Label__c, ScopeParameterTemplateId__c
			FROM ScopeParameterValueTemplate__c
			WHERE ScopeParameterTemplateId__c IN :templateIds
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c
		];

		for (ScopeParameterValueTemplate__c templateValue : templateValues) {
			ScopeParameterValueTemplateDto templateDto = new ScopeParameterValueTemplateDto(
				templateValue
			);
			parameterByTemplateId.get(templateValue.ScopeParameterTemplateId__c)
				.templateValues.add(templateDto);
		}

		return parameters;
	}

	public static Boolean saveScopeParameters(List<ScopeParameterValueDto> scopeParameters) {
		Map<Id, ScopeParameter__c> parameters = new Map<Id, ScopeParameter__c>();
		for (ScopeParameterValueDto param : scopeParameters) {
			parameters.put(
				param.Id,
				new ScopeParameter__c(
					Id = param.id,
					BooleanValue__c = param.booleanValue,
					IntegerValue__c = param.integerValue,
					TextValue__c = param.textValue
				)
			);
		}

		CRUDUtility.updateRecords(parameters.values());
		calculateTaskDuration(parameters);
		return true;
	}

	private static void calculateTaskDuration(Map<Id, ScopeParameter__c> parameters) {
		List<TaskParameterValue__c> taskParameterValues = [
			SELECT
				Id,
				TemplateId__c,
				BooleanValue__c,
				IntegerValue__c,
				TextValue__c,
				TaskId__c,
				ScopeParameterId__c
			FROM TaskParameterValue__c
			WHERE ScopeParameterId__c IN :parameters.keySet()
			WITH SECURITY_ENFORCED
		];

		Map<Id, TaskParameterValue__c> taskValuesByTemplateId = new Map<Id, TaskParameterValue__c>();
		for (TaskParameterValue__c taskValue : taskParameterValues) {
			taskValuesByTemplateId.put(taskValue.TemplateId__c, taskValue);
		}

		Map<Id, TaskParameterTemplate__c> taskParameterTemplateById = new Map<Id, TaskParameterTemplate__c>(
			[
				SELECT
					Id,
					TaskTemplateId__c,
					DataType__c,
					Name,
					Guidance__c,
					(
						SELECT Id, Name, Label__c, PerUnitDuration__c, FromValue__c, ToValue__c
						FROM ParameterValues__r
						ORDER BY Sequence__c ASC
					)
				FROM TaskParameterTemplate__c
				WHERE Id IN :taskValuesByTemplateId.keySet() AND IsActive__c = TRUE
				WITH SECURITY_ENFORCED
				ORDER BY Sequence__c ASC
			]
		);

		List<Task__c> tasks = new List<Task__c>();
		for (TaskParameterValue__c paramValue : taskParameterValues) {
			TaskParameterTemplate__c taskTemplate = taskParameterTemplateById.get(
				paramValue.TemplateId__c
			);

			Task__c task = new Task__c(Id = paramValue.TaskId__c);

			if (!SystemUtility.nullOrEmpty(taskTemplate.ParameterValues__r)) {
				TaskParameterValueTemplate__c valueTemplate = taskTemplate.ParameterValues__r[0];
				switch on taskTemplate.DataType__c {
					when 'Integer' {
						paramValue.IntegerValue__c = parameters.get(paramValue.ScopeParameterId__c)
							.IntegerValue__c;
						task.CalculatedDuration__c =
							paramValue.IntegerValue__c * valueTemplate.PerUnitDuration__c;
					}
					when 'Checkbox' {
						paramValue.BooleanValue__c = parameters.get(paramValue.ScopeParameterId__c)
							.BooleanValue__c;
						task.CalculatedDuration__c = getBooleanValue(paramValue, valueTemplate);
					}
					when 'Picklist' {
						paramValue.TextValue__c = parameters.get(paramValue.ScopeParameterId__c).TextValue__c;
						task.CalculatedDuration__c = getPicklistValue(
							paramValue,
							taskTemplate.ParameterValues__r
						);
					}
					when 'Integer Tiers' {
						paramValue.IntegerValue__c = parameters.get(paramValue.ScopeParameterId__c)
							.IntegerValue__c;
						task.CalculatedDuration__c = getIntegerTierValue(
							paramValue,
							taskTemplate.ParameterValues__r
						);
					}
				}
				task.EstimatedDuration__c =
					task.CalculatedDuration__c + SystemUtility.nullToZero(task.LevelAdjustment__c);
				tasks.add(task);
			}
		}

		CRUDUtility.updateRecords(tasks);
		CRUDUtility.updateRecords(taskParameterValues);
	}

	private static Decimal getBooleanValue(
		TaskParameterValue__c paramValue,
		TaskParameterValueTemplate__c valueTemplate
	) {
		return paramValue.BooleanValue__c ? valueTemplate.PerUnitDuration__c : 0;
	}

	private static Decimal getPicklistValue(
		TaskParameterValue__c paramValue,
		List<TaskParameterValueTemplate__c> valueTemplates
	) {
		for (TaskParameterValueTemplate__c valueTemplate : valueTemplates) {
			if (valueTemplate.Label__c == paramValue.TextValue__c) {
				return valueTemplate.PerUnitDuration__c;
			}
		}
		return 0;
	}

	private static Decimal getIntegerTierValue(
		TaskParameterValue__c paramValue,
		List<TaskParameterValueTemplate__c> valueTemplates
	) {
		for (TaskParameterValueTemplate__c valueTemplate : valueTemplates) {
			if (
				valueTemplate.FromValue__c <= paramValue.IntegerValue__c ||
				valueTemplate.ToValue__c >= paramValue.IntegerValue__c
			) {
				return valueTemplate.PerUnitDuration__c * paramValue.IntegerValue__c;
			}
		}
		return 0;
	}

	public static List<ScopeParameter__c> createScopeParametersForEstimate(
		Map<Id, Activity__c> activitiesByTemplateId,
		Map<Id, ActivityGroup__c> activityGroupsByTemplateId,
		Id estimateTemplateId
	) {
		Set<Id> activityGroupIds = activityGroupsByTemplateId.keySet();
		Set<Id> activityIds = activitiesByTemplateId.keySet();
		Id estimateId = activityGroupsByTemplateId.values()[0].EstimateId__c;
		List<ScopeParameterTemplate__c> scopeParameters = ScopeParameterTemplateService.getScopeParameterTemplates(
			estimateTemplateId,
			activityGroupIds,
			activityIds
		);
		Map<Id, ScopeParameter__c> scopeParameterByTemplateId = new Map<Id, ScopeParameter__c>();
		for (ScopeParameterTemplate__c scopeParameterTemplate : scopeParameters) {
			ScopeParameter__c scopeParameter = ScopeParameterDto.newSO(scopeParameterTemplate);
			scopeParameter.ActivityGroupId__c = activityGroupsByTemplateId.get(
					scopeParameterTemplate.ActivityGroupTemplateId__c
				)
				?.Id;
			scopeParameter.ActivityId__c = activitiesByTemplateId.get(
					scopeParameterTemplate.ActivityTemplateId__c
				)
				?.Id;
			if (scopeParameterTemplate.EstimateTemplateId__c != null) {
				scopeParameter.EstimateId__c = estimateId;
			}

			scopeParameter.TemplateId__c = scopeParameterTemplate.Id;
			scopeParameterByTemplateId.put(scopeParameterTemplate.Id, scopeParameter);
		}
		CRUDUtility.insertRecords(scopeParameterByTemplateId.values());
		return scopeParameterByTemplateId.values();
	}
}
