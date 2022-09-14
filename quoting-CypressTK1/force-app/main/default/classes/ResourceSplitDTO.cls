/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class ResourceSplitDTO extends DurationDto {
	public ResourceSplit__c splitSO;
	@AuraEnabled
	public Decimal splitPercentage { get; set; }
	@AuraEnabled
	public Id taskRoleSummaryId { get; set; }
	@AuraEnabled
	public Integer sequence { get; set; }

	public ResourceSplitDTO() {
	}

	public ResourceSplitDTO(ResourceSplit__c splitSO) {
		this.id = splitSO.Id;
		this.name = splitSO.Name;
		this.totalEstimatedDuration = splitSO.TotalEstimatedDuration__c;
		this.totalAdjustments = splitSO.TotalAdjustments__c;
		this.totalCalculatedDuration = splitSO.TotalCalculatedDuration__c;
		this.levelAdjustment = splitSO.LevelAdjustment__c;
		this.splitPercentage = splitSO.SplitPercentage__c;
		this.taskRoleSummaryId = splitSO.TaskRoleSummaryId__c;
		this.sequence = (Integer) splitSO.Sequence__c;
	}

	public override SObject refreshSo() {
		if (this.splitSO == null) {
			this.splitSO = new ResourceSplit__c(TaskRoleSummaryId__c = this.taskRoleSummaryId);
		}

		this.splitSO.Id = this.id;
		this.splitSO.Name = this.name;
		this.splitSO.SplitPercentage__c = this.splitPercentage;
		this.splitSO.Sequence__c = (Integer) this.sequence;

		return this.splitSO;
	}
}
