/**
 *  Provus Services Quoting
 *  schemaDataService
 *  @2022 Provus Inc. All rights reserved.
 */
import ProvusMessagingService from 'c/provusMessagingService';
import { isString, packageNamespace } from 'c/util';

const READONLY_STANDARD_FIELDS = {
	SystemModstamp: true,
};

export default class SchemaDataService {
	provusMessagingService;
	customFieldNsPrefix;
	namespace;

	constructor(lightningComponentInstance) {
		this.provusMessagingService = new ProvusMessagingService(lightningComponentInstance);
		this.namespace = packageNamespace();

		if (isString(this.namespace) && this.namespace.length > 0) {
			this.customFieldNsPrefix = `${this.namespace}__`;
		} else {
			this.customFieldNsPrefix = '';
		}
	}

	/**
	 * Process getObjectInfos
	 * @param data
	 * @param error
	 * @returns {*[]}
	 */
	processObjectSchemaInfoResults({ data, error }) {
		const objectSchemaInfos = [];
		if (error) {
			this.provusMessagingService.handleWireError(error);
		}

		if (data) {
			const hasErrors = this.provusMessagingService.handleObjectInfoResultErrors(data.results);
			if (hasErrors) {
				return objectSchemaInfos;
			}

			data.results.forEach((objectSchemaInfo) => {
				const newObjectSchemaInfoResult = {
					apiName: objectSchemaInfo.result.apiName,
					label: objectSchemaInfo.result.label,
					labelPlural: objectSchemaInfo.result.labelPlural,
					fields: {},
				};

				newObjectSchemaInfoResult.fields = this.stripSfCustomFieldSyntax(objectSchemaInfo.result.fields);
				objectSchemaInfos.push(newObjectSchemaInfoResult);
			});
		}

		return objectSchemaInfos;
	}

	stripSfCustomFieldSyntax(objectSchemaFields) {
		const fieldsObject = {};

		Object.keys(objectSchemaFields).forEach((fieldName) => {
			if (!READONLY_STANDARD_FIELDS[fieldName]) {
				const strippedFieldName = SchemaDataService.stripCustomFieldNamePrefixAndNamespace(fieldName,
					this.customFieldNsPrefix);

				fieldsObject[strippedFieldName] = objectSchemaFields[fieldName];
			}
		});

		return fieldsObject;
	}

	static stripCustomFieldNamePrefixAndNamespace(fieldName, nsPrefix) {
		let newFieldName = fieldName;
		const customFieldSuffixIndex = fieldName.indexOf('__c');
		if (customFieldSuffixIndex > -1) {
			let startNsPrefixPos;
			if (nsPrefix.length > 0) {
				startNsPrefixPos = fieldName.indexOf(nsPrefix);
			}

			// we only want fields that contain our app's namespace and are custom fields
			if (startNsPrefixPos === 0) {
				newFieldName = fieldName.substring(nsPrefix.length, customFieldSuffixIndex);
			} else {
				newFieldName = fieldName.substring(0, customFieldSuffixIndex);
			}
		}

		return newFieldName;
	}

	static buildDataTableColumn(schemaField, options) {
		const baseColumnObj = {
			label: schemaField.label,
			fieldName: schemaField.apiName,
		};

		return Object.assign(baseColumnObj, options);
	}
}
