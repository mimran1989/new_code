public class RenameMetadataElement {
	public String type_x;
	public String oldFullName;
	public String newFullName;
	private String[] type_x_type_info = new List<String>{
		'type',
		SoapConstants.SOAP_M_URI,
		null,
		'1',
		'1',
		'false'
	};
	private String[] oldFullName_type_info = new List<String>{
		'oldFullName',
		SoapConstants.SOAP_M_URI,
		null,
		'1',
		'1',
		'false'
	};
	private String[] newFullName_type_info = new List<String>{
		'newFullName',
		SoapConstants.SOAP_M_URI,
		null,
		'1',
		'1',
		'false'
	};
	private String[] apex_schema_type_info = new List<String>{
		SoapConstants.SOAP_M_URI,
		'true',
		'false'
	};
	private String[] field_order_type_info = new List<String>{
		'type_x',
		'oldFullName',
		'newFullName'
	};
}
