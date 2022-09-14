/**
 *  Provus Services Quoting
 *  ExperimentalFeaturesController
 *  @2022 Provus Inc. All rights reserved.
 */
public abstract with sharing class ExperimentalFeaturesController {
	@AuraEnabled(cacheable=true)
	public static Boolean getIsExperimentalFeaturesEnabled() {
		return FeatureDecisions.isExperimentalFeaturesEnabled();
	}

	@AuraEnabled(cacheable=true)
	public static List<FeatureService.FeatureUser> getExperimentalUsers() {
		return FeatureService.getExperimentalUsers();
	}

	@AuraEnabled(cacheable=true)
	public static List<FeatureService.Feature> getExperimentalFeatures() {
		return FeatureService.getExperimentalFeatures();
	}

	@AuraEnabled
	public static void saveFeatureSettings(List<Id> userIds, List<FeatureService.Feature> features) {
		Set<Id> featureIds = new Set<Id>();
		for (FeatureService.Feature feature : features) {
			featureIds.add(feature.id);
		}

		FeatureService.saveFeatureSettings(new Set<Id>(userIds), featureIds);
	}

	private class FeatureAccessException extends Exception {
	}
}
