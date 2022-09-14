/**
 * Copyright (c) 2012, FinancialForce.com, inc
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *      this list of conditions and the following disclaimer in the documentation
 *      and/or other materials provided with the distribution.
 * - Neither the name of the FinancialForce.com, inc nor the names of its contributors
 *      may be used to endorse or promote products derived from this software without
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 **/

/**
 * This is a dummy test class to obtain 100% coverage for the generated WSDL2Apex code, it is not a funcitonal test class
 **/
@SuppressWarnings('PMD')
@isTest
private class MetadataServiceTest {
	/**
	 * Dummy Metadata API web service mock class (see MetadataCreateJobTest.cls for a better example)
	 **/
	private class WebServiceMockImpl implements WebServiceMock {
		public void doInvoke(
			Object stub,
			Object request,
			Map<String, Object> response,
			String endpoint,
			String soapAction,
			String requestName,
			String responseNS,
			String responseName,
			String responseType
		) {
			if (request instanceof UpdateMetadataElement) {
				response.put('response_x', new UpdateMetadataResponseElement());
			} else if (request instanceof RenameMetadataElement) {
				response.put('response_x', new RenameMetadataResponseElement());
			} else if (request instanceof DeleteMetadataElement) {
				response.put('response_x', new DeleteMetadataResponseElement());
			} else if (request instanceof UpsertMetadataElement) {
				response.put('response_x', new UpsertMetadataResponseElement());
			} else if (request instanceof CreateMetadataElement) {
				response.put('response_x', new CreateMetadataResponseElement());
			}

			/* the below have not been imported, but are supported */
			// if (request instanceof retrieve_element) {
			// 	response.put('response_x', new RetrieveResponseElement());
			// }
			// } else if (request instanceof checkDeployStatus_element) {
			// 	response.put('response_x', new checkDeployStatusResponse_element());
			// } else if (request instanceof listMetadata_element) {
			// 	response.put('response_x', new listMetadataResponse_element());
			// } else if (request instanceof checkRetrieveStatus_element) {
			// 	response.put('response_x', new checkRetrieveStatusResponse_element());
			// } else if (request instanceof describeMetadata_element) {
			// 	response.put('response_x', new describeMetadataResponse_element());
			// } else if (request instanceof deploy_element) {
			// 	response.put('response_x', new deployResponse_element());
			// } else if (request instanceof cancelDeploy_element) {
			// 	response.put('response_x', new cancelDeployResponse_element());
			// } else if (request instanceof deployRecentValidation_element) {
			// 	response.put('response_x', new deployRecentValidationResponse_element());
			// } else if (request instanceof describeValueType_element) {
			// 	response.put('response_x', new describeValueTypeResponse_element());
			// } else if (request instanceof checkRetrieveStatus_element) {
			// 	response.put('response_x', new checkRetrieveStatusResponse_element());
			return;
		}
	}

	@IsTest
	private static void coverGeneratedCodeCRUDOperations() {
		// Null Web Service mock implementation
		System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
		// Invoke operations
		Test.startTest();
		MetadataPort metaDataPort = new MetadataPort();
		Test.stopTest();
	}

	@IsTest
	private static void coverGeneratedCodeFileBasedOperations1() {
		// Null Web Service mock implementation
		System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
		// Invoke operations
		Test.startTest();
		MetadataPort metaDataPort = new MetadataPort();
		// metaDataPort.retrieve(null);
		// metaDataPort.checkDeployStatus(null, false);
		// metaDataPort.listMetadata(null, null);
		// metaDataPort.describeMetadata(null);
		// metaDataPort.deploy(null, null);
		// metaDataPort.checkDeployStatus(null, false);
		metaDataPort.updateMetadata(null);
		metaDataPort.renameMetadata(null, null, null);
		// metaDataPort.cancelDeploy(null);
		Test.stopTest();
	}

	@IsTest
	private static void coverGeneratedCodeFileBasedOperations2() {
		// Null Web Service mock implementation
		System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
		// Invoke operations
		Test.startTest();
		MetadataPort metaDataPort = new MetadataPort();
		metaDataPort.deleteMetadata(null, null);
		metaDataPort.upsertMetadata(null);
		metaDataPort.createMetadata(null);
		// metaDataPort.deployRecentValidation(null);
		// metaDataPort.describeValueType(null);
		// metaDataPort.checkRetrieveStatus(null, null);
		Test.stopTest();
	}

	@IsTest
	private static void coverGeneratedCodeTypes() {
		// Reference types
		Test.startTest();
		new AllOrNoneHeaderElement();
		new CallOptionsElement();
		new CreateMetadataElement();
		new CreateMetadataResponseElement();
		new CustomField();
		new CustomValue();
		new DebuggingHeaderElement();
		new DebuggingInfoElement();
		new DeleteMetadataElement();
		new DeleteMetadataResponseElement();
		new DeleteResult();
		new Error();
		new ExtendedErrorDetails();
		new FilterItem();
		new LogInfo();
		new LookupFilter();
		new Metadata();
		new MetadataPort();
		new MetadataServiceSuport();
		new MetadataServiceTest();
		new ReadMetadataElement();
		new RenameMetadataElement();
		new RenameMetadataResponseElement();
		new SaveResult();
		new SessionHeaderElement();
		new SessionSettings();
		new UpdateMetadataElement();
		new UpdateMetadataResponseElement();
		new UpsertMetadataElement();
		new UpsertMetadataResponseElement();
		new UpsertResult();
		new ValueSet();
		new ValueSetValuesDefinition();
		new ValueSettings();
		Test.stopTest();
	}
}
