public class Error {
	public ExtendedErrorDetails[] extendedErrorDetails;
	public String[] fields;
	public String message;
	public String statusCode;
	private String[] extendedErrorDetails_type_info = new List<String>{
		'extendedErrorDetails',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'-1',
		'false'
	};
	private String[] fields_type_info = new List<String>{
		'fields',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'-1',
		'false'
	};
	private String[] message_type_info = new List<String>{
		'message',
		SoapConstants.SOAP_M_URI,
		null,
		'1',
		'1',
		'false'
	};
	private String[] statusCode_type_info = new List<String>{
		'statusCode',
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
		'extendedErrorDetails',
		'fields',
		'message',
		'statusCode'
	};
}
