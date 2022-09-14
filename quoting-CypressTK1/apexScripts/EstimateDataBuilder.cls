/**
 *  Provus Services Quoting
 *  EstimateDataBuilder
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class EstimateDataBuilder {
	public static void createTestEstimate1() {
		RuntimeContext.isCreateEstimateMode = true;

		ResourceInfo resourceInfo = createRateCardsAndResources();
		Id resourceRoleId = resourceInfo.softwareEngineerId;
		Id rateCardId = resourceInfo.rateCardId;
		Id estimateTaskSummaryId = createTaskSummary();
		EstimateInfo estimateInfo = createEstimate(estimateTaskSummaryId, rateCardId, resourceRoleId);
		ActivityGroupInfo activityGroupInfo = createActivityGroup(
			estimateInfo,
			new List<Id>{ resourceRoleId },
			1
		);
		ActivityInfo activityInfo = createActivity(activityGroupInfo, new List<Id>{ resourceRoleId });
		createTask(activityInfo, activityInfo.activityTaskRoleSummaryIds[0]);

		ActivityGroupInfo activityGroupInfo2 = createActivityGroup(
			estimateInfo,
			new List<Id>{ resourceRoleId },
			2
		);
		ActivityInfo activityInfo2 = createActivity(activityGroupInfo2, new List<Id>{ resourceRoleId });
		createTask(activityInfo2, activityInfo2.activityTaskRoleSummaryIds[0]);

		ActivityGroupInfo activityGroupInfo3 = createActivityGroup(
			estimateInfo,
			new List<Id>{ resourceRoleId },
			3
		);
		ActivityInfo activityInfo3 = createActivity(activityGroupInfo3, new List<Id>{ resourceRoleId });
		createTask(activityInfo3, activityInfo3.activityTaskRoleSummaryIds[0]);

		RuntimeContext.isCreateEstimateMode = false;

		// retrieve tasks and add duration to effectuate duration fields of the parent task role summary records
		List<Task__c> tasks = [
			SELECT Id
			FROM Task__c
			WHERE EstimateId__c = :estimateInfo.estimateId
			WITH SECURITY_ENFORCED
		];
		tasks[0].LevelAdjustment__c = 20;
		tasks[0].EstimatedDuration__c = 20;
		tasks[1].LevelAdjustment__c = 50;
		tasks[1].EstimatedDuration__c = 50;
		tasks[2].LevelAdjustment__c = 60;
		tasks[2].EstimatedDuration__c = 60;

		CRUDUtility.updateRecords(tasks);
	}

	static ResourceInfo createRateCardsAndResources() {
		Id resourceRoleTypeId = Schema.getGlobalDescribe()
			.get(Schema.SObjectType.Product__c.getName())
			.getDescribe()
			.getRecordTypeInfosByName()
			.get('Resource Role')
			.getRecordTypeId();

		List<Product__c> resourceRoles = new List<Product__c>();
		Product__c softwareEngineer = new Product__c();
		softwareEngineer.IsActive__c = true;
		softwareEngineer.Name = 'Software Engineer';
		softwareEngineer.RecordTypeId = resourceRoleTypeId;
		resourceRoles.add(softwareEngineer);
		Product__c projectManager = new Product__c();
		projectManager.IsActive__c = true;
		projectManager.Name = 'Project Manager';
		projectManager.RecordTypeId = resourceRoleTypeId;
		resourceRoles.add(softwareEngineer);
		Product__c configurationEngineer = new Product__c();
		configurationEngineer.IsActive__c = true;
		configurationEngineer.Name = 'Configuration Engineer';
		configurationEngineer.RecordTypeId = resourceRoleTypeId;
		CRUDUtility.insertRecords(resourceRoles);

		RateCard__c rateCard = new RateCard__c(
			Name = 'Skill & Resource Location',
			IsActive__c = true,
			ExpirationDate__c = Date.today() + 1,
			EffectiveDate__c = Date.today() - 1
		);
		CRUDUtility.insertRecords(rateCard);

		List<RateCardItem__c> rateCardItems = new List<RateCardItem__c>();
		for (Product__c role : resourceRoles) {
			RateCardItem__c rateCardItem = new RateCardItem__c(
				IsActive__c = true,
				RateCardId__c = rateCard.Id,
				ProductId__c = role.Id,
				UnitPrice__c = 1000,
				UnitCost__c = 500,
				LocationCountry__c = 'United States',
				SkillLevel__c = 'L1',
				LocationDisplayName__c = 'United States/California'
			);

			rateCardItems.add(rateCardItem);
		}

		CRUDUtility.insertRecords(rateCardItems);

		ResourceInfo resourceInfo = new ResourceInfo();
		resourceInfo.softwareEngineerId = softwareEngineer.Id;
		resourceInfo.projectManagerId = projectManager.Id;
		resourceInfo.configurationEngineerId = configurationEngineer.Id;
		resourceInfo.rateCardId = rateCard.Id;
		return resourceInfo;
	}

	static EstimateInfo createEstimate(Id estimateTaskSummaryId, Id rateCardId, Id resourceRoleId) {
		Estimate__c estimate = new Estimate__c(
			Name = 'Test Estimate 50',
			IsActive__c = true,
			IsSyncChangesToQuote__c = true,
			SummaryId__c = estimateTaskSummaryId,
			RateCardId__c = rateCardId
		);
		CRUDUtility.insertRecords(estimate);
		TaskRoleSummary__c estimateTaskRoleSummary = new TaskRoleSummary__c(
			SummaryId__c = estimateTaskSummaryId,
			EstimateId__c = estimate.Id,
			ResourceRoleId__c = resourceRoleId, // necessary??
			SummaryLevel__c = 'Estimate'
		);
		CRUDUtility.insertRecords(estimateTaskRoleSummary);

		EstimateInfo estimateInfo = new EstimateInfo();
		estimateInfo.estimateId = estimate.Id;
		estimateInfo.estimateTaskRoleSummaryId = estimateTaskRoleSummary.Id;
		return estimateInfo;
	}

	static ActivityGroupInfo createActivityGroup(
		EstimateInfo estimateInfo,
		List<Id> resourceRoleIds,
		Decimal sequence
	) {
		// CREATE GROUP ACTIVITY RECORD(S)
		Id groupActivityLevelSummaryId = createTaskSummary();
		ActivityGroup__c activityGroup1 = new ActivityGroup__c(
			EstimateId__c = estimateInfo.estimateId,
			IsActive__c = true,
			Sequence__c = sequence,
			SummaryId__c = groupActivityLevelSummaryId,
			Name = 'Activity Group 1'
		);
		CRUDUtility.insertRecords(activityGroup1);

		List<TaskRoleSummary__c> taskRoleSummaries = new List<TaskRoleSummary__c>();
		for (Id resourceRoleId : resourceRoleIds) {
			TaskRoleSummary__c taskRoleSummary = new TaskRoleSummary__c(
				SummaryId__c = groupActivityLevelSummaryId,
				ActivityGroupId__c = activityGroup1.Id,
				ResourceRoleId__c = resourceRoleId,
				SummaryLevel__c = 'Activity Group',
				TaskRoleSummaryId__c = estimateInfo.estimateTaskRoleSummaryId
			);
			taskRoleSummaries.add(taskRoleSummary);
		}
		CRUDUtility.insertRecords(taskRoleSummaries);
		ActivityGroupInfo activityGroupInfo = new ActivityGroupInfo();
		activityGroupInfo.estimateId = estimateInfo.estimateId;
		activityGroupInfo.activityGroupId = activityGroup1.Id;
		for (TaskRoleSummary__c taskRoleSummary : taskRoleSummaries) {
			activityGroupInfo.taskRoleSummaries.add(taskRoleSummary);
		}
		return activityGroupInfo;
	}

	static ActivityInfo createActivity(
		ActivityGroupInfo activityGroupInfo,
		List<Id> resourceRoleIds
	) {
		// CREATE ACTIVITY RECORD
		Id activityTaskSummaryId = createTaskSummary();
		Activity__c activity1 = new Activity__c(
			EstimateId__c = activityGroupInfo.estimateId,
			ActivityGroupId__c = activityGroupInfo.activityGroupId,
			IsActive__c = true,
			Sequence__c = 1,
			SummaryId__c = activityTaskSummaryId,
			Name = 'Activity'
		);
		CRUDUtility.insertRecords(activity1);

		List<TaskRoleSummary__c> taskRoleSummaries = new List<TaskRoleSummary__c>();
		for (Id resourceRoleId : resourceRoleIds) {
			for (TaskRoleSummary__c taskRoleSummary : activityGroupInfo.taskRoleSummaries) {
				if (taskRoleSummary.ResourceRoleId__c == resourceRoleId) {
					TaskRoleSummary__c activityTaskRoleSummary = new TaskRoleSummary__c(
						SummaryId__c = activityTaskSummaryId,
						ActivityId__c = activity1.Id,
						ResourceRoleId__c = resourceRoleId,
						SummaryLevel__c = 'Activity',
						TaskRoleSummaryId__c = taskRoleSummary.Id
					);
					taskRoleSummaries.add(activityTaskRoleSummary);
				}
			}
		}
		CRUDUtility.insertRecords(taskRoleSummaries);
		ActivityInfo activityInfo = new ActivityInfo();
		activityInfo.activityGroupId = activityGroupInfo.activityGroupId;
		activityInfo.estimateId = activityGroupInfo.estimateId;
		for (TaskRoleSummary__c taskRoleSummary : taskRoleSummaries) {
			activityInfo.activityTaskRoleSummaryIds.add(taskRoleSummary.Id);
		}
		activityInfo.activityId = activity1.Id;
		return activityInfo;
	}

	static Id createTask(ActivityInfo activityInfo, Id taskRoleSummaryId) {
		// CREATE TASK RECORD(S)
		Task__c task1 = new Task__c(
			EstimateId__c = activityInfo.estimateId,
			ActivityGroupId__c = activityInfo.activityGroupId,
			ActivityId__c = activityInfo.activityId,
			RoleSummaryId__c = taskRoleSummaryId,
			IsActive__c = true,
			Sequence__c = 1,
			Name = 'Activity Group 1 > Activity 1 > Task 1'
		);
		CRUDUtility.insertRecords(task1);
		return task1.Id;
	}

	static Id createTaskSummary() {
		TaskSummary__c estimateLevelSummary = new TaskSummary__c();
		CRUDUtility.insertRecords(estimateLevelSummary);
		return estimateLevelSummary.Id;
	}

	class ResourceInfo {
		Id softwareEngineerId;
		Id projectManagerId;
		Id configurationEngineerId;
		Id rateCardId;
	}

	class EstimateInfo {
		Id estimateId;
		Id estimateTaskRoleSummaryId;
	}

	class ActivityGroupInfo {
		Id estimateId;
		Id activityGroupId;
		List<TaskRoleSummary__c> taskRoleSummaries = new List<TaskRoleSummary__c>();
	}

	class ActivityInfo {
		Id estimateId;
		Id activityGroupId;
		Id activityId;
		List<Id> activityTaskRoleSummaryIds = new List<Id>();
	}
}
