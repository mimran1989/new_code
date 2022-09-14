public with sharing class RateCardQuoteService {
	public static List<RateCard__c> getRateCardByQuoteId(Id quoteId) {
		return [
			SELECT Id, DerivedFromQuoteId__c
			FROM RateCard__c
			WHERE DerivedFromQuoteId__c = :quoteId
			WITH SECURITY_ENFORCED
		];
	}

	public static RateCard__c createRateCard(RateCardFromQuoteArgs request) {
		Quote__c quote = getQuote(request.quoteId);

		RateCard__c rateCard = new RateCard__c(
			AssignedToAccountId__c = quote.AccountId__c,
			EffectiveDate__c = request.effectiveDate,
			ExpirationDate__c = request.expirationDate,
			DerivedFromQuoteId__c = quote.Id,
			Description__c = quote.Name,
			Name = request.rateCardName,
			IsActive__c = true,
			AttributeGroupId__c = quote.RateCardId__r.AttributeGroupId__c
		);

		CRUDUtility.insertRecords(rateCard);

		return rateCard;
	}

	public static void createRateCardItems(RateCardFromQuoteArgs request, RateCard__c rateCard) {
		List<QuoteItem__c> quoteItems = QuoteItemServiceSupport.getQuoteItems(request.quoteId);

		if (quoteItems.size() == 0) {
			return;
		}

		Map<String, RateCardItem__c> rateCardItemsByProductId = new Map<String, RateCardItem__c>();
		ITimePeriod timePeriodCalc = TimePeriodFactory.newTimePeriod(
			quoteItems[0].QuoteId__r.TimePeriod__c
		);
		String priceUom = timePeriodCalc.getPriceUom();
		for (QuoteItem__c quoteItem : quoteItems) {
			if (!rateCardItemsByProductId.containsKey(quoteItem.RateCardItemId__r.ProductId__c)) {
				RateCardItem__c rateCardItem = new RateCardItem__c(
					IsActive__c = quoteItem.RateCardItemId__r.IsActive__c,
					LocationCity__c = quoteItem.RateCardItemId__r.LocationCity__c,
					LocationCountry__c = quoteItem.RateCardItemId__r.LocationCountry__c,
					LocationDisplayName__c = quoteItem.RateCardItemId__r.LocationDisplayName__c,
					LocationStateProvince__c = quoteItem.RateCardItemId__r.LocationStateProvince__c,
					PriceUOM__c = priceUom,
					ProductId__c = quoteItem.RateCardItemId__r.ProductId__c,
					SkillLevel__c = quoteItem.RateCardItemId__r.SkillLevel__c,
					TimeZone__c = quoteItem.RateCardItemId__r.TimeZone__c,
					UnitCost__c = timePeriodCalc.convertUnitValue(quoteItem.UnitCost__c),
					UnitPrice__c = timePeriodCalc.convertUnitValue(quoteItem.AdjustedUnitPrice__c),
					RateCardId__c = rateCard.Id
				);

				rateCardItemsByProductId.put(rateCardItem.ProductId__c, rateCardItem);
			}
		}

		Map<String, Decimal> quotePrices = getQuotePrices(request.quoteId, request.duplicateStrategy);
		for (String productId : rateCardItemsByProductId.keySet()) {
			rateCardItemsByProductId.get(productId).UnitPrice__c = timePeriodCalc.convertUnitValue(
				quotePrices.get(productId)
			);
		}

		CRUDUtility.insertRecords(rateCardItemsByProductId.values());
	}

	public static Map<String, Decimal> getQuotePrices(Id quoteId, string duplicateStrategy) {
		String operation = 'MAX';
		switch on duplicateStrategy {
			when 'Lowest' {
				operation = 'MIN';
			}
			when 'Average' {
				operation = 'AVG';
			}
			when else {
				operation = 'MAX';
			}
		}

		Map<String, Decimal> quotePrices = new Map<String, Decimal>();
		for (AggregateResult result : getAggregateQuotePrice(quoteId, operation)) {
			quotePrices.put(
				(String) result.get(Schema.QuoteItem__c.ProductId__c + ''),
				(Decimal) result.get('quotePrice')
			);
		}

		return quotePrices;
	}

	public static AggregateResult[] getAggregateQuotePrice(Id quoteId, String operation) {
		String query =
			'SELECT ' +
			Schema.QuoteItem__c.ProductId__c +
			', ' +
			operation +
			'(' +
			Schema.QuoteItem__c.AdjustedUnitPrice__c +
			') quotePrice FROM QuoteItem__c WHERE ' +
			Schema.QuoteItem__c.QuoteId__c +
			' = :quoteId GROUP BY ProductId__c';
		return Database.query(String.escapeSingleQuotes(query));
	}

	public static Quote__c getQuote(Id quoteId) {
		return [
			SELECT
				Id,
				Name,
				ServiceStartDate__c,
				ServiceEndDate__c,
				AccountId__c,
				TimePeriod__c,
				RateCardId__c,
				RateCardId__r.AttributeGroupId__c,
				Practice__c,
				Group__c,
				MarginPercent__c,
				PriceUOM__c,
				ProfitAmount__c,
				QuoteDate__c,
				ServiceId__c,
				TotalAmount__c,
				TotalCost__c
			FROM Quote__c
			WHERE Id = :quoteId
			WITH SECURITY_ENFORCED
		];
	}
}
