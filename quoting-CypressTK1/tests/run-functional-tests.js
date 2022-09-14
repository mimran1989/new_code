const fs = require('fs-extra');
const yargs = require('yargs');
const jsforce = require('jsforce');
const util = require('util');
const execSync = require('child_process').exec;

// eslint-disable-next-line padding-line-between-statements
const exec = util.promisify(execSync);

const DEFAULT_PERMISSION_SETS = JSON.parse(fs.readFileSync('../sfdx-project.json', 'utf8'))
	.packageDirectories[0]
	.apexTestAccess
	.permissionSets;

const FEATURE_FLAGS_FOLDER = '../force-app/featureFlags/default/customPermissions';

const { argv } = yargs
	.option('devhubtoken', {
		alias: 'u',
		description: 'Path to the dev hubs access token',
		type: 'string',
	})
	.option('testorgtoken', {
		alias: 't',
		description: 'Path to the test orgs access token',
		type: 'string',
	})
	.help()
	.alias('help', 'h');

//	deployMetadataForTest();
createAndPrepareOrgForFunctionalTests();

async function createAndPrepareOrgForFunctionalTests() {
	await exec(`sfdx force:auth:sfdxurl:store -f ${argv.devhubtoken} -d -a dev-hub`);
	await exec(`sfdx force:auth:sfdxurl:store -f ${argv.testorgtoken} -a test-org`);

	try {
		// console.log('Deploying metadata to test org...');
		// await deployMetadataForTest();

		console.log('Granting user access to test org...');
		const accessKey = await grantUserAccessForTest();

		// add this user to the keychain (including default permissions)
		fs.writeFileSync('keys.json', JSON.stringify([accessKey], null, 4));

		console.log('Executing functional tests...');
		await exec('npm run test:functional:ci');
	} catch (exception) {
		if (exception.stdout) {
			console.error(exception.stdout);
		}

		if (exception.stderr) {
			console.error(exception.stderr);
		} else {
			console.error(exception);
		}

		const command = 'curl -L -X PUT https://test-reports.behave.pro/REST/1.0/bdd/report '
			+ '-H "X-API-KEY: $BEHAVE_PRO_API_KEY" -H "X-COMMIT-ID: $GITHUB_SHA" -H "X-BUILD-ID: $GITHUB_RUN_ID" '
			+ '-H "X-BUILD-URL: https://github.com/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID" '
			+ '--data-binary @./target/cucumber-reports/cucumber.json';

		await exec(command);
		process.exit(1);
	}
}

async function whitelistIpAddress() {
	// Whitelist all IP addresses to disable multi factor authentication during test execution
	await fs.copy('./forceIpAllowedList', '../force-app/main/default/settings');
	return exec('sfdx force:source:deploy -p ../force-app/main/default/settings -u test-org');
}

async function grantUserAccessForTest() {
	console.log('here');

	try {
		await exec('sfdx force:user:password:generate -u test-org -v dev-hub --json');
	} catch (exception) {
		if (exception.stdout) {
			console.error(exception.stdout);
		}

		if (exception.stderr) {
			console.error(exception.stderr);
		} else {
			console.error(exception);
		}
	}

	const { instanceUrl, username, password } = await new Promise((resolve) => {
		execSync('sfdx force:org:display -u test-org --json', (error, stdout) => {
			resolve(JSON.parse(stdout).result);
		});
	});

	await whitelistIpAddress();
	setDefaultMobileNumberForUser(instanceUrl, username, password);

	const userAccessInfo = {
		loginUrl: instanceUrl,
		username,
		password,
		permissionSets: DEFAULT_PERMISSION_SETS, // copy default permissions from the sfdx-project.json build file
		features: getAvailableFeatures(),
		role: 'admin',
	};

	return userAccessInfo;
}

function getAvailableFeatures() {
	return fs.readdirSync(FEATURE_FLAGS_FOLDER).map((file) => file.substring(0, file.indexOf('.customPermission')));
}

async function setDefaultMobileNumberForUser(instanceUrl, username, password) {
	const connection = new jsforce.Connection({
		loginUrl: instanceUrl,
	});

	await connection.login(username, password);
	const users = await connection.query(`SELECT Id, MobilePhone FROM User WHERE Username = '${username}'`);
	for (let i = 0; i < users.records.length; i++) {
		const user = users.records[i];
		user.MobilePhone = '+1 9165551212';
	}

	await connection.sobject('User').update(users.records);
}
