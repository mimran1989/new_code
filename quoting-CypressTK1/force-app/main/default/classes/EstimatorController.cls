/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class EstimatorController {
	@AuraEnabled
	public static EstimateDto getEstimateForId(Id estimateId) {
		Estimate__c estimateSo = [
			SELECT RateCardId__c
			FROM Estimate__c
			WHERE Id = :estimateId
			WITH SECURITY_ENFORCED
		];
		return new EstimateDto(estimateSo);
	}
	@AuraEnabled
	public static List<EstimatorElementDto> getData(Id estimateId) {
		List<EstimatorElementDto> elements = new List<EstimatorElementDto>();
		Map<Id, EstimatorElementDto> elementDtosByIds = new Map<Id, EstimatorElementDto>();
		for (ActivityGroup__c groupSo : [
			SELECT
				Description__c,
				EstimateId__c,
				Guidance__c,
				Id,
				IsActive__c,
				IsNotApplicable__c,
				Name,
				PhaseId__c,
				Sequence__c,
				SummaryId__c,
				TotalAdjustments__c,
				TotalCalculatedDuration__c,
				TotalEstimatedDuration__c,
				TotalLevelAdjustments__c
			FROM ActivityGroup__c
			WHERE EstimateId__c = :estimateId
			WITH SECURITY_ENFORCED
		]) {
			EstimatorElementDto elementDto = new EstimatorElementDto(groupSo);
			elements.add(elementDto);
			elementDtosByIds.put(groupSo.Id, elementDto);
		}

		for (Activity__c activitySo : [
			SELECT
				ActivityGroupId__c,
				AdjustedDuration__c,
				Description__c,
				EstimateId__c,
				Guidance__c,
				Id,
				IsActive__c,
				IsNotApplicable__c,
				Name,
				Path__c,
				Sequence__c,
				SummaryId__c,
				TotalAdjustments__c,
				TotalCalculatedDuration__c,
				TotalEstimatedDuration__c,
				TotalLevelAdjustments__c
			FROM Activity__c
			WHERE EstimateId__c = :estimateId
			WITH SECURITY_ENFORCED
		]) {
			EstimatorElementDto elementDto = new EstimatorElementDto(activitySo);
			elementDtosByIds.put(activitySo.Id, elementDto);
			elementDtosByIds.get(activitySo.ActivityGroupId__c).children.add(elementDto);
		}

		for (Task__c taskSo : [
			SELECT
				ActivityGroupId__c,
				ActivityId__c,
				AdjustmentReason__c,
				CalculatedDuration__c,
				Description__c,
				EstimatedDuration__c,
				EstimateId__c,
				Guidance__c,
				Id,
				IsActive__c,
				IsNotApplicable__c,
				LevelAdjustment__c,
				Name,
				Path__c,
				PhaseId__c,
				ResourceRole__c,
				ResourceRoleId__r.Name,
				RoleSummaryId__c,
				Sequence__c,
				TemplateId__c
			FROM Task__c
			WHERE EstimateId__c = :estimateId
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c ASC
		]) {
			EstimatorElementDto elementDto = new EstimatorElementDto(taskSo);
			elementDtosByIds.put(taskSo.Id, elementDto);
			elementDtosByIds.get(taskSo.ActivityId__c).children.add(elementDto);
		}

		return elements;
	}
}
