/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
import { VolumeDiscountCategories } from 'c/constantUtil';
import ReviewVolumeDiscountDataService from '../reviewVolumeDiscountDataService';

describe('Resource Volume Discount Data Service', () => {
	describe('Map server DTO to view model', () => {
		it('When volume discount of type labor revenue expect basedOn to equal \'Labor Revenue Label\'', async() => {
			const laborRevenueLabel = 'Labor Revenue Label';

			const volumeDiscount = ReviewVolumeDiscountDataService.mapDtosToViewModel([{
				basedOn: VolumeDiscountCategories.LaborRevenue,
				categoryValue: VolumeDiscountCategories.LaborRevenue,
				categoryLabel: laborRevenueLabel,
				totalBy: 'Periods',
				appliedTierSummaries: [],
			}]);

			expect(volumeDiscount.categoryLabel)
				.toEqual(laborRevenueLabel);
		});

		it('When volume discount of type labor revenue expect basedOn to equal \'Headcount Label\'', async() => {
			const laborRevenueLabel = 'Headcount Label';

			const volumeDiscount = ReviewVolumeDiscountDataService.mapDtosToViewModel([{
				basedOn: VolumeDiscountCategories.LaborRevenue,
				categoryValue: VolumeDiscountCategories.LaborRevenue,
				categoryLabel: laborRevenueLabel,
				totalBy: 'Periods',
				appliedTierSummaries: [],
			}]);

			expect(volumeDiscount.categoryLabel)
				.toEqual(laborRevenueLabel);
		});

		it('When no volume discount review DTOs expect volume discount defined with data', async() => {
			const volumeDiscount = ReviewVolumeDiscountDataService.mapDtosToViewModel([]);

			expect(volumeDiscount)
				.toBeDefined();
			expect(volumeDiscount.headcountData.length)
				.toEqual(1);
			expect(volumeDiscount.laborRevenueData.length)
				.toEqual(1);
		});
	});

	describe('totaling', () => {
		it('should create a totals row at the end of the data set', () => {
			const dtos = [
				{
					categoryValue: 'Headcount',
					appliedTierSummaries: [
						{
							discountAmount: 1,
							activeTier: {},
						},
					],
				},
				{
					categoryValue: 'Headcount',
					appliedTierSummaries: [
						{
							discountAmount: 1,
							activeTier: {},
						},
					],
				},
			];

			expect(ReviewVolumeDiscountDataService.mapDtosToViewModel(dtos)
				.headcountData
				.at(-1).basedOn)
				.toEqual('c.Total');
		});
		it('should accumulate the discount amount across the dtos', () => {
			const dtos = [
				{
					categoryValue: 'Headcount',
					appliedTierSummaries: [
						{
							discountAmount: 1,
							activeTier: {},
						},
					],
				},
				{
					categoryValue: 'Headcount',
					appliedTierSummaries: [
						{
							discountAmount: 2,
							activeTier: {},
						},
					],
				},
			];

			expect(ReviewVolumeDiscountDataService.mapDtosToViewModel(dtos)
				.headcountData
				.at(-1).discountAmount)
				.toEqual(3);
		});
	});
});
