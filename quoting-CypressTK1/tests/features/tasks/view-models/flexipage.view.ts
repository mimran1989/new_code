/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

const CONTAINER = () => cy.get('app_flexipage-lwc-app-flexipage')
	.find('app_flexipage-lwc-app-flexipage-internal');

export default abstract class Flexipage {
    static CONTAINER = CONTAINER;
}
