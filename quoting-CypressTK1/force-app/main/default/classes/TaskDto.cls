public with sharing class TaskDto extends DurationDto {
	@AuraEnabled
	public String phaseName;
	@AuraEnabled
	public String activityGroupName;
	@AuraEnabled
	public String activityName;
	@AuraEnabled
	public Id activityGroupId;
	@AuraEnabled
	public Id taskTemplateId;
	@AuraEnabled
	public Decimal taskHours;
	@AuraEnabled
	public Decimal percentOfTotalHours;
	@AuraEnabled
	public Decimal hoursPerPeriod;
	@AuraEnabled
	public Decimal noOfPeriods;
	@AuraEnabled
	public String resourceRoleName;
	@AuraEnabled
	public Boolean isNotApplicable { get; set; }

	@AuraEnabled
	public List<TaskParameterTemplateDto> parameterTemplates { get; set; }
	@AuraEnabled
	public String adjustmentReason { get; set; }

	public TaskDto() {
	}
	public TaskDto(Task__c taskSo) {
		super(taskSo);
		this.name = taskSo.Name;
		this.parameterTemplates = new List<TaskParameterTemplateDto>();
		this.phaseName = taskSo.ActivityGroupId__r.PhaseId__r?.Name;
		this.activityGroupName = taskSo.ActivityGroupId__r.Name;
		this.activityGroupId = taskSo.ActivityGroupId__c;
		this.activityName = taskSo.ActivityId__r.Name;
		this.taskHours = taskSo.EstimatedDuration__c;

		this.resourceRoleName = taskSo.ResourceRoleId__r.Name;
		this.totalCalculatedDuration = SystemUtility.nullToZero(taskSo.CalculatedDuration__c);
		this.totalEstimatedDuration = SystemUtility.nullToZero(taskSo.EstimatedDuration__c);
		this.levelAdjustment = SystemUtility.nullToZero(taskSo.LevelAdjustment__c);
		this.taskTemplateId = taskSo.TemplateId__c;
		this.adjustmentReason = taskSo.AdjustmentReason__c;
		this.isNotApplicable = taskSo.IsNotApplicable__c;
	}

	public override SObject refreshSo() {
		Task__c taskSo = new Task__c(Id = this.id);
		taskSo.LevelAdjustment__c = this.levelAdjustment;
		taskSo.CalculatedDuration__c = this.totalCalculatedDuration;
		taskSo.EstimatedDuration__c = this.totalEstimatedDuration;

		return this.sObj;
	}
}
