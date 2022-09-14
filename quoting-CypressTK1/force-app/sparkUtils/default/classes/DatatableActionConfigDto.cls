public with sharing class DatatableActionConfigDto {
    @AuraEnabled
	public Decimal order;
	@AuraEnabled
	public String rowActionName;
	@AuraEnabled
	public String buttonLabel;
	@AuraEnabled
	public String type;
	@AuraEnabled
	public Id datatableConfigId;
	@AuraEnabled
	public String flowApiName;
	@AuraEnabled
	public String lwcName;
	@AuraEnabled
	public String dialogSize;

    public DatatableActionConfigDto(Datatable_Action_Config__mdt actionConfigMdt) {
        this.order = actionConfigMdt.Order__c;
        this.rowActionName = actionConfigMdt.Row_Action_Name__c;
        this.buttonLabel = actionConfigMdt.Button_Label__c;
        this.type = actionConfigMdt.Type__c;
        this.datatableConfigId = actionConfigMdt.Datatable_Config__c;
        this.flowApiName = actionConfigMdt.Flow_API_Name__c;
        this.lwcName = actionConfigMdt.LWC_Name__c;
        this.dialogSize = actionConfigMdt.Dialog_Size__c;
    }
}