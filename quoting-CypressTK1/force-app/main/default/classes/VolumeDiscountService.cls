/**
 *  Provus Services Quoting
 *  VolumeDiscountService
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class VolumeDiscountService {
	public static List<VolumeDiscountDto> saveVolumeDiscounts(
		List<VolumeDiscountDto> volumeDiscountDtos
	) {
		List<VolumeDiscount__c> volumeDiscountSOs = new List<VolumeDiscount__c>();

		for (Integer i = 0; i < volumeDiscountDtos.size(); i++) {
			VolumeDiscountDto volumeDiscountDto = volumeDiscountDtos[i];
			VolumeDiscount__c volumeDiscountSO = (VolumeDiscount__c) volumeDiscountDto.refreshSo();
			volumeDiscountSOs.add(volumeDiscountSO);
		}

		CRUDUtility.upsertRecords(volumeDiscountSOs);

		List<VolumeDiscountTier__c> volumeDiscountTierSOs = new List<VolumeDiscountTier__c>();
		for (Integer i = 0; i < volumeDiscountDtos.size(); i++) {
			VolumeDiscountDto volumeDiscountDto = volumeDiscountDtos[i];
			if (volumeDiscountDto.isNew) {
				Id parentVolumeDiscountId = volumeDiscountSOs[i].Id;
				for (VolumeDiscountTierDto volumeDiscountTierDto : volumeDiscountDto.tiers) {
					VolumeDiscountTier__c volDiscountTierSO = (VolumeDiscountTier__c) volumeDiscountTierDto.refreshSo();
					// associate to parent record since is new
					volDiscountTierSO.VolumeDiscountId__c = parentVolumeDiscountId;
					volumeDiscountTierSOs.add(volDiscountTierSO);
				}
			} else {
				for (VolumeDiscountTierDto volumeDiscountTierDto : volumeDiscountDto.tiers) {
					volumeDiscountTierSOs.add((VolumeDiscountTier__c) volumeDiscountTierDto.refreshSo());
				}
			}
		}

		CRUDUtility.upsertRecords(volumeDiscountTierSOs);

		// update DTO object Ids
		Integer volumeDiscountTierCount = 0;

		for (Integer i = 0; i < volumeDiscountDtos.size(); i++) {
			VolumeDiscountDto volumeDiscountDto = volumeDiscountDtos[i];
			volumeDiscountDto.id = volumeDiscountSOs[i].Id;

			for (Integer k = 0; k < volumeDiscountDto.tiers.size(); k++) {
				VolumeDiscountTierDto volumeDiscountTierDto = volumeDiscountDto.tiers[k];
				volumeDiscountTierDto.id = volumeDiscountTierSOs[volumeDiscountTierCount].Id;
				volumeDiscountTierCount++;
			}
		}

		return volumeDiscountDtos;
	}

	public static void deleteVolumeDiscounts(VolumeDiscountDto[] volumeDiscountDtos) {
		VolumeDiscount__c[] volumeDiscountSOs = new VolumeDiscount__c[0];

		for (VolumeDiscountDto volumeDiscountDto : volumeDiscountDtos) {
			// MD relationship will delete all tiers
			volumeDiscountSOs.add((VolumeDiscount__c) volumeDiscountDto.refreshSo());
		}

		CRUDUtility.deleteRecords(volumeDiscountSOs);
	}

	public static List<VolumeDiscountDto> getVolumeDiscounts(Id quoteId) {
		List<VolumeDiscountDto> volumeDiscountDtos = new List<VolumeDiscountDto>();

		List<VolumeDiscount__c> volumeDiscountSOs = [
			SELECT Id, QuoteId__c, Category__c, TotalBy__c
			FROM VolumeDiscount__c
			WHERE QuoteId__c = :quoteId
			WITH SECURITY_ENFORCED
			ORDER BY CreatedDate ASC
		];

		Set<Id> volumeDiscountIds = new Set<Id>();

		for (VolumeDiscount__c volumeDiscountSO : volumeDiscountSOs) {
			volumeDiscountIds.add(volumeDiscountSO.Id);
			volumeDiscountDtos.add(new VolumeDiscountDto(volumeDiscountSO));
		}

		List<VolumeDiscountTier__c> volumeDiscountTierSOs = [
			SELECT Id, VolumeDiscountId__c, From__c, To__c, Discount__c, Sequence__c
			FROM VolumeDiscountTier__c
			WHERE VolumeDiscountId__c IN :volumeDiscountIds
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c ASC
		];

		Map<Id, List<VolumeDiscountTierDto>> volumeDiscountTierMap = new Map<Id, List<VolumeDiscountTierDto>>();

		for (VolumeDiscountTier__c volumeDiscountTierSO : volumeDiscountTierSOs) {
			Id volumeDiscountId = volumeDiscountTierSO.VolumeDiscountId__c;

			if (!volumeDiscountTierMap.containsKey(volumeDiscountId)) {
				volumeDiscountTierMap.put(volumeDiscountId, new List<VolumeDiscountTierDto>());
			}

			volumeDiscountTierMap.get(volumeDiscountId)
				.add(new VolumeDiscountTierDto(volumeDiscountTierSO));
		}

		for (VolumeDiscountDto volumeDiscountDto : volumeDiscountDtos) {
			Id volumeDiscountId = volumeDiscountDto.id;
			if (volumeDiscountTierMap.containsKey(volumeDiscountDto.id)) {
				volumeDiscountDto.tiers = volumeDiscountTierMap.get(volumeDiscountId);
			}
		}

		return volumeDiscountDtos;
	}

	public static List<VolumeDiscountSummaryDto> getVolumeDiscountSummary(Id quoteId) {
		Map<Id, VolumeDiscountSummaryDto> discountSummaryDtosByIds = new Map<Id, VolumeDiscountSummaryDto>();

		Map<String, String> picklistValueLabelPair = new Map<String, String>();
		Schema.DescribeFieldResult fieldResult = VolumeDiscount__c.Category__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for (Schema.PicklistEntry pickListVal : ple) {
			picklistValueLabelPair.put(pickListVal.value, pickListVal.label);
		}

		for (AdjustmentVolumeDiscountTier__c discountTier : [
			SELECT
				Id,
				AdjustmentId__c,
				AdjustmentId__r.NamedRangeId__r.NamedRangeTotalId__r.AdjustedBaseAmount__c,
				AdjustmentId__r.NamedRangeId__r.NamedRangeTotalId__r.BaseExtendedCost__c,
				AdjustmentId__r.NamedRangeId__r.QuotePeriodGroupId__r.Name,
				AdjustmentId__r.NamedRangeId__r.QuotePeriodId__r.Name,
				AdjustmentId__r.Amount__c,
				VolumeDiscountTierId__r.From__c,
				VolumeDiscountTierId__r.To__c,
				VolumeDiscountTierId__r.Discount__c,
				VolumeDiscountTierId__r.Sequence__c,
				VolumeDiscountTierId__r.Id,
				VolumeDiscountTierId__r.VolumeDiscountId__c,
				VolumeDiscountTierId__r.VolumeDiscountId__r.Category__c,
				VolumeDiscountTierId__r.VolumeDiscountId__r.TotalBy__c,
				VolumeDiscountTierId__c
			FROM AdjustmentVolumeDiscountTier__c
			WHERE AdjustmentId__r.NamedRangeId__r.QuoteId__c = :quoteId
			WITH SECURITY_ENFORCED
			ORDER BY
				AdjustmentId__r.NamedRangeId__r.QuotePeriodGroupId__r.Sequence__c,
				AdjustmentId__r.NamedRangeId__r.QuotePeriodId__r.Sequence__c
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		]) {
			VolumeDiscountSummaryDto discountSummaryDto = discountSummaryDtosByIds.get(
				discountTier.VolumeDiscountTierId__r.VolumeDiscountId__c
			);
			if (discountSummaryDto == null) {
				discountSummaryDto = new VolumeDiscountSummaryDto(
					discountTier.VolumeDiscountTierId__r.VolumeDiscountId__r,
					picklistValueLabelPair
				);
			}

			discountSummaryDtosByIds.put(
				discountTier.VolumeDiscountTierId__r.VolumeDiscountId__c,
				discountSummaryDto
			);
			discountSummaryDto.appliedTierSummaries.add(
				new VolumeDiscountAppliedTierSummaryDto(discountTier)
			);
		}

		return discountSummaryDtosByIds.values();
	}
}
