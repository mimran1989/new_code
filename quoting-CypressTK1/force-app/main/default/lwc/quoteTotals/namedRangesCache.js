const _namedRanges = {};
const _laborNamedRange = {};
const _unbilledLaborNamedRange = {};
const _unbilledAddOnNamedRange = {};
const _addOnNamedRange = {};
const _quoteNamedRange = {};
const _quoteItemNamedRanges = {};
const _periodNamedRanges = {};
const _itemPeriodGroupNamedRanges = {};
const _quotePeriodGroupNamedRanges = {};
const _periodByPeriodGroupNamedRanges = {};
const _isLoaded = {};

const NamedRangesCache = {
	// eslint-disable-next-line max-lines-per-function
	setData: (quoteId, newVal) => {
		_laborNamedRange[quoteId] = null;
		_unbilledLaborNamedRange[quoteId] = null;
		_unbilledAddOnNamedRange[quoteId] = null;
		_addOnNamedRange[quoteId] = null;
		_quoteNamedRange[quoteId] = null;
		_quoteItemNamedRanges[quoteId] = {};
		_periodNamedRanges[quoteId] = {};
		_itemPeriodGroupNamedRanges[quoteId] = {};
		_quotePeriodGroupNamedRanges[quoteId] = {};
		_namedRanges[quoteId] = newVal;
		_isLoaded[quoteId] = true;

		// eslint-disable-next-line max-lines-per-function, complexity
		newVal.forEach((namedRangeDto) => {
			switch (namedRangeDto.type) {
				case 'Non-billable Quote Ancillaries':
					_unbilledAddOnNamedRange[quoteId] = namedRangeDto;
					break;
				case 'Non-billable Quote Labor':
					_unbilledLaborNamedRange[quoteId] = namedRangeDto;
					break;
				case 'Quote Labor':
					_laborNamedRange[quoteId] = namedRangeDto;
					break;
				case 'Quote Ancillaries':
					_addOnNamedRange[quoteId] = namedRangeDto;
					break;
				case 'Quote':
					_quoteNamedRange[quoteId] = namedRangeDto;
					break;
				case 'Quote Period':
					_periodNamedRanges[quoteId][namedRangeDto.quotePeriodId] = namedRangeDto;

					if (!_periodByPeriodGroupNamedRanges[namedRangeDto.quotePeriodGroupId]) {
						_periodByPeriodGroupNamedRanges[namedRangeDto.quotePeriodGroupId] = [];
					}

					_periodByPeriodGroupNamedRanges[namedRangeDto.quotePeriodGroupId].push(namedRangeDto);

					break;

				case 'Quote Item': {
					const namedRangesForQuote = _quoteItemNamedRanges[quoteId];
					namedRangesForQuote[namedRangeDto.quoteItemId] = namedRangeDto;
					break;
				}

				// refers to a period group named range comprising all rows
				case 'Quote Period Group': {
					_quotePeriodGroupNamedRanges[quoteId][namedRangeDto.quotePeriodGroupId] = namedRangeDto;
					break;
				}

				// refers to period group named range comprising a single row
				case 'Quote Item Period Group': {
					const namedRangesForGroup = _itemPeriodGroupNamedRanges[quoteId][namedRangeDto.quotePeriodGroupId] || {};
					namedRangesForGroup[namedRangeDto.quoteItemId] = namedRangeDto;
					_itemPeriodGroupNamedRanges[quoteId][namedRangeDto.quotePeriodGroupId] = namedRangesForGroup;
					break;
				}

				default:
			}
		});
	},
	addPeriodNamedRange: (quoteId, period, newNamedRangeDto) => {
		NamedRangesCache.addNamedRange(quoteId, newNamedRangeDto);
		_periodNamedRanges[quoteId][period.id] = newNamedRangeDto;

		if (!_periodByPeriodGroupNamedRanges[period.periodGroupId]) {
			_periodByPeriodGroupNamedRanges[period.periodGroupId] = [];
		}

		_periodByPeriodGroupNamedRanges[period.periodGroupId].push(newNamedRangeDto);
	},
	addQuotePeriodGroupNamedRange: (quoteId, quotePeriodGroupId, newNamedRangeDto) => {
		NamedRangesCache.addNamedRange(quoteId, newNamedRangeDto);
		_quotePeriodGroupNamedRanges[quoteId][quotePeriodGroupId] = newNamedRangeDto;
	},
	addItemPeriodGroupNamedRange: (quoteId, quotePeriodGroupId, quoteItemId, newNamedRangeDto) => {
		NamedRangesCache.addNamedRange(quoteId, newNamedRangeDto);
		let namedRangesForGroup = _itemPeriodGroupNamedRanges[quoteId][quotePeriodGroupId];
		if (!namedRangesForGroup) {
			namedRangesForGroup = {};
			_itemPeriodGroupNamedRanges[quoteId][quotePeriodGroupId] = namedRangesForGroup;
		}

		namedRangesForGroup[quoteItemId] = newNamedRangeDto;
	},
	addQuoteItemNamedRange: (quoteId, newNamedRangeDto) => {
		NamedRangesCache.addNamedRange(quoteId, newNamedRangeDto);
		_quoteItemNamedRanges[quoteId][newNamedRangeDto.quoteItemId] = newNamedRangeDto;
	},
	addNamedRange: (quoteId, newNamedRangeDto) => {
		_isLoaded[quoteId] = true;
		_namedRanges[quoteId].push(newNamedRangeDto);
	},
	addUnbilledLaborNamedRange: (quoteId, newNamedRangeDto) => {
		NamedRangesCache.addNamedRange(quoteId, newNamedRangeDto);
		_unbilledLaborNamedRange[quoteId] = newNamedRangeDto;
	},
	addUnbilledAddOnNamedRange: (quoteId, newNamedRangeDto) => {
		NamedRangesCache.addNamedRange(quoteId, newNamedRangeDto);
		_unbilledAddOnNamedRange[quoteId] = newNamedRangeDto;
	},
	deleteQuoteItemNamedRange: (quoteId, quoteItemId) => {
		const deleteIndex = _namedRanges[quoteId].findIndex((x) => x.quoteItemId === quoteItemId);
		_namedRanges[quoteId].splice(deleteIndex, 1);
		delete _quoteItemNamedRanges[quoteId][quoteItemId];
	},
	getNamedRanges: (quoteId) => _namedRanges[quoteId],
	getLaborTotal: (quoteId) => _laborNamedRange[quoteId],
	getUnbilledLaborTotal: (quoteId) => _unbilledLaborNamedRange[quoteId],
	getUnbilledAddOnTotal: (quoteId) => _unbilledAddOnNamedRange[quoteId],
	getAddOnTotal: (quoteId) => _addOnNamedRange[quoteId],
	getQuoteTotal: (quoteId) => _quoteNamedRange[quoteId],
	getQuotePeriodGroupTotals: (quoteId) => Object.values(_quotePeriodGroupNamedRanges[quoteId]),
	getQuotePeriodGroupTotal: (quoteId, quotePeriodGroupId) => _quotePeriodGroupNamedRanges[quoteId] && _quotePeriodGroupNamedRanges[quoteId][quotePeriodGroupId],
	getPeriodTotal: (quoteId, periodNumber) => _periodNamedRanges[quoteId] && _periodNamedRanges[quoteId][periodNumber],
	getQuoteItemTotal: (quoteId, quoteItemId) => _quoteItemNamedRanges[quoteId] && _quoteItemNamedRanges[quoteId][quoteItemId],
	getQuoteItemTotals: (quoteId) => _quoteItemNamedRanges[quoteId],
	getItemPeriodGroupTotal: (quoteId, quotePeriodGroupId, quoteItemId) => _itemPeriodGroupNamedRanges[quoteId]
		&& _itemPeriodGroupNamedRanges[quoteId][quotePeriodGroupId] && _itemPeriodGroupNamedRanges[quoteId][quotePeriodGroupId][quoteItemId],
	getItemPeriodGroupTotals: (quoteId) => Object.values(_itemPeriodGroupNamedRanges[quoteId]).reduce((acc, next) => [...acc, ...Object.values(next)], []),
	getPeriodTotals: (quoteId) => Object.values(_periodNamedRanges[quoteId]),
	getPeriodsByPeriodGroup: (quotePeriodGroupId) => _periodByPeriodGroupNamedRanges[quotePeriodGroupId],
	getIsStale(quoteId) {
		return !_isLoaded[quoteId];
	},
};

Object.freeze(NamedRangesCache);

export default NamedRangesCache;
