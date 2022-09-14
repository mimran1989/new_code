/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

public with sharing class ScopeSummaryController {
	@AuraEnabled
	public static List<ScopeSummaryDto> getEstimateScopeSummaries(Id estimateId) {
		return ScopeSummaryService.getScopeSummariesForEstimate(estimateId);
	}
}
