/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class EstimatorElementDto extends DurationDto {
	@AuraEnabled
	public String type;
	@AuraEnabled
	public String resourceRoleName;
	@AuraEnabled
	public Boolean isNotApplicable;
	@AuraEnabled
	public List<EstimatorElementDto> children;

	public EstimatorElementDto() {
	}
	public EstimatorElementDto(ActivityGroup__c groupSo) {
		super(groupSo);
		this.name = groupSo.Sequence__c + ' ' + groupSo.Name;
		this.totalCalculatedDuration = groupSo.TotalCalculatedDuration__c;
		this.totalAdjustments = groupSo.TotalAdjustments__c;
		this.totalLevelAdjustments = groupSo.TotalLevelAdjustments__c;
		this.totalEstimatedDuration = groupSo.TotalEstimatedDuration__c;
		this.isNotApplicable = groupSo.IsNotApplicable__c;
		this.children = new List<EstimatorElementDto>();
		this.type = EstimatorConstants.ACTIVITY_GROUP;
	}
	public EstimatorElementDto(Activity__c activitySo) {
		super(activitySo);
		this.name = activitySo.Path__c + ' ' + activitySo.Name;
		this.totalCalculatedDuration = activitySo.TotalCalculatedDuration__c;
		this.totalAdjustments = activitySo.TotalAdjustments__c;
		this.totalLevelAdjustments = activitySo.TotalLevelAdjustments__c;
		this.totalEstimatedDuration = activitySo.TotalEstimatedDuration__c;
		this.isNotApplicable = activitySo.IsNotApplicable__c;
		this.children = new List<EstimatorElementDto>();
		this.type = EstimatorConstants.ACTIVITY;
	}
	public EstimatorElementDto(Task__c taskSo) {
		super(taskSo);
		this.name = taskSo.Path__c + ' ' + taskSo.Name;
		this.totalCalculatedDuration = taskSo.CalculatedDuration__c;
		this.totalAdjustments = taskSo.LevelAdjustment__c;
		this.totalLevelAdjustments = taskSo.LevelAdjustment__c;
		this.totalEstimatedDuration = taskSo.EstimatedDuration__c;
		this.resourceRoleName = taskSo.ResourceRoleId__r.Name;
		this.isNotApplicable = taskSo.IsNotApplicable__c;
		this.type = EstimatorConstants.TASK;
	}

	public override SObject refreshSo() {
		return null;
	}
}
