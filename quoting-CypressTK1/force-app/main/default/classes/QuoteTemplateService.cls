/**
 *  Provus Services Quoting
 *  QuoteTemplateService
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class QuoteTemplateService {
	public static final String RECORDTYPE_NAME_COLLABORATION = 'Collaboration';
	/**
	 * Clone all entities from a template into the provided quotes
	 *
	 * @param quotes the quote record which contains a link to the template to
	 * 				   copy contents from
	 */
	public static void applyQuoteTemplateAfter(List<Quote__c> quotes) {
		Map<Id, Set<Id>> quotesByTemplateId = new Map<Id, Set<Id>>();

		// order the quote ids by their template ids
		for (Quote__c quote : quotes) {
			if (quote.TemplateId__c != null && quote.Type__c != RECORDTYPE_NAME_COLLABORATION) {
				// ignore collab quotes which were started from a template
				Set<Id> quotesForTemplate = quotesByTemplateId.get(quote.TemplateId__c);
				if (quotesForTemplate == null) {
					quotesForTemplate = new Set<Id>();
					quotesByTemplateId.put(quote.TemplateId__c, quotesForTemplate);
				}

				quotesForTemplate.add(quote.Id);
			}
		}

		if (!quotesByTemplateId.isEmpty()) {
			QuoteCloneService.copyQuoteChildEntities(quotesByTemplateId, null);
		}
	}
}
