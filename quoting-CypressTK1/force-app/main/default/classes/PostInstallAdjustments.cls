/*
 * Provus Services Quoting
 * Copyright (c) 2022 Provus Inc. All rights reserved.
 */
public class PostInstallAdjustments {
	public static void onInstall(InstallContext context) {
		PicklistMetadataService.PicklistValue volumeDiscountPicklistOption = new PicklistMetadataService.PicklistValue();
		volumeDiscountPicklistOption.label = 'Volume Discount';
		volumeDiscountPicklistOption.fullName = 'Volume Discount';
		volumeDiscountPicklistOption.isActive = true;
		volumeDiscountPicklistOption.isDefault = false;

		PicklistMetadataService.addPicklistValue(
			Schema.Adjustment__c.SObjectType,
			Schema.Adjustment__c.Method__c,
			volumeDiscountPicklistOption
		);

		PicklistMetadataService.PicklistValue laborRevenuePicklistOption = new PicklistMetadataService.PicklistValue();
		laborRevenuePicklistOption.label = 'Labor Revenue';
		laborRevenuePicklistOption.fullName = 'Labor Revenue';
		laborRevenuePicklistOption.isActive = true;
		laborRevenuePicklistOption.isDefault = false;

		PicklistMetadataService.addPicklistValue(
			Schema.VolumeDiscount__c.SObjectType,
			Schema.VolumeDiscount__c.Category__c,
			laborRevenuePicklistOption
		);
	}
}
