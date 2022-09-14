/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

trigger QuoteItemCellTrigger on QuoteItemCell__c(before insert, before update, before delete) {
	QuoteItemCellTriggers.processTrigger(Trigger.oldMap, Trigger.new, Trigger.isBefore);
}
