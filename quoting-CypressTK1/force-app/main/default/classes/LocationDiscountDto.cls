/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class LocationDiscountDto extends BaseDTO {
	@AuraEnabled
	public String id { get; set; }
	@AuraEnabled
	public String rateMatch { get; set; }
	@AuraEnabled
	public String country { get; set; }
	@AuraEnabled
	public String state { get; set; }
	@AuraEnabled
	public String city { get; set; }
	@AuraEnabled
	public Decimal amount { get; set; }
	@AuraEnabled
	public String quoteId { get; set; }
	@AuraEnabled
	public String type { get; set; }

	public LocationDiscountDto() {
	}

	public LocationDiscountDto(LocationDiscount__c discountRecord) {
		this.id = discountRecord.Id;
		this.rateMatch = discountRecord.RateMatch__c;
		this.country = discountRecord.Country__c;
		this.state = discountRecord.State__c;
		this.city = discountRecord.City__c;
		this.amount = discountRecord.Amount__c;
		this.quoteId = discountRecord.QuoteId__c;
		this.type = discountRecord.Type__c;
	}

	public override SObject refreshSo() {
		this.sObj = new LocationDiscount__c(
			Id = this.id,
			Country__c = this.country,
			State__c = this.state,
			City__c = this.city,
			Amount__c = this.amount,
			QuoteId__c = this.quoteId,
			Type__c = this.type
		);

		return this.sObj;
	}
}
