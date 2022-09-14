/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
function onColumnDrag(movedColumns, dropIndex) {
	const lastRow = this.countRows() - 1;
	const { phase: dropPhase } = this.getCellMeta(lastRow, dropIndex);
	if (dropPhase) {
		window.top.postMessage(
			{
				action: 'move-periods',
				data: JSON.stringify([movedColumns, dropIndex]),
			},
			'*',
		);
	}

	return false;
}

function beforeRowMove(movedRows, finalIndex) {
	if (movedRows[0] === finalIndex) {
		return false;
	}

	if (finalIndex === 0 && !this.getSourceDataAtRow(this.toPhysicalRow(finalIndex)).isQuoteItem) { // quote item cannot be moved above the first section header
		return false;
	}

	for (let i = 0; i < movedRows.length; i++) {
		const sourceData = this.getSourceDataAtRow(this.toPhysicalRow(movedRows[i]));
		if (!sourceData.isQuoteItem || sourceData.locked) {
			return false;
		}
	}

	return undefined;
}

// suppressing line max limit because this method is stringified to then be executed by an event within handsontable
// grid. For this to work we have to include any references accessed by this method within its own function body.
// eslint-disable-next-line max-lines-per-function
function onMouseOver(event, coords) {
	const isValidCoordinate = (targetCoordinates, from, to) => targetCoordinates.row >= -1
		&& targetCoordinates.col > -1
		&& (targetCoordinates.col > from.col || targetCoordinates.col < to.col);

	const checkDropArea = (hot, targetCoordinates) => (mouseEvent) => {
		const selectedRange = hot.getSelectedRange();
		if (!selectedRange?.length) {
			return;
		}

		const { from, to } = selectedRange[0];
		const moveColumnPlugin = hot.getPlugin('ManualColumnMove');
		moveColumnPlugin.backlight._element.style.removeProperty('background');
		moveColumnPlugin.backlight._element.style.removeProperty('opacity');
		moveColumnPlugin.guideline._element.style.background = 'transparent';

		if (isValidCoordinate(targetCoordinates, from, to)) {
			const lastRow = hot.countRows() - 1;
			const { phase } = hot.getCellMeta(lastRow, targetCoordinates.col);
			if (phase) {
				const targetCell = mouseEvent.target;
				const pointerOffset = mouseEvent.offsetX;
				const leftToRight = targetCoordinates.col > from.col;
				const triggerPosition = targetCell.offsetWidth / 2;
				if (
					(!leftToRight && pointerOffset <= triggerPosition)
					|| (leftToRight && pointerOffset >= triggerPosition)
				) {
					moveColumnPlugin.backlight._element.style.background = 'green';
					moveColumnPlugin.backlight._element.style.opacity = '50%';
				}
			}
		}
	};

	if (Provus.Grid.MouseOverTarget !== event.target) {
		if (Provus.Grid.MouseOverTarget) {
			// drop old listener
			Provus.Grid.MouseOverTarget.removeEventListener(
				'mousemove',
				Provus.Grid.checkDropArea,
			);
			delete Provus.Grid.checkDropArea;
		}

		// attach new listener
		Provus.Grid.checkDropArea = checkDropArea(this, coords);
		Provus.Grid.MouseOverTarget = event.target;
		Provus.Grid.MouseOverTarget.addEventListener('mousemove', Provus.Grid.checkDropArea);
	}
}

export { onColumnDrag, beforeRowMove, onMouseOver };
