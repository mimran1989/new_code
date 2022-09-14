const RateCardPage = {
	// rateCardButton: cy.get('a[title=\'Rate Cards\']'),
	rateCardButton: () => cy.get('a[title=\'Rate Cards\']'),
	newButton: () => cy.get('a[title=\'New\']'),
	rateCardTextBox: () => cy.get('input[name=\'Name\']'),
	// productsButton: Select('div').find('a').withAttribute('title', 'Products'),
	// quoteCardButton: Select('div').find('a').withAttribute('title', 'Quotes'),
	// accountsButton: Select('div').find('a').withAttribute('title', 'Accounts'),
	// headersButton: Select('div').find('a'),
	// rateCardNewButton: Select('div').find('ul').find('li').find('a')
	// 	.withAttribute('title', 'New'),
	// rateCardName: Select('div').find('input').withAttribute('name', 'Name'),
	// attributeGroup: Select('div').find('input').withAttribute('placeholder', 'Search Rate Card Attribute Groups...'),
	// skillAndresource: Select('div').find('ul').withAttribute('aria-label', 'Recent Rate Card Attribute Groups').find('li')
	// 	.nth(-1),
	activeCheckbox: () => cy.get('input[name=\'PSQ__IsActive__c\']'),
	saveButton: () => cy.get('button[name=\'SaveEdit\']'),
	effectiveDateError: () => cy.get('.slds-form-element__help').contains('Complete this field.'),

	// effectiveDate: Select('div').find('input').withAttribute('name', 'PSQ__EffectiveDate__c'),
	// expirationDate: Select('div').find('input').withAttribute('name', 'PSQ__ExpirationDate__c'),
	// weHitASnagError: Select('div').find('h2').withAttribute('title', 'We hit a snag.'),
	// effectiveDateError: Select('div').find('input').withAttribute('name', 'PSQ__EffectiveDate__c').parent()
	// 	.find('div')
	// 	.withText('Complete this field.'),
	// expiryDateError: Select('div').find('input').withAttribute('name', 'PSQ__ExpirationDate__c').parent()
	// 	.find('div')
	// 	.withText('Complete this field.'),
	// firstRateCard: Select('a').withText('Rate Card 11/03/2022, 08:55:34'),
	// relatedTab: Select('div').find('a').withText('Related'),
	// newButtonRelated: Select('div').find('button').withExactText('New'),
	// effectiveDateCannotBeGreaterThanRateCardExpirationDateError: Select('div').find('input').withAttribute('name', 'PSQ__EffectiveDate__c').parent()
	// 	.find('div')
	// 	.withExactText("The Rate Card's effective date cannot be greater than Rate Card's expiration date"),
	// effectiveDateError_YourEntryDoesNotMatchTheFormat: Select('div').find('input').withAttribute('name', 'PSQ__EffectiveDate__c').parent()
	// 	.find('div')
	// 	.withText('Your entry does not match the allowed format M/d/yyyy.'),
	// newRateCard: Select('div').find('span').withText('New Rate Card'),
	// cancelButton: Select('div').find('ul').find('li').nth(-3),
	// assignedToAccount: Select('div').find('input').withAttribute('placeholder', 'Search Accounts...'),
	// assignedToAccountValue: Select('div').find('input').withAttribute('placeholder', 'Search Accounts...').parent()
	// 	.find('div')
	// 	.find('ul')
	// 	.find('li'),
	// assignedToAccountValueInList: Select('div').find('lightning-base-combobox-formatted-text'),
};

export default RateCardPage;
