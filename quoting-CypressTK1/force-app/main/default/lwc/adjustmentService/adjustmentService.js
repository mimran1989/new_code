/**
 *  Provus Services Quoting
 *  adjustmentService
 *  @2022 Provus Inc. All rights reserved.
 */

export default class AdjustmentService {
	static removeAdjustments(namedRanges, methodName) {
		for (let i = 0; i < namedRanges.length; i++) {
			const namedRange = namedRanges[i];
			const newAdjustmentList = [];
			for (let j = 0; j < namedRange.adjustmentList.length; j++) {
				const adjustment = namedRange.adjustmentList[j];
				if (adjustment.method === methodName && adjustment.adjustmentId !== null) {
					adjustment.operationType = 'delete';
				}

				newAdjustmentList.push(adjustment);
			}

			// change by ref pointer for change detection
			namedRange.adjustmentList = newAdjustmentList;
		}
	}
}
