Id rateCardId = 'a0g1D000002J8vkQAC';
Id resourceRoleId = 'a0N1D0000043vl0UAA';

RuntimeContext.isCreateEstimateMode = true;

List<TaskSummary__c> taskSummaries = new List<TaskSummary__c>();
TaskSummary__c estimateLevelSummary = new TaskSummary__c();
taskSummaries.add(estimateLevelSummary);
TaskSummary__c groupActivityLevelSummary1 = new TaskSummary__c();
taskSummaries.add(groupActivityLevelSummary1);
TaskSummary__c activityLevelSummary1 = new TaskSummary__c();
taskSummaries.add(activityLevelSummary1);
TaskSummary__c taskLevelSummary1 = new TaskSummary__c();
taskSummaries.add(taskLevelSummary1);
TaskSummary__c groupActivityLevelSummary2 = new TaskSummary__c();
taskSummaries.add(groupActivityLevelSummary2);
TaskSummary__c activityLevelSummary2 = new TaskSummary__c();
taskSummaries.add(activityLevelSummary2);
TaskSummary__c taskLevelSummary2 = new TaskSummary__c();
taskSummaries.add(taskLevelSummary2);
TaskSummary__c groupActivityLevelSummary3 = new TaskSummary__c();
taskSummaries.add(groupActivityLevelSummary3);
TaskSummary__c activityLevelSummary3 = new TaskSummary__c();
taskSummaries.add(activityLevelSummary3);
TaskSummary__c taskLevelSummary3 = new TaskSummary__c();
taskSummaries.add(taskLevelSummary3);
CRUDUtility.insertRecords(taskSummaries);

Estimate__c estimate = new Estimate__c(Name = 'Test Estimate 22',
        IsActive__c = true,
        IsSyncChangesToQuote__c = true,
        SummaryId__c = estimateLevelSummary.Id
);
estimate.RateCardId__c = rateCardId;
CRUDUtility.insertRecords(estimate);

List<ActivityGroup__c> activityGroups = new List<ActivityGroup__c>();
ActivityGroup__c activityGroup1 = new ActivityGroup__c(
        EstimateId__c = estimate.Id,
        IsActive__c = true,
        Sequence__c = 1,
        SummaryId__c = groupActivityLevelSummary1.Id,
        Name = 'Activity Group 1'
);
activityGroups.add(activityGroup1);
ActivityGroup__c activityGroup2 = new ActivityGroup__c(
        EstimateId__c = estimate.Id,
        IsActive__c = true,
        Sequence__c = 2,
        SummaryId__c = groupActivityLevelSummary2.Id,
        Name = 'Activity Group 2'
);
activityGroups.add(activityGroup2);
ActivityGroup__c activityGroup3 = new ActivityGroup__c(
        EstimateId__c = estimate.Id,
        IsActive__c = true,
        Sequence__c = 3,
        SummaryId__c = groupActivityLevelSummary3.Id,
        Name = 'Activity Group 3'
);
activityGroups.add(activityGroup3);
CRUDUtility.insertRecords(activityGroups);

List<Activity__c> activities = new List<Activity__c>();
Activity__c activity1 = new Activity__c(
        EstimateId__c = estimate.Id,
        ActivityGroupId__c = activityGroup1.Id,
        IsActive__c = true,
        Sequence__c = 1,
        SummaryId__c = activityLevelSummary1.Id,
        Name = 'Activity Group 1 > Activity 1'
);
activities.add(activity1);
Activity__c activity2 = new Activity__c(
        EstimateId__c = estimate.Id,
        ActivityGroupId__c = activityGroup2.Id,
        IsActive__c = true,
        Sequence__c = 1,
        SummaryId__c = activityLevelSummary2.Id,
        Name = 'Activity Group 2 > Activity 2'
);
activities.add(activity2);
Activity__c activity3 = new Activity__c(
        EstimateId__c = estimate.Id,
        ActivityGroupId__c = activityGroup3.Id,
        IsActive__c = true,
        Sequence__c = 1,
        SummaryId__c = activityLevelSummary3.Id,
        Name = 'Activity Group 3 > Activity 3'
);
activities.add(activity3);
CRUDUtility.insertRecords(activities);

