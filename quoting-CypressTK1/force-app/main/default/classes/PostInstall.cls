/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global class PostInstall implements InstallHandler {
	global void onInstall(InstallContext context) {
		if (context.isUpgrade()) {
			PostInstallAdjustments.onInstall(context);
		}
	}
}
