/**
 *  Provus Services Quoting
 *  QuoteService
 *  @2021-2022 Provus Inc. All rights reserved.
 */
public with sharing class QuoteService {
	// constants
	public static final String RECORDTYPE_NAME_COLLABORATION = 'Collaboration';
	public static final String RECORDTYPE_NAME_QUOTE = 'Quote';
	public static final String RECORDTYPE_NAME_SCENARIO = 'Scenario';
	public static final String RECORDTYPE_NAME_TEMPLATE = 'Template';

	public static final String STATUS_ACTIVE = 'Active';
	public static final String STATUS_INACTIVE = 'Inactive';
	public static final String STATUS_APPROVED = 'Approved';
	public static final String STATUS_REJECTED = 'Rejected';

	public static final String TIMEPERIODSALIGNMENT_USER_DEFINED = 'User Defined Calendar';
	public static final String TIMEPERIODSALIGNMENT_WEEKDAY_CALENDAR = 'Weekday Calendar';

	public static final String LABORUNITS_HEADCOUNT = 'Headcount';
	public static final String LABORUNITS_HOURS = 'Hours';

	public static final String TYPE_QUOTE = 'Quote';
	public static final String TYPE_SCENARIO = 'Scenario';

	// runtime context
	public Quote__c quoteSO;
	public Id rateCardId;
	public String quotePractice;
	public String quoteGroup;
	public Boolean isScenarioPricePending;
	public Boolean hasAddOns;
	public String currencyCode;
	public Decimal currencyConversionRatio;

	// constructor
	public QuoteService(Id quoteId) {
		Id addOnRecordTypeId = Schema.SObjectType.Product__c.getRecordTypeInfosByDeveloperName()
			.get(ProductService.RECORDTYPE_NAME_ANCILLARY)
			.getRecordTypeId();

		QueryRequest queryQuoteItems = new QueryRequest(
			SystemUtility.getInverseRName(Schema.Quote__c.SObjectType, Schema.QuoteItem__c.SObjectType)
		);
		queryQuoteItems.requestedFields = new Set<String>{ SObjectUtility.FIELD_ID };

		queryQuoteItems.setFilterBy(
			new Map<String, String>{
				SystemUtility.getChildRName(
					Schema.QuoteItem__c.ProductId__c,
					Schema.Product__c.RecordtypeId
				) => addOnRecordTypeId
			}
		);

		QueryRequest queryRequest = new QueryRequest(Quote__c.SObjectType);
		Set<String> requestedFields = new Set<String>{
			SObjectUtility.FIELD_ID,
			Schema.Quote__c.CurrencyConversionRatio__c + '',
			Schema.Quote__c.EstimateId__c + '',
			Schema.Quote__c.Group__c + '',
			Schema.Quote__c.LaborUnits__c + '',
			Schema.Quote__c.MarginPercent__c + '',
			Schema.Quote__c.Practice__c + '',
			Schema.Quote__c.RateCardId__c + '',
			Schema.Quote__c.SectionHierarchy__c + '',
			Schema.Quote__c.TimePeriod__c + '',
			Schema.Quote__c.TimePeriodsGroupMethod__c + '',
			Schema.Quote__c.TotalAmount__c + '',
			Schema.Quote__c.Type__c + '',
			SystemUtility.getChildRName(
				Schema.Quote__c.EstimateId__c,
				Schema.Estimate__c.IsSyncChangesToQuote__c
			)
		};

		if (MultiCurrencyService.isMultiCurrencyEnabled()) {
			requestedFields.add(MultiCurrencyService.CURRENCY_ISO_CODE);
		}

		queryRequest.requestedFields = requestedFields;
		queryRequest.setFilterBy(new Map<String, String>{ SObjectUtility.FIELD_ID => quoteId });
		queryRequest.innerQueries = new List<QueryRequest>{ queryQuoteItems };
		List<Quote__c> quotes = (List<Quote__c>) SOQLUtility.querySObject(queryRequest);
		quoteSO = quotes[0];

		currencyConversionRatio = quoteSO.CurrencyConversionRatio__c;
		if (MultiCurrencyService.isMultiCurrencyEnabled()) {
			currencyCode = (String) quoteSO.get(MultiCurrencyService.CURRENCY_ISO_CODE);
		}
		rateCardId = quoteSO.RateCardId__c;
		quotePractice = quoteSO.Practice__c;
		quoteGroup = quoteSO.Group__c;
		isScenarioPricePending = RECORDTYPE_NAME_SCENARIO == quoteSO.Type__c;
		hasAddOns = quoteSO.QuoteItems__r.size() > 0;
	}

	public static void setupNewQuotes(Map<Id, Quote__c> quotes) {
		List<Quote__c> newQuotes = quotes.values();

		QuoteTemplateService.applyQuoteTemplateAfter(newQuotes); // clone template entities into the context quote
		List<Id> orphanQuoteIds = new List<Id>(); // this is quotes which are not derived from another quote
		for (Quote__c quote : quotes.values()) {
			if (quote.DerivedFromId__c == null) {
				orphanQuoteIds.add(quote.Id);
			}
		}
		QuoteTotalsService.createQuoteLevelTotalsFor(orphanQuoteIds);
		ColaRateService.copyGlobalColaRatesToQuotes(new Set<Id>(orphanQuoteIds));
		// create quote periods
		QuotePeriodService.createPeriodsAndPeriodGroupsFor(newQuotes);
	}
}
