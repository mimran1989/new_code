/**
 *  Provus Services Quoting
 *  NamedRangeService
 *  @2021 Provus Inc. All rights reserved.
 */
public with sharing class NamedRangeService {
	public static List<NamedRange__c> getNamedRangesForSummaries(Id quoteId) {
		return [
			SELECT
				Id,
				Type__c,
				NamedRangeTotalId__c,
				NamedRangeTotalId__r.AdjustedBaseAmount__c,
				NamedRangeTotalId__r.BaseExtendedAmount__c,
				NamedRangeTotalId__r.NetExtendedAmount__c,
				NamedRangeTotalId__r.Name,
				NamedRangeTotalId__r.Quantity__c,
				NamedRangeTotalId__r.NetExtendedCost__c,
				NamedRangeTotalId__r.MarginPercent__c,
				QuoteItemId__r.UnitCost__c,
				QuoteItemId__r.ProductId__r.Name,
				QuoteItemId__r.RoleNameOverride__c,
				QuoteItemId__r.LocationCountry__c,
				QuoteItemId__r.QuoteSectionId__r.Name,
				QuoteItemId__r.QuoteSectionId__r.DisplaySequence__c,
				QuoteId__r.TimePeriod__c,
				ProjectPhaseId__c,
				ProjectPhaseId__r.Name,
				ProjectPhaseId__r.Sequence__c,
				QuotePeriodGroupId__r.Name,
				QuotePeriodGroupId__r.Sequence__c,
				QuotePeriodId__r.Name
			FROM NamedRange__c
			WHERE
				QuoteId__c = :quoteId
				AND (Type__c = :ProjectPhaseService.NRTYPE_QUOTE_PERIOD_GROUP
				OR Type__c = :ProjectPhaseService.NRTYPE_PROJECT_PHASE
				OR Type__c = :ProjectPhaseService.NRTYPE_QUOTE_ITEM)
			WITH SECURITY_ENFORCED
			ORDER BY CreatedDate DESC
		];
	}

	public static NamedRange.NamedRangeDO getQuoteTotalForQuote(Id quoteId) {
		List<NamedRange> namedRanges = getNamedRangeMOsForQuote(quoteId);
		NamedRange.NamedRangeDO quoteTotalNamedRange = null;
		for (NamedRange namedRange : namedRanges) {
			if (namedRange.isQuoteTotal()) {
				quoteTotalNamedRange = (NamedRange.NamedRangeDO) namedRange.baseDTO;
				break;
			}
		}

		return quoteTotalNamedRange;
	}

	@AuraEnabled
	public static List<NamedRange.NamedRangeDO> getNamedRangesForQuote(Id quoteId) {
		List<NamedRange.NamedRangeDO> namedRangeDOs = new List<NamedRange.NamedRangeDO>();
		for (NamedRange namedRange : getNamedRangeMOsForQuote(quoteId)) {
			namedRangeDOs.add((NamedRange.NamedRangeDO) namedRange.baseDTO);
		}
		return namedRangeDOs;
	}

	/**
	 * Gets all namedranges for a quote
	 * @param   quoteId Id of the quote
	 * @return  List<NamedRange>
	 */
	private static List<NamedRange> getNamedRangeMOsForQuote(Id quoteId) {
		Map<Id, NamedRange> namedRangeDtoById = new Map<Id, NamedRange>();
		List<NamedRange__c> namedRangeSos = [
			SELECT
				Id,
				Name,
				ProjectPhaseId__c,
				QuoteId__c,
				QuoteItemId__c,
				QuotePeriodId__c,
				QuotePeriodGroupId__c,
				QuoteSectionId__c,
				RangeSpecJSON__c,
				Type__c,
				NamedRangeTotalId__c,
				NamedRangeTotalId__r.AdjustedBaseAmount__c,
				NamedRangeTotalId__r.MarginPercent__c,
				NamedRangeTotalId__r.BaseExtendedAmount__c,
				NamedRangeTotalId__r.BaseExtendedCost__c,
				NamedRangeTotalId__r.NetExtendedAmount__c,
				NamedRangeTotalId__r.NetExtendedCost__c,
				NamedRangeTotalId__r.Quantity__c,
				NamedRangeTotalId__r.QuantityUOM__c
			FROM NamedRange__c
			WHERE QuoteId__c = :quoteId
			WITH SECURITY_ENFORCED
		];

		for (NamedRange__c namedRangeSO : namedRangeSos) {
			NamedRange namedRange = new NamedRange(namedRangeSO);
			namedRangeDtoById.put(namedRangeSO.Id, namedRange);
		}

		for (Adjustment__c adjustmentSo : [
			SELECT
				Id,
				Amount__c,
				AppliedBy__c,
				AppliedTo__c,
				Method__c,
				Sequence__c,
				Type__c,
				NamedRangeId__c,
				(
					SELECT VolumeDiscountTierId__r.VolumeDiscountId__r.Category__c
					FROM AdjustmentVolumeDiscountTiers__r
				),
				(SELECT LocationDiscountId__c FROM LocationDiscountAdjustments__r)
			FROM Adjustment__c
			WHERE NamedRangeId__c IN :namedRangeDtoById.keySet()
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c
		]) {
			NamedRange namedRangeDto = namedRangeDtoById.get(adjustmentSo.NamedRangeId__c);
			((NamedRange.NamedRangeDO) namedRangeDto.baseDTO)
				.adjustmentList.add(new AdjustmentDTO(adjustmentSo));
		}

		return namedRangeDtoById.values();
	}

	/**
	 * commit namedranges for a quote
	 *
	 * @param namedRangeColData JSON string containing named range col data
	 *
	 * @return boolean indicating result of commit
	 */
	public static Boolean commitNamedRanges(String namedRangeColData) {
		List<NamedRange.NamedRangeDO> namedRangeDOs = (List<NamedRange.NamedRangeDO>) JSON.deserialize(
			namedRangeColData,
			List<NamedRange.NamedRangeDO>.class
		);

		List<NamedRange> requestNamedRanges = new List<NamedRange>();

		for (NamedRange.NamedRangeDO namedRangeDO : namedRangeDOs) {
			NamedRange namedRange = new NamedRange(namedRangeDO);
			requestNamedRanges.add(namedRange);
		}

		NamedRange.commitNamedRanges(requestNamedRanges);

		Boolean isSuccess = true;
		return isSuccess;
	}
}
