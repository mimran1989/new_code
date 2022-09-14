import { After, Before } from '@badeball/cypress-cucumber-preprocessor';
import messages from '@cucumber/messages';
import ActorParameterType from '../features/support/types/actorParameterType';
import DateParameterType from '../features/support/types/dateParameterType';
import { KeyChain } from '../features/support/keychain';
import World from '../support/world';

ActorParameterType();
DateParameterType();

declare const testState: {
	gherkinDocument: messages.GherkinDocument,
	pickles: messages.Pickle[],
	pickle: messages.Pickle,
	pickleStep?: messages.PickleStep,
};

// this context is not correct if the callback is an arrow fn
// eslint-disable-next-line prefer-arrow-callback
Before(function() {
	const { tags } = testState.pickle;
	const enabledFeatures = {};
	tags.forEach((tag) => {
		if (tag.name.includes('@feature-flag')) {
			const openMarkerIdx = tag.name.indexOf('[');
			const closeMarkerIdx = tag.name.indexOf(']');
			tag.name.substring(openMarkerIdx + 1, closeMarkerIdx).split(',')
				.forEach((featureString) => {
					const stringSplit = featureString.split(':');
					const featureName = stringSplit[0];
					const isOn = stringSplit[1] === 'on';
					enabledFeatures[featureName] = isOn;
				});
		}
	});
	World.features = enabledFeatures;
});

After(() => {
	KeyChain.checkInAllKeys();
});
