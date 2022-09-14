/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public class MetadataServiceSuport {
	public static MetadataPort createService() {
		return createService(UserInfo.getSessionId());
	}

	public static MetadataPort createService(String sessionId) {
		MetadataPort service = new MetadataPort();
		service.SessionHeader = new SessionHeaderElement();
		service.SessionHeader.sessionId = sessionId;
		return service;
	}
}
