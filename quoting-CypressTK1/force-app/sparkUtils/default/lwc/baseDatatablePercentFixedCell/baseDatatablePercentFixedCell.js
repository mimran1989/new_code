/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

import { LightningElement, api } from 'lwc';

export default class BaseDatatableNameCell extends LightningElement {
  // Properties specific to this cell type
  @api maximumFractionDigits;
  // Required properties for datatable-edit-cell
  @api value; // comes in from datatable as the value of the name field
  @api tableBoundary;
  @api rowKeyAttribute;
  @api rowKeyValue;
  @api isEditable;
  @api objectApiName;
  @api columnName;
  @api fieldApiName;
}
