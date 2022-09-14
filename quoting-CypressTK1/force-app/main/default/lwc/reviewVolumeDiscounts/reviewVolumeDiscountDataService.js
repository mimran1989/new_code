/**
 *  Provus Services Quoting
 *  reviewVolumeDiscountDataService
 *  @2022 Provus Inc. All rights reserved.
 */
import { VolumeDiscountCategories } from 'c/constantUtil';
import LABEL_TOTAL from '@salesforce/label/c.Total';
import ReviewAppliedVolumeDiscount from './reviewAppliedVolumeDiscount';

const createTotalRow = () => ({
	basedOn: LABEL_TOTAL,
	discountAmount: 0,
});

export default class ReviewVolumeDiscountDataService {
	static mapDtosToViewModel(reviewVolumeDiscountDtos) {
		const appliedVolumeDiscountVm = {
			headcountData: [],
			laborRevenueTotalBy: '',
			laborRevenueData: [],
		};

		const headcountTotal = createTotalRow();
		const laborRevenueTotal = createTotalRow();
		if (reviewVolumeDiscountDtos.length > 0) {
			reviewVolumeDiscountDtos.forEach((reviewVolumeDiscountDto) => {
				switch (reviewVolumeDiscountDto.categoryValue) {
					case VolumeDiscountCategories.Headcount:
						appliedVolumeDiscountVm.categoryLabel = reviewVolumeDiscountDto.categoryLabel;
						appliedVolumeDiscountVm.headcountData = ReviewVolumeDiscountDataService.getAppliedTierSummaries(reviewVolumeDiscountDto, headcountTotal);
						break;
					case VolumeDiscountCategories.LaborRevenue:
						appliedVolumeDiscountVm.categoryLabel = reviewVolumeDiscountDto.categoryLabel;
						appliedVolumeDiscountVm.laborRevenueTotalBy = reviewVolumeDiscountDto.totalBy;
						appliedVolumeDiscountVm.laborRevenueData = ReviewVolumeDiscountDataService.getAppliedTierSummaries(reviewVolumeDiscountDto, laborRevenueTotal);
						break;
					default:
				}
			});
		}

		appliedVolumeDiscountVm.headcountData.push(headcountTotal);
		appliedVolumeDiscountVm.laborRevenueData.push(laborRevenueTotal);

		return appliedVolumeDiscountVm;
	}

	static getAppliedTierSummaries(reviewVolumeDiscountDto, discountTotal) {
		const appliedVolumeDiscounts = [];
		const total = discountTotal;
		reviewVolumeDiscountDto.appliedTierSummaries.forEach((appliedTierSummary) => {
			const discountRow = new ReviewAppliedVolumeDiscount(reviewVolumeDiscountDto, appliedTierSummary);
			appliedVolumeDiscounts.push(discountRow);
			total.discountAmount += +discountRow.discountAmount;
		});
		return appliedVolumeDiscounts;
	}
}
