/**
 *  Provus Services Quoting
 *  VolumeDiscountControllerTest
 *  @2022 Provus Inc. All rights reserved.
 */
@IsTest
public with sharing class VolumeDiscountControllerTest extends TestBase {
	private static String quoteNameNo1 = 'Volume Discount Quote #1';

	@TestSetup
	static void setup() {
		Quote__c quoteSo = TestBase.newQuote(quoteNameNo1);
		QuotePeriod__c periodSo = newQuotePeriod(quoteSo.Id);
		periodSo.Name = 'Test Period';
		CRUDUtility.updateRecords(periodSo);

		VolumeDiscount__c[] volumeDiscountSOs = new VolumeDiscount__c[0];
		VolumeDiscount__c volumeDiscountSo1 = new VolumeDiscount__c(
			QuoteId__c = quoteSo.Id,
			Category__c = 'Headcount',
			TotalBy__c = 'Quote'
		);
		volumeDiscountSOs.add(volumeDiscountSo1);

		VolumeDiscount__c volumeDiscountSo2 = new VolumeDiscount__c(
			QuoteId__c = quoteSo.Id,
			Category__c = 'Labor Revenue',
			TotalBy__c = 'Quote'
		);
		volumeDiscountSOs.add(volumeDiscountSo2);

		insert volumeDiscountSOs;

		VolumeDiscountTier__c[] volumeDiscountTierSOs = new VolumeDiscountTier__c[0];
		volumeDiscountTierSOs.add(
			new VolumeDiscountTier__c(
				VolumeDiscountId__c = volumeDiscountSo1.Id,
				From__c = 0,
				To__c = 10,
				Discount__c = 5,
				Sequence__c = 1
			)
		);

		volumeDiscountTierSOs.add(
			new VolumeDiscountTier__c(
				VolumeDiscountId__c = volumeDiscountSo1.Id,
				From__c = 11,
				To__c = 27,
				Discount__c = 10,
				Sequence__c = 2
			)
		);

		volumeDiscountTierSOs.add(
			new VolumeDiscountTier__c(
				VolumeDiscountId__c = volumeDiscountSo2.Id,
				From__c = 0,
				To__c = 100000,
				Discount__c = 5,
				Sequence__c = 1
			)
		);

		volumeDiscountTierSOs.add(
			new VolumeDiscountTier__c(
				VolumeDiscountId__c = volumeDiscountSo2.Id,
				From__c = 100001,
				To__c = 200000,
				Discount__c = 10,
				Sequence__c = 1
			)
		);

		insert volumeDiscountTierSOs;

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
			VolumeDiscountTierId__c = volumeDiscountTierSOs[0].Id
		);
		CRUDUtility.insertRecords(discountTier);
	}

	@IsTest
	static void shouldRetrieveAllVolumeDiscountsForQuote() {
		Quote__c quoteSO = [SELECT Id FROM Quote__c WHERE Name = :quoteNameNo1];
		Test.startTest();
		{
			VolumeDiscountDto[] volumeDiscountDtos = VolumeDiscountController.getVolumeDiscounts(
				quoteSO.Id
			);
			System.assertEquals(2, volumeDiscountDtos.size());
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldUpdateVolumeDiscountTierDiscountAmountQuote() {
		Quote__c quoteSO = [SELECT Id FROM Quote__c WHERE Name = :quoteNameNo1];
		VolumeDiscountDto[] volumeDiscountDtos = VolumeDiscountController.getVolumeDiscounts(
			quoteSO.Id
		);
		// set discount amount from 5 -> 20
		volumeDiscountDtos[0].tiers[0].discount = 20;

		Test.startTest();
		{
			volumeDiscountDtos = VolumeDiscountController.saveVolumeDiscounts(volumeDiscountDtos);
			System.assertEquals(20, volumeDiscountDtos[0].tiers[0].discount);
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldDeleteAllVolumeDiscountsButTheFirstForQuote() {
		Quote__c quoteSO = [SELECT Id FROM Quote__c WHERE Name = :quoteNameNo1];
		VolumeDiscountDto[] volumeDiscountDtos = VolumeDiscountController.getVolumeDiscounts(
			quoteSO.Id
		);

		for (Integer i = 0; i < volumeDiscountDtos.size(); i++) {
			if (i > 0) {
				volumeDiscountDtos[i].operationType = 'delete';
			}
		}

		Test.startTest();
		{
			volumeDiscountDtos = VolumeDiscountController.saveVolumeDiscounts(volumeDiscountDtos);
			System.assertEquals(1, volumeDiscountDtos.size());
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldReturnSummaryDtos() {
		Quote__c quoteSO = [SELECT Id FROM Quote__c WHERE Name = :quoteNameNo1];
		Test.startTest();
		{
			List<VolumeDiscountSummaryDto> summaryDtos = VolumeDiscountController.getVolumeDiscountSummary(
				quoteSO.Id
			);
			System.assertEquals(1, summaryDtos[0].appliedTierSummaries.size());
		}
		Test.stopTest();
	}
}
