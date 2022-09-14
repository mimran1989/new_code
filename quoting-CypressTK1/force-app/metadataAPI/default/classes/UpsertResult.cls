public class UpsertResult {
	public Boolean created;
	public Error[] errors;
	public String fullName;
	public Boolean success;
	private String[] created_type_info = new List<String>{
		'created',
		SoapConstants.SOAP_M_URI,
		null,
		'1',
		'1',
		'false'
	};
	private String[] errors_type_info = new List<String>{
		'errors',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'-1',
		'false'
	};
	private String[] fullName_type_info = new List<String>{
		'fullName',
		SoapConstants.SOAP_M_URI,
		null,
		'1',
		'1',
		'false'
	};
	private String[] success_type_info = new List<String>{
		'success',
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
		'created',
		'errors',
		'fullName',
		'success'
	};
}
