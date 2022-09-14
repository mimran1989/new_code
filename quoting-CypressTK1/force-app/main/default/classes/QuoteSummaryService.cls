/**
 *  Provus Services Quoting
 *  @2021 Provus Inc. All rights reserved.
 */
public with sharing class QuoteSummaryService {
	public static List<QuoteSummaryDO> getQuoteSummaries(Id quoteId) {
		Map<String, QuoteSummaryDO> summariesByRangeName = generateSummaryDOs(quoteId);
		Map<String, QuoteSummaryDO> mapTotals = generateTotals(summariesByRangeName);
		setPercentageOfTotalFields(mapTotals, summariesByRangeName);
		for (String key : mapTotals.keySet()) {
			summariesByRangeName.put(key, mapTotals.get(key));
		}

		List<QuoteSummaryDO> summaries = summariesByRangeName.values();
		summaries.sort();
		if (!summaries.isEmpty()) {
			Quote__c quoteSO = [
				SELECT LaborUnits__c
				FROM Quote__c
				WHERE Id = :quoteId
				WITH SECURITY_ENFORCED
			];
			if (quoteSO != null && quoteSO.LaborUnits__c == 'Hours') {
				summaries[0].timePeriod = System.Label.Hours;
			}
		}
		return summaries;
	}

	private static Map<String, QuoteSummaryDO> generateSummaryDOs(Id quoteId) {
		Map<String, QuoteSummaryDO> summariesByRangeName = new Map<String, QuoteSummaryDO>();

		for (NamedRange__c namedRangeSO : NamedRangeService.getNamedRangesForSummaries(quoteId)) {
			String rangeType = getRangeType(namedRangeSO);
			String rangeName = getRangeName(namedRangeSO);

			if (rangeName == null) {
				continue;
			}

			createSummary(summariesByRangeName, namedRangeSO);
			createLocationSummary(summariesByRangeName, namedRangeSO);
			createSectionSummary(summariesByRangeName, namedRangeSO);

			if (rangeType == QuoteSummary.SUMMARYTYPE_ROLE) {
				createOverrideSummary(summariesByRangeName, namedRangeSO);
			}
		}

		return summariesByRangeName;
	}

	private static void createSummary(
		Map<String, QuoteSummaryDO> summariesByRangeName,
		NamedRange__c namedRangeSO
	) {
		String rangeType = getRangeType(namedRangeSO);
		String rangeName = getRangeName(namedRangeSO);
		QuoteSummaryDO summary = summariesByRangeName.get(rangeName);
		if (summary == null) {
			QuoteSummaryDO quoteStruct = new QuoteSummaryDO(rangeType, rangeName);
			quoteStruct.setSummary(namedRangeSO);
			summariesByRangeName.put(rangeName, quoteStruct);
		} else {
			summary.addToSummary(namedRangeSO);
		}
	}

	private static void createSectionSummary(
		Map<String, QuoteSummaryDO> summariesByRangeName,
		NamedRange__c namedRangeSO
	) {
		if (namedRangeSO.Type__c != ProjectPhaseService.NRTYPE_QUOTE_ITEM) {
			return;
		}

		String sectionName = namedRangeSO.QuoteItemId__r.QuoteSectionId__r.Name;
		QuoteSummaryDO summary = summariesByRangeName.get(sectionName);
		if (summary == null) {
			QuoteSummaryDO quoteStruct = new QuoteSummaryDO(
				QuoteSummary.SUMMARYTYPE_SECTION,
				sectionName
			);
			quoteStruct.setSummary(namedRangeSO);
			summariesByRangeName.put(sectionName, quoteStruct);
		} else {
			summary.addToSummary(namedRangeSO);
		}
	}

	private static void createLocationSummary(
		Map<String, QuoteSummaryDO> summariesByRangeName,
		NamedRange__c namedRangeSO
	) {
		if (namedRangeSO.Type__c != ProjectPhaseService.NRTYPE_QUOTE_ITEM) {
			return;
		}

		String locationName = namedRangeSO.QuoteItemId__r.LocationCountry__c;
		QuoteSummaryDO summary = summariesByRangeName.get(locationName);
		if (summary == null) {
			QuoteSummaryDO quoteStruct = new QuoteSummaryDO(
				QuoteSummary.SUMMARYTYPE_LOCATION,
				locationName
			);
			quoteStruct.setSummary(namedRangeSO);
			summariesByRangeName.put(locationName, quoteStruct);
		} else {
			summary.addToSummary(namedRangeSO);
		}
	}
	private static void createOverrideSummary(
		Map<String, QuoteSummaryDO> summariesByRangeName,
		NamedRange__c namedRangeSO
	) {
		String rangeName = getRangeName(namedRangeSO);
		String overrideName = namedRangeSO.Type__c == ProjectPhaseService.NRTYPE_QUOTE_ITEM
			? namedRangeSO.QuoteItemId__r.RoleNameOverride__c
			: null;
		String overrideSummaryName = overrideName != null ? overrideName : rangeName;
		QuoteSummaryDO overrideSummary = summariesByRangeName.get('override_' + overrideSummaryName);

		if (overrideSummary == null) {
			QuoteSummaryDO newSummary = new QuoteSummaryDO(
				QuoteSummary.SUMMARYTYPE_ROLE_OVERRIDE,
				overrideSummaryName
			);
			newSummary.setSummary(namedRangeSO);
			summariesByRangeName.put('override_' + overrideSummaryName, newSummary);
		} else {
			overrideSummary.addToSummary(namedRangeSO);
		}
	}

	private static String getRangeType(NamedRange__c range) {
		Map<String, String> mapRangeTypeToName = new Map<String, String>();
		mapRangeTypeToName.put(ProjectPhaseService.NRTYPE_QUOTE_ITEM, QuoteSummary.SUMMARYTYPE_ROLE);
		mapRangeTypeToName.put(
			ProjectPhaseService.NRTYPE_QUOTE_PERIOD_GROUP,
			QuoteSummary.SUMMARYTYPE_PERIOD_GROUP
		);
		mapRangeTypeToName.put(
			ProjectPhaseService.NRTYPE_PROJECT_PHASE,
			QuoteSummary.SUMMARYTYPE_PROJECT_PHASE
		);

		return mapRangeTypeToName?.get(range.Type__c);
	}

	private static String getRangeName(NamedRange__c range) {
		if (range.Type__c == ProjectPhaseService.NRTYPE_QUOTE_ITEM) {
			return range.QuoteItemId__r.ProductId__r.Name;
		} else if (range.Type__c == ProjectPhaseService.NRTYPE_QUOTE_PERIOD_GROUP) {
			return range.QuotePeriodGroupId__r.Name;
		} else if (range.Type__c == ProjectPhaseService.NRTYPE_PROJECT_PHASE) {
			return range.ProjectPhaseId__r.Name;
		}

		return null;
	}

	private static Map<String, QuoteSummaryDO> generateTotals(
		Map<String, QuoteSummaryDO> mapQuoteStruct
	) {
		Map<String, QuoteSummaryDO> mapTotals = new Map<String, QuoteSummaryDO>();
		for (QuoteSummaryDO summaryDO : mapQuoteStruct.values()) {
			String summaryType;
			String summaryName;
			switch on summaryDO.type {
				when 'role' {
					summaryType = QuoteSummary.SUMMARYTYPE_RESOURCE_TOTALS;
					summaryName = System.Label.ResourceRoleTotals;
				}
				when 'projectPhase' {
					summaryType = QuoteSummary.SUMMARYTYPE_PROJECT_PHASE_TOTALS;
					summaryName = System.Label.ProjectPhaseTotals;
				}
				when 'periodGroup' {
					summaryType = QuoteSummary.SUMMARYTYPE_PERIOD_GROUP_TOTALS;
					summaryName = System.Label.PeriodGroupTotals;
				}
				when 'role_override' {
					summaryType = QuoteSummary.SUMMARYTYPE_RESOURCE_OVERRIDE_TOTALS;
					summaryName = System.Label.ResourceRoleTotals;
				}
				when 'location' {
					summaryType = QuoteSummary.SUMMARYTYPE_LOCATION_TOTALS;
					summaryName = System.Label.locationTotals;
				}
				when 'section' {
					summaryType = QuoteSummary.SUMMARYTYPE_SECTION_TOTALS;
					summaryName = System.Label.SectionTotals;
				}
			}

			if (summaryName == null) {
				continue;
			}

			if (!mapTotals.containsKey(summaryType)) {
				QuoteSummaryDO quoteStructTotal = new QuoteSummaryDO(summaryType, summaryName);
				quoteStructTotal.setSummary(summaryDO);
				mapTotals.put(summaryType, quoteStructTotal);
			} else {
				mapTotals.get(summaryType).addToSummary(summaryDO);
			}
		}
		return mapTotals;
	}

	private static void setPercentageOfTotalFields(
		Map<String, QuoteSummaryDO> mapTotals,
		Map<String, QuoteSummaryDO> mapQuoteStruct
	) {
		Map<String, QuoteSummaryDO> totalsByType = new Map<String, QuoteSummaryDO>();
		for (QuoteSummaryDO totals : mapTotals.values()) {
			totalsByType.put(totals.type, totals);
		}

		for (QuoteSummaryDO summary : mapQuoteStruct.values()) {
			QuoteSummaryDO totals;
			switch on summary.type {
				when 'role' {
					totals = totalsByType.get(QuoteSummary.SUMMARYTYPE_RESOURCE_TOTALS);
				}
				when 'projectPhase' {
					totals = totalsByType.get(QuoteSummary.SUMMARYTYPE_PROJECT_PHASE_TOTALS);
				}
				when 'periodGroup' {
					totals = totalsByType.get(QuoteSummary.SUMMARYTYPE_PERIOD_GROUP_TOTALS);
				}
				when 'role_override' {
					totals = totalsByType.get(QuoteSummary.SUMMARYTYPE_RESOURCE_OVERRIDE_TOTALS);
				}
				when 'location' {
					totals = totalsByType.get(QuoteSummary.SUMMARYTYPE_LOCATION_TOTALS);
				}
				when 'section' {
					totals = totalsByType.get(QuoteSummary.SUMMARYTYPE_SECTION_TOTALS);
				}
			}

			if (totals != null) {
				summary.calculatePercentages(totals);
			}
		}
	}
}
