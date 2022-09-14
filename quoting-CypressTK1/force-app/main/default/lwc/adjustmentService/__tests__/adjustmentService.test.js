import AdjustmentService from '../adjustmentService';

describe('AdjustmentService', () => {
	it('One saved adjustment with id should mark for deletion', async() => {
		const namedRanges = [];
		namedRanges.push({
			adjustmentList: [],
		});
		namedRanges[0].adjustmentList.push({
			adjustmentId: 'adjustment id 1',
			method: 'Volume Discount',
		});

		AdjustmentService.removeAdjustments(namedRanges, 'Volume Discount');

		expect(namedRanges[0].adjustmentList.length).toEqual(1);
		expect(namedRanges[0].adjustmentList[0].operationType).toEqual('delete');
	});

	it('One unsaved volume adjustment should be unchanged', async() => {
		const namedRanges = [];
		namedRanges.push({
			adjustmentList: [],
		});
		namedRanges[0].adjustmentList.push({
			adjustmentId: null,
			method: 'Volume Discount',
			operationType: null,
		});

		AdjustmentService.removeAdjustments(namedRanges, 'Volume Discount');

		expect(namedRanges[0].adjustmentList.length).toEqual(1);
		expect(namedRanges[0].adjustmentList[0].operationType).toEqual(null);
	});
});
