/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

import Util from '../../support/util';
import Flexipage from './flexipage.view';

export default abstract class GlobalColaRateAdmin {
    static component = () => Flexipage.CONTAINER().find(Util.componentSelector('global-cola-rate-admin'));
    static table = () => GlobalColaRateAdmin.component().find(Util.componentSelector('base-datatable'));
    static addRowButton = () => GlobalColaRateAdmin.component().contains('button', 'Add row');
    static tableRow = () => GlobalColaRateAdmin.table().find('tr');
}
