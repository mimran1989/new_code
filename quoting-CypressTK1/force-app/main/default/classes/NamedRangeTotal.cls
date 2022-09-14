/**
 *  Provus Services Quoting
 *  NamedRangeTotal
 *  @2021 Provus Inc. All rights reserved.
 */
public with sharing class NamedRangeTotal extends ManagedObject {
	// constants
	public static final String SOBJECT_NAME = 'NamedRangeTotal__c';
	public static final String FIELD_NAME_QUOTE_ID = 'QuoteId__c';
	public static final String QUOTE_TOTAL_NAMED_RANGE = 'Quote Totals';
	public static final String LABOR_AMOUNT_NAMED_RANGE = 'Labor Amount';
	public static final String ADDON_TOTAL_NAMED_RANGE = 'Add-Ons Amount';

	public class NamedRangeTotalDO extends BaseDTO {
		@AuraEnabled
		public Decimal adjustedBaseAmount;
		@AuraEnabled
		public Decimal netExtendedAmount;
		@AuraEnabled
		public Decimal baseExtendedAmount;
		@AuraEnabled
		public Decimal baseExtendedCost;
		@AuraEnabled
		public Decimal netExtendedCost;
		@AuraEnabled
		public Decimal marginPercent;
		@AuraEnabled
		public Decimal totalQuantity;
		@AuraEnabled
		public String quantityUOM;
		@AuraEnabled
		public Id namedRangeTotalId;

		public override SObject refreshSo() {
			return null;
		}
	}

	public NamedRangeTotal(Id quoteId, NamedRangeTotalDO namedRangeTotalDO) {
		super(namedRangeTotalDO);
		this.pSObject = NamedRangeTotal.newNamedRangeTotalSO(quoteId, namedRangeTotalDO);
	}

	public static NamedRangeTotalDO newNamedRangeTotalDO(NamedRangeTotal__c namedRangeTotalSO) {
		NamedRangeTotalDO namedRangeTotalDO = new NamedRangeTotalDO();
		namedRangeTotalDO.namedRangeTotalId = namedRangeTotalSO.Id;
		namedRangeTotalDO.adjustedBaseAmount = SystemUtility.nullToZero(
			namedRangeTotalSO.AdjustedBaseAmount__c
		);
		namedRangeTotalDO.netExtendedAmount = SystemUtility.nullToZero(
			namedRangeTotalSO.NetExtendedAmount__c
		);
		namedRangeTotalDO.baseExtendedAmount = SystemUtility.nullToZero(
			namedRangeTotalSO.BaseExtendedAmount__c
		);

		namedRangeTotalDO.netExtendedCost = SystemUtility.nullToZero(
			namedRangeTotalSO.NetExtendedCost__c
		);

		// handle legacy data
		if (
			namedRangeTotalSO.BaseExtendedCost__c == null &&
			namedRangeTotalSO.NetExtendedCost__c != null
		) {
			namedRangeTotalDO.baseExtendedCost = SystemUtility.nullToZero(
				namedRangeTotalSO.NetExtendedCost__c
			);
		} else {
			namedRangeTotalDO.baseExtendedCost = SystemUtility.nullToZero(
				namedRangeTotalSO.BaseExtendedCost__c
			);
		}

		namedRangeTotalDO.totalQuantity = SystemUtility.nullToZero(namedRangeTotalSO.Quantity__c);
		namedRangeTotalDO.quantityUOM = namedRangeTotalSO.QuantityUOM__c;
		namedRangeTotalDO.marginPercent = SystemUtility.nullToZero(namedRangeTotalSO.MarginPercent__c);
		return namedRangeTotalDO;
	}

	private static NamedRangeTotal__c newNamedRangeTotalSO(
		Id quoteId,
		NamedRangeTotalDO namedRangeTotalDO
	) {
		NamedRangeTotal__c namedRangeTotalSO = new NamedRangeTotal__c(
			AdjustedBaseAmount__c = namedRangeTotalDO.adjustedBaseAmount,
			NetExtendedAmount__c = namedRangeTotalDO.netExtendedAmount,
			BaseExtendedAmount__c = namedRangeTotalDO.baseExtendedAmount,
			BaseExtendedCost__c = namedRangeTotalDO.baseExtendedCost,
			NetExtendedCost__c = namedRangeTotalDO.netExtendedCost,
			MarginPercent__c = namedRangeTotalDO.marginPercent,
			Quantity__c = namedRangeTotalDO.totalQuantity,
			QuantityUOM__c = namedRangeTotalDO.quantityUOM,
			Id = namedRangeTotalDO.namedRangeTotalId,
			QuoteId__c = quoteId
		);
		return namedRangeTotalSO;
	}
}
