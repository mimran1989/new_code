public class MetadataPort {
	public String endpoint_x = URL.getOrgDomainUrl().toExternalForm() + '/services/Soap/m/42.0';
	public Map<String, String> inputHttpHeaders_x;
	public Map<String, String> outputHttpHeaders_x;
	public String clientCertName_x;
	public String clientCert_x;
	public String clientCertPasswd_x;
	public Integer timeout_x;
	public SessionHeaderElement SessionHeader;
	public DebuggingInfoElement DebuggingInfo;
	public DebuggingHeaderElement DebuggingHeader;
	public CallOptionsElement CallOptions;
	public AllOrNoneHeaderElement AllOrNoneHeader;
	private String SessionHeader_hns = 'SessionHeader=http://soap.sforce.com/2006/04/metadata';
	private String DebuggingInfo_hns = 'DebuggingInfo=http://soap.sforce.com/2006/04/metadata';
	private String DebuggingHeader_hns = 'DebuggingHeader=http://soap.sforce.com/2006/04/metadata';
	private String CallOptions_hns = 'CallOptions=http://soap.sforce.com/2006/04/metadata';
	private String AllOrNoneHeader_hns = 'AllOrNoneHeader=http://soap.sforce.com/2006/04/metadata';
	private String[] ns_map_type_info = new List<String>{
		SoapConstants.SOAP_M_URI,
		'MetadataService'
	};
	public DeleteResult[] deleteMetadata(String type_x, String[] fullNames) {
		DeleteMetadataElement request_x = new DeleteMetadataElement();
		request_x.type_x = type_x;
		request_x.fullNames = fullNames;
		DeleteMetadataResponseElement response_x;
		Map<String, DeleteMetadataResponseElement> response_map_x = new Map<String, DeleteMetadataResponseElement>();
		response_map_x.put('response_x', response_x);
		WebServiceCallout.invoke(
			this,
			request_x,
			response_map_x,
			new List<String>{
				endpoint_x,
				'',
				SoapConstants.SOAP_M_URI,
				'deleteMetadata',
				SoapConstants.SOAP_M_URI,
				'deleteMetadataResponse',
				'DeleteMetadataResponseElement'
			}
		);
		response_x = response_map_x.get('response_x');
		return response_x.result;
	}
	public SaveResult renameMetadata(String type_x, String oldFullName, String newFullName) {
		RenameMetadataElement request_x = new RenameMetadataElement();
		request_x.type_x = type_x;
		request_x.oldFullName = oldFullName;
		request_x.newFullName = newFullName;
		RenameMetadataResponseElement response_x;
		Map<String, RenameMetadataResponseElement> response_map_x = new Map<String, RenameMetadataResponseElement>();
		response_map_x.put('response_x', response_x);
		WebServiceCallout.invoke(
			this,
			request_x,
			response_map_x,
			new List<String>{
				endpoint_x,
				'',
				SoapConstants.SOAP_M_URI,
				'renameMetadata',
				SoapConstants.SOAP_M_URI,
				'renameMetadataResponse',
				'RenameMetadataResponseElement'
			}
		);
		response_x = response_map_x.get('response_x');
		return response_x.result;
	}
	public SaveResult[] updateMetadata(Metadata[] metadata) {
		UpdateMetadataElement request_x = new UpdateMetadataElement();
		request_x.metadata = metadata;
		UpdateMetadataResponseElement response_x;
		Map<String, UpdateMetadataResponseElement> response_map_x = new Map<String, UpdateMetadataResponseElement>();
		response_map_x.put('response_x', response_x);
		WebServiceCallout.invoke(
			this,
			request_x,
			response_map_x,
			new List<String>{
				endpoint_x,
				'',
				SoapConstants.SOAP_M_URI,
				'updateMetadata',
				SoapConstants.SOAP_M_URI,
				'updateMetadataResponse',
				'UpdateMetadataResponseElement'
			}
		);
		response_x = response_map_x.get('response_x');
		return response_x.result;
	}

	public SaveResult[] createMetadata(Metadata[] metadata) {
		CreateMetadataElement request_x = new CreateMetadataElement();
		request_x.metadata = metadata;
		CreateMetadataResponseElement response_x;
		Map<String, CreateMetadataResponseElement> response_map_x = new Map<String, CreateMetadataResponseElement>();
		response_map_x.put('response_x', response_x);
		WebServiceCallout.invoke(
			this,
			request_x,
			response_map_x,
			new List<String>{
				endpoint_x,
				'',
				SoapConstants.SOAP_M_URI,
				'createMetadata',
				SoapConstants.SOAP_M_URI,
				'createMetadataResponse',
				'CreateMetadataResponseElement'
			}
		);
		response_x = response_map_x.get('response_x');
		return response_x.result;
	}
	public IReadResult readMetadata(String type_x, String[] fullNames) {
		ReadMetadataElement request_x = new ReadMetadataElement();
		request_x.type_x = type_x;
		request_x.fullNames = fullNames;
		IReadResponseElement response_x;
		Map<String, IReadResponseElement> response_map_x = new Map<String, IReadResponseElement>();
		response_map_x.put('response_x', response_x);
		WebServiceCallout.invoke(
			this,
			request_x,
			response_map_x,
			new List<String>{
				endpoint_x,
				'',
				SoapConstants.SOAP_M_URI,
				'readMetadata',
				SoapConstants.SOAP_M_URI,
				'readMetadataResponse',
				'MetadataService.read' +
				type_x +
				'Response_element'
			}
		);
		response_x = response_map_x.get('response_x');
		return response_x.getResult();
	}
	public UpsertResult[] upsertMetadata(Metadata[] metadata) {
		UpsertMetadataElement request_x = new UpsertMetadataElement();
		request_x.metadata = metadata;
		UpsertMetadataResponseElement response_x;
		Map<String, UpsertMetadataResponseElement> response_map_x = new Map<String, UpsertMetadataResponseElement>();
		response_map_x.put('response_x', response_x);
		WebServiceCallout.invoke(
			this,
			request_x,
			response_map_x,
			new List<String>{
				endpoint_x,
				'',
				SoapConstants.SOAP_M_URI,
				'upsertMetadata',
				SoapConstants.SOAP_M_URI,
				'upsertMetadataResponse',
				'UpsertMetadataResponseElement'
			}
		);
		response_x = response_map_x.get('response_x');
		return response_x.result;
	}
}
