/**
 *  Provus Services Quoting
 *  ResourceRoleDialogController
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class ResourceRoleDialogController {
	@AuraEnabled(cacheable=true)
	public static List<RateCardAttributeOptionDto> getRateCardFilters(Id rateCardId) {
		if (!FeatureDecisions.isFilterResourcesEnabled()) {
			return new List<RateCardAttributeOptionDto>();
		}

		return RateCardService.getRateCardFilters(rateCardId);
	}
}
