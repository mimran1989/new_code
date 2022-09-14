/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class ColaAdjustmentController {
	@AuraEnabled
	public static List<ColaAdjustmentDto> getColaAdjustments(Id quoteId) {
		return ColaAdjustmentService.getColaAdjustments(quoteId);
	}

	@AuraEnabled
	public static void saveColaAdjustments(Id quoteId, List<ColaAdjustmentDto> colaAdjustmentDtos) {
		ColaAdjustmentService.deleteColaAdjustments(quoteId);
		ColaAdjustmentService.saveColaAdjustments(colaAdjustmentDtos);
	}
}
