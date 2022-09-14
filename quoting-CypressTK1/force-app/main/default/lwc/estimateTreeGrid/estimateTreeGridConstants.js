// estimate schema
import ESTIMATE_SYNC_TO_QUOTE_FIELD from '@salesforce/schema/Estimate__c.IsSyncChangesToQuote__c';
import ESTIMATENAME_FIELD from '@salesforce/schema/Estimate__c.Name';
import ESTIMATENAME_LINKED_QUOTE_FIELD from '@salesforce/schema/Estimate__c.QuoteId__c';
import RATECARD_ID_FIELD from '@salesforce/schema/Estimate__c.RateCardId__c';
import USE_PROJECT_PHASES_FIELD from '@salesforce/schema/Estimate__c.UseProjectPhases__c';
// task role summary schema
import LEVELADJUSTMENT_FIELD from '@salesforce/schema/TaskRoleSummary__c.LevelAdjustment__c';
import RESOURCEROLE_FIELD from '@salesforce/schema/TaskRoleSummary__c.ResourceRole__c';
import TOTALADJUSTMENT_FIELD from '@salesforce/schema/TaskRoleSummary__c.TotalAdjustments__c';
import TOTALCALCULATEDURATION_FIELD from '@salesforce/schema/TaskRoleSummary__c.TotalCalculatedDuration__c';
import TOTALESTIMATEDDURATION_FIELD from '@salesforce/schema/TaskRoleSummary__c.TotalEstimatedDuration__c';
// labels
import LABEL_ADJUST_HOURS from '@salesforce/label/c.AdjustHours';
import LABEL_LEVEL_ADJUSTMENT from '@salesforce/label/c.LevelAdjustment';
import LABEL_RESOURCE from '@salesforce/label/c.Resource';
import LABEL_ROLLED_UP_ADJUSTMENTS from '@salesforce/label/c.RolledUpAdjustments';
import LABEL_ROLLED_UP_CALCULATED_DURATION from '@salesforce/label/c.RolledUpCalculatedDuration';
import LABEL_ROLLED_UP_ESTIMATED_DURATION from '@salesforce/label/c.EstimatedDuration';
import LABEL_SPECIFY_AVAILABILITY from '@salesforce/label/c.SpecifyAvailability';
import LABEL_SPLIT_RESOURCE from '@salesforce/label/c.SplitResource';

const ResourceRowActions = {
	ADJUST_HOURS: { label: LABEL_ADJUST_HOURS, name: 'adjust_hours' },
	SPECIFY_AVAILABILITY: { label: LABEL_SPECIFY_AVAILABILITY, name: 'specify_availability' },
	SPLIT: { label: LABEL_SPLIT_RESOURCE, name: 'split' },
};

const FIELDS = [
	ESTIMATENAME_FIELD,
	USE_PROJECT_PHASES_FIELD,
	RATECARD_ID_FIELD,
	ESTIMATE_SYNC_TO_QUOTE_FIELD,
	ESTIMATENAME_LINKED_QUOTE_FIELD,
];

const FIELD_RESOURCE_SPLITS = 'ResourceSplits';

const actions = [
	ResourceRowActions.ADJUST_HOURS,
];

const activityGroupActions = [
	...actions,
	ResourceRowActions.SPECIFY_AVAILABILITY,
	ResourceRowActions.SPLIT,
];

const baseSummaryColumns = [
	{
		label: LABEL_RESOURCE, fieldName: RESOURCEROLE_FIELD.fieldApiName, type: 'text', editable: false, sortable: 'true',
	},
	{
		label: LABEL_ROLLED_UP_CALCULATED_DURATION, fieldName: TOTALCALCULATEDURATION_FIELD.fieldApiName, type: 'number', editable: false,
	},
	{
		label: LABEL_ROLLED_UP_ADJUSTMENTS, fieldName: TOTALADJUSTMENT_FIELD.fieldApiName, type: 'number', editable: false, sortable: 'true',
	},
	{
		label: LABEL_LEVEL_ADJUSTMENT, fieldName: LEVELADJUSTMENT_FIELD.fieldApiName, type: 'number', editable: true,
	},
	{
		label: LABEL_ROLLED_UP_ESTIMATED_DURATION, fieldName: TOTALESTIMATEDDURATION_FIELD.fieldApiName, type: 'number', editable: false, sortable: 'true',
	},
];

const HASHTAG_USER_INPUT = 'user_input';

export {
	FIELDS,
	FIELD_RESOURCE_SPLITS,
	HASHTAG_USER_INPUT,
	actions,
	activityGroupActions,
	baseSummaryColumns,
};
