/**
 *  Provus Services Quoting
 *  QuoteItemDO
 *  @2021 Provus Inc. All rights reserved.
 */
public class QuoteItemDTO extends BaseDTO {
	public static final String LINE_TYPE_MISCELLANEOUS = 'Miscellaneous';

	@AuraEnabled
	public Boolean isMiscellaneous = false;
	@AuraEnabled
	public Decimal displaySequence;
	@AuraEnabled
	public Decimal lineSequence;
	@AuraEnabled
	public Decimal sectionSequence;
	@AuraEnabled
	public Id adjustmentId;
	@AuraEnabled
	public Id productId;
	@AuraEnabled
	public Id quoteId;
	@AuraEnabled
	public Id quoteItemCellId;
	@AuraEnabled
	public Id rateCardItemId;
	@AuraEnabled
	public Id sectionId;
	@AuraEnabled
	public Boolean nonBillable;
	@AuraEnabled
	public Location location;

	@AuraEnabled
	public AdjustmentDTO adjustment = new AdjustmentDTO();

	@AuraEnabled
	public QuoteItem__c quoteItemSO;
	@AuraEnabled
	public Map<String, Decimal> periodValueMap;

	public static QuoteItemDTO newDO(QuoteItem__c quoteItemSO) {
		QuoteItemDTO newDTO = new QuoteItemDTO();
		newDTO.quoteItemSO = quoteItemSO;
		newDTO.id = quoteItemSO.Id;
		newDTO.quoteId = quoteItemSO.QuoteId__c;
		newDTO.productId = quoteItemSO.ProductId__c;
		newDTO.rateCardItemId = quoteItemSO.RateCardItemId__c;
		newDTO.lineSequence = quoteItemSO.Sequence__c;
		newDTO.sectionSequence = quoteItemSO.SectionSequence__c;
		newDTO.displaySequence = quoteItemSO.DisplaySequence__c;
		newDTO.adjustmentId = quoteItemSO.AdjustmentId__c;
		newDTO.adjustment.type = quoteItemSO.AdjustmentId__r.Type__c;
		newDTO.adjustment.amount = quoteItemSO.AdjustmentId__r.Amount__c;
		newDTO.periodValueMap = new Map<String, Decimal>();
		newDTO.sectionId = quoteItemSO.QuoteSectionId__c;
		newDTO.nonBillable = quoteItemSO.NonBillable__c;
		newDTO.location = new Location();
		newDTO.location.country = quoteItemSO.RateCardItemId__r.LocationCountry__c;
		newDTO.location.state = quoteItemSO.RateCardItemId__r.LocationStateProvince__c;
		newDTO.location.city = quoteItemSO.RateCardItemId__r.LocationCity__c;

		if (!quoteItemSO.QuoteItemCells__r.isEmpty()) {
			newDTO.quoteItemCellId = quoteItemSO.QuoteItemCells__r[0].Id;
			newDTO.periodValueMap = QuoteItemCellService.convertToPeriodValueMaps(
					quoteItemSO.QuoteItemCells__r
				)
				.get(quoteItemSO.Id);
		}

		return newDTO;
	}

	public void refreshDO() {
		this.id = this.quoteItemSO.Id;
		this.quoteId = this.quoteItemSO.QuoteId__c;
		this.productId = this.quoteItemSO.ProductId__c;
		this.rateCardItemId = this.quoteItemSO.RateCardItemId__c;
		this.lineSequence = this.quoteItemSO.Sequence__c;
		this.nonBillable = this.quoteItemSO.NonBillable__c;
		this.displaySequence = this.quoteItemSO.DisplaySequence__c;
		this.adjustmentId = this.quoteItemSO.AdjustmentId__c;
	}

	public override SObject refreshSo() {
		if (this.quoteItemSO == null) {
			this.quoteItemSO = new QuoteItem__c();
		}

		quoteItemSO.Id = this.id;
		if (quoteItemSO.QuoteId__c == null) {
			quoteItemSO.QuoteId__c = this.quoteId;
		}

		quoteItemSO.DisplaySequence__c = this.displaySequence;
		quoteItemSO.ProductId__c = this.productId;
		quoteItemSO.QuoteSectionId__c = this.sectionId;
		quoteItemSO.RateCardItemId__c = this.rateCardItemId;
		quoteItemSO.SectionSequence__c = this.sectionSequence;
		quoteItemSO.Sequence__c = this.lineSequence;

		this.isMiscellaneous = quoteItemSO.LineType__c == LINE_TYPE_MISCELLANEOUS;

		return this.quoteItemSO;
	}
}
