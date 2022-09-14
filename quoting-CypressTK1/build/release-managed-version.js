/* eslint-disable import/no-extraneous-dependencies */
const fs = require('fs-extra');
const yargs = require('yargs');
const util = require('util');
const exec = util.promisify(require('child_process').exec);
const replaceInFiles = require('replace-in-files');

const { argv } = yargs
	.option('type', {
		alias: 't',
		description: 'semvar release type',
		type: 'string',
	})
	.option('nextVersion', {
		alias: 'v',
		description: 'next release version',
		type: 'string',
	})
	.option('channel', {
		alias: 'c',
		description: 'release channel',
		type: 'string',
	})
	.help()
	.alias('help', 'h');

releaseNewVersion();

// eslint-disable-next-line max-lines-per-function
async function releaseNewVersion() {
	const { type, nextVersion } = argv;
	let { channel } = argv;
	const projectDetails = JSON.parse(fs.readFileSync('../sfdx-project.json', 'utf8'));
	if (!channel) {
		channel = 'latest';
	}

	const packageInfo = projectDetails.packageDirectories.filter((package) => package.branch === channel)[0];
	const { versionNumber, package: packageName } = packageInfo;
	const calculatedNextVersion = calculateNextVersion(type, versionNumber);
	let requestedReleaseVersion = nextVersion;
	// for beta branches always use the calculated next version
	if (channel !== 'latest') {
		requestedReleaseVersion = calculatedNextVersion;
	}

	if (calculatedNextVersion !== requestedReleaseVersion) {
		console.warn('The calculated next version does not match the semantic version');
		console.warn('Calculated: ', calculatedNextVersion, ' semantic-next: ', requestedReleaseVersion);
		throw new Error(
			`The calculated next version does not match the semantic version.
			Calculated: : ${calculatedNextVersion}, semantic-next: ${requestedReleaseVersion}`,
		);
	}

	packageInfo.ancestorVersion = getAncestorVersion(versionNumber);
	packageInfo.versionNumber = `${requestedReleaseVersion}.NEXT`;
	fs.writeFileSync('../sfdx-project.json', JSON.stringify(projectDetails, null, 4));

	// write sfdx package
	try {
		await generateAndPromoteNewVersion(packageName);
	} catch (exception) {
		if (exception.stderr) {
			console.error(exception.stderr);
		} else {
			console.error(exception);
		}

		process.exit(1);
	}
}

function calculateNextVersion(type, currentVersion) {
	const [major, minor, patch] = currentVersion.split('.');
	let calculatedNextVersion;
	if (type === 'minor') {
		calculatedNextVersion = `${major}.${parseInt(minor, 10) + 1}.0`;
	} else if (type === 'patch') {
		calculatedNextVersion = `${major}.${minor}.${parseInt(patch, 10) + 1}`;
	} else {
		throw new Error('Updating the major release requires manual approval.');
	}

	return calculatedNextVersion;
}

function getAncestorVersion(currentVersion) {
	const [major, minor] = currentVersion.split('.');
	return `${major}.${minor}.0`;
}

async function generateAndPromoteNewVersion(packageName) {
	try {
		await exec('npx sfdx force:auth:sfdxurl:store -f token.txt -d -a package-hub --json');

		console.log('Generating new package version...');

		// make all feature custom permissions protected in the managed package
		const options = {
			files: '../force-app/featureFlags/**/customPermissions/**',
			from: /<protected>false/g,
			to: '<protected>true',
		};

		await replaceInFiles(options);
		await exec(`cd ..;npx sfdx force:package:version:create -p "${packageName}" -k installprovus -v package-hub -c -w 60`);

		console.log('Promoting new package version...');
		await exec(`cd ..; latestVersion=$(npx sfdx force:package:version:list -v package-hub -p "${packageName}" -o `
			+ 'CreatedDate --concise | tail -1 | awk \'{print $3}\'); npx sfdx force:package:version:promote -p $latestVersion -n -v package-hub --json');
	} catch (e) {
		console.warn(e.stdout);
		console.warn(e.stderr);
		process.exit(1);
	}
}
