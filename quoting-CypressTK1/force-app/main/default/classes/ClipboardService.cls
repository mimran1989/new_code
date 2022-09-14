/**
 *  Provus Services Quoting
 *  ClipboardService
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class ClipboardService {
	@AuraEnabled
	public static void copyToClipboard(String parentId, String type) {
		List<Clipboard__e> clipboardEvents = new List<Clipboard__e>();
		clipboardEvents.add(new Clipboard__e(ParentId__c = parentId, Type__c = type));
		EventBus.publish(clipboardEvents);
	}
}
