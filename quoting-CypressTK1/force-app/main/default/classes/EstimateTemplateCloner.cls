/**
 *  Provus Services Quoting
 *  EstimateTemplateCloner : This is controller for EstimateTemplateCloner lwc component.
 *  @2021 Provus Inc. All rights reserved.
 */
public with sharing class EstimateTemplateCloner {
	@AuraEnabled
	public static String cloneEstimateTemplate(
		String estimateTemplateId,
		String estimateTemplateName
	) {
		//Create Cloned EstimateTemplate
		EstimateTemplate__c newEstimateTemplate = new EstimateTemplate__c();
		newEstimateTemplate.Name = EstimateTemplateName;

		newEstimateTemplate = cloneEstimateTemplates(estimateTemplateId, newEstimateTemplate);

		//Create Cloned phaseTemplates
		Map<Id, PhaseTemplate__c> phaseTemplateMap = new Map<Id, PhaseTemplate__c>();
		if (newEstimateTemplate.UseProjectPhases__c == true) {
			clonePhaseTemplates(phaseTemplateMap, newEstimateTemplate, estimateTemplateId);
		}
		//Create Cloned ActivityGroup
		Map<Id, ActivityGroupTemplate__c> activityGroupTemplateMap = cloneActivityGroupTemplates(
			newEstimateTemplate,
			estimateTemplateId,
			phaseTemplateMap
		);

		//Create Cloned Activity
		Map<Id, ActivityTemplate__c> activityTemplateMap = new Map<Id, ActivityTemplate__c>();
		cloneActivityTemplates(activityTemplateMap, activityGroupTemplateMap);

		//Create Cloned ScopeParameter for ActivityTemplate
		Map<Id, ScopeParameterTemplate__c> scopeParameterTemplateMap = new Map<Id, ScopeParameterTemplate__c>();
		cloneScopeParameterTemplate(scopeParameterTemplateMap, activityTemplateMap);

		//Create Cloned ScopeParameter For EstimateTemplate
		Map<Id, ScopeParameterTemplate__c> scopeParameterForEstimateTemplateMap = new Map<Id, ScopeParameterTemplate__c>();
		cloneScopeParameterForEstimateTemplate(
			scopeParameterForEstimateTemplateMap,
			newEstimateTemplate,
			estimateTemplateId
		);

		//Create Cloned ScopeParameter for ActivityGroupTemplate
		Map<Id, ScopeParameterTemplate__c> scopeParameterForActivityGroupTemplateMap = new Map<Id, ScopeParameterTemplate__c>();
		cloneScopeParameterForActivityGroupTemplate(
			scopeParameterForActivityGroupTemplateMap,
			activityGroupTemplateMap
		);

		//Create Cloned ScopeParameterValues for ScopeParameter associated with Activity
		Map<Id, ScopeParameterValueTemplate__c> scopeParameterValueTemplateMap = new Map<Id, ScopeParameterValueTemplate__c>();
		cloneScopeParameterValueTemplate(scopeParameterValueTemplateMap, scopeParameterTemplateMap);

		//Create Cloned ScopeParameterValues for ScopeParameterTemplate associated with Estimate Template
		Map<Id, ScopeParameterValueTemplate__c> scopeParameterValueEstimateTemplateMap = new Map<Id, ScopeParameterValueTemplate__c>();
		cloneScopeParameterValueForEstimateTemplate(
			scopeParameterValueEstimateTemplateMap,
			scopeParameterForEstimateTemplateMap
		);

		//Create Cloned ScopeParameterValues for ScopeParameterTemplate associated with ActivityGroup
		Map<Id, ScopeParameterValueTemplate__c> scopeParameterValueActivityGroupMap = new Map<Id, ScopeParameterValueTemplate__c>();
		cloneScopeParameterValueForActivityGroup(
			scopeParameterValueActivityGroupMap,
			scopeParameterForActivityGroupTemplateMap
		);

		//Create Cloned Tasks
		Map<Id, TaskTemplate__c> taskTemplateMap = new Map<Id, TaskTemplate__c>();
		Map<Id, TaskParameterTemplate__c> taskParameterTemplateMap = new Map<Id, TaskParameterTemplate__c>();
		cloneTaskTemplates(taskTemplateMap, activityTemplateMap);
		if (!SystemUtility.nullOrEmpty(taskTemplateMap)) {
			//Create Cloned Task Parameter Templates
			cloneTaskParameterTemplates(taskParameterTemplateMap, taskTemplateMap);
		}
		if (!SystemUtility.nullOrEmpty(taskParameterTemplateMap)) {
			//Create Cloned Tasks
			Map<Id, TaskParameterValueTemplate__c> taskParameterValueTemplateMap = new Map<Id, TaskParameterValueTemplate__c>();
			cloneTaskParameterValueTemplates(taskParameterValueTemplateMap, taskParameterTemplateMap);
		}
		//Create Cloned Resource Defaults
		Map<Id, ResourceDefault__c> resourceDefaultMap = new Map<Id, ResourceDefault__c>();
		cloneResourceDefaults(resourceDefaultMap, newEstimateTemplate, estimateTemplateId);

		return newEstimateTemplate.Id;
	}

	public static EstimateTemplate__c cloneEstimateTemplates(
		Id estimateTemplateId,
		EstimateTemplate__c newEstimateTemplate
	) {
		// Creating EstimateTemplate
		String clonedEstimateTemplateName = newEstimateTemplate.Name;
		QueryRequest queryRequest = new QueryRequest(Schema.EstimateTemplate__c.SObjectType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(
			Schema.EstimateTemplate__c.SObjectType
		);
		queryRequest.setFilterBy(
			new Map<String, String>{ SObjectUtility.FIELD_ID => estimateTemplateId }
		);
		List<EstimateTemplate__c> listEstimateTemplate = (List<EstimateTemplate__c>) SOQLUtility.querySObject(
			queryRequest
		);
		EstimateTemplate__c existingEstimateTemplate = listEstimateTemplate[0];
		newEstimateTemplate = existingEstimateTemplate.clone();
		newEstimateTemplate.UseProjectPhases__c = existingEstimateTemplate.UseProjectPhases__c;
		newEstimateTemplate.Name = clonedEstimateTemplateName;
		CRUDUtility.insertRecords(newEstimateTemplate);
		return newEstimateTemplate;
	}
	private static void clonePhaseTemplates(
		Map<Id, PhaseTemplate__c> phaseTemplateMap,
		EstimateTemplate__c newEstimateTemplate,
		Id estimateTemplateId
	) {
		QueryRequest queryRequest = new QueryRequest(Schema.PhaseTemplate__c.SObjectType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(
			Schema.PhaseTemplate__c.SObjectType
		);
		queryRequest.setFilterBy(
			new Map<String, String>{
				Schema.PhaseTemplate__c.EstimateTemplateId__c + '' => estimateTemplateId
			}
		);
		List<PhaseTemplate__c> listPhaseTemplates = (List<PhaseTemplate__c>) SOQLUtility.querySObject(
			queryRequest
		);
		for (PhaseTemplate__c phaseTemplate : listPhaseTemplates) {
			PhaseTemplate__c phaseTemplateNew = phaseTemplate.clone();
			phaseTemplateNew.EstimateTemplateId__c = newEstimateTemplate.Id;
			phaseTemplateMap.put(phaseTemplate.Id, phaseTemplateNew);
		}
		CRUDUtility.insertRecords(phaseTemplateMap.values());
	}
	public static Map<Id, ActivityGroupTemplate__c> cloneActivityGroupTemplates(
		EstimateTemplate__c newEstimateTemplate,
		Id estimateTemplateId,
		Map<Id, PhaseTemplate__c> phaseTemplateMap
	) {
		Map<Id, ActivityGroupTemplate__c> activityGroupTemplateMap = new Map<Id, ActivityGroupTemplate__c>();
		QueryRequest queryRequest = new QueryRequest(Schema.ActivityGroupTemplate__c.SObjectType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(
			Schema.ActivityGroupTemplate__c.SObjectType
		);
		queryRequest.setFilterBy(
			new Map<String, String>{
				Schema.ActivityGroupTemplate__c.EstimateTemplateId__c + '' => estimateTemplateId
			}
		);
		List<ActivityGroupTemplate__c> listActivityGroupTemplates = (List<ActivityGroupTemplate__c>) SOQLUtility.querySObject(
			queryRequest
		);
		for (ActivityGroupTemplate__c activityGroup : listActivityGroupTemplates) {
			ActivityGroupTemplate__c activityGroupNew = activityGroup.clone();
			activityGroupNew.EstimateTemplateId__c = newEstimateTemplate.Id;
			activityGroupNew.PhaseTemplateId__c = phaseTemplateMap.get(
					activityGroupNew.PhaseTemplateId__c
				)
				?.id;
			activityGroupTemplateMap.put(activityGroup.Id, activityGroupNew);
		}
		CRUDUtility.insertRecords(activityGroupTemplateMap.values());
		return activityGroupTemplateMap;
	}
	public static void cloneActivityTemplates(
		Map<Id, ActivityTemplate__c> activityTemplateMap,
		Map<Id, ActivityGroupTemplate__c> activityGroupTemplateMap
	) {
		Set<Id> activityGroupOldIds = activityGroupTemplateMap.keySet();
		QueryRequest queryRequest = new QueryRequest(Schema.ActivityTemplate__c.SObjectType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(
			Schema.ActivityTemplate__c.SObjectType
		);
		queryRequest.setFilterBy(
			new Map<String, Set<Id>>{
				Schema.ActivityTemplate__c.ActivityGroupTemplateId__c + '' => activityGroupOldIds
			}
		);
		List<ActivityTemplate__c> listActivityTemplates = (List<ActivityTemplate__c>) SOQLUtility.querySObject(
			queryRequest
		);
		for (ActivityTemplate__c activity : listActivityTemplates) {
			ActivityTemplate__c activityNew = activity.clone();
			ActivityGroupTemplate__c newActivityGroup = activityGroupTemplateMap.get(
				activity.ActivityGroupTemplateId__c
			);
			activityNew.ActivityGroupTemplateId__c = newActivityGroup?.Id;
			activityTemplateMap.put(activity.Id, activityNew);
		}
		CRUDUtility.insertRecords(activityTemplateMap.values());
	}

	public static void cloneResourceDefaults(
		Map<Id, ResourceDefault__c> resourceDefaultMap,
		EstimateTemplate__c newEstimateTemplate,
		Id estimateTemplateId
	) {
		QueryRequest queryRequest = new QueryRequest(Schema.ResourceDefault__c.SObjectType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(
			Schema.ResourceDefault__c.SObjectType
		);
		queryRequest.setFilterBy(
			new Map<String, String>{
				Schema.ResourceDefault__c.EstimateTemplateId__c + '' => estimateTemplateId
			}
		);
		List<ResourceDefault__c> listResourceDefaults = (List<ResourceDefault__c>) SOQLUtility.querySObject(
			queryRequest
		);
		for (ResourceDefault__c resourceDefault : listResourceDefaults) {
			ResourceDefault__c resourceDefaultNew = resourceDefault.clone();
			resourceDefaultNew.EstimateTemplateId__c = newEstimateTemplate.Id;
			resourceDefaultMap.put(resourceDefault.Id, resourceDefaultNew);
		}
		CRUDUtility.insertRecords(resourceDefaultMap.values());
	}
	public static void cloneTaskTemplates(
		Map<Id, TaskTemplate__c> taskTemplateMap,
		Map<Id, TaskTemplate__c> clonedTaskTemplateMap
	) {
		Set<Id> taskTemplateIds = clonedTaskTemplateMap.keyset();
		QueryRequest queryRequest = new QueryRequest(Schema.TaskTemplate__c.SObjectType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(
			Schema.TaskTemplate__c.SObjectType
		);
		queryRequest.setFilterBy(
			new Map<String, Set<Id>>{ SObjectUtility.FIELD_ID => taskTemplateIds }
		);

		List<TaskTemplate__c> listTaskTemplates = (List<TaskTemplate__c>) SOQLUtility.querySObject(
			queryRequest
		);
		for (TaskTemplate__c task : listTaskTemplates) {
			TaskTemplate__c taskNew = task.clone();
			taskNew.ActivityTemplateId__c = task.ActivityTemplateId__c;
			taskNew.Name = clonedTaskTemplateMap.get(task.id).Name;
			taskNew.Sequence__c = clonedTaskTemplateMap.get(task.id).Sequence__c;
			taskNew.Guidance__c = clonedTaskTemplateMap.get(task.id).Guidance__c;
			taskNew.ResourceRoleId__c = clonedTaskTemplateMap.get(task.id).ResourceRoleId__c;
			taskTemplateMap.put(task.Id, taskNew);
		}
		CRUDUtility.insertRecords(taskTemplateMap.values());
	}
	public static void cloneTaskTemplates(
		Map<Id, TaskTemplate__c> taskTemplateMap,
		Map<Id, ActivityTemplate__c> activityTemplateMap
	) {
		Set<Id> activityOldIds = activityTemplateMap.keySet();
		QueryRequest queryRequest = new QueryRequest(Schema.TaskTemplate__c.SObjectType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(
			Schema.TaskTemplate__c.SObjectType
		);
		queryRequest.setFilterBy(
			new Map<String, Set<Id>>{
				Schema.TaskTemplate__c.ActivityTemplateId__c + '' => activityOldIds
			}
		);
		List<TaskTemplate__c> listTaskTemplates = (List<TaskTemplate__c>) SOQLUtility.querySObject(
			queryRequest
		);
		for (TaskTemplate__c task : listTaskTemplates) {
			TaskTemplate__c taskNew = task.clone();
			taskNew.ActivityTemplateId__c = activityTemplateMap.get(taskNew.ActivityTemplateId__c).Id;
			taskTemplateMap.put(task.Id, taskNew);
		}
		CRUDUtility.insertRecords(taskTemplateMap.values());
	}
	//clone ScopeParameterTemplate for ActivityTemplate
	public static void cloneScopeParameterTemplate(
		Map<Id, ScopeParameterTemplate__c> scopeParameterTemplateMap,
		Map<Id, ActivityTemplate__c> activityTemplateMap
	) {
		Set<Id> activityOldIds = activityTemplateMap.keySet();
		QueryRequest queryRequest = new QueryRequest(Schema.ScopeParameterTemplate__c.SObjectType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(
			Schema.ScopeParameterTemplate__c.SObjectType
		);
		queryRequest.setFilterBy(
			new Map<String, Set<Id>>{
				Schema.ScopeParameterTemplate__c.ActivityTemplateId__c + '' => activityOldIds
			}
		);
		List<ScopeParameterTemplate__c> listScopeParameterTemplates = (List<ScopeParameterTemplate__c>) SOQLUtility.querySObject(
			queryRequest
		);
		for (ScopeParameterTemplate__c scopeParameter : listScopeParameterTemplates) {
			ScopeParameterTemplate__c scopeParameterNew = scopeParameter.clone();
			scopeParameterNew.ActivityTemplateId__c = activityTemplateMap.get(
					scopeParameterNew.ActivityTemplateId__c
				)
				.Id;
			scopeParameterTemplateMap.put(scopeParameter.Id, scopeParameterNew);
		}
		CRUDUtility.insertRecords(scopeParameterTemplateMap.values());
	}
	//clone ScopeParameterTemplate for ActivityGroupTemplate
	public static void cloneScopeParameterForActivityGroupTemplate(
		Map<Id, ScopeParameterTemplate__c> scopeParameterForActivityGroupTemplateMap,
		Map<Id, ActivityGroupTemplate__c> activityGroupTemplateMap
	) {
		Set<Id> activityGroupOldIds = activityGroupTemplateMap.keySet();
		QueryRequest queryRequest = new QueryRequest(Schema.ScopeParameterTemplate__c.SObjectType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(
			Schema.ScopeParameterTemplate__c.SObjectType
		);
		queryRequest.setFilterBy(
			new Map<String, Set<Id>>{
				Schema.ScopeParameterTemplate__c.ActivityGroupTemplateId__c + '' => activityGroupOldIds
			}
		);
		List<ScopeParameterTemplate__c> listScopeParameterTemplates = (List<ScopeParameterTemplate__c>) SOQLUtility.querySObject(
			queryRequest
		);
		for (ScopeParameterTemplate__c scopeParameter : listScopeParameterTemplates) {
			ScopeParameterTemplate__c scopeParameterNew = scopeParameter.clone();
			scopeParameterNew.ActivityGroupTemplateId__c = activityGroupTemplateMap.get(
					scopeParameterNew.ActivityGroupTemplateId__c
				)
				.Id;
			scopeParameterForActivityGroupTemplateMap.put(scopeParameter.Id, scopeParameterNew);
		}
		CRUDUtility.insertRecords(scopeParameterForActivityGroupTemplateMap.values());
	}
	//clone ScopeParameterTemplate for EstimateTemplate
	public static void cloneScopeParameterForEstimateTemplate(
		Map<Id, ScopeParameterTemplate__c> scopeParameterForEstimateTemplateMap,
		EstimateTemplate__c newEstimateTemplate,
		Id estimateTemplateId
	) {
		QueryRequest queryRequest = new QueryRequest(Schema.ScopeParameterTemplate__c.SObjectType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(
			Schema.ScopeParameterTemplate__c.SObjectType
		);
		queryRequest.setFilterBy(
			new Map<String, String>{
				Schema.ScopeParameterTemplate__c.EstimateTemplateId__c + '' => estimateTemplateId
			}
		);
		List<ScopeParameterTemplate__c> listScopeParameterTemplates = (List<ScopeParameterTemplate__c>) SOQLUtility.querySObject(
			queryRequest
		);
		for (ScopeParameterTemplate__c scopeParameter : listScopeParameterTemplates) {
			ScopeParameterTemplate__c scopeParameterNew = scopeParameter.clone();
			scopeParameterNew.EstimateTemplateId__c = newEstimateTemplate.Id;
			scopeParameterForEstimateTemplateMap.put(scopeParameter.Id, scopeParameterNew);
		}
		CRUDUtility.insertRecords(scopeParameterForEstimateTemplateMap.values());
	}
	public static void cloneTaskParameterTemplates(
		Map<Id, TaskParameterTemplate__c> taskParameterTemplateMap,
		Map<Id, TaskTemplate__c> taskTemplateMap
	) {
		Set<Id> tasktemplateOldIds = taskTemplateMap.keySet();
		QueryRequest queryRequest = new QueryRequest(Schema.TaskParameterTemplate__c.SObjectType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(
			Schema.TaskParameterTemplate__c.SObjectType
		);
		queryRequest.setFilterBy(
			new Map<String, Set<Id>>{
				Schema.TaskParameterTemplate__c.TaskTemplateId__c + '' => tasktemplateOldIds
			}
		);
		List<TaskParameterTemplate__c> listTaskParameterTemplates = (List<TaskParameterTemplate__c>) SOQLUtility.querySObject(
			queryRequest
		);
		for (TaskParameterTemplate__c taskParameter : listTaskParameterTemplates) {
			TaskParameterTemplate__c taskParameterNew = taskParameter.clone();
			taskParameterNew.TaskTemplateId__c = taskTemplateMap.get(taskParameterNew.TaskTemplateId__c)
				.Id;
			taskParameterTemplateMap.put(taskParameter.Id, taskParameterNew);
		}
		RuntimeContext.skipCopyScopeParamValuesToTask = true;
		CRUDUtility.insertRecords(taskParameterTemplateMap.values());
		RuntimeContext.skipCopyScopeParamValuesToTask = false;
	}
	public static void cloneTaskParameterValueTemplates(
		Map<Id, TaskParameterValueTemplate__c> taskParameterValueTemplateMap,
		Map<Id, TaskParameterTemplate__c> taskParameterTemplateMap
	) {
		Set<Id> tasktParameteremplateOldIds = taskParameterTemplateMap.keySet();
		QueryRequest queryRequest = new QueryRequest(Schema.TaskParameterValueTemplate__c.SObjectType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(
			Schema.TaskParameterValueTemplate__c.SObjectType
		);
		queryRequest.setFilterBy(
			new Map<String, Set<Id>>{
				Schema.TaskParameterValueTemplate__c.TaskParameterTemplateId__c +
				'' => tasktParameteremplateOldIds
			}
		);
		List<TaskParameterValueTemplate__c> listTaskParameterValueTemplates = (List<TaskParameterValueTemplate__c>) SOQLUtility.querySObject(
			queryRequest
		);
		for (TaskParameterValueTemplate__c taskParameterValue : listTaskParameterValueTemplates) {
			TaskParameterValueTemplate__c taskParameterValueNew = taskParameterValue.clone();
			taskParameterValueNew.TaskParameterTemplateId__c = taskParameterTemplateMap.get(
					taskParameterValueNew.TaskParameterTemplateId__c
				)
				.Id;
			taskParameterValueTemplateMap.put(taskParameterValue.Id, taskParameterValueNew);
		}
		CRUDUtility.insertRecords(taskParameterValueTemplateMap.values());
	}
	public static List<String> getObjectFields(string objectApiName) {
		SObjectType contactType = Schema.getGlobalDescribe().get(objectApiName);
		Map<String, Schema.SObjectField> mfields = contactType.getDescribe().fields.getMap();
		List<String> sObjectDetailsList = new List<String>();
		for (String field : mfields.keySet()) {
			if (mfields.get(field).getDescribe().isAccessible()) {
				sObjectDetailsList.add(String.valueOf(mfields.get(field)));
			}
		}
		return sObjectDetailsList;
	}
	//clone ScopeParameterValues for ScopeParameterTemplate
	public static void cloneScopeParameterValueTemplate(
		Map<Id, ScopeParameterValueTemplate__c> scopeParameterValueTemplateMap,
		Map<Id, ScopeParameterTemplate__c> scopeParameterTemplateMap
	) {
		Set<Id> scopeParameterOldIds = scopeParameterTemplateMap.keySet();
		QueryRequest queryRequest = new QueryRequest(Schema.ScopeParameterValueTemplate__c.SObjectType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(
			Schema.ScopeParameterValueTemplate__c.SObjectType
		);
		queryRequest.setFilterBy(
			new Map<String, Set<Id>>{
				Schema.ScopeParameterValueTemplate__c.ScopeParameterTemplateId__c +
				'' => scopeParameterOldIds
			}
		);
		List<ScopeParameterValueTemplate__c> listScopeParameterValueTemplates = (List<ScopeParameterValueTemplate__c>) SOQLUtility.querySObject(
			queryRequest
		);
		for (ScopeParameterValueTemplate__c scopeParameterValue : listScopeParameterValueTemplates) {
			ScopeParameterValueTemplate__c scopeParameterValueNew = scopeParameterValue.clone();
			scopeParameterValueNew.ScopeParameterTemplateId__c = scopeParameterTemplateMap.get(
					scopeParameterValueNew.ScopeParameterTemplateId__c
				)
				.Id;
			scopeParameterValueTemplateMap.put(scopeParameterValue.Id, scopeParameterValueNew);
		}
		CRUDUtility.insertRecords(scopeParameterValueTemplateMap.values());
	}
	//clone ScopeParameterValues for ScopeParameterTemplate associated with Estimate Template
	public static void cloneScopeParameterValueForEstimateTemplate(
		Map<Id, ScopeParameterValueTemplate__c> scopeParameterValueEstimateTemplateMap,
		Map<Id, ScopeParameterTemplate__c> scopeParameterForEstimateTemplateMap
	) {
		Set<Id> scopeParameterOldIds = scopeParameterForEstimateTemplateMap.keySet();
		QueryRequest queryRequest = new QueryRequest(Schema.ScopeParameterValueTemplate__c.SObjectType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(
			Schema.ScopeParameterValueTemplate__c.SObjectType
		);
		queryRequest.setFilterBy(
			new Map<String, Set<Id>>{
				Schema.ScopeParameterValueTemplate__c.ScopeParameterTemplateId__c +
				'' => scopeParameterOldIds
			}
		);
		List<ScopeParameterValueTemplate__c> listScopeParameterValueTemplates = (List<ScopeParameterValueTemplate__c>) SOQLUtility.querySObject(
			queryRequest
		);
		for (ScopeParameterValueTemplate__c scopeParameterValue : listScopeParameterValueTemplates) {
			ScopeParameterValueTemplate__c scopeParameterValueNew = scopeParameterValue.clone();
			scopeParameterValueNew.ScopeParameterTemplateId__c = scopeParameterForEstimateTemplateMap.get(
					scopeParameterValueNew.ScopeParameterTemplateId__c
				)
				.Id;
			scopeParameterValueEstimateTemplateMap.put(scopeParameterValue.Id, scopeParameterValueNew);
		}
		CRUDUtility.insertRecords(scopeParameterValueEstimateTemplateMap.values());
	}
	//clone ScopeParameterValues for ScopeParameterTemplate associated with ActivityGroup
	public static void cloneScopeParameterValueForActivityGroup(
		Map<Id, ScopeParameterValueTemplate__c> scopeParameterValueActivityGroupMap,
		Map<Id, ScopeParameterTemplate__c> scopeParameterForActivityGroupTemplateMap
	) {
		Set<Id> scopeParameterOldIds = scopeParameterForActivityGroupTemplateMap.keySet();
		QueryRequest queryRequest = new QueryRequest(Schema.ScopeParameterValueTemplate__c.SObjectType);
		queryRequest.requestedFields = SObjectUtility.getFieldsForSObject(
			Schema.ScopeParameterValueTemplate__c.SObjectType
		);
		queryRequest.setFilterBy(
			new Map<String, Set<Id>>{
				Schema.ScopeParameterValueTemplate__c.ScopeParameterTemplateId__c +
				'' => scopeParameterOldIds
			}
		);
		List<ScopeParameterValueTemplate__c> listScopeParameterValueTemplates = (List<ScopeParameterValueTemplate__c>) SOQLUtility.querySObject(
			queryRequest
		);
		for (ScopeParameterValueTemplate__c scopeParameterValue : listScopeParameterValueTemplates) {
			ScopeParameterValueTemplate__c scopeParameterValueNew = scopeParameterValue.clone();
			scopeParameterValueNew.ScopeParameterTemplateId__c = scopeParameterForActivityGroupTemplateMap.get(
					scopeParameterValueNew.ScopeParameterTemplateId__c
				)
				.Id;
			scopeParameterValueActivityGroupMap.put(scopeParameterValue.Id, scopeParameterValueNew);
		}
		CRUDUtility.insertRecords(scopeParameterValueActivityGroupMap.values());
	}
}
