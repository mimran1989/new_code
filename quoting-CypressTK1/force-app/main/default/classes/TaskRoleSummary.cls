public with sharing class TaskRoleSummary extends ManagedObject {
	public static final String NAME = 'TaskRoleSummary__c';
	public static final String RESOURCE_ROLE_ID = 'ResourceRoleId__c';
	public static final String ROLLEDUP_ESTIMATED_DURATION = 'RolledUpEstimatedDuration__c';
	public static final String ACTIVITY_GROUP_ID = 'ActivityGroupId__c';
	public static final String RELATED_ACTIVITY_GROUP_NAME = 'ActivityGroupId__r.Name';
	public static final String RELATED_ACTIVITY_GROUP_SEQUENCE = 'ActivityGroupId__r.Sequence__c';
	public static final String RELATED_ACTIVITY_GROUP_ESTIMATE_ID = 'ActivityGroupId__r.EstimateId__c';
	public static final String SUMMARY_LEVEL = 'SummaryLevel__c';
	public static final String ESTIMATE_ID = 'EstimateId__c';
	public static final String SUMMARYLEVEL_ESTIMATE = 'Estimate';
	public static final String SUMMARYLEVEL_ACTIVITY_GROUP = 'Activity Group';

	public TaskRoleSummary(TaskRoleSummary__c taskRoleSummarySo) {
		super(taskRoleSummarySo);
	}

	public static List<TaskRoleSummary> toTaskRoleSummary(
		List<TaskRoleSummary__c> taskRoleSummaries
	) {
		List<TaskRoleSummary> taskRoleSummariesMos = new List<TaskRoleSummary>();
		for (TaskRoleSummary__c taskRoleSummarySo : taskRoleSummaries) {
			taskRoleSummariesMos.add(new TaskRoleSummary(taskRoleSummarySo));
		}

		return taskRoleSummariesMos;
	}

	public Decimal maxEstimatedDuration() {
		TaskRoleSummary__c taskRoleSummary = (TaskRoleSummary__c) getSObject();
		Decimal maxDuration = taskRoleSummary.TotalEstimatedDuration__c;
		ResourceSplit__c maxSplit = maxResourceSplit(taskRoleSummary.ResourceSplits__r);
		ResourceAvailability__c maxAvailability = maxAvailability(
			taskRoleSummary.ResourceAvailabilities__r
		);
		// assumes that the avilability percentage applies to the entire summary
		if (maxAvailability != null) {
			maxDuration = maxAvailability.FullTimeTotalEstimatedDuration__c;
		}

		if (maxSplit != null) {
			maxDuration *= (maxSplit.SplitPercentage__c / 100);
		}

		return maxDuration;
	}

	private ResourceSplit__c maxResourceSplit(List<ResourceSplit__c> resourceSplits) {
		ResourceSplit__c maxSplit;
		for (ResourceSplit__c resourceSplit : resourceSplits) {
			if (maxSplit == null || resourceSplit.SplitPercentage__c > maxSplit.SplitPercentage__c) {
				maxSplit = resourceSplit;
			}
		}
		return maxSplit;
	}

	private ResourceAvailability__c maxAvailability(
		List<ResourceAvailability__c> resourceAvailabilities
	) {
		ResourceAvailability__c maxAvailability;
		for (ResourceAvailability__c resourceAvailability : resourceAvailabilities) {
			if (
				maxAvailability == null ||
				resourceAvailability.FullTimeTotalEstimatedDuration__c >
				maxAvailability.FullTimeTotalEstimatedDuration__c
			) {
				maxAvailability = resourceAvailability;
			}
		}

		return maxAvailability;
	}
}
