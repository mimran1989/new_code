const http = require('https');
const Deferred = require('deferred');
const yargs = require('yargs');

const { argv } = yargs
	.option('prNumber', {
		alias: 'n',
		description: 'pull request number',
		type: 'string',
	})
	.help()
	.alias('help', 'h');

async function enableAutoMerge() {
	const { prNumber } = argv;
	const prId = await getPRId(prNumber);
	await enableAutoMergeForPR(prId);
}

async function getPRId(prNumber) {
	const query = {
		query: `query { repository(name: "quoting", owner: "provusinc") { pullRequest(number: ${prNumber}) { id }}}`,
	};

	const deferred = new Deferred();
	executeQuery(query, (response) => {
		response.on('data', (chunk) => {
			const responseObj = JSON.parse(chunk);
			const { id } = responseObj.data.repository.pullRequest;
			deferred.resolve(id);
		});
		return deferred.promise;
	});
}

function enableAutoMergeForPR(prId) {
	const mutationQuery = {
		query: `mutation { enablePullRequestAutoMerge(input: {mergeMethod: SQUASH, pullRequestId: "${prId}"}) { clientMutationId }}`,
	};

	const deferred = new Deferred();
	executeQuery(mutationQuery, (res) => res.on('data', deferred.resolve));
	return deferred.promise;
}

function executeQuery(graphQLQuery, callBack) {
	const options = {
		host: 'api.github.com',
		method: 'POST',
		path: '/graphql',
		headers: {
			Authorization: `bearer ${process.env.GITHUB_TOKEN}`,
			'user-agent': 'node.js',
		},
	};

	const req = http.request(options, callBack);
	req.write(JSON.stringify(graphQLQuery));
	req.end();
}

enableAutoMerge();
