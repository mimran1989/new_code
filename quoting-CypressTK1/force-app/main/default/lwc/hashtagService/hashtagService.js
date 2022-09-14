/**
 *  Provus Services Quoting
 *  hashtagService
 *  @2022 Provus Inc. All rights reserved.
 */
import getHashtagDictionaryForEstimate from '@salesforce/apex/HashtagServiceController.getHashtagDictionaryForEstimate';
import getHashtagDictionaryForEstimateTemplate from '@salesforce/apex/HashtagServiceController.getHashtagDictionaryForEstimateTemplate';

export default class HashtagService {
	hashtagDictionary = {};

	getDictionary() {
		return this.hashtagDictionary;
	}

	async loadHashtags(estimateId) {
		this.hashtagDictionary = await getHashtagDictionaryForEstimate({ estimateId });
	}

	async loadHashtagsForEstimateTemplate(estimateTemplateId) {
		this.hashtagDictionary = await getHashtagDictionaryForEstimateTemplate({ estimateTemplateId });
	}

	getHashtag(hashtag) {
		return this.hashtagDictionary[hashtag];
	}

	setHashtag(hashtag, value) {
		this.hashtagDictionary[hashtag] = value;
	}

	deleteHashtag(hashtag) {
		delete this.hashtagDictionary[hashtag];
	}
}
