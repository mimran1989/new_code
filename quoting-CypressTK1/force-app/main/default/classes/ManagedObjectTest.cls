/**
 *  Provus Services Quoting
 *  ManagedObjectTest
 *  @2021 Provus Inc. All rights reserved.
 */
@IsTest
public with sharing class ManagedObjectTest extends TestBase {
	@IsTest
	static void itShouldReturnManagedSO() {
		Quote__c quoteSO = newQuote();

		Test.startTest();
		ManagedObject testManagedObject = new ManagedObject(quoteSO);
		System.assertEquals(
			quoteSO,
			(Quote__c) testManagedObject.getSObject(),
			'should return the sObject DO'
		);
		Test.stopTest();
	}
}
