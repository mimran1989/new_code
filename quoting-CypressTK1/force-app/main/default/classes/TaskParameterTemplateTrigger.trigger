/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
trigger TaskParameterTemplateTrigger on TaskParameterTemplate__c(after insert, after update) {
	TaskParameterTemplateTriggers.processTriggers(Trigger.oldMap, Trigger.new, Trigger.isBefore);
}
