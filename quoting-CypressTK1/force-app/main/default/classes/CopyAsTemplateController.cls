/**
 *  Provus Services Quoting
 *  @2021-2022 Provus Inc. All rights reserved.
 */
public with sharing class CopyAsTemplateController {
	@AuraEnabled
	public static String getQuoteName(Id recordId) {
		return [SELECT Id, Name FROM Quote__c WHERE Id = :recordId WITH SECURITY_ENFORCED].Name;
	}

	@AuraEnabled
	public static Quote__c copyAsTemplate(Id recordId, String templateName) {
		Quote__c clonedQuote = QuoteCloneService.cloneQuote(recordId);
		if (clonedQuote != null) {
			clonedQuote.Type__c = QuoteService.RECORDTYPE_NAME_TEMPLATE;
			clonedQuote.Name = templateName;
			clonedQuote.AccountId__c = null;
			clonedQuote.OpportunityId__c = null;
			clonedQuote.TemplateId__c = null;
			CRUDUtility.updateRecords(clonedQuote);
		}

		return clonedQuote;
	}
}
