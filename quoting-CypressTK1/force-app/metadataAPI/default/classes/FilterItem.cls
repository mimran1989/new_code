public class FilterItem {
	public String field;
	public String operation;
	public String value;
	public String valueField;
	private String[] field_type_info = new List<String>{
		'field',
		SoapConstants.SOAP_M_URI,
		null,
		'1',
		'1',
		'false'
	};
	private String[] operation_type_info = new List<String>{
		'operation',
		SoapConstants.SOAP_M_URI,
		null,
		'1',
		'1',
		'false'
	};
	private String[] value_type_info = new List<String>{
		'value',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] valueField_type_info = new List<String>{
		'valueField',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] apex_schema_type_info = new List<String>{
		SoapConstants.SOAP_M_URI,
		'true',
		'false'
	};
	private String[] field_order_type_info = new List<String>{
		'field',
		'operation',
		'value',
		'valueField'
	};
}
