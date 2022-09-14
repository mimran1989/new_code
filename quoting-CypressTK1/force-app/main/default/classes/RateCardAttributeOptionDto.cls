/**
 *  Provus Services Quoting
 *  RateCardAttributeOptionDto
 *  @2022 Provus Inc. All rights reserved.
 */
public class RateCardAttributeOptionDto extends BaseDTO {
	@AuraEnabled
	public String label;
	@AuraEnabled
	public List<String> options;

	public override SObject refreshSo() {
		return null;
	}
}
