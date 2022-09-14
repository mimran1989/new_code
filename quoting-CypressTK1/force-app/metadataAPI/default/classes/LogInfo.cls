public class LogInfo {
	public String category;
	public String level;
	private String[] category_type_info = new List<String>{
		'category',
		SoapConstants.SOAP_M_URI,
		null,
		'1',
		'1',
		'false'
	};
	private String[] level_type_info = new List<String>{
		'level',
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
	private String[] field_order_type_info = new List<String>{ 'category', 'level' };
}
