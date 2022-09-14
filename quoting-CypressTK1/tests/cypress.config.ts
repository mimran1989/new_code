import * as webpackProcessor from '@cypress/webpack-preprocessor';
import { defineConfig } from 'cypress';
import { addCucumberPreprocessorPlugin } from '@badeball/cypress-cucumber-preprocessor';
import fs from 'fs';
import pathResolver from 'path';
import {
	assignPermissionSets, deleteSObjects, describeSObject, insertSObjects, loginToSfdc, turnOffAllAvailableFeatures, turnOnFeatures,
} from './support/jsForce';
import getCypressWebpackConfig from './webpack.config.cypress';

async function setupNodeEvents(
	on: Cypress.PluginEvents,
	config: Cypress.PluginConfigOptions,
): Promise<Cypress.PluginConfigOptions> {
	await addCucumberPreprocessorPlugin(on, config);

	on('file:preprocessor', webpackProcessor.default(getCypressWebpackConfig(config)));
	on('task', { assignPermissionSets });
	on('task', { deleteSObjects });
	on('task', { describeSObject });
	on('task', { insertSObjects });
	on('task', { loginToSfdc });
	on('task', { turnOffAllAvailableFeatures });
	on('task', { turnOnFeatures });

	// Make sure to return the config object as it might have been modified by the plugin.
	return config;
}

const pathRelativeToRoot = pathResolver.resolve(__dirname, 'keys.json');
const keys = JSON.parse(fs.readFileSync(pathRelativeToRoot, 'utf-8'));

export default defineConfig({
	e2e: {
		specPattern: '**/*.feature',
		supportFile: false,
		setupNodeEvents,
		env: {
			keys,
		},
		experimentalSessionAndOrigin: true,
		includeShadowDom: true,
		pageLoadTimeout: 120000,
	},
});
