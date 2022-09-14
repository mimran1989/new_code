/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class TaskRoleSummaryDto extends DurationDto {
	@AuraEnabled
	public String rateCardItemId { get; set; }
	@AuraEnabled
	public String resourceRole { get; set; }
	@AuraEnabled
	public Id resourceRoleId { get; set; }
	@AuraEnabled
	public Id estimateId { get; set; }
	@AuraEnabled
	public Id activityGroupId { get; set; }
	@AuraEnabled
	public Id activityId { get; set; }
	@AuraEnabled
	public String summaryLevel { get; set; }
	@AuraEnabled
	public List<ResourceSplitDTO> splits { get; set; }

	public TaskRoleSummaryDto() {
	}

	public TaskRoleSummaryDto(TaskRoleSummary__c roleSummarySo) {
		super(roleSummarySo);
		this.activityGroupId = roleSummarySo.ActivityGroupId__c;
		this.activityId = roleSummarySo.ActivityId__c;
		this.estimateId = roleSummarySo.EstimateId__c;
		this.levelAdjustment = roleSummarySo.LevelAdjustment__c;
		this.rateCardItemId = roleSummarySo.RateCardItemId__c;
		this.resourceRole = roleSummarySo.ResourceRole__c;
		this.resourceRoleId = roleSummarySo.ResourceRoleId__c;
		this.summaryLevel = roleSummarySo.SummaryLevel__c;
		this.totalAdjustments = roleSummarySo.TotalAdjustments__c;
		this.totalCalculatedDuration = roleSummarySo.TotalCalculatedDuration__c;
		this.totalEstimatedDuration = roleSummarySo.TotalEstimatedDuration__c;

		if (!SystemUtility.nullOrEmpty(roleSummarySo.ResourceSplits__r)) {
			splits = new List<ResourceSplitDTO>();
			for (ResourceSplit__c resourceSplitSo : roleSummarySo.ResourceSplits__r) {
				splits.add(new ResourceSplitDTO(resourceSplitSo));
			}
		}
	}

	public override SObject refreshSo() {
		if (this.sObj == null) {
			this.sObj = new TaskRoleSummary__c();
		}

		TaskRoleSummary__c roleSummarySo = (TaskRoleSummary__c) this.sObj;

		roleSummarySo.ActivityGroupId__c = this.activityGroupId;
		roleSummarySo.ActivityId__c = this.activityId;
		roleSummarySo.EstimateId__c = this.estimateId;
		roleSummarySo.Id = this.id;
		roleSummarySo.LevelAdjustment__c = this.levelAdjustment;
		roleSummarySo.RateCardItemId__c = this.rateCardItemId;
		roleSummarySo.ResourceRoleId__c = this.resourceRoleId;
		roleSummarySo.SummaryLevel__c = this.summaryLevel;

		return roleSummarySo;
	}
}
