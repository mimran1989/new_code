/**
 *  Provus Services Quoting
 *  QuoteItemSectionControllerTest
 *  @2022 Provus Inc. All rights reserved.
 */
@IsTest
private class QuoteItemSectionControllerTest extends TestBase {
	static final Integer START_POSITION = 5;
	static final Integer MAX_PERIOD_COUNT =
		QuotePeriodService.MAX_PERIOD_COUNT - (START_POSITION * 2);

	@TestSetup
	static void setup() {
		Quote__c quoteSO = newQuote();
		quoteSO.Name = 'Quote Item Cell Service Test';
		CRUDUtility.updateRecords(quoteSO);

		Id productTypeId = SObjectUtility.getRecordTypeIdbyName(
			Schema.Product__c.SObjectType + '',
			'Product'
		);
		Product__c productSO = newProduct('Main Product', productTypeId);
		CRUDUtility.insertRecords(productSO);

		QuoteSection__c quoteSectionSO = newQuoteSection(quoteSO.Id);

		QuoteItem__c quoteItemSO = new QuoteItem__c();
		quoteItemSO.QuoteId__c = quoteSO.Id;
		quoteItemSO.QuoteSectionId__c = quoteSectionSO.Id;
		quoteItemSO.ProductId__c = productSO.Id;
		quoteItemSO.Sequence__c = 1;

		CRUDUtility.insertRecords(quoteItemSO);

		QuoteItemCell__c itemCellSO = new QuoteItemCell__c();
		itemCellSO.QuoteItemId__c = quoteItemSO.Id;

		for (Integer k = START_POSITION; k <= MAX_PERIOD_COUNT; k++) {
			String shiftFromColName = QuoteItemCellService.cellColumnName(k);
			itemCellSO.put(shiftFromColName, 1);
		}

		CRUDUtility.insertRecords(itemCellSO);
	}

	@IsTest
	static void shiftQuoteCellValuesRightByFour() {
		Test.startTest();
		List<QuoteItem__c> quoteItems = [
			SELECT Id, QuoteSectionId__c
			FROM QuoteItem__c
			WHERE QuoteId__r.Name = 'Quote Item Cell Service Test'
		];

		// shift cell values right by 4 positions
		Integer shiftFactor = 4;
		Map<Id, Map<String, Decimal>> quoteItemCells = QuoteItemSectionController.shiftQuoteItemSection(
			quoteItems[0].QuoteSectionId__c,
			shiftFactor
		);
		Map<String, Decimal> quoteItemCell = quoteItemCells.values()[0];
		System.assertEquals(1, quoteItemCell.get('009'), 'value at cell 9 is 1');
		System.assertEquals(1, quoteItemCell.get('' + MAX_PERIOD_COUNT), 'value at cell 9 is 1');
		Test.stopTest();
	}

	@IsTest
	static void shiftQuoteCellValuesLeftByFour() {
		Test.startTest();
		List<QuoteItem__c> quoteItems = [
			SELECT Id, QuoteSectionId__c
			FROM QuoteItem__c
			WHERE QuoteId__r.Name = 'Quote Item Cell Service Test'
		];

		// shift cell values left by 4 positions
		Integer shiftFactor = -4;
		Integer lastCellVal = MAX_PERIOD_COUNT + shiftFactor;
		Map<Id, Map<String, Decimal>> quoteItemCells = QuoteItemSectionController.shiftQuoteItemSection(
			quoteItems[0].QuoteSectionId__c,
			shiftFactor
		);

		Map<String, Decimal> quoteItemCell = quoteItemCells.values()[0];
		System.assertEquals(1, quoteItemCell.get('001'), 'value at cell 1 is 1');
		System.assertEquals(
			1,
			quoteItemCell.get('' + lastCellVal),
			'value at cell ' +
			lastCellVal +
			' is 1'
		);
		Test.stopTest();
	}
}
