import Discounting from '../discounting';

describe('Discounting', () => {
	it('should see named range matches first tier', async() => {
		const tier = {
			sequence: 1,
			fromValue: 1,
			toValue: 10,
		};

		const isNamedRangeInTier = Discounting.isNamedRangeInTier(5, tier, 'Headcount');
		expect(isNamedRangeInTier).toEqual(true);
	});

	it('should see named range does not match first tier', async() => {
		const tier = {
			sequence: 1,
			fromValue: 1,
			toValue: 10,
		};

		const isNamedRangeInTier = Discounting.isNamedRangeInTier(11, tier, 'Headcount');
		expect(isNamedRangeInTier).toEqual(false);
	});

	it('should see named range matches second tier', async() => {
		const tier = {
			sequence: 2,
			fromValue: 11,
			toValue: 20,
		};

		const isNamedRangeInTier = Discounting.isNamedRangeInTier(11, tier, 'Headcount');
		expect(isNamedRangeInTier).toEqual(true);
	});

	it('should see named range does not match second tier', async() => {
		const tier = {
			sequence: 2,
			fromValue: 11,
			toValue: 20,
		};

		const isNamedRangeInTier = Discounting.isNamedRangeInTier(21, tier, 'Headcount');
		expect(isNamedRangeInTier).toEqual(false);
	});

	it('should see named range matches last tier', async() => {
		const tier = {
			sequence: 3,
			fromValue: 21,
			toValue: 30,
		};

		const isNamedRangeInTier = Discounting.isNamedRangeInTier(21, tier, 'Headcount');
		expect(isNamedRangeInTier).toEqual(true);
	});

	it('should see named range does not match last tier', async() => {
		const tier = {
			sequence: 3,
			fromValue: 21,
			toValue: 30,
		};

		const isNamedRangeInTier = Discounting.isNamedRangeInTier(11, tier, 'Headcount');
		expect(isNamedRangeInTier).toEqual(false);
	});

	it('should apply first tier discount for a decimal quantity between first and second tier', async() => {
		const tier = {
			sequence: 1,
			fromValue: 1,
			toValue: 10,
		};

		const isNamedRangeInTier = Discounting.isNamedRangeInTier(10.12, tier, 'Headcount');
		expect(isNamedRangeInTier).toEqual(true);
	});

	it('should apply second tier discount for a decimal quantity between first and second tier', async() => {
		const tier = {
			sequence: 2,
			fromValue: 11,
			toValue: 20,
		};

		const isNamedRangeInTier = Discounting.isNamedRangeInTier(20.12, tier, 'Headcount');
		expect(isNamedRangeInTier).toEqual(true);
	});
});
