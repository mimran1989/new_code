import { generateUUID } from 'c/baseUtils';
import { infinity } from 'c/util';

export default class VolumeDiscountTierVm {
	volumeDiscountId;
	id;
	label;
	_from = null;
	_to = null;
	_discount = null;
	_isNew = true;

	constructor({ tierTitle, dto }) {
		if (!dto) {
			this.id = generateUUID();
		} else {
			// set view model values from apex DTO object
			this.mapDtoToVm(dto);
			this._isNew = false;
		}

		this.label = tierTitle;
	}

	get from() {
		return this._from;
	}
	set from(fromValue) {
		if (fromValue.length === 0) {
			this._from = null;
		} else {
			this._from = +fromValue;
		}
	}

	get to() {
		return this._to;
	}
	set to(toValue) {
		if (toValue === null) {
			this._to = toValue;
		} else if (
			(this._to !== infinity.inputValue && toValue.length === 0)
			|| toValue === infinity.inputValue
			|| toValue === infinity.numericValue
		) {
			this._to = infinity.inputValue;
		} else {
			this._to = +toValue;
		}
	}

	get discount() {
		return this._discount;
	}
	set discount(discountValue) {
		// assume 0% discount if none specified
		if (discountValue.length === 0) {
			this.discount = 0;
		} else {
			this._discount = discountValue;
		}
	}

	resetDefault() {
		this._from = null;
		this._to = null;
		this._discount = null;
	}

	validate() {
		if (this.from === null) {
			this.resetDefault();
			return false;
		}

		return true;
	}

	mapDtoToVm(dto) {
		this.volumeDiscountId = dto.volumeDiscountId;
		this.id = dto.id;
		this._from = VolumeDiscountTierVm.convertDtoDecimalValue(dto.fromValue);
		this.to = VolumeDiscountTierVm.convertDtoDecimalValue(dto.toValue);
		this._discount = VolumeDiscountTierVm.convertDtoDecimalValue(dto.discount);
	}

	static convertDtoDecimalValue(theValue) {
		return theValue || theValue === 0 ? theValue : null;
	}

	/**
	 * Convert view model to apex friendly DTO object
	 * @param sequence whole number indicating position/order of tier within list of tiers
	 * @returns {{fromValue: null, toValue: number, sequence, volumeDiscountId, discount: null, id: (null|*)}}
	 */
	getDto(sequence) {
		// if "To" value is "Infinity" convert to max apex decimal number
		const toValue = this._to === infinity.inputValue ? infinity.numericValue : this._to;
		return {
			volumeDiscountId: this.volumeDiscountId,
			id: this._isNew ? null : this.id,
			fromValue: this._from,
			toValue,
			discount: this.discount,
			sequence,
		};
	}
}
