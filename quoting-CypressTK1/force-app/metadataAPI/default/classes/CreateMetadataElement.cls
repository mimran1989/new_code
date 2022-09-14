public class CreateMetadataElement {
	public Metadata[] metadata;
	private String[] metadata_type_info = new List<String>{
		'metadata',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'-1',
		'false'
	};
	private String[] apex_schema_type_info = new List<String>{
		SoapConstants.SOAP_M_URI,
		'true',
		'false'
	};
	private String[] field_order_type_info = new List<String>{ 'metadata' };
}
