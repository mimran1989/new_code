public with sharing class ScopeParameterDto extends ScopeParameterBaseDto {
	@AuraEnabled
	public String hashtag { get; set; }
	@AuraEnabled
	public String title { get; set; }
	@AuraEnabled
	public ScopeParameterValueDto value { get; set; }
	@AuraEnabled
	public List<ScopeParameterValueTemplateDto> templateValues { get; set; }

	public ScopeParameterDto(ScopeParameter__c scopeParameter) {
		this.name = scopeParameter.Name;
		this.dataType = scopeParameter.DataType__c;
		this.guidance = scopeParameter.Guidance__c;
		this.sequence = scopeParameter.Sequence__c;
		this.hashtag = scopeParameter.DeveloperName__c;
		this.value = new ScopeParameterValueDto();
		this.value.booleanValue = scopeParameter.BooleanValue__c;
		this.value.integerValue = scopeParameter.IntegerValue__c;
		this.value.textValue = scopeParameter.TextValue__c;
		this.value.id = scopeParameter.id;
		if (scopeParameter.EstimateId__c != null) {
			this.title = scopeParameter.EstimateId__r.Name;
		}
		if (scopeParameter.ActivityGroupId__c != null) {
			this.title = scopeParameter.ActivityGroupId__r.Name;
		}
		if (scopeParameter.ActivityId__c != null) {
			this.title = scopeParameter.ActivityId__r.Name;
		}
		this.templateValues = new List<ScopeParameterValueTemplateDto>();
	}

	public static ScopeParameter__c newSO(ScopeParameterTemplate__c templateSO) {
		ScopeParameter__c scopeParameterSO = new ScopeParameter__c();
		scopeParameterSO.Name = templateSO.Name;
		scopeParameterSO.DeveloperName__c = templateSO.DeveloperName__c;
		scopeParameterSO.Description__c = templateSO.Description__c;
		scopeParameterSO.Guidance__c = templateSO.Guidance__c;
		scopeParameterSO.Sequence__c = templateSO.Sequence__c;
		scopeParameterSO.DataType__c = templateSO.DataType__c;
		scopeParameterSO.IsActive__c = true;
		return scopeParameterSO;
	}

	public override SObject refreshSo() {
		return null;
	}
}
