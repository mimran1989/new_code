import Util from '../../support/util';

const COMPONENT = () => cy.get(Util.componentSelector('resource-role-dialog'), { timeout: 8000 });

const ROLE_BASE_COMBO_BOX = () => COMPONENT().find('lightning-combobox.role-select')
	.find('lightning-base-combobox');

const RATE_ITEM_ROWS = () => COMPONENT()
	.find('c-soql-datatable')
	.find('c-base-datatable-extension')
	.find('tbody');

const ResourceRoleDialog = {
	addToQuoteButton: () => COMPONENT().contains('button', 'Add to quote'),
	cancelButton: () => COMPONENT().contains('button', 'Cancel'),
	component: () => COMPONENT(),
	noRolesAvailableText: () => COMPONENT().contains('There are no available roles for the selected Practice and Group.'),
	roleDropdown: () => ROLE_BASE_COMBO_BOX().find('button'),
	roleDropDownItem: {
		labeled: (itemLabel: string) => () => ROLE_BASE_COMBO_BOX().find(`span[title='${itemLabel}']`),
	},
	rateItem: {
		number: (selectIdx: number) => ({
			radioButton: () => RATE_ITEM_ROWS().find('tr').filter('[data-row-key-value]')
				.eq(selectIdx - 1)
				.find('input[type="radio"]'),
		}),
	},
};

export default ResourceRoleDialog;
