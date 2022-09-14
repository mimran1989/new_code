import LABEL_TIER from '@salesforce/label/c.Tier';
import LABEL_REQUIRED_FIELD_EMPTY from '@salesforce/label/c.RequiredFieldEmpty';
import LABEL_DISCOUNT_TIER_NO_GAPS from '@salesforce/label/c.DiscountTierNoGaps';
import LABEL_DISCOUNT_TIER_NO_OVERLAP from '@salesforce/label/c.DiscountTierNoOverlap';
import LABEL_SELECT_VOLUME_DISCOUNT_CATEGORY from '@salesforce/label/c.SelectDiscountMetric';
import LABEL_SELECT_VOLUME_DISCOUNT_PERIOD_TYPE from '@salesforce/label/c.SelectAggregatedBy';
import LABEL_QUALIFYING_PERIOD from '@salesforce/label/c.QualifyingPeriod';
import LABEL_AT_LEAST_ONE_TIER_REQUIRED from '@salesforce/label/c.AtLeastOneTierRequired';
import { generateUUID } from 'c/baseUtils';
import { infinity, inputIsBlank } from 'c/util';
import { VolumeDiscountCategories } from 'c/constantUtil';

import VolumeDiscountTierVm from './volumeDiscountTierVM';

export default class VolumeDiscountVm {
	quoteId;
	id;
	_category;
	/**
	 * Selected total by picklist value
	 * @type {string}
	 */
	totalBy;
	tiers = [];
	_isNew = true;
	tierFieldsFormat = {
		to: {
			formatter: undefined,
			step: '1',
		},
		from: {
			formatter: undefined,
			step: '1',
		},
		discount: {
			formatter: 'percent-fixed',
			step: '.1',
		},
	}

	labels = {
		Tier: LABEL_TIER,
		RequiredFieldEmpty: LABEL_REQUIRED_FIELD_EMPTY,
		SelectDiscountMetric: LABEL_SELECT_VOLUME_DISCOUNT_CATEGORY,
		SelectAggregatedBy: LABEL_SELECT_VOLUME_DISCOUNT_PERIOD_TYPE,
		QualifyingPeriod: LABEL_QUALIFYING_PERIOD,
		AtLeastOneTierRequired: LABEL_AT_LEAST_ONE_TIER_REQUIRED,
	}

	constructor({
		quoteId,
		category,
		dto,
		viewModel,
	}) {
		this.category = category;

		if (dto) {
			this.mapDtoToVm(dto);
			this._isNew = false;
		} else if (viewModel) {
			this.cloneFromViewModel(viewModel);
		} else {
			// create new empty view model instance
			this.quoteId = quoteId;
			this.id = generateUUID();
			this.generateNewTiers();
		}
	}

	get category() {
		return this._category;
	}

	set category(categoryValue) {
		this._category = categoryValue;

		if (categoryValue === VolumeDiscountCategories.LaborRevenue) {
			this.tierFieldsFormat.from.formatter = 'currency';
			this.tierFieldsFormat.to.formatter = 'currency';
		} else {
			this.tierFieldsFormat.from.formatter = undefined;
			this.tierFieldsFormat.to.formatter = undefined;
		}
	}

	generateNewTiers() {
		// add default of 3 new tiers (will be replaced with actual tier records if exist)
		this.tiers.push(
			new VolumeDiscountTierVm({
				tierTitle: this.getTierLabel(this.tiers.length),
			}),
		);
		this.tiers.push(
			new VolumeDiscountTierVm({
				tierTitle: this.getTierLabel(this.tiers.length),
			}),
		);
		this.tiers.push(
			new VolumeDiscountTierVm({
				tierTitle: this.getTierLabel(this.tiers.length),
			}),
		);
	}

	validate() {
		// reset validForSave flag each time we validate
		const results = [];
		if (!this.category) {
			results.push({
				message: this.labels.RequiredFieldEmpty.replace('{0}', this.labels.Category),
			});
		}

		const totalByIsEmpty = inputIsBlank(this.totalBy);
		if (totalByIsEmpty) {
			results.push({
				message: this.labels.RequiredFieldEmpty.replace('{0}', this.labels.QualifyingPeriod),
			});
		}

		const tierValidationResults = this.validateTiers();
		if (tierValidationResults.length > 0) {
			results.push(...tierValidationResults);
		}

		return results;
	}

	/**
	 * validate each tier
	 * @returns {[]}
	 */
	validateTiers() {
		const results = [];
		let hasATierEntry = false;
		this.tiers.every((tier, index) => {
			// if current tier has no from value then stop iterating
			const tierIsValid = tier.validate();
			if (tierIsValid) {
				if (!hasATierEntry) {
					hasATierEntry = true;
				}

				const gapsAndOverlapValidationResults = this.validateGapsAndOverlap(tier, index);
				if (gapsAndOverlapValidationResults.length > 0) {
					results.push(...gapsAndOverlapValidationResults);
					return false;
				}
			}

			return true;
		});

		if (!hasATierEntry) {
			results.push({
				message: this.labels.AtLeastOneTierRequired,
			});
		}

		return results;
	}

	validateGapsAndOverlap(tier, index) {
		const results = [];
		if (index > 0) {
			const previousTier = this.tiers[index - 1];
			const previousToValue = previousTier.to;
			// overlap of previous tier to value and current from value not allowed
			if (previousToValue === infinity.inputValue || tier.from <= previousToValue) {
				results.push({
					message: LABEL_DISCOUNT_TIER_NO_OVERLAP,
				});
			}

			if (previousToValue + 1 < tier.from) {
				results.push({
					message: LABEL_DISCOUNT_TIER_NO_GAPS,
				});
			}
		}

		return results;
	}

	/**
	 * Convert DTO object to view model object
	 * @param dto
	 */
	mapDtoToVm(dto) {
		this.mapCommonFields(dto);
		dto.tiers.forEach((tierDto, index) => {
			this.tiers.push(
				new VolumeDiscountTierVm({
					tierTitle: this.getTierLabel(index),
					dto: tierDto,
				}),
			);
		});
	}

	/**
	 * Create this view model from existing view model
	 * @param viewModel
	 */
	cloneFromViewModel(viewModel) {
		this.mapCommonFields(viewModel);
		this.tiers = viewModel.tiers;
		this._isNew = viewModel._isNew;
		this.tierFieldsFormat = viewModel.tierFieldsFormat;
	}

	mapCommonFields(entity) {
		this.id = entity.id;
		this.quoteId = entity.quoteId;
		this.category = entity.category;
		this.totalBy = entity.totalBy;
	}

	/**
	 * Return volume discount apex DTO object
	 */
	getDto() {
		const newDto = {
			quoteId: this.quoteId,
			id: this._isNew ? null : this.id,
			category: this.category,
			totalBy: this.totalBy,
			tiers: [],
		};

		this.tiers.forEach((tierVm, index) => {
			const tierSequence = index + 1;
			newDto.tiers.push(tierVm.getDto(tierSequence));
		});

		return newDto;
	}

	getTierLabel(count) {
		return this.labels.Tier.replace('{0}', count + 1);
	}
}
