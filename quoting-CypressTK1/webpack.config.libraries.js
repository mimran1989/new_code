const path = require('path');

module.exports = {
	entry: {
		HyperFormula: './external-libraries/hyperformula.js',
	},
	output: {
		filename: '[name]/[name].js',
		path: path.resolve(__dirname, 'force-app/main/default/staticresources'),
	},
};
