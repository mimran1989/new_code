/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class TaskParameterTemplateDto extends BaseDTO {
	@AuraEnabled
	public String name;
	@AuraEnabled
	public String dataType;
	@AuraEnabled
	public List<TaskParameterValueTemplateDto> parameterValueTemplates;

	@AuraEnabled
	public TaskParameterValueDto parameterValue { get; set; }

	public TaskParameterTemplateDto() {
	}

	public TaskParameterTemplateDto(TaskParameterTemplate__c templateSo) {
		super(templateSo);
		this.name = templateSo.Name;
		this.dataType = templateSo.DataType__c;

		if (!SystemUtility.nullOrEmpty(templateSo.ParameterValues__r)) {
			this.parameterValueTemplates = new List<TaskParameterValueTemplateDto>();
			for (TaskParameterValueTemplate__c paramValueTemplateSo : templateSo.ParameterValues__r) {
				parameterValueTemplates.add(new TaskParameterValueTemplateDto(paramValueTemplateSo));
			}
		}
	}

	public override SObject refreshSo() {
		return null;
	}
}
