/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
@IsTest
private class ScopeParameterDialogControllerTest extends EstimateTestBase {
	@IsTest
	static void shouldSaveScopeParameters() {
		RateCard__c rateCardSo = newRateCard();
		EstimateTemplate__c templateSo = EstimateTemplateTestBase.newEstimateTemplate(rateCardSo.Id);
		ScopeParameterTemplateDto paramDto = new ScopeParameterTemplateDto();

		Test.startTest();
		{
			List<ScopeParameterTemplateDto> savedParamDtos = ScopeParameterDialogController.saveScopeParameters(
				templateSo.Id,
				new List<ScopeParameterTemplateDto>{ paramDto }
			);
			System.assertEquals(1, savedParamDtos.size(), 'should not be empty');
			System.assert(!String.isBlank(savedParamDtos.get(0).id), 'should be assigned an ID');
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldDeleteScopeParameters() {
		RateCard__c rateCardSo = newRateCard();
		EstimateTemplate__c templateSo = EstimateTemplateTestBase.newEstimateTemplate(rateCardSo.Id);
		ScopeParameterTemplateDto paramDto = new ScopeParameterTemplateDto();

		Test.startTest();
		{
			ScopeParameterDialogController.deleteScopeParameters(
				ScopeParameterDialogController.saveScopeParameters(
					templateSo.Id,
					new List<ScopeParameterTemplateDto>{ paramDto }
				)
			);

			List<ScopeParameterTemplateDto> savedParamDtos = ScopeParameterDialogController.getScopeParameters(
				templateSo.Id
			);
			System.assertEquals(0, savedParamDtos.size(), 'should be empty');
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldSaveScopeParameterValues() {
		RateCard__c rateCardSo = newRateCard();
		EstimateTemplate__c templateSo = EstimateTemplateTestBase.newEstimateTemplate(rateCardSo.Id);
		ScopeParameterTemplateDto paramDto = new ScopeParameterTemplateDto();
		ScopeParameterValueTemplateDto valueDto = new ScopeParameterValueTemplateDto();
		paramDto.paramValues = new List<ScopeParameterValueTemplateDto>{ valueDto };

		Test.startTest();
		{
			List<ScopeParameterTemplateDto> savedParamDtos = ScopeParameterDialogController.saveScopeParameters(
				templateSo.Id,
				new List<ScopeParameterTemplateDto>{ paramDto }
			);
			System.assertEquals(1, savedParamDtos.get(0).paramValues.size(), 'should not be empty');
		}
		Test.stopTest();
	}

	@IsTest
	static void shouldDeleteScopeParameterValues() {
		RateCard__c rateCardSo = newRateCard();
		EstimateTemplate__c templateSo = EstimateTemplateTestBase.newEstimateTemplate(rateCardSo.Id);
		ScopeParameterTemplateDto paramDto = new ScopeParameterTemplateDto();
		ScopeParameterValueTemplateDto valueDto = new ScopeParameterValueTemplateDto();
		paramDto.paramValues = new List<ScopeParameterValueTemplateDto>{ valueDto };

		Test.startTest();
		{
			ScopeParameterDialogController.deleteScopeParameterValues(
				ScopeParameterDialogController.saveScopeParameters(
						templateSo.Id,
						new List<ScopeParameterTemplateDto>{ paramDto }
					)
					.get(0)
					.paramValues
			);

			List<ScopeParameterTemplateDto> savedParamDtos = ScopeParameterDialogController.getScopeParameters(
				templateSo.Id
			);
			System.assertEquals(0, savedParamDtos.get(0).paramValues.size(), 'should be empty');
		}
		Test.stopTest();
	}
}
