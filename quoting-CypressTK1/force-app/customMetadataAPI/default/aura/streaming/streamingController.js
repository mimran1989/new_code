/* global $A */
({
	doInit: function(component) {
		const action = component.get('c.getSessionId');
		action.setCallback(this, (response) => {
			// Configure CometD for this component
			const sessionId = response.getReturnValue();
			const cometd = new window.org.cometd.CometD();
			cometd.configure({
				url: `${window.location.protocol}//${window.location.hostname}/cometd/41.0/`,
				requestHeaders: { Authorization: `OAuth ${sessionId}` },
				appendMessageTypeToURL: false,
			});
			cometd.websocketEnabled = false;
			component.set('v.cometd', cometd);

			// Connect to
			cometd.handshake($A.getCallback((status) => {
				if (status.successful) {
					const eventName = component.get('v.channel');

					const subscription = cometd.subscribe(eventName, $A.getCallback((message) => {
						const messageEvent = component.getEvent('onMessage');
						if (messageEvent != null) {
							messageEvent.setParam('payload', message.data.payload);
							messageEvent.fire();
						}
					}));

					component.set('v.subscription', subscription);
				} else {
					// TODO: Throw an event / set error property here?
					// console.error(`streaming component: ${status}`);
				}
			}));
		});
		$A.enqueueAction(action);
	},
	handleDestroy: function(component) {
		// Ensure this component unsubscribes and disconnects from the server
		const cometd = component.get('v.cometd');
		const subscription = component.get('v.subscription');
		cometd.unsubscribe(subscription, {}, (unsubscribeReply) => {
			if (unsubscribeReply.successful) {
				cometd.disconnect((disconnectReply)
				=> {
					// console.log('streaming component: Success unsubscribe');

					if (disconnectReply.successful) {
						// console.log('streaming component: Success disconnect');
					} else {
						// console.error('streaming component: Failed disconnect');
					}
				});
			} else {
				// console.error('streaming component: Failed unsubscribe');
			}
		});
	},
});
