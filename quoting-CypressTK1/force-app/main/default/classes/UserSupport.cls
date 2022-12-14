/**
 *  Provus Services Quoting
 *  @2021 Provus Inc. All rights reserved.
 */
public with sharing class UserSupport {
	public static final String USER_TYPE = Schema.SObjectType.User.getKeyPrefix();
	private static final String PERMISSION_SET_NAME_COLLABORATION_USER = 'CollaborationUser';

	public static List<User> getGroupMemberUsers(String groupDeveloperName) {
		Set<Id> userIds = getAllGroupMembersIdsByDeveloperName(groupDeveloperName);

		return [
			SELECT Id, Name, Email, Title
			FROM User
			WHERE Id IN :userIds
			WITH SECURITY_ENFORCED
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		];
	}

	public static Set<Id> getAllGroupMembersIdsByDeveloperName(String developerName) {
		Set<Id> userIDs = new Set<Id>();

		for (GroupMember groupMemberSO : [
			SELECT UserOrGroupId
			FROM GroupMember
			WHERE Group.DeveloperName = :developerName
			WITH SECURITY_ENFORCED
		]) {
			if (((String) groupMemberSO.UserOrGroupId).startsWith(USER_TYPE)) {
				userIDs.add(groupMemberSO.UserOrGroupId);
			}
		}
		return userIDs;
	}

	public static User getUserInformation(Id userId) {
		return [SELECT Id, Name, Email FROM User WHERE Id = :userId WITH SECURITY_ENFORCED];
	}

	/**
	 * Get the active users which have logged in in the past year
	 */
	public static List<User> getActiveExcludingLoggedInUser() {
		String sfdcProvisionedUsernamePattern = '%' + UserInfo.getOrganizationId() + '%';
		return [
			SELECT Id, Name, Email, Title, LastLoginDate
			FROM User
			WHERE
				Id != :UserInfo.getUserId()
				AND IsActive = TRUE
				AND (NOT Username LIKE :sfdcProvisionedUsernamePattern)
				AND LastLoginDate != NULL
				AND LastLoginDate > LAST_N_YEARS:1
			WITH SECURITY_ENFORCED
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		];
	}

	/**
	 * Get the active users which have logged in in the past year
	 * and having CollaborationUser permission set
	 */
	public static List<User> getCollaborationUserList() {
		String sfdcProvisionedUsernamePattern = '%' + UserInfo.getOrganizationId() + '%';
		PermissionSet collaborationUser = getCollaborationUserPermissionSet();
		return [
			SELECT Id, Name, Email, Title, LastLoginDate
			FROM User
			WHERE
				Id != :UserInfo.getUserId()
				AND IsActive = TRUE
				AND (NOT Username LIKE :sfdcProvisionedUsernamePattern)
				AND LastLoginDate != NULL
				AND LastLoginDate > LAST_N_YEARS:1
				AND Id IN (
					SELECT AssigneeId
					FROM PermissionSetAssignment
					WHERE PermissionSetId = :collaborationUser.Id
				)
			WITH SECURITY_ENFORCED
			LIMIT :SOQLConstants.SOQL_QUERY_LIMIT
		];
	}

	private static PermissionSet getCollaborationUserPermissionSet() {
		return [
			SELECT Id, Name
			FROM PermissionSet
			WHERE Name = :PERMISSION_SET_NAME_COLLABORATION_USER
			WITH SECURITY_ENFORCED
			LIMIT 1
		];
	}
}
