public class ReadMetadataElement {
	public String type_x;
	public String[] fullNames;
	private String[] type_x_type_info = new List<String>{
		'type',
		SoapConstants.SOAP_M_URI,
		null,
		'1',
		'1',
		'false'
	};
	private String[] fullNames_type_info = new List<String>{
		'fullNames',
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
	private String[] field_order_type_info = new List<String>{ 'type_x', 'fullNames' };
}
