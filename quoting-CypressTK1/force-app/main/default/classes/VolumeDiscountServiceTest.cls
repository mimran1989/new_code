/**
 *  Provus Services Quoting
 *  VolumeDiscountServiceTest
 *  @2022 Provus Inc. All rights reserved.
 */
@IsTest
public with sharing class VolumeDiscountServiceTest extends TestBase {
	private static String quoteNameNo1 = 'Volume Discount Quote #1';

	@TestSetup
	static void setup() {
		Quote__c quote = TestBase.newQuote(quoteNameNo1);

		VolumeDiscount__c volumeDiscount = new VolumeDiscount__c(
			QuoteId__c = quote.Id,
			Category__c = 'Headcount',
			TotalBy__c = 'Quote'
		);

		insert volumeDiscount;

		List<VolumeDiscountTier__c> volumeDiscountTierSOs = new List<VolumeDiscountTier__c>();
		volumeDiscountTierSOs.add(
			new VolumeDiscountTier__c(
				VolumeDiscountId__c = volumeDiscount.Id,
				From__c = 0,
				To__c = 10,
				Discount__c = 5,
				Sequence__c = 1
			)
		);

		volumeDiscountTierSOs.add(
			new VolumeDiscountTier__c(
				VolumeDiscountId__c = volumeDiscount.Id,
				From__c = 11,
				To__c = 27,
				Discount__c = 10,
				Sequence__c = 2
			)
		);

		insert volumeDiscountTierSOs;
	}

	@IsTest
	static void whenOneNewVolumeDiscountAndTierDtoInsertedOneVolumeDiscountAndTierRecordExist() {
		Id quoteId = getTestQuoteNumber1().Id;
		VolumeDiscountDto volumeDiscountDto = new VolumeDiscountDto();
		volumeDiscountDto.quoteId = quoteId;
		volumeDiscountDto.totalBy = 'Quote';
		volumeDiscountDto.category = 'Headcount';
		VolumeDiscountTierDto volumeDiscountTierDto1 = new VolumeDiscountTierDto();
		volumeDiscountTierDto1.fromValue = 0;
		volumeDiscountTierDto1.toValue = 10;
		volumeDiscountTierDto1.discount = 3;
		volumeDiscountTierDto1.sequence = 1;
		volumeDiscountDto.tiers.add(volumeDiscountTierDto1);

		List<VolumeDiscountDto> volumeDiscountDtos = VolumeDiscountService.saveVolumeDiscounts(
			new List<VolumeDiscountDto>{ volumeDiscountDto }
		);

		VolumeDiscount__c volumeDiscount = [
			SELECT Id, TotalBy__c, Category__c
			FROM VolumeDiscount__c
			WHERE Id = :volumeDiscountDtos[0].id
		];

		List<VolumeDiscountTier__c> volumeDiscountTiers = [
			SELECT From__c, To__c, Discount__c, Sequence__c
			FROM VolumeDiscountTier__c
			WHERE VolumeDiscountId__c = :volumeDiscount.Id
		];

		System.assertEquals(
			1,
			volumeDiscountTiers.size(),
			'expect only one volume discount tier record'
		);
	}

	@IsTest
	static void whenOneNewVolumeDiscountAndTwoTierDtosInsertedOneVolumeDiscountAndTwoTierRecordsExist() {
		Id quoteId = getTestQuoteNumber1().Id;
		VolumeDiscountDto volumeDiscountDto = new VolumeDiscountDto();
		volumeDiscountDto.quoteId = quoteId;
		volumeDiscountDto.totalBy = 'Quote';
		volumeDiscountDto.category = 'Headcount';

		VolumeDiscountTierDto volumeDiscountTierDto1 = new VolumeDiscountTierDto();
		volumeDiscountTierDto1.fromValue = 0;
		volumeDiscountTierDto1.toValue = 10;
		volumeDiscountTierDto1.discount = 3;
		volumeDiscountTierDto1.sequence = 1;
		volumeDiscountDto.tiers.add(volumeDiscountTierDto1);

		VolumeDiscountTierDto volumeDiscountTierDto2 = new VolumeDiscountTierDto();
		volumeDiscountTierDto2.fromValue = 11;
		volumeDiscountTierDto2.toValue = 20;
		volumeDiscountTierDto2.discount = 5;
		volumeDiscountTierDto2.sequence = 2;
		volumeDiscountDto.tiers.add(volumeDiscountTierDto2);

		List<VolumeDiscountDto> volumeDiscountDtos = VolumeDiscountService.saveVolumeDiscounts(
			new List<VolumeDiscountDto>{ volumeDiscountDto }
		);

		VolumeDiscount__c volumeDiscount = [
			SELECT Id, TotalBy__c, Category__c
			FROM VolumeDiscount__c
			WHERE Id = :volumeDiscountDtos[0].id
		];

		List<VolumeDiscountTier__c> volumeDiscountTiers = [
			SELECT From__c, To__c, Discount__c, Sequence__c
			FROM VolumeDiscountTier__c
			WHERE VolumeDiscountId__c = :volumeDiscount.Id
		];

		System.assertEquals(2, volumeDiscountTiers.size(), 'expect two volume discount tier records');
	}

	@IsTest
	static void whenOneNewVolumeDiscountAndOneVolumeDiscountTierDtoInsertedEachFieldValuePersistedCorrectly() {
		Id quoteId = getTestQuoteNumber1().Id;
		VolumeDiscountDto volumeDiscountDto = new VolumeDiscountDto();
		volumeDiscountDto.quoteId = quoteId;
		volumeDiscountDto.totalBy = 'Quote';
		volumeDiscountDto.category = 'Headcount';

		VolumeDiscountTierDto volumeDiscountTierDto1 = new VolumeDiscountTierDto();
		volumeDiscountTierDto1.fromValue = 0;
		volumeDiscountTierDto1.toValue = 10;
		volumeDiscountTierDto1.discount = 3;
		volumeDiscountTierDto1.sequence = 1;
		volumeDiscountDto.tiers.add(volumeDiscountTierDto1);

		List<VolumeDiscountDto> volumeDiscountDtos = VolumeDiscountService.saveVolumeDiscounts(
			new List<VolumeDiscountDto>{ volumeDiscountDto }
		);

		VolumeDiscount__c volumeDiscountSO = [
			SELECT Id, TotalBy__c, Category__c
			FROM VolumeDiscount__c
			WHERE Id = :volumeDiscountDtos[0].id
		];

		List<VolumeDiscountTier__c> volumeDiscountTiers = [
			SELECT Id, From__c, To__c, Discount__c, Sequence__c
			FROM VolumeDiscountTier__c
			WHERE VolumeDiscountId__c = :volumeDiscountSO.Id
		];

		System.assertEquals(
			volumeDiscountDto.totalBy,
			volumeDiscountSO.TotalBy__c,
			'expect TotalBy__c field to equal \'' +
			volumeDiscountDto.totalBy +
			'\''
		);

		System.assertEquals(
			volumeDiscountDto.category,
			volumeDiscountSO.Category__c,
			'expect Category__c field to equal \'' +
			volumeDiscountDto.category +
			'\''
		);

		VolumeDiscountTier__c volumeDiscountTierSO = volumeDiscountTiers[0];
		System.assertEquals(
			volumeDiscountTierDto1.fromValue,
			volumeDiscountTierSO.From__c,
			'expect From__c field to equal \'' +
			volumeDiscountTierDto1.fromValue +
			'\''
		);
		System.assertEquals(
			volumeDiscountTierDto1.toValue,
			volumeDiscountTierSO.To__c,
			'expect To__c field to equal \'' +
			volumeDiscountTierDto1.toValue +
			'\''
		);
		System.assertEquals(
			volumeDiscountTierDto1.discount,
			volumeDiscountTierSO.Discount__c,
			'expect Discount__c field to equal \'' +
			volumeDiscountTierDto1.discount +
			'\''
		);
		System.assertEquals(
			volumeDiscountTierDto1.sequence,
			volumeDiscountTierSO.Sequence__c,
			'expect Sequence__c field to equal \'' +
			volumeDiscountTierDto1.sequence +
			'\''
		);
	}

	@IsTest
	static void oneNewVolumeDiscountAndTierRecordCallGetVolumeDiscountsReturnsOneVolumeDiscountWithTwoTierRecords() {
		Id quoteId = getTestQuoteNumber1().Id;

		VolumeDiscount__c volumeDiscountSO = [
			SELECT Id, QuoteId__c, Category__c, TotalBy__c
			FROM VolumeDiscount__c
			WHERE QuoteId__c = :quoteId
		];

		List<VolumeDiscountTier__c> volumeDiscountTierSOs = [
			SELECT Id, VolumeDiscountId__c, From__c, To__c, Discount__c, Sequence__c
			FROM VolumeDiscountTier__c
			WHERE VolumeDiscountId__c = :volumeDiscountSO.Id
		];

		List<VolumeDiscountDto> volumeDiscountDtos = VolumeDiscountService.getVolumeDiscounts(quoteId);

		VolumeDiscountDto volumeDiscountDto = volumeDiscountDtos[0];
		System.assertEquals(
			volumeDiscountSO.TotalBy__c,
			volumeDiscountDto.totalBy,
			'Field \'TotalBy__c\' should equal \'' +
			volumeDiscountSO.TotalBy__c +
			'\''
		);
		System.assertEquals(
			volumeDiscountSO.Category__c,
			volumeDiscountDto.category,
			'Field \'Category__c\' should equal \'' +
			volumeDiscountSO.Category__c +
			'\''
		);

		VolumeDiscountTier__c volumeDiscountTierSO1 = volumeDiscountTierSOs[0];
		VolumeDiscountTierDto volumeDiscountTierDto1 = new VolumeDiscountTierDto(volumeDiscountTierSO1);
		System.assertEquals(
			volumeDiscountTierSO1.From__c,
			volumeDiscountTierDto1.fromValue,
			'Field \'fromValue\' should equal \'' +
			volumeDiscountTierSO1.From__c +
			'\''
		);
		System.assertEquals(
			volumeDiscountTierSO1.To__c,
			volumeDiscountTierDto1.toValue,
			'Field \'toValue\' should equal \'' +
			volumeDiscountTierSO1.To__c +
			'\''
		);
		System.assertEquals(
			volumeDiscountTierSO1.Discount__c,
			volumeDiscountTierDto1.discount,
			'Field \'discount\' should equal \'' +
			volumeDiscountTierSO1.Discount__c +
			'\''
		);
		System.assertEquals(
			volumeDiscountTierSO1.Sequence__c,
			volumeDiscountTierDto1.sequence,
			'Field \'sequence\' should equal \'' +
			volumeDiscountTierSO1.Sequence__c +
			'\''
		);
		System.assertEquals(
			volumeDiscountSO.Id,
			volumeDiscountTierDto1.volumeDiscountId,
			'Field \'volumeDiscountId\' should equal \'' +
			volumeDiscountSO.Id +
			'\''
		);

		VolumeDiscountTier__c volumeDiscountTierSO2 = volumeDiscountTierSOs[1];
		VolumeDiscountTierDto volumeDiscountTierDto2 = new VolumeDiscountTierDto(volumeDiscountTierSO2);
		System.assertEquals(
			volumeDiscountTierSO2.From__c,
			volumeDiscountTierDto2.fromValue,
			'Field \'fromValue\' should equal \'' +
			volumeDiscountTierSO2.From__c +
			'\''
		);
		System.assertEquals(
			volumeDiscountTierSO2.To__c,
			volumeDiscountTierDto2.toValue,
			'Field \'toValue\' should equal \'' +
			volumeDiscountTierSO2.To__c +
			'\''
		);
		System.assertEquals(
			volumeDiscountTierSO2.Discount__c,
			volumeDiscountTierDto2.discount,
			'Field \'discount\' should equal \'' +
			volumeDiscountTierSO2.Discount__c +
			'\''
		);
		System.assertEquals(
			volumeDiscountTierSO2.Sequence__c,
			volumeDiscountTierDto2.sequence,
			'Field \'sequence\' should equal \'' +
			volumeDiscountTierSO2.Sequence__c +
			'\''
		);
		System.assertEquals(
			volumeDiscountSO.Id,
			volumeDiscountTierDto2.volumeDiscountId,
			'Field \'volumeDiscountId\' should equal \'' +
			volumeDiscountSO.Id +
			'\''
		);
	}

	@IsTest
	static void shouldDeleteVolumeDiscountAndTiers() {
		Id quoteId = getTestQuoteNumber1().Id;
		VolumeDiscountDto volumeDiscountDto = new VolumeDiscountDto();
		volumeDiscountDto.quoteId = quoteId;
		volumeDiscountDto.totalBy = 'Quote';
		volumeDiscountDto.category = 'Headcount';
		VolumeDiscountTierDto volumeDiscountTierDto1 = new VolumeDiscountTierDto();
		volumeDiscountTierDto1.fromValue = 0;
		volumeDiscountTierDto1.toValue = 10;
		volumeDiscountTierDto1.discount = 3;
		volumeDiscountTierDto1.sequence = 1;
		volumeDiscountDto.tiers.add(volumeDiscountTierDto1);

		List<VolumeDiscountDto> volumeDiscountDtos = VolumeDiscountService.saveVolumeDiscounts(
			new List<VolumeDiscountDto>{ volumeDiscountDto }
		);

		Test.startTest();
		{
			Id volumeDiscountId = volumeDiscountDto.refreshSo().Id;
			VolumeDiscountService.deleteVolumeDiscounts(volumeDiscountDtos);
			VolumeDiscount__c[] volumeDiscountSOs = [
				SELECT Id
				FROM VolumeDiscount__c
				WHERE Id = :volumeDiscountId
			];
			System.assertEquals(0, volumeDiscountSOs.size());
		}
		Test.stopTest();
	}

	@IsTest
	private static Quote__c getTestQuoteNumber1() {
		Quote__c quote1 = [SELECT Id FROM Quote__c WHERE Name = :quoteNameNo1];
		return quote1;
	}

	@IsTest
	static void shouldReturnSummaryDtos() {
		Quote__c quoteSo = newQuote();
		QuotePeriod__c periodSo = newQuotePeriod(quoteSo.Id);
		periodSo.Name = 'Test Period';
		CRUDUtility.updateRecords(periodSo);
		VolumeDiscount__c discountSo = new VolumeDiscount__c(
			QuoteId__c = quoteSo.Id,
			Category__c = 'Headcount',
			TotalBy__c = 'Period'
		);
		CRUDUtility.insertRecords(discountSo);
		VolumeDiscountTier__c tierSo = new VolumeDiscountTier__c(
			From__c = 1,
			To__c = 10,
			Discount__c = 10,
			Sequence__c = 1,
			VolumeDiscountId__c = discountSo.Id
		);
		CRUDUtility.insertRecords(tierSo);
		NamedRangeTotal__c totalSo = new NamedRangeTotal__c(
			QuoteId__c = quoteSo.Id,
			AdjustedBaseAmount__c = 100
		);
		CRUDUtility.insertRecords(totalSo);
		NamedRange__c namedRangeSo = new NamedRange__c(
			Name = 'Test',
			QuoteId__c = quoteSo.Id,
			NamedRangeTotalId__c = totalSo.Id,
			QuotePeriodId__c = periodSo.Id
		);
		CRUDUtility.insertRecords(namedRangeSo);
		Adjustment__c adjustmentSo = new Adjustment__c(
			NamedRangeId__c = namedRangeSo.Id,
			Amount__c = 100
		);
		CRUDUtility.insertRecords(adjustmentSo);
		AdjustmentVolumeDiscountTier__c discountTier = new AdjustmentVolumeDiscountTier__c(
			AdjustmentId__c = adjustmentSo.Id,
			VolumeDiscountTierId__c = tierSo.Id
		);
		CRUDUtility.insertRecords(discountTier);

		Test.startTest();
		{
			List<VolumeDiscountSummaryDto> summaries = VolumeDiscountService.getVolumeDiscountSummary(
				quoteSo.Id
			);
			System.assertEquals(1, summaries[0].appliedTierSummaries.size());
			System.assertEquals(discountTier.Id, summaries[0].appliedTierSummaries[0].Id);
			System.assertEquals(
				10,
				summaries[0].appliedTierSummaries[0].discountAmount,
				'should be 10% of 100'
			);
			System.assertEquals(100, summaries[0].appliedTierSummaries[0].revenue);
			System.assertEquals('Test Period', summaries[0].appliedTierSummaries[0].periodName);
		}
		Test.stopTest();
	}
}
