public class DebuggingInfoElement {
	public String debugLog;
	private String[] debugLog_type_info = new List<String>{
		'debugLog',
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
	private String[] field_order_type_info = new List<String>{ 'debugLog' };
}
