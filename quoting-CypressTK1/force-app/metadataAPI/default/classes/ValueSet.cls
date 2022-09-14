public class ValueSet {
	public String controllingField;
	public Boolean restricted;
	public ValueSetValuesDefinition valueSetDefinition;
	public String valueSetName;
	public ValueSettings[] valueSettings;
	private String[] controllingField_type_info = new List<String>{
		'controllingField',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] restricted_type_info = new List<String>{
		'restricted',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] valueSetDefinition_type_info = new List<String>{
		'valueSetDefinition',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] valueSetName_type_info = new List<String>{
		'valueSetName',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] valueSettings_type_info = new List<String>{
		'valueSettings',
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
	private String[] field_order_type_info = new List<String>{
		'controllingField',
		'restricted',
		'valueSetDefinition',
		'valueSetName',
		'valueSettings'
	};
}
