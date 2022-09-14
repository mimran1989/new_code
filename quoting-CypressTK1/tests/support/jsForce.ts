import jsforce, {
	Connection, ErrorResult, RecordResult, RecordTypeInfo, UserInfo,
} from 'jsforce';
import { AuthenticatedUser } from '../features/abilities/authenticate';
import { SObjectSO } from '../features/support/sObject';

type RecordOrError = RecordResult & ErrorResult;

async function getUserInfo(salesforceConnection: Connection, username: string) {
	const userRecord = await salesforceConnection.query(`SELECT Id, ProfileId FROM User where Username='${username}'`);
	const profileId = (userRecord.records[0] as any).ProfileId as string;
	const profileRecords = await salesforceConnection.query(`SELECT Id FROM PermissionSet WHERE ProfileId='${profileId}'`);
	return {
		Id: userRecord.records[0].Id,
		profileId,
		profilePermissionSetId: profileRecords.records[0].Id,
	};
}

async function assignPermissionSets({ authUser }: { authUser: AuthenticatedUser }) {
	const { connection: salesforceConnection } = await login(authUser);
	const { username, permissionSets } = authUser.keys;
	const { Id: userId } = await getUserInfo(salesforceConnection, username);

	const requiredPermissionSetsQryString = permissionSets
		.map((permSetName) => `'${permSetName}'`)
		.join(',');

	const requiredPermissionSetIds = (await salesforceConnection
		.query(`SELECT Id, Name FROM PermissionSet Where Name IN (${requiredPermissionSetsQryString})`))
		.records
		.map((permissionSet: any) => permissionSet.Id);

	const assignedPermissionSetIds = (await salesforceConnection
		.query(`SELECT Id, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = '${userId}'`))
		.records
		.map((permissionSet: any) => permissionSet.PermissionSetId);

	const permissionSetAssignmentsToInsert = requiredPermissionSetIds
		.filter((permissionSetId) => !assignedPermissionSetIds.includes(permissionSetId))
		.map((permissionSetId) => ({
			AssigneeId: userId,
			PermissionSetId: permissionSetId,
		}));

	return insertSObjects({ authUser, objectType: 'PermissionSetAssignment', records: permissionSetAssignmentsToInsert });
}

async function deleteSObjects({ authUser, objectType, records }: { authUser: AuthenticatedUser, objectType: string, records: SObjectSO[] }) {
	const { connection: salesforceConnection } = await login(authUser);
	return salesforceConnection.sobject(objectType).del(records.map((record) => record.Id));
}

async function describeSObject({ authUser, objectName }): Promise<Record<string, string>> {
	try {
		const { connection: salesforceConnection } = await login(authUser);
		const sObjectDescribeInfo = await salesforceConnection.sobject(objectName).describe();
		return sObjectDescribeInfo.recordTypeInfos.reduce((accumulator: Record<string, string>, nextRecordTypeInfo: RecordTypeInfo) => {
			const recordTypeIdsByName = accumulator;
			recordTypeIdsByName[nextRecordTypeInfo.name] = nextRecordTypeInfo.recordTypeId;
			return recordTypeIdsByName;
		}, {});
	} catch (exception) {
		throw Error(`Failed to describe the sObject: ${objectName} ${exception}`);
	}
}

async function insertSObjects({ authUser, objectType, records }: { authUser: AuthenticatedUser, objectType: string, records: SObjectSO[] }): Promise<SObjectSO[]> {
	const { connection: salesforceConnection } = await login(authUser);
	const createRecordsResult = await salesforceConnection.sobject(objectType).create(records, { allOrNone: true });
	const errors: any = [];
	const ctxRecords = records;

	// remmeber the record id of inserted records
	const newRecordsWithIds = (createRecordsResult as unknown as RecordOrError[])
		.map((record, idx) => {
			const insertErrors = record.errors;
			if (insertErrors?.length) {
				errors.push(...insertErrors);
			}

			ctxRecords[idx].id = (record as any).id;
			return ctxRecords[idx];
		});

	if (errors.length > 0) {
		const isNamespaceError = errors.some((error) => error.statusCode === 'JSON_PARSER_ERROR');
		const recordsString = ctxRecords.map((ctxRecord) => JSON.stringify(ctxRecord, null, 4));
		if (isNamespaceError) {
			throw new Error(`Error inserting records: Invalid field definition for object type: ${objectType},\n${recordsString}`);
		} else {
			const errorString: string = errors.map((error) => error.message).join('\n');
			throw new Error(`Error inserting records:\n${errorString}\n${recordsString}`);
		}
	}

	return newRecordsWithIds;
}

async function login({ loginUrl, username, password }): Promise<{ connection: Connection, userInfo: UserInfo }> {
	return new Promise((resolve, reject) => {
		const connection: Connection = new jsforce.Connection({ loginUrl });
		connection.login(username, password, (err, userInfo: UserInfo) => {
			if (err) {
				reject(err);
			} else {
				resolve({ connection, userInfo });
			}
		});
	});
}

async function loginToSfdc({ loginUrl, username, password }) {
	const { connection, userInfo } = await login({ loginUrl, username, password });
	const { accessToken, instanceUrl } = connection;
	return {
		accessToken,
		instanceUrl,
		userInfo,
	};
}

async function turnOffAllAvailableFeatures({ authUser }: { authUser: AuthenticatedUser }) {
	const { connection: salesforceConnection } = await login(authUser);
	const { features: availableFeatures } = authUser.keys;

	const availableFeatureNamesStr = availableFeatures
		.map((featureName) => `'${featureName}'`)
		.join(',');

	const customPermissionIdsStr = (await salesforceConnection
		.query(`SELECT Id, DeveloperName FROM CustomPermission Where DeveloperName IN (${availableFeatureNamesStr})`))
		.records
		.map((customPermission: any) => `'${customPermission.Id}'`)
		.join(',');

	if (customPermissionIdsStr) {
		const recordsToDelete = await salesforceConnection
			.query(`SELECT Id FROM SetupEntityAccess WHERE SetupEntityId IN (${customPermissionIdsStr})`);

		await salesforceConnection.sobject('SetupEntityAccess').del(
			recordsToDelete.records.map((record) => record.Id),
		);
	}

	return null;
}

async function turnOnFeatures({ authUser, features }: { authUser: AuthenticatedUser, features: Record<string, boolean> }) {
	const { connection: salesforceConnection } = await login(authUser);
	const { username } = authUser.keys;
	const { profilePermissionSetId } = await getUserInfo(salesforceConnection, username);
	const featuresToEnable = Object.keys(features);
	if (featuresToEnable.length > 0) {
		const featuresStr = featuresToEnable
			.filter((featureName) => features[featureName])
			.map((featureName) => `'${featureName}'`)
			.join(',');

		const setupEntities = (await salesforceConnection
			.query(`SELECT Id FROM CustomPermission Where DeveloperName IN (${featuresStr})`))
			.records
			.map((feature: any) => ({ ParentId: profilePermissionSetId, SetupEntityId: feature.Id }));

		await insertSObjects({ authUser, objectType: 'SetupEntityAccess', records: setupEntities });
	}

	return null;
}

export {
	assignPermissionSets, deleteSObjects, describeSObject, insertSObjects, loginToSfdc,
	turnOffAllAvailableFeatures, turnOnFeatures,
};
