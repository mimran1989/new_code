public virtual class CustomValue extends Metadata {
	public String type = 'CustomValue';
	public String fullName;
	private String[] fullName_type_info = new List<String>{
		'fullName',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	public String color;
	public Boolean default_x;
	public String description;
	public Boolean isActive;
	public String label;
	private String[] color_type_info = new List<String>{
		'color',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] default_x_type_info = new List<String>{
		'default',
		SoapConstants.SOAP_M_URI,
		null,
		'1',
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
	private String[] isActive_type_info = new List<String>{
		'isActive',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] label_type_info = new List<String>{
		'label',
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
		'fullName',
		'color',
		'default_x',
		'description',
		'isActive',
		'label'
	};
}
