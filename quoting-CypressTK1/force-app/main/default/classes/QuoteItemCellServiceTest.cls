/*
 * Provus Services Quoting
 * Copyright (c) 2021 Provus Inc. All rights reserved.
 */
@IsTest
private with sharing class QuoteItemCellServiceTest extends TestBase {
	@TestSetup
	static void setup() {
		Quote__c quoteSO = newQuote();
		quoteSO.Name = 'Quote Item Cell Service Test';
		CRUDUtility.updateRecords(quoteSO);

		Id productTypeId = SObjectUtility.getRecordTypeIdbyName(
			Schema.SObjectType.Product__c.getName(),
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

		List<QuoteItemCell__c> quoteItemCells = new List<QuoteItemCell__c>();

		Integer numberOfQuoteItemCellsToCreate = 3;
		for (Integer i = 0; i < numberOfQuoteItemCellsToCreate; i++) {
			QuoteItemCell__c itemCellSO = new QuoteItemCell__c();
			itemCellSO.QuoteItemId__c = quoteItemSO.Id;
			for (Integer cellPos = 1; cellPos <= QuotePeriodService.MAX_PERIOD_COUNT; cellPos++) {
				String shiftFromColName = QuoteItemCellService.cellColumnName(cellPos);
				itemCellSO.put(shiftFromColName, 1);
			}
			quoteItemCells.add(itemCellSO);
		}

		CRUDUtility.insertRecords(quoteItemCells);
	}

	@IsTest
	static void itShouldGetQuoteItemCells() {
		Test.startTest();
		List<QuoteItem__c> quoteItems = [
			SELECT Id, QuoteId__c, QuoteId__r.Name
			FROM QuoteItem__c
			WHERE QuoteId__r.Name = 'Quote Item Cell Service Test'
		];
		Set<Id> quoteItemIds = new Set<Id>();
		for (QuoteItem__c quoteItemSO : quoteItems) {
			quoteItemIds.add(quoteItemSO.Id);
		}
		List<QuoteItemCell__c> itemCells = QuoteItemCellService.getCellsForMergeFor(quoteItemIds);
		System.assert(!itemCells.isEmpty(), 'should have quote items');
		Test.stopTest();
	}

	@IsTest
	static void itShouldCreateQuoteCellItem() {
		Test.startTest();
		Product__c productSO = [SELECT Id FROM Product__c WHERE Name = 'Main Product' LIMIT 1];
		Map<String, Decimal> durationByRole = new Map<String, Decimal>{ productSO.Id + '-1' => 12 };
		Decimal itemDuration = durationByRole.get(productSO.Id + '-1');
		Decimal itemPeriodSpan = DurationCalcs.itemPeriodSpan('Months', itemDuration);
		Decimal monthHours = DurationCalcs.numberOfHoursInPeriod('Months');
		Map<Decimal, EstimateService.PeriodDetails> periodDetails = createPeriodDetails(12, monthHours);
		QuoteItemCellService.QuoteItemCellRequest itemCellRequest = new QuoteItemCellService.QuoteItemCellRequest();
		itemCellRequest.itemDurationHours = itemPeriodSpan;
		itemCellRequest.startCellIndex = 1;

		QuoteItemCell__c itemCellSO = QuoteItemCellService.createQuoteItemCell(
				itemCellRequest,
				periodDetails
			)
			.quoteItemCell;
		System.assert(itemCellSO != null, 'it should have created quote item cell succesfully');

		Test.stopTest();
	}

	@IsTest
	static void whenLaborUnitsIsInHoursCreateQuoteCellItemWithFourTermsOf40HoursEach() {
		Quote__c quote1 = getQuote1();
		quote1.LaborUnits__c = QuoteService.LABORUNITS_HOURS;

		QuoteItemCellService.QuoteItemCellRequest itemCellRequest = new QuoteItemCellService.QuoteItemCellRequest();
		itemCellRequest.itemDurationHours = 160;
		itemCellRequest.startCellIndex = 1;
		itemCellRequest.isLaborUnitsInHours = true;

		Map<Decimal, EstimateService.PeriodDetails> timeByPeriodSequence = createPeriodDetails(4, 40);

		Test.startTest();
		itemCellRequest.isLaborUnitsInHours = true;
		QuoteItemCell__c itemCellSO = QuoteItemCellService.createQuoteItemCell(
				itemCellRequest,
				timeByPeriodSequence
			)
			.quoteItemCell;

		System.assert(itemCellSO != null, 'it should have created quote item cell successfully');
		for (Integer i = 1; i < 5; i++) {
			Decimal value = (Decimal) itemCellSO.get(QuoteItemCellService.cellColumnName(i));
			System.assertEquals(40, value, 'expect period to have 40 hours');
		}

		Test.stopTest();
	}

	@IsTest
	static void whenLaborUnitsIsNotHoursCreateQuoteCellItemWithFourTermsOf1PeriodEach() {
		Quote__c quote1 = getQuote1();
		quote1.LaborUnits__c = QuoteService.LABORUNITS_HOURS;

		QuoteItemCellService.QuoteItemCellRequest itemCellRequest = new QuoteItemCellService.QuoteItemCellRequest();
		itemCellRequest.itemDurationHours = 160;
		itemCellRequest.startCellIndex = 1;

		Map<Decimal, EstimateService.PeriodDetails> timeByPeriodSequence = new Map<Decimal, EstimateService.PeriodDetails>();

		for (Integer i = 1; i < 5; i++) {
			Decimal standardHours = DurationCalcs.numberOfHoursInPeriod('Weeks');
			EstimateService.PeriodDetails details = new EstimateService.PeriodDetails();
			details.workableHours = standardHours;
			details.periodHours = standardHours;
			timeByPeriodSequence.put(i, details);
		}

		Test.startTest();

		QuoteItemCell__c itemCellSO = QuoteItemCellService.createQuoteItemCell(
				itemCellRequest,
				timeByPeriodSequence
			)
			.quoteItemCell;

		Test.stopTest();

		System.assert(itemCellSO != null, 'it should have created quote item cell successfully');
		for (Integer i = 1; i < 5; i++) {
			Decimal value = (Decimal) itemCellSO.get(QuoteItemCellService.cellColumnName(i));
			System.assertEquals(1, value, 'expect period to have 40 hours');
		}
	}

	@IsTest
	static void shouldReturnQuoteItemCellRecords() {
		Test.startTest();
		List<QuoteItem__c> quoteItems = [
			SELECT Id
			FROM QuoteItem__c
			WHERE QuoteId__r.Name = 'Quote Item Cell Service Test'
		];
		Set<Id> quoteItemIds = new Set<Id>();
		for (QuoteItem__c quoteItemSO : quoteItems) {
			quoteItemIds.add(quoteItemSO.Id);
		}
		List<QuoteItemCell__c> itemCells = QuoteItemCellService.getQuoteItemCellsByQuoteItemIds(
			quoteItemIds
		);
		System.assert(!itemCells.isEmpty(), 'should have quote item cell records');
		System.assert(itemCells[0].C001__c == 1, 'first cell should contain value');
		System.assert(
			itemCells[0].get(QuoteItemCellService.cellColumnName(QuotePeriodService.MAX_PERIOD_COUNT)) ==
			1,
			'first cell should contain value'
		);
		Test.stopTest();
	}

	@IsTest
	static void itShouldCreatePeriodValueMap() {
		QuoteItemCell__c cell = new QuoteItemCell__c(C001__c = 1, C003__c = 0.5);
		Test.startTest();
		Map<Id, Map<String, Decimal>> result = QuoteItemCellService.convertToPeriodValueMaps(
			new List<QuoteItemCell__c>{ cell }
		);
		System.assertEquals(1, result.get(null).get('001'), 'should copy the value from cell 1');
		System.assertEquals(0.5, result.get(null).get('003'), 'should copy the value from cell 3');
		Test.stopTest();
	}

	@IsTest
	static void itShouldCreateQuoteCellItemWithCarryover() {
		Map<Decimal, EstimateService.PeriodDetails> periodDetailsBySequence = new Map<Decimal, EstimateService.PeriodDetails>();
		EstimateService.PeriodDetails carryoverTerm = new EstimateService.PeriodDetails();
		carryoverTerm.workableHours = 80;
		carryoverTerm.periodHours = 160;
		EstimateService.PeriodDetails fullTerm = new EstimateService.PeriodDetails();
		fullTerm.workableHours = 160;
		fullTerm.periodHours = 160;
		periodDetailsBySequence.put(2, carryoverTerm);
		periodDetailsBySequence.put(3, fullTerm);
		periodDetailsBySequence.put(4, fullTerm);

		Test.startTest();
		{
			QuoteItemCellService.QuoteItemCellRequest itemCellRequest = new QuoteItemCellService.QuoteItemCellRequest();
			itemCellRequest.itemDurationHours = 400;
			itemCellRequest.startCellIndex = 2;

			QuoteItemCell__c itemCellSo = QuoteItemCellService.createQuoteItemCell(
					itemCellRequest,
					periodDetailsBySequence
				)
				.quoteItemCell;
			System.assertEquals(0.5, itemCellSo.C002__c);
			System.assertEquals(1, itemCellSo.C003__c);
			System.assertEquals(1, itemCellSo.C004__c);
		}
		Test.stopTest();
	}

	@IsTest
	static void itShouldCreateQuoteCellItemWithCarryoverInLaborUnitHours() {
		Map<Decimal, EstimateService.PeriodDetails> periodDetailsBySequence = new Map<Decimal, EstimateService.PeriodDetails>();
		EstimateService.PeriodDetails carryoverTerm = new EstimateService.PeriodDetails();
		carryoverTerm.workableHours = 80;
		carryoverTerm.periodHours = 160;
		EstimateService.PeriodDetails fullTerm = new EstimateService.PeriodDetails();
		fullTerm.workableHours = 160;
		fullTerm.periodHours = 160;
		periodDetailsBySequence.put(2, carryoverTerm);
		periodDetailsBySequence.put(3, fullTerm);
		periodDetailsBySequence.put(4, fullTerm);

		Test.startTest();
		{
			QuoteItemCellService.QuoteItemCellRequest itemCellRequest = new QuoteItemCellService.QuoteItemCellRequest();
			itemCellRequest.itemDurationHours = 400;
			itemCellRequest.startCellIndex = 2;
			itemCellRequest.isLaborUnitsInHours = true;

			QuoteItemCell__c itemCellSo = QuoteItemCellService.createQuoteItemCell(
					itemCellRequest,
					periodDetailsBySequence
				)
				.quoteItemCell;
			System.assertEquals(80, itemCellSo.C002__c);
			System.assertEquals(160, itemCellSo.C003__c);
			System.assertEquals(160, itemCellSo.C004__c);
		}
		Test.stopTest();
	}

	@IsTest
	static void itShouldCreateQuoteCellItemWithPartialTerms() {
		Map<Decimal, EstimateService.PeriodDetails> periodDetailsBySequence = new Map<Decimal, EstimateService.PeriodDetails>();
		EstimateService.PeriodDetails fullTerm = new EstimateService.PeriodDetails();
		fullTerm.workableHours = 160;
		fullTerm.periodHours = 160;
		EstimateService.PeriodDetails partialTerm = new EstimateService.PeriodDetails();
		partialTerm.workableHours = 80;
		partialTerm.periodHours = 160;
		periodDetailsBySequence.put(1, fullTerm);
		periodDetailsBySequence.put(2, partialTerm);
		periodDetailsBySequence.put(3, fullTerm);
		periodDetailsBySequence.put(4, partialTerm);

		Test.startTest();
		{
			QuoteItemCellService.QuoteItemCellRequest itemCellRequest = new QuoteItemCellService.QuoteItemCellRequest();
			itemCellRequest.itemDurationHours = 480;
			itemCellRequest.startCellIndex = 1;

			QuoteItemCell__c itemCellSo = QuoteItemCellService.createQuoteItemCell(
					itemCellRequest,
					periodDetailsBySequence
				)
				.quoteItemCell;
			System.assertEquals(1, itemCellSo.C001__c);
			System.assertEquals(0.5, itemCellSo.C002__c);
			System.assertEquals(1, itemCellSo.C003__c);
			System.assertEquals(0.5, itemCellSo.C004__c);
		}
		Test.stopTest();
	}

	@IsTest
	static void itShouldCreateQuoteCellItemWithPartialTermsInHours() {
		Map<Decimal, EstimateService.PeriodDetails> periodDetailsBySequence = new Map<Decimal, EstimateService.PeriodDetails>();
		EstimateService.PeriodDetails fullTerm = new EstimateService.PeriodDetails();
		fullTerm.workableHours = 160;
		fullTerm.periodHours = 160;
		EstimateService.PeriodDetails partialTerm = new EstimateService.PeriodDetails();
		partialTerm.workableHours = 80;
		partialTerm.periodHours = 160;
		periodDetailsBySequence.put(1, fullTerm);
		periodDetailsBySequence.put(2, partialTerm);
		periodDetailsBySequence.put(3, fullTerm);
		periodDetailsBySequence.put(4, partialTerm);

		Test.startTest();
		{
			QuoteItemCellService.QuoteItemCellRequest itemCellRequest = new QuoteItemCellService.QuoteItemCellRequest();
			itemCellRequest.itemDurationHours = 480;
			itemCellRequest.startCellIndex = 1;
			itemCellRequest.isLaborUnitsInHours = true;

			QuoteItemCell__c itemCellSo = QuoteItemCellService.createQuoteItemCell(
					itemCellRequest,
					periodDetailsBySequence
				)
				.quoteItemCell;
			System.assertEquals(160, itemCellSo.C001__c);
			System.assertEquals(80, itemCellSo.C002__c);
			System.assertEquals(160, itemCellSo.C003__c);
			System.assertEquals(80, itemCellSo.C004__c);
		}
		Test.stopTest();
	}

	@IsTest
	static void itShouldCreateQuoteCellItemWithPartialAvailability() {
		Map<Decimal, EstimateService.PeriodDetails> periodDetailsBySequence = new Map<Decimal, EstimateService.PeriodDetails>();
		EstimateService.PeriodDetails fullTerm = new EstimateService.PeriodDetails();
		fullTerm.workableHours = 160;
		fullTerm.periodHours = 160;
		periodDetailsBySequence.put(1, fullTerm);
		periodDetailsBySequence.put(2, fullTerm);
		periodDetailsBySequence.put(3, fullTerm);
		periodDetailsBySequence.put(4, fullTerm);

		Test.startTest();
		{
			QuoteItemCellService.QuoteItemCellRequest itemCellRequest = new QuoteItemCellService.QuoteItemCellRequest();
			itemCellRequest.itemDurationHours = 320;
			itemCellRequest.startCellIndex = 1;
			itemCellRequest.availabilityPercentage = 50;

			QuoteItemCell__c itemCellSo = QuoteItemCellService.createQuoteItemCell(
					itemCellRequest,
					periodDetailsBySequence
				)
				.quoteItemCell;

			System.assertEquals(0.5, itemCellSo.C001__c);
			System.assertEquals(0.5, itemCellSo.C002__c);
			System.assertEquals(0.5, itemCellSo.C003__c);
			System.assertEquals(0.5, itemCellSo.C004__c);
		}
		Test.stopTest();
	}

	@IsTest
	static void itShouldCreateQuoteCellItemWithCarryoverAndPartialAvailability() {
		Map<Decimal, EstimateService.PeriodDetails> periodDetailsBySequence = new Map<Decimal, EstimateService.PeriodDetails>();
		EstimateService.PeriodDetails carryoverTerm = new EstimateService.PeriodDetails();
		carryoverTerm.workableHours = 32;
		carryoverTerm.periodHours = 160;
		EstimateService.PeriodDetails fullTerm = new EstimateService.PeriodDetails();
		fullTerm.workableHours = 160;
		fullTerm.periodHours = 160;
		periodDetailsBySequence.put(1, carryoverTerm);
		periodDetailsBySequence.put(2, fullTerm);
		periodDetailsBySequence.put(3, fullTerm);
		periodDetailsBySequence.put(4, fullTerm);
		periodDetailsBySequence.put(5, fullTerm);

		Test.startTest();
		{
			QuoteItemCellService.QuoteItemCellRequest itemCellRequest = new QuoteItemCellService.QuoteItemCellRequest();
			itemCellRequest.itemDurationHours = 320;
			itemCellRequest.startCellIndex = 1;
			itemCellRequest.availabilityPercentage = 50;

			QuoteItemCell__c itemCellSo = QuoteItemCellService.createQuoteItemCell(
					itemCellRequest,
					periodDetailsBySequence
				)
				.quoteItemCell;

			System.assertEquals(0.1, itemCellSo.C001__c);
			System.assertEquals(0.5, itemCellSo.C002__c);
			System.assertEquals(0.5, itemCellSo.C003__c);
			System.assertEquals(0.5, itemCellSo.C004__c);
			System.assertEquals(0.4, itemCellSo.C005__c);
		}
		Test.stopTest();
	}

	@IsTest
	static void itShouldCreateQuoteCellItemWithPartialTermAndPartialAvailability() {
		Map<Decimal, EstimateService.PeriodDetails> periodDetailsBySequence = new Map<Decimal, EstimateService.PeriodDetails>();
		EstimateService.PeriodDetails fullTerm = new EstimateService.PeriodDetails();
		fullTerm.workableHours = 160;
		fullTerm.periodHours = 160;
		EstimateService.PeriodDetails partialTerm = new EstimateService.PeriodDetails();
		partialTerm.workableHours = 80;
		partialTerm.periodHours = 160;
		periodDetailsBySequence.put(1, fullTerm);
		periodDetailsBySequence.put(2, partialTerm);
		periodDetailsBySequence.put(3, fullTerm);
		periodDetailsBySequence.put(4, partialTerm);
		periodDetailsBySequence.put(5, fullTerm);

		Test.startTest();
		{
			QuoteItemCellService.QuoteItemCellRequest itemCellRequest = new QuoteItemCellService.QuoteItemCellRequest();
			itemCellRequest.itemDurationHours = 320;
			itemCellRequest.startCellIndex = 1;
			itemCellRequest.availabilityPercentage = 50;

			QuoteItemCell__c itemCellSo = QuoteItemCellService.createQuoteItemCell(
					itemCellRequest,
					periodDetailsBySequence
				)
				.quoteItemCell;

			System.assertEquals(0.5, itemCellSo.C001__c);
			System.assertEquals(0.25, itemCellSo.C002__c);
			System.assertEquals(0.5, itemCellSo.C003__c);
			System.assertEquals(0.25, itemCellSo.C004__c);
			System.assertEquals(0.5, itemCellSo.C005__c);
		}
		Test.stopTest();
	}

	@IsTest
	static void itShouldCreateQuoteCellItemForVaryingPeriodWorkableHours() {
		Map<Decimal, EstimateService.PeriodDetails> periodDetailsBySequence = new Map<Decimal, EstimateService.PeriodDetails>();
		EstimateService.PeriodDetails quarter1 = new EstimateService.PeriodDetails();
		quarter1.workableHours = 520;
		quarter1.periodHours = 520;
		EstimateService.PeriodDetails quarter2 = new EstimateService.PeriodDetails();
		quarter2.workableHours = 520;
		quarter2.periodHours = 520;
		EstimateService.PeriodDetails quarter3 = new EstimateService.PeriodDetails();
		quarter3.workableHours = 524;
		quarter3.periodHours = 524;
		EstimateService.PeriodDetails quarter4 = new EstimateService.PeriodDetails();
		quarter4.workableHours = 520;
		quarter4.periodHours = 520;
		periodDetailsBySequence.put(1, quarter1);
		periodDetailsBySequence.put(2, quarter2);
		periodDetailsBySequence.put(3, quarter3);
		periodDetailsBySequence.put(4, quarter4);

		Test.startTest();
		{
			QuoteItemCellService.QuoteItemCellRequest itemCellRequest = new QuoteItemCellService.QuoteItemCellRequest();
			itemCellRequest.itemDurationHours = 1800;
			itemCellRequest.startCellIndex = 1;
			itemCellRequest.isLaborUnitsInHours = true;

			QuoteItemCell__c itemCellSo = QuoteItemCellService.createQuoteItemCell(
					itemCellRequest,
					periodDetailsBySequence
				)
				.quoteItemCell;

			System.assertEquals(520, itemCellSo.C001__c);
			System.assertEquals(520, itemCellSo.C002__c);
			System.assertEquals(524, itemCellSo.C003__c);
			System.assertEquals(236, itemCellSo.C004__c);
		}
		Test.stopTest();
	}

	static Map<Decimal, EstimateService.PeriodDetails> createPeriodDetails(
		Integer periodDetailCount,
		Decimal standardHours
	) {
		Map<Decimal, EstimateService.PeriodDetails> periodDetails = new Map<Decimal, EstimateService.PeriodDetails>();
		for (Integer i = 1; i < periodDetailCount + 1; i++) {
			EstimateService.PeriodDetails details = new EstimateService.PeriodDetails();
			details.workableHours = standardHours;
			details.periodHours = standardHours;
			periodDetails.put(i, details);
		}

		return periodDetails;
	}

	@IsTest
	static Quote__c getQuote1() {
		Quote__c quote1 = [SELECT Id, Name FROM Quote__c WHERE Name = 'Quote Item Cell Service Test'];
		return quote1;
	}
}
