public class LookupFilter {
	public Boolean active;
	public String booleanFilter;
	public String description;
	public String errorMessage;
	public FilterItem[] filterItems;
	public String infoMessage;
	public Boolean isOptional;
	private String[] active_type_info = new List<String>{
		'active',
		SoapConstants.SOAP_M_URI,
		null,
		'1',
		'1',
		'false'
	};
	private String[] booleanFilter_type_info = new List<String>{
		'booleanFilter',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] description_type_info = new List<String>{
		'description',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] errorMessage_type_info = new List<String>{
		'errorMessage',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] filterItems_type_info = new List<String>{
		'filterItems',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'-1',
		'false'
	};
	private String[] infoMessage_type_info = new List<String>{
		'infoMessage',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] isOptional_type_info = new List<String>{
		'isOptional',
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
		'active',
		'booleanFilter',
		'description',
		'errorMessage',
		'filterItems',
		'infoMessage',
		'isOptional'
	};
}
