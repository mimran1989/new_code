import { Discounting } from 'c/util';
import AdjustmentService from 'c/adjustmentService';
import getVolumeDiscounts from '@salesforce/apex/VolumeDiscountController.getVolumeDiscounts';

const Constants = {
	QUOTE: 'Quote',
	PERIOD: 'Period',
	PERIOD_GROUP: 'Period Group',
};

export default class VolumeDiscountAdjustment {
	_laborAmountNamedRange;
	_periodNamedRanges;
	_periodGroupNamedRanges;

	async updateVolumeDiscountAdjustment({ quoteId, volumeDiscounts, namedRanges }) {
		let volumeDiscountDTOs = volumeDiscounts;
		if (!volumeDiscountDTOs && quoteId) {
			volumeDiscountDTOs = await getVolumeDiscounts({ quoteId });
		}

		this._laborAmountNamedRange = namedRanges.laborAmount;
		this._periodNamedRanges = namedRanges.periods;
		this._periodGroupNamedRanges = namedRanges.periodGroups;

		this.removeExistingVolumeDiscountAdjustments();
		this.applyVolumeDiscounts(volumeDiscountDTOs);
	}

	applyVolumeDiscounts(volumeDiscountDTOs) {
		volumeDiscountDTOs.forEach((volumeDiscount) => {
			switch (volumeDiscount.totalBy) {
				case Constants.QUOTE:
					VolumeDiscountAdjustment.updateAdjustments([this._laborAmountNamedRange], volumeDiscount);
					break;
				case Constants.PERIOD:
					VolumeDiscountAdjustment.updateAdjustments(this._periodNamedRanges, volumeDiscount);
					break;
				case Constants.PERIOD_GROUP:
					VolumeDiscountAdjustment.updateAdjustments(this._periodGroupNamedRanges, volumeDiscount);
					break;
				default:
					break;
			}
		});
	}

	removeExistingVolumeDiscountAdjustments() {
		AdjustmentService.removeAdjustments([this._laborAmountNamedRange, ...this._periodNamedRanges, ...this._periodGroupNamedRanges], 'Volume Discount');
	}

	static updateAdjustments(namedRanges, volumeDiscount) {
		for (let i = 0; i < namedRanges.length; i++) {
			const namedRange = namedRanges[i];
			const ctxAdjustmentIndex = namedRange.adjustmentList.findIndex((ctxAdjustment) => ctxAdjustment.category === volumeDiscount.category);
			let isInTiers = false;
			for (let j = 0; j < volumeDiscount.tiers.length; j++) {
				const tier = volumeDiscount.tiers[j];
				const { category } = volumeDiscount;
				const quantity = Discounting.getNamedRangeQuantity(namedRange, category);
				if (Discounting.isNamedRangeInTier(quantity, tier, category)) {
					isInTiers = true;

					if (ctxAdjustmentIndex > -1) {
						const adjustment = namedRange.adjustmentList[ctxAdjustmentIndex];
						adjustment.amount = tier.discount;
						adjustment.tierId = tier.id;
						adjustment.operationType = null;
						namedRange.adjustmentList = [...namedRange.adjustmentList];
					} else {
						const ctxAdjustment = Discounting.createNewVolumeDiscountAdjustment(namedRange, tier);
						namedRange.adjustmentList = [...namedRange.adjustmentList, ctxAdjustment];
					}
				}
			}

			if (ctxAdjustmentIndex > -1 && !isInTiers) {
				namedRange.adjustmentList[ctxAdjustmentIndex].amount = 0;
				namedRange.adjustmentList = [...namedRange.adjustmentList];
			}
		}
	}
}
