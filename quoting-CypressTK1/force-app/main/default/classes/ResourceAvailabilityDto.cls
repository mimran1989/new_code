/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class ResourceAvailabilityDto extends BaseDTO {
	@AuraEnabled
	public Id taskRoleSummaryId { get; set; }
	@AuraEnabled
	public Decimal availabilityPercentage { get; set; }

	public ResourceAvailabilityDto() {
	}

	public ResourceAvailabilityDto(ResourceAvailability__c availabilitySo) {
		super(availabilitySo);
		this.taskRoleSummaryId = availabilitySo.TaskRoleSummaryId__c;
		this.availabilityPercentage = availabilitySo.AvailabilityPercentage__c;
	}

	public override SObject refreshSo() {
		this.sObj = new ResourceAvailability__c(
			Id = this.id,
			TaskRoleSummaryId__c = this.taskRoleSummaryId,
			AvailabilityPercentage__c = this.availabilityPercentage
		);

		return this.sObj;
	}
}
