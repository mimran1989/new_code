/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class CollaborationRequestDto {
	@AuraEnabled
	public Id id;
	@AuraEnabled
	public String name;
	@AuraEnabled
	public Id sectionId;
	@AuraEnabled
	public Id sectionDerivedFromId;
	@AuraEnabled
	public String sectionName;
	@AuraEnabled
	public Id quoteId;
	@AuraEnabled
	public String quoteType;
	@AuraEnabled
	public String status;
	@AuraEnabled
	public String collaboratorUserName;
	@AuraEnabled
	public String collaborationQuoteName;
	@AuraEnabled
	public Id collaborationQuoteId;

	public CollaborationRequestDto(CollaborationRequest__c requestSo) {
		this.id = requestSo.Id;
		this.name = requestSo.Name;
		this.sectionId = requestSo.SectionId__c;
		this.sectionDerivedFromId = requestSo.SectionId__r.DerivedFromId__c;
		this.sectionName = requestSo.SectionId__r.Name;
		this.quoteId = requestSo.Id;
		this.quoteType = requestSo.QuoteId__r.Type__c;
		this.status = requestSo.Status__c;
		this.collaboratorUserName = requestSo.CollaboratorUserId__r.Name;
	}
}
