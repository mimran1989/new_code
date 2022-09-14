@IsTest
public class LocationDiscountReviewControllerTest extends TestBase {
	@IsTest
	public static void verifyDiscountAmount() {
		Quote__c quoteSO = newQuote();
		LocationDiscount__c locationDiscountSO = new LocationDiscount__c(
			Country__c = 'India',
			State__c = 'Karnataka',
			City__c = 'Bangalore',
			Type__c = Adjustment.TYPE_DISCOUNT_PERCENT,
			Amount__c = 10,
			QuoteId__c = quoteSO.Id
		);
		CRUDUtility.insertRecords(locationDiscountSO);

		NamedRangeTotal__c namedRangeTotalSO = new NamedRangeTotal__c(
			QuoteId__c = quoteSO.Id,
			BaseExtendedAmount__c = 500
		);
		CRUDUtility.insertRecords(namedRangeTotalSO);

		NamedRange__c namedRangeSO = new NamedRange__c(
			NamedRangeTotalId__c = namedRangeTotalSO.Id,
			QuoteId__c = quoteSO.Id
		);
		CRUDUtility.insertRecords(namedRangeSO);

		Adjustment__c adjustmentSO = new Adjustment__c(NamedRangeId__c = namedRangeSO.Id);
		CRUDUtility.insertRecords(adjustmentSO);

		LocationDiscountAdjustment__c locationAdjustmentSO = new LocationDiscountAdjustment__c(
			LocationDiscountId__c = locationDiscountSO.Id,
			AdjustmentId__c = adjustmentSO.Id
		);
		CRUDUtility.insertRecords(locationAdjustmentSO);

		Test.startTest();

		List<LocationDiscountReviewDto> locationDiscounts = LocationDiscountReviewController.getLocationDiscountReviewForQuote(
			quoteSO.Id
		);
		System.assert(locationDiscounts.size() == 1, 'Should have location discount reviews');
		System.assert(
			locationDiscounts[0].discountAmount == 50,
			'Should have discount amount = 50 for 10%'
		);
		System.assert(
			locationDiscounts[0].newAmount == 450,
			'Should have new amount = 450 after 10% disount'
		);

		Test.stopTest();
	}

	@IsTest
	public static void verifyDiscountPercentage() {
		Quote__c quoteSO = newQuote();
		LocationDiscount__c locationDiscountSO = new LocationDiscount__c(
			Country__c = 'India',
			State__c = 'Karnataka',
			City__c = 'Bangalore',
			Type__c = Adjustment.TYPE_DISCOUNT_AMOUNT,
			Amount__c = 50,
			QuoteId__c = quoteSO.Id
		);
		CRUDUtility.insertRecords(locationDiscountSO);

		NamedRangeTotal__c namedRangeTotalSO = new NamedRangeTotal__c(
			QuoteId__c = quoteSO.Id,
			BaseExtendedAmount__c = 500
		);
		CRUDUtility.insertRecords(namedRangeTotalSO);

		NamedRange__c namedRangeSO = new NamedRange__c(
			NamedRangeTotalId__c = namedRangeTotalSO.Id,
			QuoteId__c = quoteSO.Id
		);
		CRUDUtility.insertRecords(namedRangeSO);

		Adjustment__c adjustmentSO = new Adjustment__c(NamedRangeId__c = namedRangeSO.Id);
		CRUDUtility.insertRecords(adjustmentSO);

		LocationDiscountAdjustment__c locationAdjustmentSO = new LocationDiscountAdjustment__c(
			LocationDiscountId__c = locationDiscountSO.Id,
			AdjustmentId__c = adjustmentSO.Id
		);
		CRUDUtility.insertRecords(locationAdjustmentSO);

		Test.startTest();

		List<LocationDiscountReviewDto> locationDiscounts = LocationDiscountReviewController.getLocationDiscountReviewForQuote(
			quoteSO.Id
		);
		System.assert(locationDiscounts.size() == 1, 'Should have location discount reviews');
		System.assert(locationDiscounts[0].discountAmount == 50, 'Should have discount amount = 50');
		System.assert(
			locationDiscounts[0].discountPercentage == 10,
			'Should have discount percentage = 10 for $50'
		);
		System.assert(
			locationDiscounts[0].newAmount == 450,
			'Should have new amount = 450 after $50 discount'
		);

		Test.stopTest();
	}

	@IsTest
	public static void verifyMultipleDiscountAmount() {
		Quote__c quoteSO = newQuote();
		LocationDiscount__c locationDiscountSO = new LocationDiscount__c(
			Country__c = 'India',
			State__c = 'Karnataka',
			City__c = 'Bangalore',
			Type__c = Adjustment.TYPE_DISCOUNT_PERCENT,
			Amount__c = 10,
			QuoteId__c = quoteSO.Id
		);
		CRUDUtility.insertRecords(locationDiscountSO);

		NamedRangeTotal__c namedRangeTotalSO = new NamedRangeTotal__c(
			QuoteId__c = quoteSO.Id,
			BaseExtendedAmount__c = 500
		);
		NamedRangeTotal__c namedRangeTotalSO2 = new NamedRangeTotal__c(
			QuoteId__c = quoteSO.Id,
			BaseExtendedAmount__c = 500
		);
		CRUDUtility.insertRecords(
			new List<NamedRangeTotal__c>{ namedRangeTotalSO, namedRangeTotalSO2 }
		);

		NamedRange__c namedRangeSO = new NamedRange__c(
			NamedRangeTotalId__c = namedRangeTotalSO.Id,
			QuoteId__c = quoteSO.Id
		);
		NamedRange__c namedRangeSO2 = new NamedRange__c(
			NamedRangeTotalId__c = namedRangeTotalSO2.Id,
			QuoteId__c = quoteSO.Id
		);
		CRUDUtility.insertRecords(new List<NamedRange__c>{ namedRangeSO, namedRangeSO2 });

		Adjustment__c adjustmentSO = new Adjustment__c(NamedRangeId__c = namedRangeSO.Id);
		Adjustment__c adjustmentSO2 = new Adjustment__c(NamedRangeId__c = namedRangeSO2.Id);
		CRUDUtility.insertRecords(new List<Adjustment__c>{ adjustmentSO, adjustmentSO2 });

		LocationDiscountAdjustment__c locationAdjustmentSO = new LocationDiscountAdjustment__c(
			LocationDiscountId__c = locationDiscountSO.Id,
			AdjustmentId__c = adjustmentSO.Id
		);
		LocationDiscountAdjustment__c locationAdjustmentSO2 = new LocationDiscountAdjustment__c(
			LocationDiscountId__c = locationDiscountSO.Id,
			AdjustmentId__c = adjustmentSO2.Id
		);
		CRUDUtility.insertRecords(
			new List<LocationDiscountAdjustment__c>{ locationAdjustmentSO, locationAdjustmentSO2 }
		);

		Test.startTest();

		List<LocationDiscountReviewDto> locationDiscounts = LocationDiscountReviewController.getLocationDiscountReviewForQuote(
			quoteSO.Id
		);
		System.assert(locationDiscounts.size() == 1, 'Should have location discount reviews');
		System.assert(
			locationDiscounts[0].discountAmount == 100,
			'Should have discount amount = 100 for 10%'
		);
		System.assert(
			locationDiscounts[0].newAmount == 900,
			'Should have new amount = 900 after 10% disount'
		);

		Test.stopTest();
	}
}
