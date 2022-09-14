import { UserInfo } from 'jsforce';
import { KeyChainEntry } from '../support/keychain';

export class AuthenticatedUser {
	static type: string = 'authenticate';
	readonly username: string;
	readonly password: string;
	readonly loginUrl: string;
	readonly keys: KeyChainEntry;

	private _loggedIn = false;
	private _connected = false;
	private _accessToken: string;
	private _instanceUrl: string;
	private _userInfo: UserInfo;

	constructor(username?: string | KeyChainEntry, password?: string, loginUrl?: string) {
		if (username && !password) {
			this.keys = username as KeyChainEntry;
			this.username = this.keys.username;
			this.password = this.keys.password;
			this.loginUrl = this.keys.loginUrl;
		} else {
			this.username = username as string;
			this.password = password;
			this.loginUrl = loginUrl;
		}

		const loginArray = this.loginUrl.split('.');
		const loginPrefix = loginArray[0].split('://')[1];
		if (loginPrefix !== 'login' && loginPrefix !== 'test') {
			if (loginArray[loginArray.length - 3] !== 'my') {
				// console.error('The URL for the Salesforce instance is wrong. Use a MyDomain URL such as https://your-domain.my.salesforce.com/');
				// throw new Error('The URL for the Salesforce instance is wrong. Use a MyDomain URL such as https://your-domain.my.salesforce.com/');
			}
		}
	}

	// eslint-disable-next-line class-methods-use-this
	get type(): string {
		return AuthenticatedUser.type;
	}

	get isLoggedIn(): boolean {
		return this._loggedIn;
	}

	get isConnected(): boolean {
		return this._connected;
	}

	get instanceUrl() {
		return this._instanceUrl;
	}

	get userInfo() {
		return this._userInfo;
	}

	loggedIn(): void {
		this._loggedIn = true;
	}

	logout(): void {
		this._loggedIn = false;
	}

	connected({
		accessToken,
		instanceUrl,
		userInfo,
	}: { accessToken: string, instanceUrl: string, userInfo: UserInfo}) {
		this._accessToken = accessToken;
		this._instanceUrl = instanceUrl;
		this._userInfo = userInfo;
		this._connected = true;
	}
}

export const Authenticate = {
	usingUsernameAndPassword: (username: string, password: string, loginUrl: string) => new AuthenticatedUser(username, password, loginUrl),
	withKeys: (keys: KeyChainEntry) => new AuthenticatedUser(keys),
};
