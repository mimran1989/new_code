import { merge } from 'lodash';
import { NamedRangeDO } from '../../interfaces/namedRangeDO';
import UIElement, { ObservedElement } from './element';
import { UIElementDO } from '../../interfaces/elementDO';
import Sync from '../base/sync';

export class NamedRange extends UIElement {
	$type: string = 'NamedRange';

	static newDO({ ...props }): NamedRangeDO {
		const merged: NamedRangeDO = merge(
			{
				name: null,
				namedRangeId: null,
				quoteItemId: null,
				quotePeriodId: null,
				quotePeriodGroupId: null,
				quoteSectionId: null,
				projectPhaseId: null,
				type: null,
				rangeSpec: null,
				relatedTotal: {
					namedRangeTotalId: null,
					quantityUOM: null,
					totalAmount: 0,
					totalCost: 0,
					totalQuantity: 0,
					baseExtendedAmount: 0,
					baseExtendedCost: 0,
					adjustedBaseAmount: 0,
					netExtendedAmount: 0,
					netExtendedCost: 0,
					marginPercent: 0,
				},
				adjustmentList: [],
			},
			props,
		);

		merged.$id = props.rangeSpec;
		return merged;
	}

	merge = (sourceDO: UIElementDO, observerName: string) => {
		Sync.forType(this.$type).pause(observerName, this.$id);
		this.mergeProperties(this.elementDO, sourceDO);
		(<NamedRangeDO> this.elementDO).adjustmentList = (<NamedRangeDO> this.elementDO).adjustmentList.filter((adjustment) => adjustment.adjustmentId === null
				|| (<NamedRangeDO>sourceDO).adjustmentList.some(
					(adjustmentResult) => adjustment.adjustmentId === adjustmentResult.adjustmentId,
				));

		Sync.forType(this.$type).resume(observerName, this.$id);
	};

	markDirty = (propertyName: string) => {
		const dirtyFieldCount = this.dirtyFields[propertyName] || 0;
		this.dirtyFields[propertyName] = dirtyFieldCount + 1;

		if (propertyName === 'adjustmentList') {
			this.dirtyFields[propertyName] = 1;
		}
	};

	static for(namedRangeDo: UIElementDO): ObservedElement {
		const namedRange = super.for(namedRangeDo);
		(<NamedRangeDO>namedRange.elementDO).rangeSpec = namedRange.$id;
		return namedRange;
	}
}

export const NamedRanges = {
	for: (namedRangeDos: NamedRangeDO[]): ObservedElement[] => namedRangeDos.map((namedRangeDo) => {
		const namedRange = NamedRange.for(namedRangeDo);
		(<NamedRangeDO>namedRange.elementDO).rangeSpec = namedRange.$id;
		return namedRange;
	}),
};
