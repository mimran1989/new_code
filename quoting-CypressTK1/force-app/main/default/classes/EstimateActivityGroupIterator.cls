/**
 *  Provus Services Quoting
 *  EstimateQuoteGroupIterator
 *  @2022 Provus Inc. All rights reserved.
 */
public with sharing class EstimateActivityGroupIterator implements Iterator<ActivityGroup__c> {
	private List<ActivityGroup__c> activityGroups;
	private Integer currentIndex = -1;

	public EstimateActivityGroupIterator(List<ActivityGroup__c> activityGroups) {
		this.activityGroups = activityGroups;
	}

	/**
	 * @return true if there is another activity group to be returned
	 */
	public Boolean hasNext() {
		Boolean hasNext = false;
		Integer currentIndexOffset = 1;
		while (currentIndex + currentIndexOffset < activityGroups.size()) {
			ActivityGroup__c actGrp = activityGroups[currentIndex + currentIndexOffset];
			if (actGrp.RoleSummaries__r != null && actGrp.RoleSummaries__r.size() > 0) {
				// update index offset
				currentIndex += currentIndexOffset - 1;
				return hasNext = true;
			}
			currentIndexOffset++;
		}

		return hasNext;
	}

	/**
	 * @return returns next available activity group record if one exists
	 */
	public ActivityGroup__c next() {
		currentIndex++;
		return activityGroups[currentIndex];
	}
}
