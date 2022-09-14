/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class TaskParameterValueDto extends BaseDTO {
	@AuraEnabled
	public Decimal integerValue { get; set; }
	@AuraEnabled
	public String textValue { get; set; }
	@AuraEnabled
	public Boolean booleanValue { get; set; }

	public TaskParameterValueDto() {
	}

	public TaskParameterValueDto(TaskParameterValue__c paramValueSo) {
		super(paramValueSo);
		this.integerValue = paramValueSo.IntegerValue__c;
		this.textValue = paramValueSo.TextValue__c;
		this.booleanValue = paramValueSo.BooleanValue__c;
	}

	public override SObject refreshSo() {
		return new TaskParameterValue__c(
			Id = this.id,
			IntegerValue__c = this.integerValue,
			TextValue__c = this.textValue,
			BooleanValue__c = this.booleanValue
		);
	}
}
