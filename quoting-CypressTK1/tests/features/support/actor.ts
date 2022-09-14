import { AbilityRequestError, MissingAbilityError, UnsupportedTaskError } from './types/errors';
import World from '../../support/world';
import { AuthenticatedUser } from '../abilities/authenticate';
import Connect from '../tasks/interactions/connect';
import Login from '../tasks/login';
import Assign from '../tasks/permissions';
import { KeyChain } from './keychain';
import { createActorTask, Task } from './task';

export interface AbilityFactory<T> {
	create(): T;
}
export declare type AbilityType<T> = T extends AbilityFactory<infer FA> ? FA : T;
export const isAbilityFactory = (
	ability: any,
): ability is AbilityFactory<any> => typeof ability === 'object' && typeof ability.create === 'function';

// export declare const isAbilityFactory: (ability: any) => ability is AbilityFactory<any>;
export type DefaultFunction<T> = () => T;

const PREPARE_TASKS: Task<any>[] = [
	Connect.withCredentials, // open a bulk api connection to salesforce
	Assign.permissionSets, // assign the required permission sets for this user role
	Assign.features, // enable the required features for this user role
	Login.withCredentials, // login using the user interface
];

export class Actor {
	readonly world: typeof World;
	readonly name: string;
	protected abilities: object[];
	protected preparing: boolean = false;
	private readonly memory;

	constructor(abilities: object[], world: typeof World, name: string) {
		this.abilities = abilities;
		this.world = world;
		this.name = name;
		this.memory = new Map();
	}

	ability<T extends object>(type: { new(): T }): T {
		// If the actor is not preparing, this method is misused.
		if (!this.preparing) {
			throw new AbilityRequestError();
		}

		// Search for the first matching ability.
		const ability = this.abilities
			.filter(
				(ctxAbility): ctxAbility is T => ctxAbility.constructor.name === type.prototype.constructor.name
				|| (ctxAbility as any)?.prototype?.constructor?.name === type.prototype.constructor.name,
			)
			.shift();

		// If no ability is found, throw an exception.
		if (!ability) {
			throw new MissingAbilityError();
		}

		return ability;
	}

	get isAuthenticated() {
		return this.hasAbility(AuthenticatedUser);
	}

	remember<T>(key: string, value: T) {
		this.memory.set(key, value);
	}

	recall<T>(key: string, defaultFunction?: DefaultFunction<T>): T {
		if (!this.memory.has(key) && defaultFunction) {
			this.memory.set(key, defaultFunction());
		}

		return this.memory.get(key);
	}

	prepare<T extends object>(
		interactions: { new(actor: Actor): T } | { new(actor: Actor): T }[],
	): T {
		// Try to create an instance of all interactions.
		this.preparing = true;

		const executor = (
			interactions instanceof Array ? interactions : [interactions]
		)
			.map((Interaction) => {
				try {
					return new Interaction(this);
				} catch (err) {
					// If the constructor threw a MissingAbilityError, this interaction is
					// no supported by the actor, so we skip it.
					if (err instanceof MissingAbilityError) {
						return null;
					}

					// All other errors are passed outside.
					throw err;
				}
			})
			.filter((e) => e !== null)
			.shift();

		this.preparing = false;

		if (executor === undefined || executor === null) {
			// If there was no matching interaction, raise an exception to indicate that
			// this task is not supported by the current actor.
			throw new UnsupportedTaskError(
				(interactions instanceof Array ? interactions : [interactions]).map(
					(interaction) => interaction.prototype.constructor.name,
				),
			);
		}

		return executor;
	}

	attemptsTo<R = any>(...tasks: Task<any>[]): R {
		let result;
		if (!this.isAuthenticated) {
			result = this.authenticateActor().then(() => this.executeTasks(tasks));
		} else {
			result = this.executeTasks(tasks);
		}

		return result;
	}

	executeTasks(authTasks: Task<any>[]) {
		let lastResult;
		for (let i = 0; i < authTasks.length; i++) {
			const task = authTasks[i];
			const prepped = this.prepare(task);
			lastResult = prepped.invoke(lastResult);
		}

		return lastResult;
	}

	authenticateActor() {
		const authTasks = [this.authenticateActorTask, ...PREPARE_TASKS];
		return cy.wrap(this.executeTasks(authTasks));
	}

	authenticateActorTask = createActorTask<Promise<void>>((actor) => KeyChain.checkout(actor));

	whoCan(ability: AuthenticatedUser) {
		this.abilities.push(ability);
	}

	hasAbility<T extends object>(ability: {
		new(): T;
	}): boolean {
		let result: boolean;
		const prevPreparingValue = this.preparing;
		try {
			this.preparing = true;
			result = !!this.ability(ability);
		} catch (e) {
			result = false;
		}

		this.preparing = prevPreparingValue;

		return result;
	}

	// ask<R>(...questions: Question<R>[]) {
	// 	for (let i = 0; i < questions.length; i++) {
	// 		const question = questions[i];
	// 		this.prepare(question).invoke();
	// 	}
	// }
}
