@IsTest
private class CreateEstimateServiceTest extends EstimateTestBase {
	@testSetup
	static void setup() {
		EstimateTemplate__c estimateTemplate = EstimateTemplateTestBase.newEstimateTemplate();
		List<ActivityGroupTemplate__c> activityGroupTemplates = EstimateTemplateTestBase.createActivityGroupTemplates(
			estimateTemplate.Id,
			null
		);
		List<ActivityTemplate__c> activityTemplates = EstimateTemplateTestBase.createActivityTemplates(
			activityGroupTemplates
		);
		List<Product__c> resourceRoles = createResourceRoles();
		EstimateTemplateTestBase.createTaskTemplates(activityTemplates, resourceRoles);
	}

	@IsTest
	static void phaseSetup() {
		EstimateTemplate__c estimateTemplate = EstimateTemplateTestBase.newEstimateTemplate(true);
		CRUDUtility.updateRecords(estimateTemplate);
		List<PhaseTemplate__c> phaseTemplates = EstimateTemplateTestBase.createPhaseTemplates(
			estimateTemplate.Id
		);
		EstimateTemplateTestBase.createActivityGroupTemplates(
			estimateTemplate.Id,
			phaseTemplates[0].Id
		);

		Test.startTest();
		EstimateTemplate__c estimateTemplate1 = [
			SELECT
				Id,
				Name,
				Description__c,
				Guidance__c,
				IsActive__c,
				RateCardId__c,
				ProductId__c,
				ServiceId__c,
				UseProjectPhases__c,
				ServiceId__r.Name,
				(
					SELECT Id, Name, Description__c, Guidance__c, Sequence__c, IsActive__c, PhaseTemplateId__c
					FROM ActivityGroups__r
					WHERE IsActive__c = TRUE
				),
				(
					SELECT Id, Name, Description__c, Guidance__c, Sequence__c
					FROM Phases__r
					WHERE IsActive__c = TRUE
				)
			FROM EstimateTemplate__c
			WHERE Id = :estimateTemplate.Id
			WITH SECURITY_ENFORCED
		];

		Estimate__c estimate = Estimate.newSO(estimateTemplate1);
		CRUDUtility.insertRecords(estimate);
		Map<Id, Phase__c> phasesByTemplateId = CreateEstimateSupport.createPhases(
			estimateTemplate1,
			estimate.Id
		);

		System.assertEquals(
			estimateTemplate1.Phases__r.size(),
			phasesByTemplateId.values().size(),
			'Phases not configured properly'
		);

		Map<Id, ActivityGroup__c> activitiesByTemplateId = CreateEstimateSupport.createActivityGroups(
			estimateTemplate.ActivityGroups__r,
			estimate.Id,
			phasesByTemplateId
		);
		Test.stopTest();

		System.assertEquals(
			estimateTemplate.ActivityGroups__r.size(),
			activitiesByTemplateId.values().size(),
			'Activities not configured properly'
		);
	}

	@IsTest
	static void createEstimateFromEstimateTemplateTest() {
		EstimateTemplate__c estimateTemplate = [
			SELECT
				Id,
				Name,
				Description__c,
				Guidance__c,
				IsActive__c,
				RateCardId__c,
				ProductId__c,
				ServiceId__c,
				UseProjectPhases__c,
				ServiceId__r.Name
			FROM EstimateTemplate__c
			WHERE Name = 'CLM Development Estimate'
		];

		Test.startTest();
		Estimate__c estimate = Estimate.newSO(estimateTemplate);
		Test.stopTest();

		System.assertEquals(estimateTemplate.Name, estimate.Name, 'Estimate not configured properly');
		System.assertEquals(
			estimateTemplate.Description__c,
			estimate.Description__c,
			'Estimate not configured properly'
		);
	}

	@IsTest
	static void getActivityGroupsFromTemplateTest() {
		EstimateTemplate__c estimateTemplate = [
			SELECT
				Id,
				Name,
				Description__c,
				Guidance__c,
				IsActive__c,
				RateCardId__c,
				ProductId__c,
				ServiceId__c,
				UseProjectPhases__c,
				ServiceId__r.Name,
				(
					SELECT Id, Name, Description__c, Guidance__c, Sequence__c, PhaseTemplateId__c
					FROM ActivityGroups__r
					WHERE IsActive__c = TRUE
				)
			FROM EstimateTemplate__c
			WHERE Name = 'CLM Development Estimate'
		];

		Test.startTest();
		Estimate__c estimate = Estimate.newSO(estimateTemplate);
		CRUDUtility.insertRecords(estimate);
		Map<Id, ActivityGroup__c> activitiesByTemplateId = CreateEstimateSupport.createActivityGroups(
			estimateTemplate.ActivityGroups__r,
			estimate.Id,
			new Map<Id, Phase__c>()
		);
		Test.stopTest();

		System.assertEquals(
			estimateTemplate.ActivityGroups__r.size(),
			activitiesByTemplateId.values().size(),
			'Activities not configured properly'
		);
	}
}
