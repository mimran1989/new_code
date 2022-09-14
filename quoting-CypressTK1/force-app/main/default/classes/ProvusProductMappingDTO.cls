/**
 *  Provus Services Quoting
 *  ProvusProductMappingDTO
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class ProvusProductMappingDTO extends BaseDTO {
	public ProvusProductMapping__mdt sO;
	public String fieldName;
	public String product2FieldName;

	public ProvusProductMappingDTO(ProvusProductMapping__mdt so) {
		this.sO = so;
		this.name = this.sO.DeveloperName;
		this.fieldName = this.sO.FieldName__c;
		this.product2FieldName = this.sO.Product2FieldName__c;
	}

	public override SObject refreshSo() {
		return null;
	}
}
