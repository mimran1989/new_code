/**
 *  Provus Services Quoting
 *  FeatureService
 *  @2022 Provus Inc. All rights reserved.
 */
public abstract with sharing class FeatureService {
	private static final String CUSTOM_PERMISSION_ALLOW_EXPERIMENTAL_FEATURES = 'AllowExperimentalFeatures';
	private static final String CUSTOM_PERMISSION_MANAGE_EXPERIMENTAL_FEATURES = 'ManageExperimentalFeatures';
	private static final String PERMISSION_SET_NAME_EXPERIMENTAL_FEATURES_USER = 'ExperimentalFeaturesUser';
	private static final String SETTING_NAME_EXPERIMENTAL_USERS = 'ExperimentalFeaturesUsers';
	private static Map<Id, String> customPermissionNamesById;
	private static Map<String, Id> customPermissionIdsByName;
	private static Map<Id, CustomPermission> customPermissionsById;

	public class Feature {
		@AuraEnabled
		public String name { get; set; }

		@AuraEnabled
		public Id id { get; set; }

		@AuraEnabled
		public Boolean isSelected { get; set; }

		@AuraEnabled
		public String description { get; set; }
	}

	public class FeatureUser {
		@AuraEnabled
		public String name { get; set; }

		@AuraEnabled
		public Id id { get; set; }

		@AuraEnabled
		public Boolean isSelected { get; set; }
	}

	static {
		String namespace = SystemUtility.getNamespacePrefix().replaceAll('_', '');
		customPermissionNamesById = new Map<Id, String>();
		customPermissionIdsByName = new Map<String, Id>();
		customPermissionsById = new Map<Id, CustomPermission>(
			[
				SELECT Id, MasterLabel, Description, DeveloperName
				FROM CustomPermission
				WHERE NamespacePrefix = :namespace
				WITH SECURITY_ENFORCED
			]
		);

		for (CustomPermission customPermission : customPermissionsById.values()) {
			customPermissionNamesById.put(customPermission.Id, customPermission.DeveloperName);
			customPermissionIdsByName.put(customPermission.DeveloperName, customPermission.Id);
		}
	}

	public static void saveFeatureSettings(Set<Id> userIds, Set<Id> featureIds) {
		Id experimentalUserGrantId = getExperimentalUsersPermissionSet()?.Id;
		CustomPermission allowExperimentalFeaturesPermission = getAllowExperimentalFeaturesPermission();

		if (experimentalUserGrantId == null) {
			experimentalUserGrantId = createExperimentalUsersPermissionSet();
		} else {
			// only perform this delete action if we did not have to create a new permission set
			// there is a bug in the SFDC runtime whereby if you invoke the delete DML operation
			// on setup entities and then attempt to update custom metadata, the runtime will fail
			// with an internal error
			removeFeaturesFromPermissionSet(experimentalUserGrantId, customPermissionsById.keyset());
			SystemUtility.removeAllUsersFromPermissionSet(experimentalUserGrantId);
		}

		// create a new permission set link for every allowed feature
		Set<Id> featuresToAdd = new Set<Id>{ allowExperimentalFeaturesPermission.id };
		featuresToAdd.addAll(featureIds);

		Boolean isDeployedInPackage = !String.isBlank(SystemUtility.getNamespacePrefix());
		Boolean isDeployedInDX = SystemUtility.isInScratchORG();
		if (isDeployedInPackage == true && !isDeployedInDX) {
			for (Id permissionId : customPermissionNamesById.keySet()) {
				String permissionName = customPermissionNamesById.get(permissionId);
				if (featuresToAdd.contains(permissionId)) {
					FeatureManagement.changeProtection(permissionName, 'CustomPermission', 'Unprotected');
				} else {
					FeatureManagement.changeProtection(permissionName, 'CustomPermission', 'Protected');
				}
			}
		}

		addFeaturesToPermissionSet(experimentalUserGrantId, featuresToAdd);
		SystemUtility.assignUsersToPermissionSet(experimentalUserGrantId, userIds);
	}

	public static List<FeatureUser> getExperimentalUsers() {
		PermissionSet experimentalUserGrant = getExperimentalUsersPermissionSet();
		Map<Id, User> experimentalUsers = new Map<Id, User>();
		if (experimentalUserGrant != null) {
			experimentalUsers = new Map<Id, User>(
				[
					SELECT Id
					FROM User
					WHERE
						Id IN (
							SELECT AssigneeId
							FROM PermissionSetAssignment
							WHERE PermissionSetId = :experimentalUserGrant.Id
						)
					WITH SECURITY_ENFORCED
				]
			);
		}

		List<FeatureUser> usersList = new List<FeatureUser>();
		for (User systemUser : [SELECT Id, Name FROM User WITH SECURITY_ENFORCED]) {
			FeatureUser userInfo = new FeatureUser();
			userInfo.name = systemUser.Name;
			userInfo.id = systemUser.Id;
			userInfo.isSelected = experimentalUsers.containsKey(systemUser.Id);
			usersList.add(userInfo);
		}
		return usersList;
	}

	public static List<Feature> getExperimentalFeatures() {
		// fetch experimental features
		List<Feature> experimentalFeatures = new List<Feature>();
		PermissionSet experimentalUserGrant = getExperimentalUsersPermissionSet();
		Set<Id> enabledPermissionSets = new Set<Id>();
		if (experimentalUserGrant != null) {
			for (SetupEntityAccess grant : [
				SELECT SetupEntityId
				FROM SetupEntityAccess
				WHERE ParentId = :experimentalUserGrant.Id
				WITH SECURITY_ENFORCED
			]) {
				enabledPermissionSets.add(grant.SetupEntityId);
			}
		}

		for (
			CustomPermission customPermission : getAllExperimentalFeatureCustomPermissions().values()
		) {
			Feature experimentalFeature = new Feature();
			experimentalFeature.name = customPermission.MasterLabel;
			experimentalFeature.id = customPermission.Id;
			experimentalFeature.description = customPermission.Description;
			experimentalFeature.isSelected = enabledPermissionSets.contains(customPermission.Id);
			experimentalFeatures.add(experimentalFeature);
		}
		return experimentalFeatures;
	}

	private static CustomPermission getAllowExperimentalFeaturesPermission() {
		return getPermission(CUSTOM_PERMISSION_ALLOW_EXPERIMENTAL_FEATURES);
	}

	private static CustomPermission getManageExperimentalFeaturesPermission() {
		return getPermission(CUSTOM_PERMISSION_MANAGE_EXPERIMENTAL_FEATURES);
	}

	private static CustomPermission getPermission(String permissionName) {
		return customPermissionsById.get(customPermissionIdsByName.get(permissionName));
	}

	private static PermissionSet getExperimentalUsersPermissionSet() {
		Boolean isDeployedInPackage = !String.isBlank(SystemUtility.getNamespacePrefix());
		Boolean isDeployedInDX = SystemUtility.isInScratchORG();
		String namespace = (isDeployedInPackage && isDeployedInDX)
			? SystemUtility.getNamespacePrefix().replaceAll('_', '')
			: null;
		List<ProvusConfiguration__mdt> settings = [
			SELECT Id, TextValue__c
			FROM ProvusConfiguration__mdt
			WHERE
				NamespacePrefix = :(isDeployedInPackage && isDeployedInDX) ? namespace : null
				AND DeveloperName = :SETTING_NAME_EXPERIMENTAL_USERS
			WITH SECURITY_ENFORCED
		];

		Id experimentalUsersPermissionSetId = settings.size() > 0 ? settings[0].TextValue__c : null;
		List<PermissionSet> permissionSets = [
			SELECT Id, Name
			FROM PermissionSet
			WHERE Id = :experimentalUsersPermissionSetId
			WITH SECURITY_ENFORCED
			LIMIT 1
		];

		return permissionSets.isEmpty() ? null : permissionSets[0];
	}

	private static Map<Id, CustomPermission> getAllExperimentalFeatureCustomPermissions() {
		Map<Id, CustomPermission> allowExperimentalFeaturesPermission = new Map<Id, CustomPermission>();
		for (CustomPermission permission : customPermissionsById.values()) {
			if (
				permission.Id != getAllowExperimentalFeaturesPermission().Id &&
				permission.Id != getManageExperimentalFeaturesPermission().Id
			) {
				allowExperimentalFeaturesPermission.put(permission.Id, permission);
			}
		}
		return allowExperimentalFeaturesPermission;
	}

	private static void addFeaturesToPermissionSet(Id permissionSetId, Set<Id> featureIds) {
		List<SetupEntityAccess> newPermissionGrants = new List<SetupEntityAccess>();
		for (Id featureId : featureIds) {
			SetupEntityAccess accessEntity = new SetupEntityAccess();
			accessEntity.ParentId = permissionSetId;
			accessEntity.SetupEntityId = featureId;
			newPermissionGrants.add(accessEntity);
		}
		CRUDUtility.insertRecords(newPermissionGrants);
	}

	private static void removeFeaturesFromPermissionSet(
		Id permissionSetId,
		Set<Id> permissionsToRemove
	) {
		CRUDUtility.deleteRecords(
			[
				SELECT Id
				FROM SetupEntityAccess
				WHERE SetupEntityId IN :permissionsToRemove AND ParentId = :permissionSetId
			]
		);
	}

	private static Id createExperimentalUsersPermissionSet() {
		String permissionSetName =
			SETTING_NAME_EXPERIMENTAL_USERS +
			String.valueOf(Datetime.now()).replaceAll(' ', '').replaceAll(':', '').replaceAll('-', '');
		PermissionSet experimentalUserPermSet = new PermissionSet(
			Label = permissionSetName,
			Name = permissionSetName
		);
		CRUDUtility.insertRecords(experimentalUserPermSet);

		CustomMetadata.Operations
			.callback(
				// Platform event for deploy status
				MetadataDeployment__e.getSObjectType(),
				MetadataDeployment__e.DeploymentId__c,
				MetadataDeployment__e.Result__c
			)
			.enqueueUpsertRecords(
				// Custom Metadata object type
				ProvusConfiguration__mdt.getSObjectType(),
				new List<Map<SObjectField, Object>>{
					// Custom Metadata record
					new Map<SObjectField, Object>{
						ProvusConfiguration__mdt.DeveloperName => SETTING_NAME_EXPERIMENTAL_USERS,
						ProvusConfiguration__mdt.TextValue__c => String.valueOf(experimentalUserPermSet.Id),
						ProvusConfiguration__mdt.Label => SETTING_NAME_EXPERIMENTAL_USERS
					}
				}
			);

		return experimentalUserPermSet.Id;
	}
}
