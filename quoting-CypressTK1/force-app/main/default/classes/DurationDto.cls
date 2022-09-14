/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing abstract class DurationDto extends BaseDTO {
	@AuraEnabled
	public Decimal totalCalculatedDuration { get; set; }
	@AuraEnabled
	public Decimal totalAdjustments { get; set; }
	@AuraEnabled
	public Decimal totalLevelAdjustments { get; set; }
	@AuraEnabled
	public Decimal totalEstimatedDuration { get; set; }
	@AuraEnabled
	public Decimal levelAdjustment { get; set; }

	protected DurationDto() {
		super();
	}

	protected DurationDto(SObject sObj) {
		super(sObj);
	}
}
