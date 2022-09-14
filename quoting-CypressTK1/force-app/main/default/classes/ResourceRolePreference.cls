/**
 *  Provus Services Quoting
 *  ResourceRolePreference
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class ResourceRolePreference {
	@AuraEnabled
	public String role;
	@AuraEnabled
	public String skillLevel;
	@AuraEnabled
	public String location;
}
