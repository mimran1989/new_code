public with sharing class SyncEstimateToQuoteService {
	public static String syncEstimateToQuote(Id estimateId) {
		List<Quote__c> quotes = [
			SELECT
				Id,
				Name,
				EstimateId__c,
				RateCardId__c,
				TimePeriod__c,
				ServiceStartDate__c,
				ServiceEndDate__c,
				TimePeriodsAlignment__c,
				TimePeriodsGroupMethod__c,
				LaborUnits__c
			FROM Quote__c
			WHERE EstimateId__c = :estimateId
			WITH SECURITY_ENFORCED
			LIMIT 1
		];

		if (quotes == null || quotes.size() == 0) {
			throw new ApplicationException(System.Label.EstimateNotLinkedQuoteError);
		}

		Quote__c quoteSO = quotes[0];
		EndDateArgs endDateArgs = new EndDateArgs();
		endDateArgs.timePeriods = quoteSO.TimePeriod__c;
		endDateArgs.calendarAlignment = quoteSO.TimePeriodsAlignment__c;
		endDateArgs.serviceStartDate = quoteSO.ServiceStartDate__c;

		Date newServiceEndDate = EstimateService.getServiceEndDate(estimateId, endDateArgs);

		if (quoteSO.ServiceEndDate__c != newServiceEndDate) {
			quoteSO.ServiceEndDate__c = newServiceEndDate;
			CRUDUtility.updateRecords(quoteSO);
		}

		updateSections(quoteSO);
		return quoteSO.Name;
	}

	private static void updateSections(Quote__c quoteSO) {
		List<ActivityGroup__c> groups = ActivityGroupService.getApplicableGroups(quoteSO.EstimateId__c);
		EstimateActivityGroupIterator activityGroupIterator = new EstimateActivityGroupIterator(groups);
		Set<Id> orderedRoleIds = EstimateService.getOrderedResourceRoles(quoteSO.EstimateId__c);

		Map<Id, QuoteSection__c> sectionsByActivityGroup = QuoteSectionService.getQuoteSectionsByActivityGroup(
			quoteSO.Id
		);

		List<QuoteSection__c> sections = new List<QuoteSection__c>();
		Map<String, Decimal> durationsBySectionRole = new Map<String, Decimal>();
		Set<Id> allTaskRoleSummaryIds = new Set<Id>();
		Integer sequence = 1;
		CreateQuoteFromEstimateService.QuoteItemsCreationDetail quoteItemCreationDetails = new CreateQuoteFromEstimateService.QuoteItemsCreationDetail();
		quoteItemCreationDetails.quoteId = quoteSO.Id;
		Map<Id, RateCardItem__c> rateCardItemByRoleId = EstimateService.getRateCardItemPreferences(
			quoteSO.EstimateId__c
		);

		while (activityGroupIterator.hasNext()) {
			ActivityGroup__c activityGroup = activityGroupIterator.next();
			QuoteSection__c section = sectionsByActivityGroup.get(activityGroup.Id);
			if (section == null) {
				section = new QuoteSection__c();
				section.Name = activityGroup.Name;
				section.Sequence__c = activityGroup.Sequence__c;
				section.DisplaySequence__c = activityGroup.Sequence__c;
				section.QuoteId__c = quoteSO.Id;
				section.ActivityGroupId__c = activityGroup.Id;
			}
			sections.add(section);
			sequence += 1;

			CreateQuoteFromEstimateService.QuoteSectionDetails sectionDetails = new CreateQuoteFromEstimateService.QuoteSectionDetails();
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
		quoteItemCreationDetails.allTaskRoleSummaryIds = allTaskRoleSummaryIds;
		CRUDUtility.upsertRecords(sections);

		// list of resource split records by task role summary id as the key
		CreateQuoteFromEstimateService.CreateQuoteItemsResponse createQuoteItemsResp = updateQuoteItems(
			quoteItemCreationDetails,
			rateCardItemByRoleId
		);

		CRUDUtility.upsertRecords(createQuoteItemsResp.quoteItems);
		if (!createQuoteItemsResp.quoteItems.isEmpty()) {
			deleteExistingCells(createQuoteItemsResp);
			EstimateService.createQuoteItemCells(quoteSO, createQuoteItemsResp, durationsBySectionRole);
		}
	}

	private static void deleteExistingCells(
		CreateQuoteFromEstimateService.CreateQuoteItemsResponse createQuoteItemsResp
	) {
		Map<Id, QuoteItem__c> quoteItems = new Map<Id, QuoteItem__c>(createQuoteItemsResp.quoteItems);
		List<QuoteItemCell__c> cells = [
			SELECT Id
			FROM QuoteItemCell__c
			WHERE QuoteItemId__c IN :quoteItems.keySet()
			WITH SECURITY_ENFORCED
		];
		CRUDUtility.deleteRecords(cells);
	}

	private static CreateQuoteFromEstimateService.CreateQuoteItemsResponse updateQuoteItems(
		CreateQuoteFromEstimateService.QuoteItemsCreationDetail quoteItemRequest,
		Map<Id, RateCardItem__c> rateCardItemByRoleId
	) {
		Map<Id, Map<String, QuoteItem__c>> quoteItemsBySectionRoleId = new Map<Id, Map<String, QuoteItem__c>>();
		for (
			QuoteItem__c quoteItemSO : QuoteItemServiceSupport.getQuoteItemSOsForQuote(
				quoteItemRequest.quoteId
			)
		) {
			if (quoteItemSO.LineType__c == QuoteItem.LINE_TYPE_MISCELLANEOUS) {
				continue;
			}

			if (!quoteItemsBySectionRoleId.containsKey(quoteItemSO.QuoteSectionId__c)) {
				quoteItemsBySectionRoleId.put(
					quoteItemSO.QuoteSectionId__c,
					new Map<String, QuoteItem__c>()
				);
			}
			Map<String, QuoteItem__c> itemsByRoleId = quoteItemsBySectionRoleId.get(
				quoteItemSO.QuoteSectionId__c
			);
			String itemKey = EstimateService.quoteItemSplitRolesKey(quoteItemSO);
			if (!itemsByRoleId.containsKey(itemKey)) {
				itemsByRoleId.put(itemKey, quoteItemSO);
			}
		}

		Set<Id> existingSections = quoteItemsBySectionRoleId.keySet();
		Set<Id> allTaskRoleSummaryIds = quoteItemRequest.allTaskRoleSummaryIds;
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

		CreateQuoteFromEstimateService.CreateQuoteItemsResponse response = new CreateQuoteFromEstimateService.CreateQuoteItemsResponse();

		for (
			CreateQuoteFromEstimateService.QuoteSectionDetails sectionRequest : quoteItemRequest.sectionRequests
		) {
			for (Id roleId : sectionRequest.roleIds) {
				Id taskRoleSummaryId = sectionRequest.taskRoleSummaryIds.get(roleId);
				TaskRoleSummary__c taskRoleSummary = taskRoleSummariesMap.get(taskRoleSummaryId);

				// set availability percentage
				response.availabilityPercentageByRoleKey.put(
					roleId +
					'-' +
					sectionRequest.section.Sequence__c,
					EstimateService.getAvailabilityPercentage(taskRoleSummary)
				);
			}

			Map<String, QuoteItem__c> existingItems = new Map<String, QuoteItem__c>();
			if (quoteItemsBySectionRoleId.containsKey(sectionRequest.section.Id)) {
				existingItems = quoteItemsBySectionRoleId.get(sectionRequest.section.Id);
			}
			existingSections.remove(sectionRequest.section.Id);
			QuoteItemRequest request = new QuoteItemRequest();
			request.sectionRequest = sectionRequest;
			request.existingItems = existingItems;
			request.quoteItemRequest = quoteItemRequest;
			request.taskRoleSummariesMap = taskRoleSummariesMap;
			request.rateCardItemByRoleId = rateCardItemByRoleId;

			CreateQuoteFromEstimateService.CreateQuoteItemsResponse sectionResponse = updateQuoteItems(
				quoteItemRequest,
				request
			);
			response.quoteItems.addAll(sectionResponse.quoteItems);
			response.quoteItemSplitsById.putAll(sectionResponse.quoteItemSplitsById);
		}

		deleteRemovedSections(existingSections, quoteItemsBySectionRoleId);

		return response;
	}

	private static void deleteRemovedSections(
		Set<Id> existingSections,
		Map<Id, Map<String, QuoteItem__c>> quoteItemsBySectionRoleId
	) {
		if (!existingSections.isEmpty()) {
			List<QuoteSection__c> deleteSections = new List<QuoteSection__c>();
			List<QuoteItem__c> deleteQuoteItems = new List<QuoteItem__c>();
			for (Id sectionId : existingSections) {
				if (quoteItemsBySectionRoleId.containsKey(sectionId)) {
					Map<String, QuoteItem__c> existingItems = quoteItemsBySectionRoleId.get(sectionId);
					deleteSections.add(new QuoteSection__c(Id = sectionId));
					deleteQuoteItems.addAll(existingItems.values());
				}
			}

			CRUDUtility.deleteRecords(deleteQuoteItems);
			CRUDUtility.deleteRecords(deleteSections);
		}
	}

	private static CreateQuoteFromEstimateService.CreateQuoteItemsResponse updateQuoteItems(
		CreateQuoteFromEstimateService.QuoteItemsCreationDetail quoteItemsCreationDetail,
		QuoteItemRequest request
	) {
		CreateQuoteFromEstimateService.CreateQuoteItemsResponse response = new CreateQuoteFromEstimateService.CreateQuoteItemsResponse();
		CreateQuoteFromEstimateService.CreateQuoteItemRequest quoteItemReq = new CreateQuoteFromEstimateService.CreateQuoteItemRequest();
		quoteItemReq.section = request.sectionRequest.section;
		quoteItemReq.sectionSequence = 1;
		quoteItemReq.sequence = ++quoteItemsCreationDetail.sequence;

		Set<String> existingRoleIds = request.existingItems.keySet();
		for (Id roleId : request.sectionRequest.roleIds) {
			quoteItemReq.roleId = roleId;
			// get task role summary id for role id
			Id taskRoleSummaryId = request.sectionRequest.taskRoleSummaryIds.get(roleId);
			TaskRoleSummary__c taskRoleSummary = request.taskRoleSummariesMap.get(taskRoleSummaryId);
			List<ResourceSplit__c> splits = taskRoleSummary.ResourceSplits__r;
			if (splits != null && splits.size() > 0) {
				// create quote item for each corresponding split record
				for (ResourceSplit__c splitPercent : splits) {
					QuoteItem__c newItem = createQuoteItem(quoteItemReq, request, existingRoleIds);
					// store split value by derived key
					response.quoteItemSplitsById.put(
						EstimateService.quoteItemSplitRolesKey(newItem),
						splitPercent.SplitPercentage__c
					);
					response.quoteItems.add(newItem);
					quoteItemReq.sectionSequence++;
				}
			} else {
				QuoteItem__c newItem = createQuoteItem(quoteItemReq, request, existingRoleIds);
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

		deleteRemovedItems(existingRoleIds, request);
		return response;
	}

	private static QuoteItem__c createQuoteItem(
		CreateQuoteFromEstimateService.CreateQuoteItemRequest quoteItemReq,
		QuoteItemRequest request,
		Set<String> existingRoleIds
	) {
		QuoteItem__c newItem = EstimateService.createQuoteItem(
			quoteItemReq,
			request.rateCardItemByRoleId
		);

		String itemKey = EstimateService.quoteItemSplitRolesKey(newItem);
		if (request.existingItems.containsKey(itemKey)) {
			newItem = request.existingItems.get(itemKey);
			existingRoleIds.remove(itemKey);
		}

		return newItem;
	}

	private static void deleteRemovedItems(Set<String> existingRoleIds, QuoteItemRequest request) {
		if (!existingRoleIds.isEmpty()) {
			List<QuoteItem__c> deleteItems = new List<QuoteItem__c>();
			for (String roleId : existingRoleIds) {
				deleteItems.add(request.existingItems.get(roleId));
			}
			CRUDUtility.deleteRecords(deleteItems);
		}
	}

	private class QuoteItemRequest {
		CreateQuoteFromEstimateService.QuoteSectionDetails sectionRequest;
		Map<String, QuoteItem__c> existingItems;
		CreateQuoteFromEstimateService.QuoteItemsCreationDetail quoteItemRequest;
		Map<Id, TaskRoleSummary__c> taskRoleSummariesMap;
		Map<Id, RateCardItem__c> rateCardItemByRoleId;
	}
}
