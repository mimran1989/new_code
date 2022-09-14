public with sharing class ImportDatatableController {
	@AuraEnabled(cacheable=true)
	public static List<Map<String, Object>> getColumnDataForImport(Id quoteId) {
		Id rateCardId = [SELECT RateCardId__c FROM Quote__c WHERE Id = :quoteId WITH SECURITY_ENFORCED]
		.RateCardId__c;

		List<String> rateCardAttributesForQuote = RateCardService.getAttributesFor(rateCardId);
		// Add product name as the first column
		String productApiName = ('' + Schema.QuoteItem__c.ProductId__c).replace('__c', '__r.Name');
		rateCardAttributesForQuote.add(0, productApiName);

		return DataTableService.getColumnDataFromCsvList(
			String.join(rateCardAttributesForQuote, ','),
			new QuoteItem__c()
		);
	}

	@AuraEnabled
	public static void importQuoteItems(Id quoteId, Decimal startSequence, List<ImportRow> rows) {
		hydratePricingAndProductInfo(quoteId, rows);

		List<QuoteItem__c> quoteItemsToUpsert = new List<QuoteItem__c>();
		Decimal nextDisplaySequence = startSequence;
		Decimal nextSequence = 1;
		List<QuoteItem__c> existingQuoteItems = [
			SELECT Id, Sequence__c
			FROM QuoteItem__c
			WHERE QuoteId__c = :quoteId
			WITH SECURITY_ENFORCED
			ORDER BY Sequence__c NULLS LAST
		];

		if (!existingQuoteItems.isEmpty()) {
			QuoteItem__c lastQuoteItem = existingQuoteItems[existingQuoteItems.size() - 1];
			if (lastQuoteItem.Sequence__c == null) {
				nextSequence = existingQuoteItems.size() + 1;
			}
		}

		for (ImportRow row : rows) {
			QuoteItem__c quoteItem = row.quoteItem;
			quoteItem.QuoteId__c = quoteId;
			quoteItem.DisplaySequence__c = nextDisplaySequence++;
			quoteItem.Sequence__c = nextSequence++;
			quoteItemsToUpsert.add(quoteItem);
		}

		// re-sequence anything below
		for (QuoteItem__c quoteItem : [
			SELECT Id, DisplaySequence__c
			FROM QuoteItem__c
			WHERE DisplaySequence__c >= :startSequence AND QuoteId__c = :quoteId
			WITH SECURITY_ENFORCED
		]) {
			quoteItem.DisplaySequence__c = nextSequence++;
			quoteItemsToUpsert.add(quoteItem);
		}

		CRUDUtility.upsertRecords(quoteItemsToUpsert);
	}

	private static List<ImportRow> hydratePricingAndProductInfo(Id quoteId, List<ImportRow> rows) {
		Id rateCardId = [SELECT RateCardId__c FROM Quote__c WHERE Id = :quoteId WITH SECURITY_ENFORCED]
		.RateCardId__c;
		Set<String> attributesForRateCard = new Set<String>(
			RateCardService.getAttributesFor(rateCardId)
		);

		Map<String, Set<String>> attributesToValues = new Map<String, Set<String>>{
			SystemUtility.getChildRName(
				Schema.RateCardItem__c.ProductId__c,
				Schema.Product__c.Name
			) => new Set<String>()
		};

		String productNameRField = SystemUtility.getChildRName(
			Schema.RateCardItem__c.ProductId__c,
			Schema.Product__c.Name
		);
		for (ImportRow row : rows) {
			QuoteItem__c quoteItem = row.quoteItem;
			for (String attributeApiName : attributesForRateCard) {
				Set<String> valuesForAttribute = attributesToValues.get(attributeApiName);
				if (valuesForAttribute == null) {
					valuesForAttribute = new Set<String>();
					attributesToValues.put(attributeApiName, valuesForAttribute);
				}

				String itemValue = (String) quoteItem.get(attributeApiName);
				valuesForAttribute.add(itemValue);
			}

			// Add product name
			Set<String> valuesForProductName = attributesToValues.get(productNameRField);
			if (valuesForProductName == null) {
				valuesForProductName = new Set<String>();
				attributesToValues.put(productNameRField, valuesForProductName);
			}
			valuesForProductName.add(row.productName);
		}

		QueryRequest queryRequest = new QueryRequest(RateCardItem__c.SObjectType);
		queryRequest.requestedFields = attributesForRateCard;
		queryRequest.requestedFields.add(Schema.RateCardItem__c.ProductId__c + '');
		queryRequest.requestedFields.add(productNameRField);
		queryRequest.setFilterBy(attributesToValues);
		queryRequest.filterBy.boolOperand = SOQLConstants.BOOL_OPERATION_OR;

		List<RateCardItem__c> rateCardItems = (List<RateCardItem__c>) SOQLUtility.querySObject(
			queryRequest
		);

		List<QuoteItem__c> quoteItemsToInsert = setRateCardItemAndProductForImportRows(
			rows,
			attributesForRateCard,
			rateCardItems
		);
		CRUDUtility.insertRecords(quoteItemsToInsert);

		return rows;
	}

	private static List<QuoteItem__c> setRateCardItemAndProductForImportRows(
		List<ImportRow> rows,
		Set<String> attributesForRateCard,
		List<RateCardItem__c> rateCardItems
	) {
		String productNameRField = SystemUtility.getChildRName(
			Schema.RateCardItem__c.ProductId__c,
			Schema.Product__c.Name
		);
		List<QuoteItem__c> updatedQuoteItems = new List<QuoteItem__c>();
		for (ImportRow row : rows) {
			QuoteItem__c quoteItem = row.quoteItem;
			for (RateCardItem__c rateCardItem : rateCardItems) {
				Boolean matchesRateCardItem = true;
				if (rateCardItem.ProductId__r.Name == row.productName) {
					quoteItem.ProductId__c = rateCardItem.ProductId__c;
				} else {
					continue;
				}

				for (String attributeApiName : attributesForRateCard) {
					if (productNameRField == attributeApiName) {
						continue; // don't try to check against product id
					}

					Object quoteItemValue = quoteItem.get(attributeApiName);
					Object rateCardItemValue = rateCardItem.get(attributeApiName);
					if (quoteItemValue != rateCardItemValue) {
						matchesRateCardItem = false;
						break;
					}
				}

				if (matchesRateCardItem == true) {
					quoteItem.RateCardItemId__c = rateCardItem.Id;
					break;
				}
			}
		}

		return updatedQuoteItems;
	}

	private class QuoteRateCardMetadata {
		@AuraEnabled
		public List<Map<String, Object>> columnMetadata { get; set; }
		@AuraEnabled
		public String fieldApiNamesCsv { get; set; }
	}

	private class ImportRow {
		@AuraEnabled
		public String productName { get; set; }
		@AuraEnabled
		public QuoteItem__c quoteItem { get; set; }
	}
}
