/**
 *  Provus Services Quoting
 *  QuotePeriodService
 *  @2021 Provus Inc. All rights reserved.
 */
public with sharing class QuotePeriodService {
	// constants
	public static final String SOBJECT_NAME = 'QuotePeriod__c';
	public static final Integer MAX_PERIOD_COUNT = 468;

	/** Gets the quote periods for a given quote
	 * @param   quoteId Id of the quote
	 * @return  List<QuotePeriod>
	 */
	public static List<QuotePeriod> getQuotePeriods(Id quoteId) {
		List<QuotePeriod> quotePeriods = new List<QuotePeriod>();

		for (QuotePeriodGroup__c periodGroup : [
			SELECT
				Id,
				Name,
				QuoteId__c,
				QuotePeriodGroupId__c,
				Sequence__c,
				(
					SELECT
						Id,
						Name,
						EndDate__c,
						ProjectPhaseId__c,
						ProjectPhaseId__r.Name,
						QuoteId__c,
						QuotePeriodGroupId__c,
						Sequence__c,
						StartDate__c,
						Term__c
					FROM QuotePeriods__r
					ORDER BY Sequence__c ASC
				)
			FROM QuotePeriodGroup__c
			WHERE QuoteId__c = :quoteId
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c ASC
		]) {
			for (QuotePeriod__c period : periodGroup.QuotePeriods__r) {
				QuotePeriod periodStruct = new QuotePeriod();

				periodStruct.id = period.Id;
				periodStruct.name = period.Name;
				periodStruct.startDate = period.StartDate__c;
				periodStruct.endDate = period.EndDate__c;
				periodStruct.sequence = period.Sequence__c;
				periodStruct.term = period.Term__c;
				periodStruct.periodGroupName = periodGroup.Name;
				periodStruct.periodGroupId = periodGroup.Id;

				periodStruct.projectPhaseId = period.ProjectPhaseId__c;
				periodStruct.projectPhaseName = period.ProjectPhaseId__r.Name;

				quotePeriods.add(periodStruct);
			}
		}

		return quotePeriods;
	}

	public static void recreatePeriodsAndPeriodGroupsFor(List<Quote__c> quoteList) {
		if (quoteList.isEmpty()) {
			return;
		}
		List<Id> quoteIds = new List<Id>();
		Map<QuotePeriodGroup__c, List<QuotePeriod__c>> periodsByGroupMap = new Map<QuotePeriodGroup__c, List<QuotePeriod__c>>();
		for (Quote__c quoteSO : quoteList) {
			// check for validity of dates
			if (quoteSO.ServiceStartDate__c > quoteSO.ServiceEndDate__c) {
				quoteSO.addError(Label.QuoteServiceDateRangeError);
				quoteSO.ServiceStartDate__c.addError('');
				quoteSO.ServiceEndDate__c.addError('');
				continue;
			}

			quoteIds.add(quoteSO.Id);
			periodsByGroupMap.putAll(DefaultPeriodService.generatePeriods(quoteSO));
		}

		List<QuotePeriod__c> periods = [
			SELECT Id, (SELECT Id, NamedRangeTotalId__c FROM NamedRanges__r)
			FROM QuotePeriod__c
			WHERE QuoteId__c IN :quoteIds
			WITH SECURITY_ENFORCED
		];
		List<QuotePeriodGroup__c> periodGroups = [
			SELECT Id, (SELECT Id, NamedRangeTotalId__c FROM NamedRanges__r)
			FROM QuotePeriodGroup__c
			WHERE QuoteId__c IN :quoteIds
			WITH SECURITY_ENFORCED
		];
		List<NamedRange__c> namedRanges = new List<NamedRange__c>();
		List<NamedRangeTotal__c> namedRangeTotals = new List<NamedRangeTotal__c>();
		for (QuotePeriod__c quotePeriod : periods) {
			namedRanges.addAll(quotePeriod.NamedRanges__r);
		}
		for (QuotePeriodGroup__c quotePeriodGroup : periodGroups) {
			namedRanges.addAll(quotePeriodGroup.NamedRanges__r);
		}
		for (NamedRange__c namedRange : namedRanges) {
			namedRangeTotals.add(new NamedRangeTotal__c(Id = namedRange.NamedRangeTotalId__c));
		}
		CRUDUtility.deleteRecords(periods);
		CRUDUtility.deleteRecords(periodGroups);
		CRUDUtility.deleteRecords(namedRanges);
		CRUDUtility.deleteRecords(namedRangeTotals);

		insertGroupsAndPeriods(periodsByGroupMap);
	}

	public static void createPeriodsAndPeriodGroupsFor(List<Quote__c> quoteList) {
		for (Quote__c newQuote : (List<Quote__c>) quoteList) {
			// check for validity of dates
			if (newQuote.ServiceStartDate__c > newQuote.ServiceEndDate__c) {
				newQuote.addError(Label.QuoteServiceDateRangeError);
				newQuote.ServiceStartDate__c.addError('');
				newQuote.ServiceEndDate__c.addError('');
			}

			Map<QuotePeriodGroup__c, List<QuotePeriod__c>> periodsByGroupMap = newQuote.TimePeriodsAlignment__c ==
				QuoteService.TIMEPERIODSALIGNMENT_WEEKDAY_CALENDAR
				? WeekdayPeriodService.generatePeriods(newQuote)
				: DefaultPeriodService.generatePeriods(newQuote);

			insertGroupsAndPeriods(periodsByGroupMap);
		}
	}

	/**
	 * Adds periods to existing quote
	 *
	 * @param numberOfPeriodsToAdd number of periods
	 * @param quoteId user-defined schedule setting
	 * @param timePeriod user selected time period
	 */
	public static void addRemoveQuotePeriods(
		Decimal numberOfPeriodsToAdd,
		Id quoteId,
		String timePeriod
	) {
		Quote__c quote = [
			SELECT ServiceStartDate__c, ServiceEndDate__c, TimePeriod__c, TimePeriodsGroupMethod__c
			FROM Quote__c
			WHERE Id = :quoteId
			WITH SECURITY_ENFORCED
		];

		IPeriodUnit periodUnit = PeriodUnits.getPeriodUnit(
			numberOfPeriodsToAdd,
			new PeriodUnits(SettingsService.getScheduleSettingsForQuote(quoteId)),
			timePeriod
		);

		Decimal numberOfPeriods = periodUnit.toPeriodUnit(quote.TimePeriod__c).getAmount();

		ITimePeriod timePeriodCalc = TimePeriodFactory.newTimePeriod(quote.TimePeriod__c);

		// if quote exists get current state of periods such as total count, last group sequence value and period group
		// record
		QuotePeriodState quotePeriodState = QuotePeriodService.getQuotePeriodState(quoteId);

		IQuotePeriodGenerator periodGenerator = new QuotePeriodGenerator(
			timePeriodCalc,
			quote,
			quotePeriodState
		);
		List<QuotePeriod__c> periodsForQuote = periodGenerator.newPeriods(
			(Integer) Math.ceil(numberOfPeriods)
		);

		Integer numberOfPeriodsInGroup = DurationCalcs.numberOfPeriodsInAGroup(
			quote.TimePeriod__c,
			quote.TimePeriodsGroupMethod__c
		);

		Map<QuotePeriodGroup__c, List<QuotePeriod__c>> periodGroupsMap = new QuotePeriodGroupBuilder(
				quote,
				quotePeriodState
			)
			.buildQuotePeriodGroups(periodsForQuote, numberOfPeriodsInGroup);

		insertGroupsAndPeriods(periodGroupsMap);

		RuntimeContext.skipQuoteTrigger = true;
		quote.ServiceEndDate__c = periodsForQuote[periodsForQuote.size() - 1].EndDate__c;
		CRUDUtility.updateRecords(quote);
		RuntimeContext.skipQuoteTrigger = false;
	}

	public static void insertGroupsAndPeriods(
		Map<QuotePeriodGroup__c, List<QuotePeriod__c>> periodsByGroupMap
	) {
		if (periodsByGroupMap.size() > 0) {
			Map<Integer, QuotePeriodGroup__c> qpgMap = new Map<Integer, QuotePeriodGroup__c>();
			Map<Integer, List<QuotePeriod__c>> qpListMap = new Map<Integer, List<QuotePeriod__c>>();

			Integer count = 1;
			for (QuotePeriodGroup__c qpg : periodsByGroupMap.keySet()) {
				qpgMap.put(count, qpg);
				qpListMap.put(count, periodsByGroupMap.get(qpg));
				count++;
			}
			CRUDUtility.upsertRecords(qpgMap.values());

			List<QuotePeriod__c> periodList = new List<QuotePeriod__c>();
			for (Integer cnt : qpgMap.keySet()) {
				for (QuotePeriod__c qp : qpListMap.get(cnt)) {
					qp.QuotePeriodGroupId__c = qpgMap.get(cnt).Id;
				}
				periodList.addAll(qpListMap.get(cnt));
			}
			CRUDUtility.insertRecords(periodList);
		}
	}

	/**
	 * Get quote's period status details
	 *
	 * @param quoteId id of quote
	 *
	 * @return quote period status object with status details
	 */
	public static QuotePeriodState getQuotePeriodState(Id quoteId) {
		QuotePeriodState quotePeriodState = new QuotePeriodState();

		AggregateResult[] groupedPeriodsState = [
			SELECT COUNT(Id) TotalCount, MAX(QuotePeriodGroupId__c) QuotePeriodGroupId
			FROM QuotePeriod__c
			WHERE QuoteId__c = :quoteId
			WITH SECURITY_ENFORCED
			ORDER BY MAX(Sequence__c)
		];

		if (groupedPeriodsState.size() == 1) {
			AggregateResult ar = groupedPeriodsState[0];
			Integer totalPeriodCount = (Integer) ar.get('TotalCount');
			if (totalPeriodCount > 0) {
				quotePeriodState.totalCount = totalPeriodCount;
			}

			Id lastQuotePeriodGroupId = (Id) ar.get('QuotePeriodGroupId');
			if (lastQuotePeriodGroupId != null) {
				quotePeriodState = getLastGroupDetail(
					groupedPeriodsState,
					lastQuotePeriodGroupId,
					quotePeriodState
				);
			}
		}

		quotePeriodState.previousExist =
			quotePeriodState.previousGroup != null &&
			quotePeriodState.totalCount > 0;

		return quotePeriodState;
	}

	private static QuotePeriodState getLastGroupDetail(
		AggregateResult[] groupedPeriodsState,
		Id lastQuotePeriodGroupId,
		QuotePeriodState quotePeriodState
	) {
		AggregateResult[] quotePeriodGroupAggregateResults = [
			SELECT
				COUNT(Id) NumberOfPeriodsInGroup,
				MAX(QuotePeriodGroupId__c) QuotePeriodGroupId,
				MAX(QuotePeriodGroupId__r.Sequence__c) QuotePeriodGroupSequence
			FROM QuotePeriod__c
			WHERE QuotePeriodGroupId__c = :lastQuotePeriodGroupId
			WITH SECURITY_ENFORCED
		];

		if (groupedPeriodsState.size() == 1) {
			AggregateResult periodGroupAggregateResult = quotePeriodGroupAggregateResults[0];
			QuotePeriodGroup__c quotePeriodGroup = new QuotePeriodGroup__c(
				Id = (Id) periodGroupAggregateResult.get('QuotePeriodGroupId'),
				Sequence__c = (Decimal) periodGroupAggregateResult.get('QuotePeriodGroupSequence')
			);

			quotePeriodState.lastGroupCount = (Integer) periodGroupAggregateResult.get(
				'NumberOfPeriodsInGroup'
			);
			quotePeriodState.previousGroup = quotePeriodGroup;
		}

		return quotePeriodState;
	}
}
