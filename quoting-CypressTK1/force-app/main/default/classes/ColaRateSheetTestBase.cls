/**
 *  Provus Services Quoting
 *  ColaRateSheetTestsBase : This is Tests Base for cola rate sheet Object
 *  @2021 Provus Inc. All rights reserved.
 */
public with sharing abstract class ColaRateSheetTestBase extends TestBase {
	/**
	 * Create a Cola Rate Sheet record.
	 * @return  ColaRateSheet__c : Cloned Cola Rate Sheet Object
	 */
	public static ColaRateSheet__c newColaRateSheet() {
		ColaRateSheet__c rateSheet = new ColaRateSheet__c(Name = 'SFDC UT Rate Sheet');
		CRUDUtility.insertRecords(rateSheet);
		return rateSheet;
	}

	/**
	 * Creates set of resource roles for Cola Setup.
	 * @return  List<Product__c> : List of Resource Roles
	 */
	public static List<Product__c> createResourceRoles() {
		Id resourceRoleTypeId = SObjectUtility.getRecordTypeIdbyName(
			Schema.SObjectType.Product__c.getName(),
			'Resource Role'
		);

		List<Product__c> resourceRoles = new List<Product__c>();
		resourceRoles.add(newProduct('Software Engineer', resourceRoleTypeId));
		resourceRoles.add(newProduct('Project Manager', resourceRoleTypeId));
		resourceRoles.add(newProduct('Configuration Engineer', resourceRoleTypeId));

		CRUDUtility.insertRecords(resourceRoles);
		return resourceRoles;
	}

	/**
	 * Create a Set od Cola Rate records.
	 * @param   Id of the Cola Rate Sheet Record
	 * @param   List<Product__c> : List of Cola Rate Sheet Records
	 * @return  List<ColaRate__c> : List of Cola Rates Records
	 */
	public static List<ColaRate__c> createColaRates(
		Id colaRateSheetId,
		List<Product__c> resourceRoles
	) {
		List<ColaRate__c> colaRates = new List<ColaRate__c>();
		for (Product__c resourceRole : resourceRoles) {
			ColaRate__c colaRate = new ColaRate__c(
				RateSheetId__c = colaRateSheetId,
				Country__c = 'United States',
				State__c = 'California',
				YearOverYearRate__c = 13.5
			);
			colaRate.ServiceYear__c = Date.today().year();
		}

		return (List<ColaRate__c>) CRUDUtility.insertRecords(colaRates);
	}
}
