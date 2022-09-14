/**
 *  Provus Services Quoting
 *  EstimatorTestsBase
 *  @2021 Provus Inc. All rights reserved.
 */
public with sharing abstract class EstimateTestBase extends TestBase {
	public static final String GUIDANCE = 'sample guidance for test';
	public static final String DESCRIPTION = 'sample description for test';
	static final String TEST_ESTIMATE_W_RESOURCE_SPLIT_NAME = 'Test Estimate With Resource Splits';
	public static final String TEST_SPLIT_QUOTE = 'Split Quote';
	static final String SUMMARYLEVEL_ACTIVITYGROUP = EstimatorConstants.ACTIVITY_GROUP;

	public static ActivityGroup__c createNewActivityGroup(Id estimateId) {
		ActivityGroup__c groupSo = new ActivityGroup__c(EstimateId__c = estimateId);
		CRUDUtility.insertRecords(groupSo);
		return groupSo;
	}

	public static List<Product__c> createResourceRoles() {
		Id resourceRoleTypeId = SObjectUtility.getRecordTypeIdbyName(
			Schema.SObjectType.Product__c.getName(),
			'Resource Role'
		);

		List<Product__c> resourceRoles = new List<Product__c>();
		resourceRoles.add(newProduct('Software Engineer', resourceRoleTypeId));
		resourceRoles.add(newProduct('Project Manager', resourceRoleTypeId));
		resourceRoles.add(newProduct('Configuration Engineer', resourceRoleTypeId));

		CRUDUtility.insertRecords(resourceRoles);
		return resourceRoles;
	}

	public static RateCardItem__c newRateCardItem(
		Map<String, Object> rateCardItemValues,
		Id productId
	) {
		RateCardItem__c rateCardItem = new RateCardItem__c(
			IsActive__c = true,
			ProductId__c = productId
		);
		for (String field : rateCardItemValues.keySet()) {
			rateCardItem.put(field, rateCardItemValues.get(field));
		}

		return rateCardItem;
	}

	public static RateCard__c newRateCardWithItems(List<Product__c> resourceRoles) {
		RateCard__c rateCard = newRateCard();
		Map<String, Object> rateCardItemValues = new Map<String, Object>();
		rateCardItemValues.put('RateCardId__c', (String) rateCard.Id);
		//rateCardItemValues.add('ProductId__c', role.Id);
		rateCardItemValues.put('LocationCountry__c', 'United States');
		rateCardItemValues.put('SkillLevel__c', 'L1');
		rateCardItemValues.put('LocationDisplayName__c', 'United States/California');

		List<RateCardItem__c> rateCardItems = new List<RateCardItem__c>();
		for (Product__c role : resourceRoles) {
			rateCardItems.add(newRateCardItem(rateCardItemValues, role.Id));
		}

		rateCardItemValues.put('SkillLevel__c', 'L2');
		for (Product__c role : resourceRoles) {
			rateCardItems.add(newRateCardItem(rateCardItemValues, role.Id));
		}

		if (!rateCardItems.isEmpty()) {
			CRUDUtility.insertRecords(rateCardItems);
		}

		return rateCard;
	}

	/**
	 * @param rateCardID rate card ID
	 * @param resourceRoles resource role Product__c records for estimate setup
	 */
	public static void createDataForSplitQuote(Id rateCardID, List<Product__c> resourceRoles) {
		Estimate__c testEstimateWithResourceSplits = new Estimate__c(
			Name = TEST_ESTIMATE_W_RESOURCE_SPLIT_NAME,
			IsActive__c = true,
			RateCardId__c = rateCardID,
			Guidance__c = 'sample guidance for test',
			Description__c = 'sample description for test'
		);
		CRUDUtility.insertRecords(testEstimateWithResourceSplits);

		List<ActivityGroup__c> activityGroups = new List<ActivityGroup__c>();
		ActivityGroup__c activityGroupInitiation = new ActivityGroup__c(
			EstimateId__c = testEstimateWithResourceSplits.Id,
			Name = 'Initiation',
			Sequence__c = 1,
			IsActive__c = true,
			Guidance__c = 'initiation activity group guidance',
			Description__c = 'initiation activity group description'
		);
		activityGroups.add(activityGroupInitiation);
		ActivityGroup__c activityGroupDesign = new ActivityGroup__c(
			EstimateId__c = testEstimateWithResourceSplits.Id,
			Name = 'Design',
			Sequence__c = 2,
			IsActive__c = true,
			Guidance__c = 'design activity group guidance',
			Description__c = 'design activity group description'
		);
		activityGroups.add(activityGroupDesign);
		CRUDUtility.insertRecords(activityGroups);

		List<TaskSummary__c> taskSummaries = new List<TaskSummary__c>();
		TaskSummary__c taskSumm1 = new TaskSummary__c();
		taskSummaries.add(taskSumm1);

		CRUDUtility.insertRecords(taskSummaries);

		List<TaskRoleSummary__c> taskRoleSummaries = new List<TaskRoleSummary__c>();
		TaskRoleSummary__c taskRoleSummary1 = createTaskRoleSummaryForActivityGroup(
			testEstimateWithResourceSplits.Id
		);
		taskRoleSummary1.ResourceRoleId__c = resourceRoles[0].Id;
		taskRoleSummary1.ActivityGroupId__c = activityGroups[0].Id;
		taskRoleSummary1.SummaryId__c = taskSumm1.Id;
		taskRoleSummaries.add(taskRoleSummary1);

		TaskRoleSummary__c taskRoleSummary2 = createTaskRoleSummaryForActivityGroup(
			testEstimateWithResourceSplits.Id
		);
		taskRoleSummary2.ResourceRoleId__c = resourceRoles[1].Id;
		taskRoleSummary2.ActivityGroupId__c = activityGroups[1].Id;
		taskRoleSummary2.SummaryId__c = taskSumm1.Id;
		taskRoleSummaries.add(taskRoleSummary2);

		TaskRoleSummary__c taskRoleSummary3 = createTaskRoleSummaryForActivityGroup(
			testEstimateWithResourceSplits.Id
		);
		taskRoleSummary3.ResourceRoleId__c = resourceRoles[2].Id;
		taskRoleSummary3.ActivityGroupId__c = activityGroups[0].Id;
		taskRoleSummary3.SummaryId__c = taskSumm1.Id;
		taskRoleSummaries.add(taskRoleSummary3);

		CRUDUtility.insertRecords(taskRoleSummaries);

		List<Task__c> tasks = new List<Task__c>();
		Task__c task1 = new Task__c();
		task1.EstimateId__c = testEstimateWithResourceSplits.Id;
		task1.ActivityGroupId__c = activityGroupInitiation.Id;
		task1.CalculatedDuration__c = 50;
		task1.EstimatedDuration__c = 50;
		task1.RoleSummaryId__c = taskRoleSummary1.Id;
		tasks.add(task1);

		Task__c task2 = new Task__c();
		task2.EstimateId__c = testEstimateWithResourceSplits.Id;
		task2.ActivityGroupId__c = activityGroupDesign.Id;
		task2.CalculatedDuration__c = 50;
		task2.EstimatedDuration__c = 50;
		task2.RoleSummaryId__c = taskRoleSummary2.Id;
		tasks.add(task2);

		Task__c task3 = new Task__c();
		task3.EstimateId__c = testEstimateWithResourceSplits.Id;
		task3.ActivityGroupId__c = activityGroupDesign.Id;
		task3.CalculatedDuration__c = 0;
		task3.EstimatedDuration__c = 0;
		task3.RoleSummaryId__c = taskRoleSummary3.Id;
		tasks.add(task3);

		CRUDUtility.insertRecords(tasks);

		taskRoleSummaries = [
			SELECT TotalEstimatedDuration__c
			FROM TaskRoleSummary__c
			WHERE EstimateId__c = :testEstimateWithResourceSplits.Id
			WITH SECURITY_ENFORCED
		];

		List<ResourceSplit__c> resourceSplits = new List<ResourceSplit__c>();
		ResourceSplit__c resourceSplit1 = new ResourceSplit__c(
			SplitPercentage__c = 40,
			Sequence__c = 1,
			TaskRoleSummaryId__c = taskRoleSummary1.Id
		);
		resourceSplits.add(resourceSplit1);
		ResourceSplit__c resourceSplit2 = new ResourceSplit__c(
			SplitPercentage__c = 60,
			Sequence__c = 2,
			TaskRoleSummaryId__c = taskRoleSummary1.Id
		);
		resourceSplits.add(resourceSplit2);
		ResourceSplit__c resourceSplit3 = new ResourceSplit__c(
			SplitPercentage__c = 50,
			Sequence__c = 1,
			TaskRoleSummaryId__c = taskRoleSummary2.Id
		);
		resourceSplits.add(resourceSplit3);
		ResourceSplit__c resourceSplit4 = new ResourceSplit__c(
			SplitPercentage__c = 50,
			Sequence__c = 2,
			TaskRoleSummaryId__c = taskRoleSummary2.Id
		);
		resourceSplits.add(resourceSplit4);
		CRUDUtility.insertRecords(resourceSplits);

		Quote__c splitQuote = newQuote(TEST_SPLIT_QUOTE);
		splitQuote.TimePeriod__c = 'Days';
		splitQuote.ServiceStartDate__c = Date.newInstance(2022, 1, 1);
		splitQuote.ServiceEndDate__c = DurationCalcs.endDate(
			100,
			splitQuote.Id,
			splitQuote.ServiceStartDate__c
		);
		splitQuote.EstimateId__c = testEstimateWithResourceSplits.Id;
		CRUDUtility.updateRecords(splitQuote);

		// create section
		QuoteSection__c section = new QuoteSection__c();
		section.Name = 'Quote Section';
		section.Sequence__c = 1;
		section.QuoteId__c = splitQuote.Id;
		CRUDUtility.insertRecords(section);
	}

	public static List<QuoteItemCell__c> getQuoteCellValues(Id quoteId) {
		List<QuoteItem__c> quoteItems = [
			SELECT Id
			FROM QuoteItem__c
			WHERE QuoteId__c = :quoteId
			WITH SECURITY_ENFORCED
		];
		Set<Id> quoteItemIds = (new Map<Id, QuoteItem__c>(quoteItems)).keySet();
		List<QuoteItemCell__c> quoteItemCells = QuoteItemCellService.getQuoteItemCellsByQuoteItemIds(
			quoteItemIds
		);

		return quoteItemCells;
	}

	static TaskRoleSummary__c createTaskRoleSummaryForActivityGroup(Id estimateId) {
		TaskRoleSummary__c taskRoleSummary = new TaskRoleSummary__c();
		taskRoleSummary.EstimateId__c = estimateId;
		taskRoleSummary.SummaryLevel__c = SUMMARYLEVEL_ACTIVITYGROUP;
		return taskRoleSummary;
	}
}
