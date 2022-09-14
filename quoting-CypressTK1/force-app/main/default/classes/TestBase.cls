/**
 *  Provus Services Quoting
 *  TestBase
 *  @2021 Provus Inc. All rights reserved.
 */
@SuppressWarnings('PMD.ExcessivePublicCount')
public with sharing abstract class TestBase {
	static final String NS_PREFIX = SystemUtility.getNamespacePrefix();

	public static String nsPrefix() {
		return NS_PREFIX;
	}

	public static User newUser() {
		Profile profileSO = [SELECT Id FROM Profile WITH SECURITY_ENFORCED LIMIT 1];

		User newUser = new User(
			Username = 'testbase@provus.com',
			LastName = 'TestBase',
			Email = 'testbase@provus.com',
			Alias = 'testbase',
			TimeZoneSidKey = 'America/Los_Angeles',
			LocaleSidKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			ProfileId = profileSO.Id,
			LanguageLocaleKey = 'en_US'
		);

		CRUDUtility.insertRecords(newUser);
		return newUser;
	}

	public static Quote__c newQuote() {
		return newQuote(null);
	}

	public static Quote__c newQuote(String quoteName) {
		Quote__c newQuote = new Quote__c(
			Name = quoteName,
			ServiceStartDate__c = Date.today(),
			ServiceEndDate__c = Date.today().addDays(7),
			TimePeriod__c = TimePeriodDay.NAME_PLURAL,
			TimePeriodsGroupMethod__c = TimePeriodWeek.NAME
		);
		CRUDUtility.insertRecords(newQuote);
		return newQuote;
	}

	public static QuotePeriod__c newQuotePeriod(Id quoteId) {
		QuotePeriod__c newQuotePeriod = new QuotePeriod__c();
		newQuotePeriod.QuoteId__c = quoteId;
		CRUDUtility.insertRecords(newQuotePeriod);
		return newQuotePeriod;
	}

	public static Proposal__c newProposal() {
		Proposal__c proposalSO = new Proposal__c(Name = 'Test Proposal');
		CRUDUtility.insertRecords(proposalSO);
		return proposalSO;
	}

	public static Opportunity newOpportunity() {
		Opportunity opp = new Opportunity(
			Name = 'Test',
			StageName = 'Test',
			CloseDate = Date.valueOf('2021-12-31')
		);
		CRUDUtility.insertRecords(opp);
		return opp;
	}

	public static Opportunity newOpportunity(Pricebook2 pricebook) {
		Opportunity opp = new Opportunity(
			Name = 'Test',
			StageName = 'Test',
			CloseDate = Date.valueOf('2022-12-31'),
			Pricebook2Id = pricebook.Id
		);
		CRUDUtility.insertRecords(opp);
		return opp;
	}

	public static Pricebook2 newPricebook() {
		Pricebook2 newPricebook = new Pricebook2(IsActive = true, Name = 'Pricebook');
		CRUDUtility.insertRecords(newPricebook);
		return newPricebook;
	}

	public static PricebookEntry newPricebookEntry(Id pricebookId, Id productId) {
		PricebookEntry newPricebookEntry = new PricebookEntry(
			IsActive = true,
			UnitPrice = 1000,
			Pricebook2Id = pricebookId,
			Product2Id = productId
		);
		return newPricebookEntry;
	}

	public static RateCard__c newRateCard() {
		RateCard__c rateCard = new RateCard__c(
			Name = 'Skill & Resource Location',
			IsActive__c = true,
			ExpirationDate__c = Date.today() + 1,
			EffectiveDate__c = Date.today() - 1
		);
		CRUDUtility.insertRecords(rateCard);
		return rateCard;
	}

	public static RateCardAttributeGroup__c newRateCardAttributeGroup() {
		RateCardAttributeGroup__c rateCardAttributeGroup = new RateCardAttributeGroup__c(
			Name = 'Skill & Resource Location'
		);
		CRUDUtility.insertRecords(rateCardAttributeGroup);
		return rateCardAttributeGroup;
	}

	public static RateCardAttribute__c newRateCardAttribute(Id rateCardAttributeGroupId) {
		RateCardAttribute__c rateCardAttribute = new RateCardAttribute__c(
			AttributeGroupId__c = rateCardAttributeGroupId,
			Sequence__c = 1,
			Name = 'Skill',
			FieldAPIName__c = Schema.RateCardItem__c.SkillLevel__c + ''
		);
		CRUDUtility.insertRecords(rateCardAttribute);
		return rateCardAttribute;
	}

	public static RateCardItem__c newRateCardItem(Id rateCardId, Id productId) {
		RateCardItem__c rateCardItem = new RateCardItem__c(
			IsActive__c = true,
			RateCardId__c = rateCardId,
			ProductId__c = productId
		);
		CRUDUtility.insertRecords(rateCardItem);
		return rateCardItem;
	}

	public static Product__c newProduct(String productName, String recordTypeName) {
		Id recordTypeId = SObjectUtility.getRecordTypeIdbyName(
			Schema.SObjectType.Product__c.getName(),
			recordTypeName
		);
		return newProduct(productName, recordTypeId);
	}

	public static Product__c newProduct(String productName, Id recordTypeId) {
		Product__c product = new Product__c();
		product.IsActive__c = true;
		product.Name = productName;
		product.RecordTypeId = recordTypeId;
		return product;
	}

	public static Product2 newProduct2(String productName, String type) {
		Product2 product = new Product2();
		product.IsActive = true;
		product.Name = productName;
		product.Type__c = type;
		return product;
	}

	public static CollaborationRequest__c newCollaborationRequest() {
		CollaborationRequest__c requestSO = new CollaborationRequest__c();
		CRUDUtility.insertRecords(requestSO);
		return requestSO;
	}

	public static QuoteSection__c newQuoteSection(Id quoteId) {
		QuoteSection__c sectionSO = new QuoteSection__c();
		sectionSO.QuoteId__c = quoteId;
		CRUDUtility.insertRecords(sectionSO);
		return sectionSO;
	}

	public static Estimate__c newEstimate() {
		Estimate__c newEstimate = new Estimate__c();
		CRUDUtility.insertRecords(newEstimate);
		return newEstimate;
	}

	public static OpportunityLineItem newOpportunityLineItem(
		Id opportunityId,
		Id productId,
		Id pricebookEntryId
	) {
		OpportunityLineItem newOpportunityLineItem = new OpportunityLineItem();
		newOpportunityLineItem.OpportunityId = opportunityId;
		newOpportunityLineItem.Product2Id = productId;
		newOpportunityLineItem.PricebookEntryId = pricebookEntryId;
		newOpportunityLineItem.Quantity = 1;
		newOpportunityLineItem.UnitPrice = 1000;
		return newOpportunityLineItem;
	}

	public static CollaborationRequest__c newCollaborationRequest(Id sectionId, String status) {
		CollaborationRequest__c request = new CollaborationRequest__c(
			SectionId__c = sectionId,
			Status__c = status
		);
		CRUDUtility.insertRecords(request);
		return request;
	}

	public static TaskSummary__c newTaskSummary() {
		TaskSummary__c newSummary = new TaskSummary__c();
		CRUDUtility.insertRecords(newSummary);

		return newSummary;
	}

	public static TaskRoleSummary__c newTaskRoleSummary(Id taskSummaryId) {
		TaskRoleSummary__c newTaskRoleSummary = new TaskRoleSummary__c();
		newTaskRoleSummary.SummaryId__c = taskSummaryId;
		CRUDUtility.insertRecords(newTaskRoleSummary);

		return newTaskRoleSummary;
	}

	public static ActivityGroupTemplate__c newActivityGroupTemplate() {
		ActivityGroupTemplate__c newActivityGroupTemplate = new ActivityGroupTemplate__c();
		CRUDUtility.insertRecords(newActivityGroupTemplate);

		return newActivityGroupTemplate;
	}

	public static ActivityTemplate__c newActivityTemplate(Id activityGroupTemplateId) {
		ActivityTemplate__c newActivityTemplate = new ActivityTemplate__c();
		newActivityTemplate.ActivityGroupTemplateId__c = activityGroupTemplateId;
		CRUDUtility.insertRecords(newActivityTemplate);

		return newActivityTemplate;
	}

	public static Task__c newTask(Id taskTemplateId, Id roleSummaryId) {
		Task__c newTask = new Task__c();
		newTask.TemplateId__c = taskTemplateId;
		newTask.RoleSummaryId__c = roleSummaryId;
		CRUDUtility.insertRecords(newTask);

		return newTask;
	}

	public static TaskTemplate__c newTaskTemplate(Id activityTemplateId) {
		TaskTemplate__c newTaskTemplate = new TaskTemplate__c();
		newTaskTemplate.ActivityTemplateId__c = activityTemplateId;
		CRUDUtility.insertRecords(newTaskTemplate);

		return newTaskTemplate;
	}

	public static TaskParameterTemplate__c newTaskParameterTemplate(Id taskTemplateId) {
		TaskParameterTemplate__c newTaskParameterTemplate = new TaskParameterTemplate__c();
		newTaskParameterTemplate.TaskTemplateId__c = taskTemplateId;
		CRUDUtility.insertRecords(newTaskParameterTemplate);

		return newTaskParameterTemplate;
	}

	public static TaskParameterValueTemplate__c newTaskParameterValueTemplate(
		Id taskParameterTemplateId
	) {
		TaskParameterValueTemplate__c newTaskParameterValueTemplate = new TaskParameterValueTemplate__c();
		newTaskParameterValueTemplate.TaskParameterTemplateId__c = taskParameterTemplateId;
		CRUDUtility.insertRecords(newTaskParameterValueTemplate);

		return newTaskParameterValueTemplate;
	}
}
