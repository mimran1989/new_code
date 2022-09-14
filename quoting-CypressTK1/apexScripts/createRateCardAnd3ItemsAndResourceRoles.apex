Create Resources, Rate Cards and Rate Card Items

Id resourceRoleTypeId = Schema.getGlobalDescribe()
.get(Schema.SObjectType.Product__c.getName())
.getDescribe()
.getRecordTypeInfosByName()
.get('Resource Role')
.getRecordTypeId();

List<Product__c> resourceRoles = new List<Product__c>();
Product__c product1 = new Product__c();
product1.IsActive__c = true;
product1.Name = 'Software Engineer';
product1.RecordTypeId = resourceRoleTypeId;
resourceRoles.add(product1);
Product__c product2 = new Product__c();
product2.IsActive__c = true;
product2.Name = 'Project Manager';
product2.RecordTypeId = resourceRoleTypeId;
resourceRoles.add(product2);
Product__c product3 = new Product__c();
product3.IsActive__c = true;
product3.Name = 'Configuration Engineer';
product3.RecordTypeId = resourceRoleTypeId;
resourceRoles.add(product3);
CRUDUtility.insertRecords(resourceRoles);

Date startDate = Date.parse('01/01/2018');
RateCard__c rateCard = new RateCard__c(
        Name = 'Skill & Resource Location',
        IsActive__c = true,
        ExpirationDate__c = startDate.addYears(100),
        EffectiveDate__c = startDate
);
CRUDUtility.insertRecords(rateCard);

List<RateCardItem__c> rateCardItems = new List<RateCardItem__c>();
for (Product__c role : resourceRoles) {
    RateCardItem__c rateCardItem = new RateCardItem__c(
            IsActive__c = true,
            RateCardId__c = rateCard.Id,
            ProductId__c = role.Id,
            LocationCountry__c = 'United States',
            LocationStateProvince__c = 'California',
            PriceUOM__c = 'Monthly',
            UnitCost__c = 7000,
            UnitPrice__c = 10000,
            SkillLevel__c = 'L2',
            LocationDisplayName__c = 'United States/California'
    );

    RateCardItem__c rateCardItem2 = new RateCardItem__c(
            IsActive__c = true,
            RateCardId__c = rateCard.Id,
            ProductId__c = role.Id,
            LocationCountry__c = 'United States',
            LocationStateProvince__c = 'California',
            PriceUOM__c = 'Daily',
            UnitCost__c = 300,
            UnitPrice__c = 500,
            SkillLevel__c = 'L2',
            LocationDisplayName__c = 'United States/California'
    );

    rateCardItems.add(rateCardItem);
    rateCardItems.add(rateCardItem2);
}

CRUDUtility.insertRecords(rateCardItems);