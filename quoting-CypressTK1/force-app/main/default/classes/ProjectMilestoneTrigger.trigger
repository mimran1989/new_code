/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */

trigger ProjectMilestoneTrigger on ProjectMilestone__c(before insert, before update) {
	ProjectMilestoneTriggers.processTrigger(Trigger.new);
}
