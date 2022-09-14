const baseCypressWebpackConfig = {
	webpackOptions: {
		resolve: {
			extensions: ['.ts', '.js'],
		},
		module: {
			rules: [
				{
					test: /\.ts$/,
					exclude: [/node_modules/],
					use: [
						{
							loader: 'ts-loader',
							options: { configFile: 'tsconfig.json' },
						},
					],
				},
				{
					test: /\.feature$/,
					use: [
						{
							loader: '@badeball/cypress-cucumber-preprocessor/webpack',
							options: {}, // ADDED by webpack config builder fn
						},
					],
				},
			],
		},
	},
};

export default (cypressConfig) => {
	const baseConfig = { ...baseCypressWebpackConfig };
	baseConfig.webpackOptions.module.rules[1].use[0].options = cypressConfig;
	return baseConfig;
};
