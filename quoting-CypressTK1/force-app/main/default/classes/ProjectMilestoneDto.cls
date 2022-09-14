/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class ProjectMilestoneDto extends BaseDTO {
	@AuraEnabled
	public String alignToActivityOrMilestone;
	@AuraEnabled
	public Date activityDate;
	@AuraEnabled
	public String activityName;
	@AuraEnabled
	public Decimal offset;
	@AuraEnabled
	public String offsetUnit;
	@AuraEnabled
	public Date estimatedOccurrenceDate;

	public ProjectMilestoneDto(ProjectMilestone__c milestoneSO) {
		this.id = milestoneSO.Id;
		this.name = milestoneSO.Name;
		this.alignToActivityOrMilestone = milestoneSO.AlignToActivityOrMilestone__c;
		this.activityName = milestoneSO.ActivityName__c;
		this.offset = milestoneSO.Offset__c;
		this.offsetUnit = milestoneSO.OffsetUnit__c;
		this.estimatedOccurrenceDate = milestoneSO.EstimatedOccurrenceDate__c;

		if (milestoneSO.Type__c == ProjectMilestone.TYPE_DATE) {
			this.activityDate = milestoneSO.ActivityDate__c;
		}
	}

	public override SObject refreshSo() {
		return null;
	}
}
