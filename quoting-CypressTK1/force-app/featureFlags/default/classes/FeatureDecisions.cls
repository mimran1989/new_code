/**
 *  Provus Services Quoting
 *  FeatureDecisions
 *  @2022 Provus Inc. All rights reserved.
 */
public abstract with sharing class FeatureDecisions {
	private static final String PERMISSION_SET_NAME_ALLOW_EXPERIMENTAL_FEATURES = 'AllowExperimentalFeatures';
	private static final String CUSTOM_PERMISSION_NAME_FILTER_RESOURCES = 'FilterResources';
	private static final String CUSTOM_PERMISSION_NAME_NAME_SCENARIOS = 'Scenarios';

	private static final Set<String> CUSTOM_PERMISSION_NAMES;
	private static final Set<String> CUSTOM_PERMISSIONS_FOR_CURRENT_USER;

	static {
		CUSTOM_PERMISSION_NAMES = new Set<String>();
		CUSTOM_PERMISSIONS_FOR_CURRENT_USER = new Set<String>();

		String namespace = SystemUtility.getNamespacePrefix().replaceAll('_', '');

		// query the full set of permissions for the namespace
		Map<Id, String> customPermissionNamesById = new Map<Id, String>();
		List<CustomPermission> customPermissions = [
			SELECT Id, DeveloperName
			FROM CustomPermission
			WHERE NamespacePrefix = :namespace
			WITH SECURITY_ENFORCED
		];

		for (CustomPermission customPermission : customPermissions) {
			CUSTOM_PERMISSION_NAMES.add(customPermission.DeveloperName);
			customPermissionNamesById.put(customPermission.Id, customPermission.DeveloperName);
		}

		// determine the features which are assigned
		List<SetupEntityAccess> setupEntities = [
			SELECT SetupEntityId
			FROM SetupEntityAccess
			WHERE
				SetupEntityId IN :customPermissionNamesById.keySet()
				AND ParentId IN (
					SELECT PermissionSetId
					FROM PermissionSetAssignment
					WHERE AssigneeId = :UserInfo.getUserId()
				)
			WITH SECURITY_ENFORCED
		];
		for (SetupEntityAccess setupEntity : setupEntities) {
			CUSTOM_PERMISSIONS_FOR_CURRENT_USER.add(
				customPermissionNamesById.get(setupEntity.SetupEntityId)
			);
		}
	}

	public static Boolean isFilterResourcesEnabled() {
		return hasPermission(CUSTOM_PERMISSION_NAME_FILTER_RESOURCES);
	}

	@AuraEnabled(cacheable=true)
	public static Boolean isScenariosEnabled() {
		return hasPermission(CUSTOM_PERMISSION_NAME_NAME_SCENARIOS);
	}

	public static Boolean isExperimentalFeaturesEnabled() {
		Boolean isDeployedInPackage = !String.isBlank(SystemUtility.getNamespacePrefix());
		Boolean isDeployedInDX = SystemUtility.isInScratchORG();
		Boolean isInDevInstance = !isDeployedInPackage || isDeployedInDX;

		return isInDevInstance ||
			FeatureManagement.checkPackageBooleanValue(PERMISSION_SET_NAME_ALLOW_EXPERIMENTAL_FEATURES);
	}

	public static Boolean hasPermission(String customPermissionName) {
		if (!isExperimentalFeaturesEnabled()) {
			return false;
		}

		// Is this a valid custom permission name?
		if (!CUSTOM_PERMISSION_NAMES.contains(customPermissionName)) {
			throw new CustomPermissionsException(
				'Custom Permission ' +
				customPermissionName +
				' is not valid.'
			);
		}
		// Has this user been assigned this custom permission?
		return CUSTOM_PERMISSIONS_FOR_CURRENT_USER.contains(customPermissionName);
	}

	public class CustomPermissionsException extends Exception {
	}
}
