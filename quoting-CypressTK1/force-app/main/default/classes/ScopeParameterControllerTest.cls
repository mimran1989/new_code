@IsTest
public with sharing class ScopeParameterControllerTest extends TestBase {
	@IsTest
	static void isShouldGetScopeParametersForEstimate() {
		Estimate__c estimate = newEstimate();

		List<ScopeParameter__c> parameters = new List<ScopeParameter__c>();
		parameters.add(getScopeParameterSO('Test 1', estimate.Id));
		parameters.add(getScopeParameterSO('Test 2', estimate.Id));

		CRUDUtility.insertRecords(parameters);

		Test.startTest();
		List<ScopeParameterDto> params = ScopeParameterController.getScopeParameters(estimate.Id);
		System.assertEquals(params.size(), 2, 'should have the 2 parameters');
		Test.stopTest();
	}

	@IsTest
	static void isShouldSaveScopeParametersForEstimate() {
		Estimate__c estimate = newEstimate();

		List<ScopeParameter__c> parameters = new List<ScopeParameter__c>();
		parameters.add(getScopeParameterSO('Test 1', estimate.Id));
		parameters.add(getScopeParameterSO('Test 2', estimate.Id));

		CRUDUtility.insertRecords(parameters);

		Test.startTest();

		List<ScopeParameterDto> params = ScopeParameterController.getScopeParameters(estimate.Id);

		params[0].value.integerValue = 10;

		List<ScopeParameterValueDto> paramValues = new List<ScopeParameterValueDto>();
		paramValues.add(params[0].value);

		ScopeParameterController.saveScopeParameters(paramValues);

		List<ScopeParameterDto> savedParams = ScopeParameterController.getScopeParameters(estimate.Id);

		System.assertEquals(savedParams.size(), 2, 'should have the 2 parameters');
		System.assertEquals(
			savedParams[0].value.integerValue,
			10,
			'should have the integer value as 10'
		);
		Test.stopTest();
	}

	static ScopeParameter__c getScopeParameterSO(String name, Id estimateId) {
		return new ScopeParameter__c(
			Name = name,
			DataType__c = 'Integer',
			DeveloperName__c = 'dn1',
			Sequence__c = 1,
			EstimateId__c = estimateId
		);
	}
}
