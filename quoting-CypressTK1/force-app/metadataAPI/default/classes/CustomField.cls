public class CustomField extends Metadata {
	public String type = 'CustomField';
	public String fullName;
	private String[] fullName_type_info = new List<String>{
		'fullName',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	public String businessOwnerGroup;
	public String businessOwnerUser;
	public String businessStatus;
	public Boolean caseSensitive;
	public String customDataType;
	public String defaultValue;
	public String deleteConstraint;
	public Boolean deprecated;
	public String description;
	public String displayFormat;
	public Boolean displayLocationInDecimal;
	public Boolean encrypted;
	public Boolean escapeMarkup;
	public String externalDeveloperName;
	public Boolean externalId;
	public String fieldManageability;
	public String formula;
	public String formulaTreatBlanksAs;
	public String inlineHelpText;
	public Boolean isConvertLeadDisabled;
	public Boolean isFilteringDisabled;
	public Boolean isNameField;
	public Boolean isSortingDisabled;
	public String label;
	public Integer length;
	public LookupFilter lookupFilter;
	public String maskChar;
	public String maskType;
	public String metadataRelationshipControllingField;
	public Boolean populateExistingRows;
	public Integer precision;
	public String referenceTargetField;
	public String referenceTo;
	public String relationshipLabel;
	public String relationshipName;
	public Integer relationshipOrder;
	public Boolean reparentableMasterDetail;
	public Boolean required;
	public Boolean restrictedAdminField;
	public Integer scale;
	public String securityClassification;
	public Integer startingNumber;
	public Boolean stripMarkup;
	public String summarizedField;
	public FilterItem[] summaryFilterItems;
	public String summaryForeignKey;
	public String summaryOperation;
	public Boolean trackFeedHistory;
	public Boolean trackHistory;
	public Boolean trackTrending;
	public String type_x;
	public Boolean unique;
	public ValueSet valueSet;
	public Integer visibleLines;
	public Boolean writeRequiresMasterRead;
	private String[] businessOwnerGroup_type_info = new List<String>{
		'businessOwnerGroup',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] businessOwnerUser_type_info = new List<String>{
		'businessOwnerUser',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] businessStatus_type_info = new List<String>{
		'businessStatus',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] caseSensitive_type_info = new List<String>{
		'caseSensitive',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] customDataType_type_info = new List<String>{
		'customDataType',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] defaultValue_type_info = new List<String>{
		'defaultValue',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] deleteConstraint_type_info = new List<String>{
		'deleteConstraint',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] deprecated_type_info = new List<String>{
		'deprecated',
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
	private String[] displayFormat_type_info = new List<String>{
		'displayFormat',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] displayLocationInDecimal_type_info = new List<String>{
		'displayLocationInDecimal',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] encrypted_type_info = new List<String>{
		'encrypted',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] escapeMarkup_type_info = new List<String>{
		'escapeMarkup',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] externalDeveloperName_type_info = new List<String>{
		'externalDeveloperName',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] externalId_type_info = new List<String>{
		'externalId',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] fieldManageability_type_info = new List<String>{
		'fieldManageability',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] formula_type_info = new List<String>{
		'formula',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] formulaTreatBlanksAs_type_info = new List<String>{
		'formulaTreatBlanksAs',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] inlineHelpText_type_info = new List<String>{
		'inlineHelpText',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] isConvertLeadDisabled_type_info = new List<String>{
		'isConvertLeadDisabled',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] isFilteringDisabled_type_info = new List<String>{
		'isFilteringDisabled',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] isNameField_type_info = new List<String>{
		'isNameField',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] isSortingDisabled_type_info = new List<String>{
		'isSortingDisabled',
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
	private String[] length_type_info = new List<String>{
		'length',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] lookupFilter_type_info = new List<String>{
		'lookupFilter',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] maskChar_type_info = new List<String>{
		'maskChar',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] maskType_type_info = new List<String>{
		'maskType',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] metadataRelationshipControllingField_type_info = new List<String>{
		'metadataRelationshipControllingField',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] populateExistingRows_type_info = new List<String>{
		'populateExistingRows',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] precision_type_info = new List<String>{
		'precision',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] referenceTargetField_type_info = new List<String>{
		'referenceTargetField',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] referenceTo_type_info = new List<String>{
		'referenceTo',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] relationshipLabel_type_info = new List<String>{
		'relationshipLabel',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] relationshipName_type_info = new List<String>{
		'relationshipName',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] relationshipOrder_type_info = new List<String>{
		'relationshipOrder',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] reparentableMasterDetail_type_info = new List<String>{
		'reparentableMasterDetail',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] required_type_info = new List<String>{
		'required',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] restrictedAdminField_type_info = new List<String>{
		'restrictedAdminField',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] scale_type_info = new List<String>{
		'scale',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] securityClassification_type_info = new List<String>{
		'securityClassification',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] startingNumber_type_info = new List<String>{
		'startingNumber',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] stripMarkup_type_info = new List<String>{
		'stripMarkup',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] summarizedField_type_info = new List<String>{
		'summarizedField',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] summaryFilterItems_type_info = new List<String>{
		'summaryFilterItems',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'-1',
		'false'
	};
	private String[] summaryForeignKey_type_info = new List<String>{
		'summaryForeignKey',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] summaryOperation_type_info = new List<String>{
		'summaryOperation',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] trackFeedHistory_type_info = new List<String>{
		'trackFeedHistory',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] trackHistory_type_info = new List<String>{
		'trackHistory',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] trackTrending_type_info = new List<String>{
		'trackTrending',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] type_x_type_info = new List<String>{
		'type',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] unique_type_info = new List<String>{
		'unique',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] valueSet_type_info = new List<String>{
		'valueSet',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] visibleLines_type_info = new List<String>{
		'visibleLines',
		SoapConstants.SOAP_M_URI,
		null,
		'0',
		'1',
		'false'
	};
	private String[] writeRequiresMasterRead_type_info = new List<String>{
		'writeRequiresMasterRead',
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
	private String[] type_att_info = new List<String>{ 'xsi:type' };
	private String[] field_order_type_info = new List<String>{
		'fullName',
		'businessOwnerGroup',
		'businessOwnerUser',
		'businessStatus',
		'caseSensitive',
		'customDataType',
		'defaultValue',
		'deleteConstraint',
		'deprecated',
		'description',
		'displayFormat',
		'displayLocationInDecimal',
		'encrypted',
		'escapeMarkup',
		'externalDeveloperName',
		'externalId',
		'fieldManageability',
		'formula',
		'formulaTreatBlanksAs',
		'inlineHelpText',
		'isConvertLeadDisabled',
		'isFilteringDisabled',
		'isNameField',
		'isSortingDisabled',
		'label',
		'length',
		'lookupFilter',
		'maskChar',
		'maskType',
		'metadataRelationshipControllingField',
		'populateExistingRows',
		'precision',
		'referenceTargetField',
		'referenceTo',
		'relationshipLabel',
		'relationshipName',
		'relationshipOrder',
		'reparentableMasterDetail',
		'required',
		'restrictedAdminField',
		'scale',
		'securityClassification',
		'startingNumber',
		'stripMarkup',
		'summarizedField',
		'summaryFilterItems',
		'summaryForeignKey',
		'summaryOperation',
		'trackFeedHistory',
		'trackHistory',
		'trackTrending',
		'type_x',
		'unique',
		'valueSet',
		'visibleLines',
		'writeRequiresMasterRead'
	};
}
