/**
 *  Provus Services Quoting
 *  @2021 Provus Inc. All rights reserved.
 */
public with sharing class CreateQuoteFromEstimateService {
	//String Values
	private static final String STATUS_DRAFT = 'Draft';

	public static QuoteDO getEstimateQuoteDetails(Estimate__c estimateSO) {
		QuoteDO quoteData = new QuoteDO();
		quoteData.isPrimary = true;
		quoteData.description = estimateSO.Description__c;
		quoteData.rateCardId = estimateSO.RateCardId__c;
		quoteData.estimateId = estimateSO.Id;
		quoteData.status = STATUS_DRAFT;
		quoteData.serviceId = estimateSO.ServiceId__c;
		quoteData.practice = estimateSO.ServiceId__r.Practice__c;
		quoteData.groupValue = estimateSO.ServiceId__r.Group__c;

		if (Account.SObjectType.getDescribe().isAccessible()) {
			quoteData.accountId = estimateSO.AccountId__c;
		}
		if (Opportunity.SObjectType.getDescribe().isAccessible()) {
			quoteData.opportunityId = estimateSO.OpportunityId__c;
		}

		return quoteData;
	}

	public static void convertEntitiesFromEstimate(Quote__c quote) {
		createSections(quote);
	}

	@TestVisible
	private static void createSections(Quote__c quoteSO) {
		List<ActivityGroup__c> groups = ActivityGroupService.getApplicableGroups(quoteSO.EstimateId__c);
		EstimateActivityGroupIterator activityGroupIterator = new EstimateActivityGroupIterator(groups);
		Set<Id> orderedRoleIds = EstimateService.getOrderedResourceRoles(quoteSO.EstimateId__c);

		List<QuoteSection__c> sections = new List<QuoteSection__c>();
		Map<String, Decimal> durationsBySectionRole = new Map<String, Decimal>();
		Set<Id> allTaskRoleSummaryIds = new Set<Id>();
		QuoteItemsCreationDetail quoteItemCreationDetails = new QuoteItemsCreationDetail();
		Map<Id, RateCardItem__c> rateCardItemByRoleId = EstimateService.getRateCardItemPreferences(
			quoteSO.EstimateId__c
		);

		while (activityGroupIterator.hasNext()) {
			ActivityGroup__c activityGroup = activityGroupIterator.next();
			QuoteSection__c section = new QuoteSection__c();
			section.Name = activityGroup.Name;
			section.Sequence__c = activityGroup.Sequence__c;
			section.DisplaySequence__c = activityGroup.Sequence__c;
			section.QuoteId__c = quoteSO.Id;
			section.ActivityGroupId__c = activityGroup.Id;
			sections.add(section);

			QuoteSectionDetails sectionDetails = new QuoteSectionDetails();
			Set<Id> roleIds = new Set<Id>();
			for (TaskRoleSummary__c summary : activityGroup.RoleSummaries__r) {
				String durationRoleKey = EstimateService.generateRoleSequenceKey(
					summary.ResourceRoleId__c,
					section
				);

				durationsBySectionRole.put(durationRoleKey, summary.TotalEstimatedDuration__c);
				allTaskRoleSummaryIds.add(summary.Id);
				sectionDetails.taskRoleSummaryIds.put(summary.ResourceRoleId__c, summary.Id);
				roleIds.add(summary.ResourceRoleId__c);
			}

			sectionDetails.section = section;
			sectionDetails.roleIds = EstimateService.filterOrderedRoles(orderedRoleIds, roleIds);
			quoteItemCreationDetails.sectionRequests.add(sectionDetails);
			quoteItemCreationDetails.sequence = activityGroup.Sequence__c;
		}

		CRUDUtility.insertRecords(sections);

		// list of resource split records by task role summary id as the key
		CreateQuoteItemsResponse createQuoteItemsResp = createQuoteItems(
			quoteItemCreationDetails,
			allTaskRoleSummaryIds,
			rateCardItemByRoleId
		);

		CRUDUtility.insertRecords(createQuoteItemsResp.quoteItems);
		if (!createQuoteItemsResp.quoteItems.isEmpty()) {
			EstimateService.createQuoteItemCells(quoteSO, createQuoteItemsResp, durationsBySectionRole);
		}
	}

	private static CreateQuoteItemsResponse createQuoteItems(
		QuoteItemsCreationDetail quoteItemRequest,
		Set<Id> allTaskRoleSummaryIds,
		Map<Id, RateCardItem__c> rateCardItemByRoleId
	) {
		CreateQuoteItemsResponse response = new CreateQuoteItemsResponse();
		// get task role splits
		List<TaskRoleSummary__c> taskRoleSummaries = [
			SELECT
				Id,
				ResourceRoleId__c,
				(SELECT SplitPercentage__c FROM ResourceSplits__r ORDER BY Sequence__c),
				(SELECT AvailabilityPercentage__c FROM ResourceAvailabilities__r LIMIT 1)
			FROM TaskRoleSummary__c
			WHERE Id IN :allTaskRoleSummaryIds
			WITH SECURITY_ENFORCED
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		];

		Map<Id, TaskRoleSummary__c> taskRoleSummariesMap = new Map<Id, TaskRoleSummary__c>(
			taskRoleSummaries
		);

		CreateQuoteItemRequest quoteItemReq = new CreateQuoteItemRequest();
		quoteItemReq.sequence = ++quoteItemRequest.sequence; // quote item sequences start after the last section sequence

		for (QuoteSectionDetails sectionRequest : quoteItemRequest.sectionRequests) {
			quoteItemReq.section = sectionRequest.section;
			quoteItemReq.sectionSequence = 1;

			for (Id roleId : sectionRequest.roleIds) {
				quoteItemReq.roleId = roleId;

				// get task role summary id for role id
				Id roleSummaryId = sectionRequest.taskRoleSummaryIds.get(roleId);
				TaskRoleSummary__c taskRoleSummary = taskRoleSummariesMap.get(roleSummaryId);
				List<ResourceSplit__c> splits = taskRoleSummary.ResourceSplits__r;
				if (splits != null && splits.size() > 0) {
					// create quote item for each corresponding split record
					for (ResourceSplit__c splitPercent : splits) {
						QuoteItem__c newItem = EstimateService.createQuoteItem(
							quoteItemReq,
							rateCardItemByRoleId
						);
						// store split value by derived key
						response.quoteItemSplitsById.put(
							EstimateService.quoteItemSplitRolesKey(newItem),
							splitPercent.SplitPercentage__c
						);
						response.quoteItems.add(newItem);
						quoteItemReq.sectionSequence++;
					}
				} else {
					QuoteItem__c newItem = EstimateService.createQuoteItem(
						quoteItemReq,
						rateCardItemByRoleId
					);
					response.quoteItems.add(newItem);
					quoteItemReq.sectionSequence++;
				}

				// set availability percentage
				response.availabilityPercentageByRoleKey.put(
					roleId +
					'-' +
					quoteItemReq.section.Sequence__c,
					EstimateService.getAvailabilityPercentage(taskRoleSummary)
				);
			}
		}

		return response;
	}

	public class QuoteSectionDetails {
		public Set<Id> roleIds;
		public Map<Id, Id> taskRoleSummaryIds = new Map<Id, Id>();
		public QuoteSection__c section;
	}

	public class QuoteItemsCreationDetail {
		public List<QuoteSectionDetails> sectionRequests = new List<QuoteSectionDetails>();
		public Id quoteId;
		public Set<Id> allTaskRoleSummaryIds = new Set<Id>();
		public Decimal sequence = 1;
	}

	public class CreateQuoteItemRequest {
		public QuoteSection__c section;
		public Integer sectionSequence;
		public Id roleId;
		public Decimal sequence;
	}

	public class CreateQuoteItemsResponse {
		public Map<String, Decimal> quoteItemSplitsById = new Map<String, Decimal>();
		public List<QuoteItem__c> quoteItems = new List<QuoteItem__c>();
		public Map<String, Decimal> availabilityPercentageByRoleKey = new Map<String, Decimal>();
	}
}
