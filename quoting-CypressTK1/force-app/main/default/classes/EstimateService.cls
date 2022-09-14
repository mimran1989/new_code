public with sharing class EstimateService {
	public static Date getServiceEndDate(Id estimateId, EndDateArgs endDateArgs) {
		Decimal totalDuration = 0;

		Map<Id, Decimal> maxTotalByGroupId = getActivityGroupMaxDurations(estimateId);
		for (Decimal groupResult : maxTotalByGroupId.values()) {
			totalDuration += groupResult;
		}

		if (endDateArgs.calendarAlignment == QuoteService.TIMEPERIODSALIGNMENT_WEEKDAY_CALENDAR) {
			return DurationCalcs.weekdayEndDate(totalDuration, endDateArgs.serviceStartDate);
		}

		return DurationCalcs.endDate(totalDuration, endDateArgs.quoteId, endDateArgs.serviceStartDate);
	}

	/**
	 * Get the maximum duration of each activity group
	 *
	 * @param estimateId  the context estimate id
	 * @return max duration of each activity group
	 */
	@TestVisible
	private static Map<Id, Decimal> getActivityGroupMaxDurations(Id estimateId) {
		Map<Id, Decimal> maxTotalByGroupId = new Map<Id, Decimal>();
		List<TaskRoleSummary__c> taskRoleSummaries = [
			SELECT
				Id,
				ActivityGroupId__c,
				TotalEstimatedDuration__c,
				(SELECT Id, FullTimeTotalEstimatedDuration__c FROM ResourceAvailabilities__r LIMIT 1),
				(SELECT Id, SplitPercentage__c, TotalEstimatedDuration__c FROM ResourceSplits__r)
			FROM TaskRoleSummary__c
			WHERE ActivityGroupId__r.EstimateId__c = :estimateId AND TotalEstimatedDuration__c > 0
			WITH SECURITY_ENFORCED
		];

		for (TaskRoleSummary taskRoleSummary : TaskRoleSummary.toTaskRoleSummary(taskRoleSummaries)) {
			TaskRoleSummary__c taskRoleSummarySo = (TaskRoleSummary__c) taskRoleSummary.getSObject();
			Id activityGroupId = taskRoleSummarySo.ActivityGroupId__c;
			Decimal maxDuration = taskRoleSummary.maxEstimatedDuration();
			Decimal maxDurationForActivityGroup = maxTotalByGroupId.get(activityGroupId);
			if (maxDurationForActivityGroup == null) {
				maxDurationForActivityGroup = maxDuration;
			} else {
				maxDurationForActivityGroup = Math.max(maxDurationForActivityGroup, maxDuration);
			}
			maxTotalByGroupId.put(activityGroupId, maxDurationForActivityGroup);
		}

		return maxTotalByGroupId;
	}

	public static Set<Id> filterOrderedRoles(Set<Id> orderedRoleIds, Set<Id> toFilter) {
		Set<Id> sortedApplicableRoleIds = new Set<Id>();
		for (Id roleId : orderedRoleIds) {
			if (toFilter.contains(roleId)) {
				sortedApplicableRoleIds.add(roleId);
			}
		}

		return sortedApplicableRoleIds;
	}

	public static Decimal getAvailabilityPercentage(TaskRoleSummary__c taskRoleSummary) {
		Decimal availabilityPercentage = 100;
		if (!taskRoleSummary.ResourceAvailabilities__r.isEmpty()) {
			// we onlny support 1 availbility percentage per role, per group
			availabilityPercentage = taskRoleSummary.ResourceAvailabilities__r[0]
				.AvailabilityPercentage__c;
		}

		return availabilityPercentage;
	}

	public static QuoteItem__c createQuoteItem(
		CreateQuoteFromEstimateService.CreateQuoteItemRequest createQuoteItemReq,
		Map<Id, RateCardItem__c> rateCardItemByRoleId
	) {
		QuoteSection__c section = createQuoteItemReq.section;
		QuoteItem__c item = new QuoteItem__c();
		item.QuoteId__c = section.QuoteId__c;
		item.QuoteSectionId__c = section.Id;
		item.Sequence__c = createQuoteItemReq.sequence++;
		item.SectionSequence__c = createQuoteItemReq.sectionSequence; // sequence of quote item within its section
		item.DisplaySequence__c = section.DisplaySequence__c; // inherit display sequence of section
		item.ProductId__c = createQuoteItemReq.roleId;
		item.RateCardItemId__c = rateCardItemByRoleId.get(createQuoteItemReq.roleId)?.Id;
		item.SkillLevel__c = rateCardItemByRoleId.get(createQuoteItemReq.roleId)?.SkillLevel__c;
		item.LocationDisplayName__c = rateCardItemByRoleId.get(createQuoteItemReq.roleId)
			?.LocationDisplayName__c;
		return item;
	}

	public static String quoteItemSplitRolesKey(QuoteItem__c quoteItem) {
		return quoteItem.ProductId__c +
			'-' +
			quoteItem.Sequence__c +
			'-' +
			quoteItem.SectionSequence__c;
	}

	public static void createQuoteItemCells(
		Quote__c quoteSO,
		CreateQuoteFromEstimateService.CreateQuoteItemsResponse quoteItemsResponse,
		Map<String, Decimal> durationByRole
	) {
		List<QuoteItem__c> quoteItems = quoteItemsResponse.quoteItems;
		List<QuoteItemCell__c> itemCells = new List<QuoteItemCell__c>();
		Integer sectionStartCellIndex = 1;
		Integer sectionEndCellIndex = 1;
		Id currentSectionId = quoteItems.get(0).QuoteSectionId__c;

		Map<Decimal, PeriodDetails> termByPeriodSequence = getTermByPeriodSequence(quoteSO);
		Decimal minimumCarryoverHours = termByPeriodSequence.get(sectionEndCellIndex).workableHours;

		for (QuoteItem__c quoteItemSO : quoteItems) {
			String roleSequenceKey = generateRoleSequenceKey(quoteItemSO);
			if (currentSectionId != quoteItemSO.QuoteSectionId__c) {
				sectionStartCellIndex = sectionEndCellIndex + 1; // new section starts at the farthest found cell index of the previous section
				if (minimumCarryoverHours > 0) {
					sectionStartCellIndex -= 1; // start in the same starting period as the previous section end
					termByPeriodSequence.get(sectionStartCellIndex).workableHours = minimumCarryoverHours; // reduce the workable hours to the smallest carryover we're allowed
				} else {
					minimumCarryoverHours = termByPeriodSequence.get(sectionStartCellIndex).workableHours;
				}

				currentSectionId = quoteItemSO.QuoteSectionId__c;
			}

			Decimal availabilityPercentage = quoteItemsResponse.availabilityPercentageByRoleKey.get(
				roleSequenceKey
			);
			Decimal itemDuration = durationByRole.get(roleSequenceKey);
			Decimal splitPercent = quoteItemsResponse.quoteItemSplitsById.get(
				quoteItemSplitRolesKey(quoteItemSO)
			);
			// if no corresponding split value we assume no split and set to 1
			splitPercent = splitPercent == null ? 1 : splitPercent / 100;
			// reduce period span by the equivalent of the splint percentage
			itemDuration = itemDuration * splitPercent;

			QuoteItemCellService.QuoteItemCellRequest itemCellRequest = new QuoteItemCellService.QuoteItemCellRequest();
			itemCellRequest.itemDurationHours = itemDuration;
			itemCellRequest.startCellIndex = sectionStartCellIndex;
			itemCellRequest.availabilityPercentage = availabilityPercentage;
			itemCellRequest.isLaborUnitsInHours = quoteSO.LaborUnits__c == QuoteService.LABORUNITS_HOURS;

			QuoteItemCellService.QuoteItemCellResponse itemCellResp = QuoteItemCellService.createQuoteItemCell(
				itemCellRequest,
				termByPeriodSequence
			);

			itemCellResp.quoteItemCell.QuoteItemId__c = quoteItemSO.Id;
			itemCells.add(itemCellResp.quoteItemCell);

			if (itemCellResp.endCellIndex > sectionEndCellIndex) {
				// we're in a new period, reset the minimum
				sectionEndCellIndex = itemCellResp.endCellIndex;
				minimumCarryoverHours =
					termByPeriodSequence.get(sectionEndCellIndex).workableHours - itemCellResp.endCellHours;
			}

			if (itemCellResp.endCellIndex == sectionEndCellIndex) {
				// compare against same column index
				minimumCarryoverHours = Math.min(
					minimumCarryoverHours,
					termByPeriodSequence.get(sectionEndCellIndex).workableHours - itemCellResp.endCellHours
				);
			}
		}
		CRUDUtility.insertRecords(itemCells);
	}

	public class PeriodDetails {
		public Decimal workableHours;
		public Decimal periodHours;
	}

	public static Map<Decimal, PeriodDetails> getTermByPeriodSequence(Quote__c quoteSo) {
		Map<Decimal, PeriodDetails> termByPeriodSequence = new Map<Decimal, PeriodDetails>();
		Decimal standardHours = DurationCalcs.numberOfHoursInPeriod(quoteSo.TimePeriod__c);
		IWeekdayTimePeriod timePeriodCalc = WeekdayTimePeriodFactory.newTimePeriod(
			quoteSo.TimePeriod__c
		);
		List<QuotePeriod> periods = QuotePeriodService.getQuotePeriods(quoteSo.Id);
		for (QuotePeriod period : periods) {
			PeriodDetails details = new PeriodDetails();
			if (quoteSo.TimePeriodsAlignment__c == QuoteService.TIMEPERIODSALIGNMENT_WEEKDAY_CALENDAR) {
				details.workableHours =
					SettingsService.getScheduleSettings().standardDayHours *
					Calendar.weekdaysIn(period.startDate, period.endDate);
				details.periodHours = timePeriodCalc.periodHours(period.startDate);
			} else {
				details.workableHours = standardHours;
				details.periodHours = standardHours;
			}

			termByPeriodSequence.put(period.sequence, details);
		}

		return termByPeriodSequence;
	}

	public static String generateRoleSequenceKey(QuoteItem__c quoteItem) {
		return quoteItem.ProductId__c + '-' + quoteItem.DisplaySequence__c;
	}

	public static String generateRoleSequenceKey(Id roleId, QuoteSection__c quoteSection) {
		return roleId + '-' + quoteSection.DisplaySequence__c;
	}

	public static Set<Id> getOrderedResourceRoles(Id estimateId) {
		Set<Id> orderedResources = new Set<Id>();
		List<ActivityGroup__c> groups = [
			SELECT
				Id,
				(SELECT ResourceRoleId__c FROM RoleSummaries__r WHERE TotalEstimatedDuration__c > 0)
			FROM ActivityGroup__c
			WHERE EstimateId__c = :estimateId
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c
		];

		for (ActivityGroup__c grp : groups) {
			for (TaskRoleSummary__c summary : grp.RoleSummaries__r) {
				orderedResources.add(summary.ResourceRoleId__c);
			}
		}

		return orderedResources;
	}

	public static Map<Id, RateCardItem__c> getRateCardItemPreferences(Id estimateId) {
		Map<Id, RateCardItem__c> rateCardItemByRoleId = new Map<Id, RateCardItem__c>();
		for (TaskRoleSummary__c roleSummary : [
			SELECT
				ResourceRoleId__c,
				RateCardItemId__r.Id,
				RateCardItemId__r.SkillLevel__c,
				RateCardItemId__r.LocationDisplayName__c
			FROM TaskRoleSummary__c
			WHERE EstimateId__c = :estimateId AND RateCardItemId__c != NULL
			WITH SECURITY_ENFORCED
		]) {
			rateCardItemByRoleId.put(roleSummary.ResourceRoleId__c, roleSummary.RateCardItemId__r);
		}

		return rateCardItemByRoleId;
	}
}
