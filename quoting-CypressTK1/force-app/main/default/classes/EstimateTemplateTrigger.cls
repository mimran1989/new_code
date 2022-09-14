public with sharing class EstimateTemplateTrigger extends TriggerHandler {
	public static void processTrigger(
		Map<Id, EstimateTemplate__c> oldMap,
		List<EstimateTemplate__c> newObjs,
		Boolean isBefore
	) {
		final EstimateTemplateTrigger myTrigger = new EstimateTemplateTrigger(
			oldMap,
			newObjs,
			isBefore
		);
		if (isBefore) {
			myTrigger.validateEstimateTemplateUpdate();
		}
	}

	public EstimateTemplateTrigger(
		Map<Id, EstimateTemplate__c> oldMap,
		List<EstimateTemplate__c> newObjs,
		Boolean isBefore
	) {
		super(oldMap, newObjs, isBefore);
	}

	public void validateEstimateTemplateUpdate() {
		if (isUpdate) {
			for (EstimateTemplate__c estimateTemplate : (List<EstimateTemplate__c>) newObjs) {
				if (isChanged(estimateTemplate.Id, Schema.EstimateTemplate__c.UseProjectPhases__c)) {
					estimateTemplate.UseProjectPhases__c.addError(
						System.Label.EstimateTemplateValidationErrorMessage
					);
				}
			}
		}
	}
}
