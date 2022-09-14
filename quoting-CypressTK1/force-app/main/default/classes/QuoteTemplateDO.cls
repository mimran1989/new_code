/**
 *  Provus Services Quoting
 *  @2021 Provus Inc. All rights reserved.
 *
 * Wrapper class which holds quote template which includes:
 * default fields metadata, quote time period and quote period list.
 */
public with sharing class QuoteTemplateDO {
	@AuraEnabled
	public Id rateCardId;
	@AuraEnabled
	public List<QuotePeriod> quotePeriodList;
	@AuraEnabled
	public List<SObjectUtility.SObjectFieldInfo> fieldsList;
	@AuraEnabled
	public String groupName;
	@AuraEnabled
	public String practiceName;
	@AuraEnabled
	public String quoteTimePeriod;
	@AuraEnabled
	public String quoteTimePeriodsGroupMethod;
	@AuraEnabled
	public String recordType;
	@AuraEnabled
	public Boolean hasAddOns = false;
	@AuraEnabled
	public Boolean isScenarioPricePending = false;
	@AuraEnabled
	public Decimal marginPercent;
	@AuraEnabled
	public Decimal totalAmount;
	@AuraEnabled
	public ScheduleSettingDTO scheduleSettings;
	@AuraEnabled
	public String sectionHierarchy;
	@AuraEnabled
	public MultiCurrencyService.CurrencyFields currencyFields;
	@AuraEnabled
	public Id estimateId;
	@AuraEnabled
	public Boolean isEstimateSync;
	@AuraEnabled
	public String laborUnits;

	public QuoteTemplateDO(Quote__c quoteSO, Id rateCardId) {
		this.fieldsList = getFieldMetadata(rateCardId);
		this.hasAddOns = hasAddOns;
		this.isScenarioPricePending = quoteSO.Type__c == QuoteService.RECORDTYPE_NAME_SCENARIO;
		this.marginPercent = quoteSO.MarginPercent__c;
		this.quotePeriodList = QuotePeriodService.getQuotePeriods(quoteSO.Id);
		this.quoteTimePeriod = quoteSO.TimePeriod__c;
		this.quoteTimePeriodsGroupMethod = quoteSO.TimePeriodsGroupMethod__c;
		this.totalAmount = quoteSO.TotalAmount__c;
		this.recordType = quoteSO.Type__c;
		this.scheduleSettings = SettingsService.getScheduleSettingsForQuote(quoteSO.Id);
		this.sectionHierarchy = quoteSO.SectionHierarchy__c;
		this.rateCardId = rateCardId;
		this.groupName = quoteSO.Group__c;
		this.practiceName = quoteSO.Practice__c;
		this.estimateId = quoteSO.EstimateId__c;
		this.isEstimateSync = quoteSO.EstimateId__r?.IsSyncChangesToQuote__c == true;
		this.currencyFields = new MultiCurrencyService.CurrencyFields();
		this.laborUnits = quoteSO.LaborUnits__c;
		if (MultiCurrencyService.isMultiCurrencyEnabled()) {
			this.currencyFields.currencyISOCode = (String) quoteSO.get(
				MultiCurrencyService.CURRENCY_ISO_CODE
			);
		} else {
			this.currencyFields.currencyISOCode = UserInfo.getDefaultCurrency();
		}
		this.currencyFields.currencyConversionRatio = quoteSO.CurrencyConversionRatio__c;
	}

	/**
	 * Gets the list of default fields with their types
	 * @return SObjectUtility.SObjectFieldInfo  wrapper for the fields used on the configurator
	 */
	private List<SObjectUtility.SObjectFieldInfo> getFieldMetadata(Id rateCardId) {
		Map<Schema.SObjectType, Set<String>> fieldsBySObject = new Map<Schema.SObjectType, Set<String>>();
		CustomMetadataService cmService = new CustomMetadataService();

		// add product default fields
		fieldsBySObject.put(Product__c.SObjectType, cmService.getProductDefaultFields());

		// add rate card item default fields
		Set<String> rateCardItemsFieldSet = new Set<String>();
		RateCardService rtService = new RateCardService(rateCardId);
		rateCardItemsFieldSet.addAll(rtService.getAttributes());
		fieldsBySObject.put(RateCardItem__c.SObjectType, rateCardItemsFieldSet);

		// add quote item default fields
		fieldsBySObject.put(QuoteItem__c.SObjectType, cmService.getQuoteItemDefaultFields());

		List<SObjectUtility.SObjectFieldInfo> fieldStructList = SObjectUtility.getSObjectFields(
			fieldsBySObject
		);

		// add sequences
		Map<String, Decimal> sequenceByAttribute = rtService.getAttributesWithSequence();
		for (SObjectUtility.SObjectFieldInfo fldStruct : fieldStructList) {
			if (fldStruct.sourceObject == (Schema.RateCardItem__c.SObjectType + '')) {
				fldStruct.sequence = sequenceByAttribute.get(fldStruct.fieldName);
			}
		}

		return fieldStructList;
	}
}
