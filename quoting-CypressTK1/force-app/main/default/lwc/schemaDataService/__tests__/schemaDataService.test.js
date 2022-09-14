import SchemaDataService from '../schemaDataService';

const mockDescFn = jest.fn(() => 'Description__c');

// mock SF schema description field with and without namespace
jest.mock(
	'@salesforce/schema/Quote__c.Description__c',
	() => ({
		default: {
			get fieldApiName() {
				return mockDescFn();
			},
		},
	}),
	{ virtual: true },
);

describe('SchemaDataService', () => {
	describe('stripCustomFieldNamePrefixAndNamespace', () => {
		it('Custom field name with namespace removes namespace and custom field suffix', async() => {
			const result = SchemaDataService.stripCustomFieldNamePrefixAndNamespace('PSQ__CustomField__c', 'PSQ__');

			expect(result).toEqual('CustomField');
		});

		it('Custom field name with no namespace removes custom field suffix', async() => {
			const result = SchemaDataService.stripCustomFieldNamePrefixAndNamespace('CustomField__c', '');

			expect(result).toEqual('CustomField');
		});

		it('Custom field name without namespace removes custom field suffix', async() => {
			const result = SchemaDataService.stripCustomFieldNamePrefixAndNamespace('CustomField__c', '');

			expect(result).toEqual('CustomField');
		});

		it('custom field name with namespace from other package with namespace removes custom field suffix', async() => {
			const result = SchemaDataService.stripCustomFieldNamePrefixAndNamespace('OtherNs__CustomField__c', '');

			expect(result).toEqual('OtherNs__CustomField');
		});

		it('custom field name with namespace from other package with namespace removes custom field suffix and replaces with Provus namespace', async() => {
			const result = SchemaDataService.stripCustomFieldNamePrefixAndNamespace('OtherNs__CustomField__c', 'PSQ__');

			expect(result).toEqual('OtherNs__CustomField');
		});
	});

	describe('stripSfCustomFieldSyntax', () => {
		const componentInstanceWithNamespace = {};
		// describe('when Sf field has namespace', () => {
		// 	it('expect namespace prefix and custom suffix removed', async() => {
		// 		mockDescFn.mockReturnValue('PSQ__Description__c');
		// 		const schemaDataService = new SchemaDataService(componentInstanceWithNamespace);
		//
		// 		const fields = schemaDataService.stripSfCustomFieldSyntax({
		// 			PSQ__Term__c: true,
		// 		});
		//
		// 		expect(fields.Term).toEqual(true);
		// 	});
		// });

		describe('when Sf field name has no namespace', () => {
			it('component instance and field no namespace only custom suffix is removed', async() => {
				const schemaDataService = new SchemaDataService(componentInstanceWithNamespace);

				const fields = schemaDataService.stripSfCustomFieldSyntax({
					Term__c: true,
				});

				expect(fields.Term).toEqual(true);
			});

			it('component instance without namespace field name with other package namespace field name remains unchanged', async() => {
				const schemaDataService = new SchemaDataService(componentInstanceWithNamespace);

				const fields = schemaDataService.stripSfCustomFieldSyntax({
					OtherNs__Term__c: true,
				});

				expect(fields.OtherNs__Term).toEqual(true);
			});
		});
	});
});
