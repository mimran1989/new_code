/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing abstract class ScopeParameterBaseDto extends BaseDTO {
	@AuraEnabled
	public Decimal sequence { get; set; }
	@AuraEnabled
	public String guidance { get; set; }
	@AuraEnabled
	public String dataType { get; set; }
	@AuraEnabled
	public String developerName { get; set; }

	public ScopeParameterBaseDto() {
		super();
	}

	public ScopeParameterBaseDto(SObject sObj) {
		super(sObj);
	}
}
