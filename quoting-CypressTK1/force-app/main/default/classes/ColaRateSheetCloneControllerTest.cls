@IsTest
private class ColaRateSheetCloneControllerTest extends ColaRateSheetTestBase {
	@TestSetup
	static void setupData() {
		ColaRateSheet__c rateSheet = newColaRateSheet();
		List<Product__c> resourceRoles = createResourceRoles();
		createColaRates(rateSheet.Id, resourceRoles);
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
		Id clonedColaRateSheetId = ColaRateSheetCloneController.cloneColaRateSheet(
			colaRateSheet.Id,
			JSON.serialize(cloneData)
		);
		Test.stopTest();

		ColaRateSheet__c clonedColaRateSheet = [
			SELECT Id, Name, DerivedFromId__c
			FROM ColaRateSheet__c
			WHERE Id = :clonedColaRateSheetId
		];

		System.assert(clonedColaRateSheetId != null, 'should clone Cola Rate Sheet Record');
		System.assertEquals(cloneData.name, clonedColaRateSheet.Name, 'should copy the name');
		System.assertEquals(
			[SELECT Id FROM ColaRate__c WHERE RateSheetId__c = :colaRateSheet.Id].size(),
			[SELECT Id FROM ColaRate__c WHERE RateSheetId__c = :clonedColaRateSheetId].size(),
			'should clone all the Cola Rates from Cola Rate Sheet'
		);
	}
}
