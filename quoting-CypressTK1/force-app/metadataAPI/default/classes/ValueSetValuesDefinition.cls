public class ValueSetValuesDefinition {
	public Boolean sorted;
	public CustomValue[] value;
	private String[] sorted_type_info = new List<String>{
		'sorted',
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
		'-1',
		'false'
	};
	private String[] apex_schema_type_info = new List<String>{
		SoapConstants.SOAP_M_URI,
		'true',
		'false'
	};
	private String[] field_order_type_info = new List<String>{ 'sorted', 'value' };
}
