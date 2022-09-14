@IsTest
private class ColaRateSheetServiceTest extends ColaRateSheetTestBase {
	@TestSetup
	static void setupData() {
		ColaRateSheet__c rateSheet = newColaRateSheet();
		List<Product__c> resourceRoles = createResourceRoles();
		createColaRates(rateSheet.Id, resourceRoles);
	}

	@IsTest
	static void shouldReturnTheGlobalRateSheet() {
		ColaRateSheet__c rateSheet = newColaRateSheet();
		rateSheet.Type__c = ColaRateSheet.TYPE_GLOBAL;
		CRUDUtility.upsertRecords(rateSheet);

		Test.startTest();
		System.assert(
			ColaRateSheetService.getActiveGlobalRateSheet() != null,
			'should return a global rate sheet'
		);
		Test.stopTest();
	}

	@IsTest
	static void itShouldCloneTheColaRateSheet() {
		ColaRateSheet__c colaRateSheet = [
			SELECT Id, Name, DerivedFromId__c
			FROM ColaRateSheet__c
			WHERE Name = 'SFDC UT Rate Sheet'
		];

		ColaRateSheetCloneController.ColaRateSheetData cloneData = new ColaRateSheetCloneController.ColaRateSheetData();
		cloneData.name = 'SFDC UT Rate Sheet V1';
		cloneData.yearOverYearRate = 15.00;

		Test.startTest();
		ColaRateSheet__c clonedColaRateSheet = ColaRateSheetService.cloneColaRateSheet(
			colaRateSheet.Id,
			JSON.serialize(cloneData)
		);
		Test.stopTest();

		System.assert(clonedColaRateSheet != null, 'should clone Cola Rate Sheet Record');
		System.assertEquals(cloneData.name, clonedColaRateSheet.Name, 'should copy the name');
		System.assertEquals(
			[SELECT Id FROM ColaRate__c WHERE RateSheetId__c = :colaRateSheet.Id].size(),
			[SELECT Id FROM ColaRate__c WHERE RateSheetId__c = :clonedColaRateSheet.Id].size(),
			'should clone all the Cola Rates from Cola Rate Sheet'
		);
	}
}
