/**
 *  Provus Services Quoting
 *  @2021 Provus Inc. All rights reserved.
 */
public with sharing class AdjustmentService {
	public class AdjustmentCloneInfo {
		private Map<Id, Map<Id, SObject>> copiedItems;
		Map<Id, Set<Id>> oldToNewItemIds = new Map<Id, Set<Id>>();
		Map<Id, Id> newToOldId = new Map<Id, Id>();

		public AdjustmentCloneInfo(Map<Id, Map<Id, SObject>> copiedQuoteItems) {
			this.copiedItems = copiedQuoteItems;
			for (Map<Id, SObject> quoteItemsByOldId : this.copiedItems.values()) {
				for (Id oldItemId : quoteItemsByOldId.keySet()) {
					QuoteItem__c quoteItem = (QuoteItem__c) quoteItemsByOldId.get(oldItemId);
					if (quoteItem.Id != null) {
						Set<Id> newItemIds = this.oldToNewItemIds.get(oldItemId);
						if (newItemIds == null) {
							newItemIds = new Set<Id>();
							this.oldToNewItemIds.put(oldItemId, newItemIds);
						}
						this.newToOldId.put(quoteItem.AdjustmentId__c, oldItemId);
						newItemIds.add(quoteItem.Id);
					}
				}
			}
		}

		public Map<Id, Set<Id>> getOldToNewIds() {
			return oldToNewItemIds;
		}

		public Map<Id, Id> getNewToOldIds() {
			return newToOldId;
		}
	}

	public static Map<Id, Adjustment__c> getAdjustmentsToInsert(AdjustmentCloneInfo adjCloneInfo) {
		// STEP V - Clone the adjustment records
		QueryRequest queryRequest = new QueryRequest(Adjustment__c.SObjectType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(
			Schema.Adjustment__c.SObjectType
		);
		queryRequest.setFilterBy(
			new Map<String, Set<Id>>{
				SObjectUtility.FIELD_ID => new Set<Id>(adjCloneInfo.getNewToOldIds().keySet())
			}
		);
		List<Adjustment__c> newAdjustments = (List<Adjustment__c>) SOQLUtility.querySObject(
			queryRequest
		);

		Map<Id, Adjustment__c> adjustmentsToInsert = new Map<Id, Adjustment__c>();
		Id userId = UserInfo.getUserId();
		for (Adjustment__c adjustment : newAdjustments) {
			for (
				Id newId : adjCloneInfo.getOldToNewIds()
					.get(adjCloneInfo.getNewToOldIds().get(adjustment.Id))
			) {
				Adjustment__c newAdjustment = adjustment.clone(false, true);
				newAdjustment.OwnerId = userId;
				adjustmentsToInsert.put(newId, newAdjustment);
			}
		}
		return adjustmentsToInsert;
	}

	public static List<QuoteItem__c> updateAdjustmentIdOnQuoteItems(
		Map<Id, Adjustment__c> adjustmentsToInsert
	) {
		// STEP VI - Quote items adjustment record
		List<QuoteItem__c> quoteItemsToUpdate = new List<QuoteItem__c>();
		for (Id newQuoteItemId : adjustmentsToInsert.keySet()) {
			String quoteItemIdString = String.valueOf(newQuoteItemId);
			if (String.isNotBlank(quoteItemIdString)) {
				quoteItemsToUpdate.add(
					new QuoteItem__c(
						Id = newQuoteItemId,
						AdjustmentId__c = adjustmentsToInsert.get(newQuoteItemId).Id
					)
				);
			}
		}

		CRUDUtility.updateRecords(quoteItemsToUpdate);

		return quoteItemsToUpdate;
	}

	public static List<QuoteItemCell__c> getQuoteItemCellsToInsert(AdjustmentCloneInfo adjCloneInfo) {
		// STEP VII - Clone the quote item cells
		List<QuoteItemCell__c> quoteItemCellsToInsert = new List<QuoteItemCell__c>();
		Map<Id, Map<Id, SObject>> newQuoteItemCells = SystemUtility.cloneChildEntities(
			QuoteItemCell__c.SObjectType,
			QuoteItemCell.FIELD_NAME_QUOTE_ITEM_ID,
			adjCloneInfo.getOldToNewIds()
		);

		if (newQuoteItemCells.size() > 0) {
			for (Map<Id, SObject> quoteItemCellsByOldId : newQuoteItemCells.values()) {
				quoteItemCellsToInsert.addAll((List<QuoteItemCell__c>) quoteItemCellsByOldId.values());
			}
		}
		return quoteItemCellsToInsert;
	}

	public static void commitAdjustmentJunctions(List<Adjustment> adjustments) {
		List<Adjustment> adjustmentsWithTiers = new List<Adjustment>();
		List<Adjustment> adjustmentsWithLocationDiscount = new List<Adjustment>();
		for (Adjustment adjustment : adjustments) {
			AdjustmentDTO adjustmentDto = (AdjustmentDTO) adjustment.baseDTO;
			if (!adjustment.isDelete()) {
				if (adjustmentDto.tierId != null) {
					adjustmentsWithTiers.add(adjustment);
				}
				if (adjustmentDto.locationDiscountId != null) {
					adjustmentsWithLocationDiscount.add(adjustment);
				}
			}
		}

		commitAdjustmentVolumeDiscountTiers(adjustmentsWithTiers);
		commitAdjustmentLocationDiscounts(adjustmentsWithLocationDiscount);
	}

	private static void commitAdjustmentVolumeDiscountTiers(List<Adjustment> adjustments) {
		List<Id> adjustmentIds = new List<Id>();
		for (Adjustment adjustment : adjustments) {
			adjustmentIds.add(adjustment.getSObject().Id);
		}

		Map<Id, AdjustmentVolumeDiscountTier__c> junctionByAdjustmentId = new Map<Id, AdjustmentVolumeDiscountTier__c>();
		List<AdjustmentVolumeDiscountTier__c> junctionsForAdjustments = [
			SELECT Id, AdjustmentId__c
			FROM AdjustmentVolumeDiscountTier__c
			WHERE AdjustmentId__c IN :adjustmentIds
			WITH SECURITY_ENFORCED
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		];

		if (!junctionsForAdjustments.isEmpty()) {
			junctionByAdjustmentId = (Map<Id, AdjustmentVolumeDiscountTier__c>) SystemUtility.keyByIdType(
				junctionsForAdjustments,
				Schema.AdjustmentVolumeDiscountTier__c.AdjustmentId__c
			);
		}

		List<AdjustmentVolumeDiscountTier__c> updatedJunctions = new List<AdjustmentVolumeDiscountTier__c>();
		for (Adjustment adjustment : adjustments) {
			Adjustment__c adjustmentSO = (Adjustment__c) adjustment.getSObject();
			AdjustmentDTO adjustmentDto = (AdjustmentDTO) adjustment.baseDTO;
			updatedJunctions.add(
				new AdjustmentVolumeDiscountTier__c(
					Id = junctionByAdjustmentId.get(adjustmentSO.Id)?.Id,
					AdjustmentId__c = adjustmentSO.Id,
					VolumeDiscountTierId__c = adjustmentDto.tierId
				)
			);
		}

		CRUDUtility.upsertRecords(updatedJunctions);
	}

	private static void commitAdjustmentLocationDiscounts(List<Adjustment> adjustments) {
		List<Id> adjustmentIds = new List<Id>();
		for (Adjustment adjustment : adjustments) {
			adjustmentIds.add(adjustment.getSObject().Id);
		}

		Map<Id, LocationDiscountAdjustment__c> junctionByAdjustmentId = new Map<Id, LocationDiscountAdjustment__c>();
		List<LocationDiscountAdjustment__c> junctionsForAdjustments = [
			SELECT Id, AdjustmentId__c
			FROM LocationDiscountAdjustment__c
			WHERE AdjustmentId__c IN :adjustmentIds
			WITH SECURITY_ENFORCED
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		];

		if (!junctionsForAdjustments.isEmpty()) {
			junctionByAdjustmentId = (Map<Id, LocationDiscountAdjustment__c>) SystemUtility.keyByIdType(
				junctionsForAdjustments,
				Schema.LocationDiscountAdjustment__c.AdjustmentId__c
			);
		}

		List<LocationDiscountAdjustment__c> updatedJunctions = new List<LocationDiscountAdjustment__c>();
		for (Adjustment adjustment : adjustments) {
			Adjustment__c adjustmentSO = (Adjustment__c) adjustment.getSObject();
			AdjustmentDTO adjustmentDto = (AdjustmentDTO) adjustment.baseDTO;
			updatedJunctions.add(
				new LocationDiscountAdjustment__c(
					Id = junctionByAdjustmentId.get(adjustmentSO.Id)?.Id,
					AdjustmentId__c = adjustmentSO.Id,
					LocationDiscountId__c = adjustmentDto.locationDiscountId
				)
			);
		}

		CRUDUtility.upsertRecords(updatedJunctions);
	}
}
