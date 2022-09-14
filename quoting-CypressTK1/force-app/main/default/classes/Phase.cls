/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public with sharing class Phase {
	public static Phase__c newSO(PhaseTemplate__c templateSO) {
		Phase__c groupSO = new Phase__c();
		groupSO.Name = templateSO.Name;
		groupSO.Description__c = templateSO.Description__c;
		groupSO.Guidance__c = templateSO.Guidance__c;
		groupSO.Sequence__c = templateSO.Sequence__c;
		groupSO.IsActive__c = true;
		return groupSO;
	}
}
