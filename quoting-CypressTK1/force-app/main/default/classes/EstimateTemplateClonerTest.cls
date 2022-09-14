/**
 *  Provus Services Quoting
 *  EstimateTemplateClonerTest
 *  @2021 Provus Inc. All rights reserved.
 */
@IsTest
public with sharing class EstimateTemplateClonerTest extends EstimateTestBase {
	@testSetup
	static void setup() {
		List<Product__c> resourceRoles = createResourceRoles();
		RateCard__c rateCard = newRateCardWithItems(resourceRoles);

		EstimateTemplate__c estimateTemplate = TestDataFactory.createEstimateTemplate(
			'EstimateTemplate1',
			true,
			rateCard.id
		);
		estimateTemplate.UseProjectPhases__c = true;
		insert estimateTemplate;

		PhaseTemplate__c phaseTemplate = TestDataFactory.createPhaseTemplate(
			'PhaseTemplate',
			estimateTemplate.Id
		);
		insert phaseTemplate;

		ActivityGroupTemplate__c activityGroupTemplate = TestDataFactory.createActivityGroupTemplate(
			'ActivityGroup',
			true,
			estimateTemplate.Id
		);
		activityGroupTemplate.EstimateTemplateId__c = estimateTemplate.Id;
		insert activityGroupTemplate;

		ActivityTemplate__c activityTemplate = TestDataFactory.createActivityTemplate(
			'Activity',
			true,
			activityGroupTemplate.Id
		);
		insert activityTemplate;

		TaskTemplate__c taskTemplate = TestDataFactory.createTaskTemplate(
			'Task',
			true,
			activityTemplate.Id
		);
		insert taskTemplate;

		TaskParameterTemplate__c taskParameterTemplate = TestDataFactory.createTaskParamTemplate(
			'TaskParam',
			true,
			taskTemplate.Id
		);
		insert taskParameterTemplate;

		TaskParameterValueTemplate__c taskParameterValueTemplate = TestDataFactory.createTaskParamValueTemplate(
			taskParameterTemplate.Id
		);
		insert taskParameterValueTemplate;
	}

	@IsTest
	static void testMethod1() {
		String clonedEstimateTemplateId = EstimateTemplateCloner.cloneEstimateTemplate(
			[SELECT Id FROM EstimateTemplate__c LIMIT 1]
			.Id,
			'ClonedEstimateTemplate'
		);
		system.assertEquals(
			'ClonedEstimateTemplate',
			[SELECT Id, Name FROM EstimateTemplate__c WHERE ID = :clonedEstimateTemplateId]
			.Name,
			'Estimate Template Cloned Successfully'
		);
		List<PhaseTemplate__c> lstPhaseTemplates = [
			SELECT Id, Name
			FROM PhaseTemplate__c
			WHERE EstimateTemplateId__c = :clonedEstimateTemplateId
		];
		system.assertEquals(true, lstPhaseTemplates.size() > 0, 'Phase Template Cloned Successfully');
		List<ActivityGroupTemplate__c> lstActivityGroupTemplates = [
			SELECT Id
			FROM ActivityGroupTemplate__c
			WHERE EstimateTemplateId__c = :clonedEstimateTemplateId
		];
		system.assertEquals(
			true,
			lstActivityGroupTemplates.size() > 0,
			'Activity Group Templates Cloned Successfully'
		);
		List<ActivityTemplate__c> lstActivityTemplates = [
			SELECT Id
			FROM ActivityTemplate__c
			WHERE ActivityGroupTemplateId__c = :lstActivityGroupTemplates
		];
		system.assertEquals(
			true,
			lstActivityTemplates.size() > 0,
			'Activity Templates Cloned Successfully'
		);
		List<TaskTemplate__c> lstTaskTemplates = [
			SELECT Id, Name
			FROM TaskTemplate__c
			WHERE ActivityTemplateId__c = :lstActivityTemplates
		];
		system.assertEquals(true, lstTaskTemplates.size() > 0, 'Resource Default Cloned Successfully');
		List<TaskParameterTemplate__c> lstTaskParameterTemplates = [
			SELECT Id, Name
			FROM TaskParameterTemplate__c
			WHERE TaskTemplateId__c = :lstTaskTemplates
		];
		system.assertEquals(
			true,
			lstTaskParameterTemplates.size() > 0,
			'Task Parameter Templates Cloned Successfully'
		);
		List<TaskParameterValueTemplate__c> lstTaskParameterValueTemplates = [
			SELECT Id, Name
			FROM TaskParameterValueTemplate__c
			WHERE TaskParameterTemplateId__c = :lstTaskParameterTemplates
		];
		system.assertEquals(
			true,
			lstTaskParameterValueTemplates.size() > 0,
			'Task Parameter Value Templates Cloned Successfully'
		);
	}
}
