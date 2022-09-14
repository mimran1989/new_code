public with sharing class TaskService {
	public TaskService() {
	}

	public static List<TaskDto> getActivitiesAndTasks(Id resourceRoleId, Id quoteId) {
		Quote__c quote = [
			SELECT Id, TimePeriod__c, EstimateId__c
			FROM Quote__c
			WHERE Id = :quoteId
			WITH SECURITY_ENFORCED
			LIMIT 1
		];

		Id estimateId = quote.EstimateId__c;
		Decimal numberOfHoursInPeriod = DurationCalcs.numberOfHoursInPeriod(
			quote.TimePeriod__c,
			quoteId
		);

		Map<Id, Decimal> activityGroupHours = new Map<Id, Decimal>();
		Map<Id, List<TaskDto>> taskDtos = new Map<Id, List<TaskDto>>();
		for (Task__c task : [
			SELECT
				Id,
				IsNotApplicable__c,
				Name,
				ActivityId__r.Name,
				ActivityGroupId__r.Name,
				ActivityGroupId__r.PhaseId__r.Name,
				EstimatedDuration__c,
				ResourceRoleId__r.Name,
				CalculatedDuration__c,
				LevelAdjustment__c,
				TemplateId__c,
				AdjustmentReason__c
			FROM Task__c
			WHERE EstimateId__c = :estimateId AND ResourceRoleId__c = :resourceRoleId
			WITH SECURITY_ENFORCED
			ORDER BY Path__c ASC
		]) {
			TaskDto taskDto = new TaskDto(task);

			if (!activityGroupHours.containsKey(taskDto.activityGroupId)) {
				activityGroupHours.put(taskDto.activityGroupId, 0);
			}

			activityGroupHours.put(
				taskDto.activityGroupId,
				activityGroupHours.get(taskDto.activityGroupId) + taskDto.taskHours
			);

			if (!taskDtos.containsKey(taskDto.activityGroupId)) {
				taskDtos.put(taskDto.activityGroupId, new List<TaskDto>());
			}

			taskDtos.get(taskDto.activityGroupId).add(taskDtO);
		}

		TaskService.calculateHours(taskDtos, activityGroupHours, numberOfHoursInPeriod);
		TaskService.addSubTotal(taskDtos, activityGroupHours, numberOfHoursInPeriod);

		List<TaskDto> response = new List<TaskDto>();
		for (Id activityGroupId : taskDtos.keySet()) {
			response.addAll(taskDtos.get(activityGroupId));
		}

		return response;
	}

	private static void calculateHours(
		Map<Id, List<TaskDto>> taskDtos,
		Map<Id, Decimal> activityGroupHours,
		Decimal numberOfHoursInPeriod
	) {
		for (List<TaskDto> activityGroupTasks : taskDtos.values()) {
			for (TaskDto taskDO : activityGroupTasks) {
				taskDO.percentofTotalHours =
					(taskDO.taskHours / activityGroupHours.get(taskDO.activityGroupId)) * 100;
				taskDO.hoursPerPeriod = (taskDO.percentOfTotalHours * numberOfHoursInPeriod) / 100;
				taskDO.noOfPeriods = taskDO.taskHours / taskDO.hoursPerPeriod;
			}
		}
	}

	private static void addSubTotal(
		Map<Id, List<TaskDto>> taskDtos,
		Map<Id, Decimal> activityGroupHours,
		Decimal numberOfHoursInPeriod
	) {
		for (Id activityGroupId : taskDtos.keySet()) {
			TaskDto subtotal = new TaskDto();
			subtotal.id = activityGroupId;
			subtotal.name = System.Label.Subtotal;
			subtotal.percentOfTotalHours = 100;
			subtotal.hoursPerPeriod = numberOfHoursInPeriod;
			subtotal.taskHours = activityGroupHours.get(activityGroupId);
			subtotal.noOfPeriods = subtotal.taskHours / subtotal.hoursPerPeriod;
			taskDtos.get(activityGroupId).add(subtotal);
		}
	}
}
