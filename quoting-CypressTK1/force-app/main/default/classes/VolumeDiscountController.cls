/**
 *  Provus Services Quoting
 *  VolumeDiscountController
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class VolumeDiscountController {
	@AuraEnabled
	public static List<VolumeDiscountDto> saveVolumeDiscounts(
		List<VolumeDiscountDto> volumeDiscountDtos
	) {
		VolumeDiscountDto[] volumeDiscountsToDelete = new VolumeDiscountDto[0];
		VolumeDiscountDto[] volumeDiscountsToSave = new VolumeDiscountDto[0];

		for (VolumeDiscountDto volumeDiscountDto : volumeDiscountDtos) {
			if (volumeDiscountDto.isDelete()) {
				volumeDiscountsToDelete.add(volumeDiscountDto);
			} else {
				volumeDiscountsToSave.add(volumeDiscountDto);
			}
		}
		VolumeDiscountService.deleteVolumeDiscounts(volumeDiscountsToDelete);
		return VolumeDiscountService.saveVolumeDiscounts(volumeDiscountsToSave);
	}

	@AuraEnabled
	public static List<VolumeDiscountDto> getVolumeDiscounts(Id quoteId) {
		return VolumeDiscountService.getVolumeDiscounts(quoteId);
	}

	/**
	 * Retrieves list of active volume discounts and additional details for each
	 *
	 * @param quoteId id of quote
	 *
	 * @return list of VolumeDiscountSummaryDto objects
	 */
	@AuraEnabled
	public static List<VolumeDiscountSummaryDto> getVolumeDiscountSummary(Id quoteId) {
		return VolumeDiscountService.getVolumeDiscountSummary(quoteId);
	}
}
