import { CypressSelectorFn } from '../support/types/cypressSelectorFn';
import { createCypressTask } from '../support/task';

const Select = {
	value: (valueOrTextOrIndex: string | number) => ({
		inComboBox: (comboBoxSelector: CypressSelectorFn) => createCypressTask(() => {
			comboBoxSelector().select(valueOrTextOrIndex);
		}),
	}),
};

export default Select;
