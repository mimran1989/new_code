public class DebuggingHeaderElement {
	public LogInfo[] categories;
	public String debugLevel;
	private String[] categories_type_info = new List<String>{
		'categories',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'-1',
		'false'
	};
	private String[] debugLevel_type_info = new List<String>{
		'debugLevel',
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
	private String[] field_order_type_info = new List<String>{ 'categories', 'debugLevel' };
}
