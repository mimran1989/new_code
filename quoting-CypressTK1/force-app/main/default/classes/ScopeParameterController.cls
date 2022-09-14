public with sharing class ScopeParameterController {
	@AuraEnabled
	public static List<ScopeParameterDto> getScopeParameters(Id estimateId) {
		return ScopeParameterService.getScopeParameters(estimateId);
	}

	@AuraEnabled(cacheable=false)
	public static Boolean saveScopeParameters(List<ScopeParameterValueDto> scopeParameters) {
		return ScopeParameterService.saveScopeParameters(scopeParameters);
	}

	@AuraEnabled(cacheable=true)
	public static Boolean hasScopeParameters(Id estimateId) {
		return ScopeParameterService.hasScopeParameters(estimateId);
	}
}
