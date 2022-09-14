import VolumeDiscountVm from '../volumeDiscountVm';

const requiredEmptyField = 'Field {0} required';
const qualifyingPeriod = 'qualifying period';

jest.mock('@salesforce/label/c.RequiredFieldEmpty', () => ({ default: requiredEmptyField }),
	{ virtual: true });
jest.mock('@salesforce/label/c.QualifyingPeriod', () => ({ default: qualifyingPeriod }),
	{ virtual: true });
describe('volumeDiscountVm', () => {
	describe('When total by field is empty', () => {
		it('validation fails with two errors', async() => {
			const headcountVolumeDiscount = new VolumeDiscountVm({
				quoteId: 'quoteId1',
				category: 'Headcount',
			});

			const validationResults = headcountVolumeDiscount.validate();

			expect(validationResults.length).toEqual(2);
		});

		describe('first tier from field value equals zero', () => {
			it('Should return required field validation message', async() => {
				const headcountVolumeDiscount = new VolumeDiscountVm({
					quoteId: 'quoteId1',
				});

				headcountVolumeDiscount.category = 'Headcount';
				headcountVolumeDiscount.tiers[0].from = '0';

				const validationResults = headcountVolumeDiscount.validate();

				expect(validationResults.length).toEqual(1);
				// SF mocks custom labels as the label's full name
				expect(validationResults[0].message).toEqual(requiredEmptyField.replace('{0}', qualifyingPeriod));
			});
		});
		describe('first tier to field equals 5', () => {
			it('Should return two validation error messages', async() => {
				const headcountVolumeDiscount = new VolumeDiscountVm({
					quoteId: 'quoteId1',
					category: 'Headcount',
				});

				headcountVolumeDiscount.tiers[0].to = '5';

				const validationResults = headcountVolumeDiscount.validate();

				expect(validationResults.length).toEqual(2);
			});
		});
	});

	describe('When tier from field empty', () => {
		it('Should return one validation error', async() => {
			const headcountVolumeDiscount = new VolumeDiscountVm({
				quoteId: 'quoteId1',
				category: 'Headcount',
			});

			headcountVolumeDiscount.totalBy = 'Period';
			headcountVolumeDiscount.tiers[0].from = '';
			const validationResults = headcountVolumeDiscount.validate();

			expect(validationResults.length).toEqual(1);
		});
	});

	describe('When no tier fields completed', () => {
		it('Should return \'c.AtLeastOneTierRequired\' label validation error message', async() => {
			const headcountVolumeDiscount = new VolumeDiscountVm({
				quoteId: 'quoteId1',
				category: 'Headcount',
			});

			headcountVolumeDiscount.totalBy = 'Period';
			const validationResults = headcountVolumeDiscount.validate();

			expect(validationResults.length).toEqual(1);
			expect(validationResults[0].message).toEqual('c.AtLeastOneTierRequired');
		});
	});

	describe('When two tiers entered', () => {
		describe('and to/from values overlap', () => {
			it('Should return one \'c.DiscountTierNoOverlap\' validation error message', async() => {
				const laborRevenueVolumeDiscount = new VolumeDiscountVm({
					dto: {
						category: 'Labor Revenue',
						totalBy: 'Period',
						tiers: [
							{
								fromValue: 0,
								toValue: 25,
								discount: 5,
							},
							{
								fromValue: 25,
								toValue: 50,
								discount: 10,
							},
						],
					},
				});

				const validationResults = laborRevenueVolumeDiscount.validate();

				expect(validationResults.length).toEqual(1);
				// SF mocks custom labels as the label's full name
				expect(validationResults[0].message).toEqual('c.DiscountTierNoOverlap');
			});
		});
		describe('and there is a gap between to/from values', () => {
			it('Should return one \'c.DiscountTierNoGaps\' validation error message', async() => {
				const laborRevenueVolumeDiscount = new VolumeDiscountVm({
					dto: {
						category: 'Labor Revenue',
						totalBy: 'Period',
						tiers: [
							{
								fromValue: 0,
								toValue: 25,
								discount: 5,
							},
							{
								fromValue: 27,
								toValue: 50,
								discount: 10,
							},
						],
					},
				});

				const validationResults = laborRevenueVolumeDiscount.validate();

				expect(validationResults.length).toEqual(1);
				// SF mocks custom labels as the label's full name
				expect(validationResults[0].message).toEqual('c.DiscountTierNoGaps');
			});
		});
	});
});