List<TaskRoleSummary__c> taskRoleSummaries = new List<TaskRoleSummary__c>();
TaskRoleSummary__c estimateTaskRoleSummary = new TaskRoleSummary__c(
        SummaryId__c = estimateLevelSummary.Id,
        EstimateId__c = estimate.Id,
        ResourceRoleId__c = resourceRoleId,
        SummaryLevel__c = 'Estimate'
);
taskRoleSummaries.add(estimateTaskRoleSummary);
TaskRoleSummary__c activityGroup1TaskRoleSummary = new TaskRoleSummary__c(
        SummaryId__c = groupActivityLevelSummary1.Id,
        ActivityGroupId__c = activityGroup1.Id,
        ResourceRoleId__c = resourceRoleId,
        SummaryLevel__c = 'Activity Group'
);
taskRoleSummaries.add(activityGroup1TaskRoleSummary);
TaskRoleSummary__c activity1TaskRoleSummary = new TaskRoleSummary__c(
        SummaryId__c = activityLevelSummary1.Id,
        ActivityId__c = activity1.Id,
        ResourceRoleId__c = resourceRoleId,
        SummaryLevel__c = 'Activity'
);
taskRoleSummaries.add(activity1TaskRoleSummary);
TaskRoleSummary__c activityGroup2TaskRoleSummary = new TaskRoleSummary__c(
        SummaryId__c = groupActivityLevelSummary2.Id,
        ActivityGroupId__c = activityGroup2.Id,
        ResourceRoleId__c = resourceRoleId,
        SummaryLevel__c = 'Activity Group'
);
taskRoleSummaries.add(activityGroup2TaskRoleSummary);
TaskRoleSummary__c activity2TaskRoleSummary = new TaskRoleSummary__c(
        SummaryId__c = activityLevelSummary2.Id,
        ActivityId__c = activity2.Id,
        ResourceRoleId__c = resourceRoleId,
        SummaryLevel__c = 'Activity'
);
taskRoleSummaries.add(activity2TaskRoleSummary);
TaskRoleSummary__c activityGroup3TaskRoleSummary = new TaskRoleSummary__c(
        SummaryId__c = groupActivityLevelSummary3.Id,
        ActivityGroupId__c = activityGroup3.Id,
        ResourceRoleId__c = resourceRoleId,
        SummaryLevel__c = 'Activity Group'
);
taskRoleSummaries.add(activityGroup3TaskRoleSummary);
TaskRoleSummary__c activity3TaskRoleSummary = new TaskRoleSummary__c(
        SummaryId__c = activityLevelSummary3.Id,
        ActivityId__c = activity3.Id,
        ResourceRoleId__c = resourceRoleId,
        SummaryLevel__c = 'Activity'
);
taskRoleSummaries.add(activity3TaskRoleSummary);
CRUDUtility.insertRecords(taskRoleSummaries);

{
    // associate task role summaries for proper rollup functionality
    activityGroup1TaskRoleSummary.TaskRoleSummaryId__c = estimateTaskRoleSummary.Id;
    activity1TaskRoleSummary.TaskRoleSummaryId__c = activityGroup1TaskRoleSummary.Id;

    activityGroup2TaskRoleSummary.TaskRoleSummaryId__c = estimateTaskRoleSummary.Id;
    activity2TaskRoleSummary.TaskRoleSummaryId__c = activityGroup2TaskRoleSummary.Id;

    activityGroup3TaskRoleSummary.TaskRoleSummaryId__c = estimateTaskRoleSummary.Id;
    activity3TaskRoleSummary.TaskRoleSummaryId__c = activityGroup3TaskRoleSummary.Id;
    CRUDUtility.updateRecords(taskRoleSummaries);
}

{
    List<Task__c> tasks = new List<Task__c>();
    Task__c task1 = new Task__c(
            EstimateId__c = estimate.Id,
            ActivityGroupId__c = activityGroup1.Id,
            ActivityId__c = activity1.Id,
            RoleSummaryId__c = activity1TaskRoleSummary.Id,
            IsActive__c = true,
            Sequence__c = 1,
            Name = 'Activity Group 1 > Activity 1 > Task 1'
    );
    tasks.add(task1);
    Task__c task2 = new Task__c(
            EstimateId__c = estimate.Id,
            ActivityGroupId__c = activityGroup2.Id,
            ActivityId__c = activity2.Id,
            RoleSummaryId__c = activity2TaskRoleSummary.Id,
            IsActive__c = true,
            Sequence__c = 1,
            Name = 'Activity Group 2 > Activity 2 > Task 2'
    );
    tasks.add(task2);
    Task__c task3 = new Task__c(
            EstimateId__c = estimate.Id,
            ActivityGroupId__c = activityGroup3.Id,
            ActivityId__c = activity3.Id,
            RoleSummaryId__c = activity3TaskRoleSummary.Id,
            IsActive__c = true,
            Sequence__c = 1,
            Name = 'Activity Group 3 > Activity 3 > Task 3'
    );
    tasks.add(task3);
    CRUDUtility.insertRecords(tasks);
}

RuntimeContext.isCreateEstimateMode = false;

// retrieve tasks and add duration to effectuate duration fields of the parent task role summary records
List<Task__c> tasks = [SELECT Id FROM Task__c WHERE EstimateId__c = :estimate.Id];
tasks[0].LevelAdjustment__c = 20;
tasks[0].EstimatedDuration__c = 20;
tasks[1].LevelAdjustment__c = 50;
tasks[1].EstimatedDuration__c = 50;
tasks[2].LevelAdjustment__c = 60;
tasks[2].EstimatedDuration__c = 60;
CRUDUtility.updateRecords(tasks);
