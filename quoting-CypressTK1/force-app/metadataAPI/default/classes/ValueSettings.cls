public class ValueSettings {
	public String[] controllingFieldValue;
	public String valueName;
	private String[] controllingFieldValue_type_info = new List<String>{
		'controllingFieldValue',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'-1',
		'false'
	};
	private String[] valueName_type_info = new List<String>{
		'valueName',
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
	private String[] field_order_type_info = new List<String>{ 'controllingFieldValue', 'valueName' };
}
