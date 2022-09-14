/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
@IsTest
public class EstimateTemplateTestBase {
	public static EstimateTemplate__c newEstimateTemplate(Id rateCardId) {
		EstimateTemplate__c newEstimateTemplate = new EstimateTemplate__c(RateCardId__c = rateCardId);
		CRUDUtility.insertRecords(newEstimateTemplate);

		return newEstimateTemplate;
	}

	public static TaskTemplate__c newTaskTemplate(
		String taskTemplateName,
		Map<String, String> fieldValues,
		Integer sequence
	) {
		TaskTemplate__c taskTemplate = new TaskTemplate__c();
		taskTemplate.IsActive__c = true;
		taskTemplate.Sequence__c = sequence;
		taskTemplate.Name = taskTemplateName;

		for (String field : fieldValues.keySet()) {
			taskTemplate.put(field, fieldValues.get(field));
		}

		return taskTemplate;
	}

	public static ActivityTemplate__c newActivityTemplate(
		String activityTemplateName,
		Map<String, String> fieldValues,
		Integer sequence
	) {
		ActivityTemplate__c activityTemplate = new ActivityTemplate__c();
		activityTemplate.IsActive__c = true;
		activityTemplate.Sequence__c = sequence;
		activityTemplate.Name = activityTemplateName;

		for (String field : fieldValues.keySet()) {
			activityTemplate.put(field, fieldValues.get(field));
		}

		return activityTemplate;
	}

	public static PhaseTemplate__c newPhaseTemplate(
		String phaseTemplateName,
		Map<String, String> fieldValues,
		Integer sequence
	) {
		PhaseTemplate__c phaseTemplate = new PhaseTemplate__c();
		phaseTemplate.IsActive__c = true;
		phaseTemplate.Sequence__c = sequence;
		phaseTemplate.Name = phaseTemplateName;

		for (String field : fieldValues.keySet()) {
			phaseTemplate.put(field, fieldValues.get(field));
		}

		return phaseTemplate;
	}

	public static ActivityGroupTemplate__c newActivityGroupTemplate(
		String activityGroupTemplateName,
		Map<String, String> fieldValues,
		Integer sequence
	) {
		ActivityGroupTemplate__c activityGroupTemplate = new ActivityGroupTemplate__c();
		activityGroupTemplate.IsActive__c = true;
		activityGroupTemplate.Sequence__c = sequence;
		activityGroupTemplate.Name = activityGroupTemplateName;

		for (String field : fieldValues.keySet()) {
			activityGroupTemplate.put(field, fieldValues.get(field));
		}

		return activityGroupTemplate;
	}

	public static EstimateTemplate__c newEstimateTemplate(Map<String, Object> fieldValues) {
		EstimateTemplate__c estimateTemplate = new EstimateTemplate__c();
		estimateTemplate.IsActive__c = true;
		for (String field : fieldValues.keySet()) {
			estimateTemplate.put(field, fieldValues.get(field));
		}

		return estimateTemplate;
	}

	public static List<TaskTemplate__c> createTaskTemplates(
		List<ActivityTemplate__c> activityTemplates,
		List<Product__c> resourceRoles
	) {
		//Task Template Configuration values
		Map<String, String> taskTemplateValues = new Map<String, String>();
		taskTemplateValues.put('ResourceRoleId__c', (String) resourceRoles[0].Id);
		taskTemplateValues.put('Guidance__c', EstimateTestBase.GUIDANCE);
		taskTemplateValues.put('Description__c', EstimateTestBase.DESCRIPTION);
		taskTemplateValues.put('ActivityTemplateId__c', (String) activityTemplates[0].Id);

		List<TaskTemplate__c> taskTemplates = new List<TaskTemplate__c>();
		TaskTemplate__c taskTemplate1 = newTaskTemplate('Kick-Off', taskTemplateValues, 1);
		taskTemplateValues.put('ActivityTemplateId__c', (String) activityTemplates[1].Id);
		taskTemplateValues.put('ResourceRoleId__c', (String) resourceRoles[1].Id);
		TaskTemplate__c taskTemplate2 = newTaskTemplate('JIRA Process Setup', taskTemplateValues, 1);

		taskTemplates.add(taskTemplate1);
		taskTemplates.add(taskTemplate2);
		CRUDUtility.insertRecords(taskTemplates);
		return taskTemplates;
	}

