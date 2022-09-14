/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class ResourceDefaultDto {
	public ResourceDefault__c defaultSo;
	@AuraEnabled
	public Id id { get; set; }
	@AuraEnabled
	public String rateCardItemId { get; set; }

	public ResourceDefault__c updateSo() {
		if (this.defaultSo == null) {
			this.defaultSo = new ResourceDefault__c();
		}

		defaultSo.Id = this.id;
		defaultSo.RateCardItemId__c = this.rateCardItemId;

		return this.defaultSo;
	}
}
