import { defineParameterType } from '@badeball/cypress-cucumber-preprocessor';

export default function init() {
	defineParameterType({
		name: 'date',
		regexp: /\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2]\d|3[0-1])/,
		transformer: function transformFunction(dateString: string) {
			return new Date(dateString);
		},
	});
}