	public static List<ActivityTemplate__c> createActivityTemplates(
		List<ActivityGroupTemplate__c> activityGroupTemplates
	) {
		Map<String, String> activityTemplateValues = new Map<String, String>();
		activityTemplateValues.put('Guidance__c', EstimateTestBase.GUIDANCE);
		activityTemplateValues.put('Description__c', EstimateTestBase.DESCRIPTION);
		activityTemplateValues.put('ActivityGroupTemplateId__c', (String) activityGroupTemplates[0].Id);

		List<ActivityTemplate__c> activityTemplates = new List<ActivityTemplate__c>();
		ActivityTemplate__c activityTemplate1 = newActivityTemplate(
			'Kick-Off',
			activityTemplateValues,
			1
		);
		activityTemplateValues.put('ActivityGroupTemplateId__c', (String) activityGroupTemplates[1].Id);
		ActivityTemplate__c activityTemplate2 = newActivityTemplate(
			'JIRA Setup',
			activityTemplateValues,
			1
		);
		activityTemplates.add(activityTemplate1);
		activityTemplates.add(activityTemplate2);

		CRUDUtility.insertRecords(activityTemplates);
		return activityTemplates;
	}

	public static List<ActivityGroupTemplate__c> createActivityGroupTemplates(
		Id estimateTemplateId,
		Id phaseId
	) {
		//Activity Group Template Configuration Values
		Map<String, String> activityGroupValues = new Map<String, String>();
		activityGroupValues.put('Guidance__c', EstimateTestBase.GUIDANCE);
		activityGroupValues.put('Description__c', EstimateTestBase.DESCRIPTION);
		activityGroupValues.put('EstimateTemplateId__c', (String) estimateTemplateId);
		activityGroupValues.put('PhaseTemplateId__c', (String) phaseId);

		List<ActivityGroupTemplate__c> activityGroupTemplates = new List<ActivityGroupTemplate__c>();
		ActivityGroupTemplate__c activityGroupTemp1 = newActivityGroupTemplate(
			'Initiation',
			activityGroupValues,
			1
		);
		ActivityGroupTemplate__c activityGroupTemp2 = newActivityGroupTemplate(
			'Design',
			activityGroupValues,
			2
		);
		activityGroupTemplates.add(activityGroupTemp1);
		activityGroupTemplates.add(activityGroupTemp2);

		CRUDUtility.insertRecords(activityGroupTemplates);
		return activityGroupTemplates;
	}

	public static List<ActivityGroupTemplate__c> createActivityGroupTemplates(Id estimateTemplateId) {
		//Activity Group Template Configuration Values
		Map<String, String> activityGroupValues = new Map<String, String>();
		activityGroupValues.put('Guidance__c', EstimateTestBase.GUIDANCE);
		activityGroupValues.put('Description__c', EstimateTestBase.DESCRIPTION);
		activityGroupValues.put('EstimateTemplateId__c', (String) estimateTemplateId);

		List<ActivityGroupTemplate__c> activityGroupTemplates = new List<ActivityGroupTemplate__c>();
		ActivityGroupTemplate__c activityGroupTemp1 = newActivityGroupTemplate(
			'Initiation',
			activityGroupValues,
			1
		);
		ActivityGroupTemplate__c activityGroupTemp2 = newActivityGroupTemplate(
			'Design',
			activityGroupValues,
			2
		);
		activityGroupTemplates.add(activityGroupTemp1);
		activityGroupTemplates.add(activityGroupTemp2);

		CRUDUtility.insertRecords(activityGroupTemplates);
		return activityGroupTemplates;
	}

	public static List<PhaseTemplate__c> createPhaseTemplates(Id estimateTemplateId) {
		//Activity Group Template Configuration Values
		Map<String, String> phaseValues = new Map<String, String>();
		phaseValues.put('Guidance__c', EstimateTestBase.GUIDANCE);
		phaseValues.put('Description__c', EstimateTestBase.DESCRIPTION);
		phaseValues.put('EstimateTemplateId__c', (String) estimateTemplateId);

		List<PhaseTemplate__c> phaseTemplates = new List<PhaseTemplate__c>();
		PhaseTemplate__c phaseTemp1 = newPhaseTemplate('Phase 1', phaseValues, 1);
		phaseTemplates.add(phaseTemp1);

		CRUDUtility.insertRecords(phaseTemplates);
		return phaseTemplates;
	}

	public static EstimateTemplate__c newEstimateTemplate(Boolean usePhase) {
		//Estimate Template Configuration Values
		Map<String, Object> estimateTemplateValues = new Map<String, Object>();
		estimateTemplateValues.put('Guidance__c', EstimateTestBase.GUIDANCE);
		estimateTemplateValues.put('Description__c', EstimateTestBase.DESCRIPTION);
		estimateTemplateValues.put('Name', 'CLM Development Estimate');
		estimateTemplateValues.put('UseProjectPhases__c', usePhase);

		EstimateTemplate__c estimateTemplate = newEstimateTemplate(estimateTemplateValues);

		CRUDUtility.insertRecords(estimateTemplate);
		return estimateTemplate;
	}

	public static EstimateTemplate__c newEstimateTemplate() {
		return newEstimateTemplate(false);
	}
}
