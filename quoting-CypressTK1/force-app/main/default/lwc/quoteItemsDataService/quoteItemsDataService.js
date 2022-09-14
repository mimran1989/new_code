const QuoteItemCache = {};

export default class QuoteItemsDataService {
	static setQuoteItem(id, quoteItem) {
		QuoteItemCache[id] = quoteItem;
	}

	static removeQuoteItem(id) {
		delete QuoteItemCache[id];
	}

	static getQuoteItem(id) {
		return QuoteItemCache[id];
	}

	static getAllQuoteItems() {
		return QuoteItemCache;
	}
}
