// eslint-disable-next-line max-classes-per-file
import UseCypress from '../abilities/useCypress';
import { AbilityType, Actor, isAbilityFactory } from './actor';

export interface TaskInteraction<P> {
	invoke(previousParam: P): any;
}

declare type TaskType<P> = {
	new(actor: Actor): TaskInteraction<P>;
};

export declare type Task<P> = TaskType<P> | TaskType<P>[];

export declare type TaskProcedure<A extends object>
	= (ability: AbilityType<A>, cy: Cypress.cy & CyEventEmitter, actor: Actor, previousParam?: any) => any;

export declare type CypressTaskProcedure
	= (cy: Cypress.cy & CyEventEmitter, actor: Actor, previousParam?: any) => any;

export declare type ActorTaskProcedure
	= (actor: Actor, previousParam?: any) => any;

export function createActorTask<P = void>(procedure: ActorTaskProcedure): Task<P> {
	return class implements TaskInteraction<P> {
		/**
		 * An actor to perform sub-tasks.
		 */
		public actor?: Actor;

		constructor(actor: Actor) {
			this.actor = actor;
		}
		invoke(previousParam: any): any {
			return procedure(this.actor, previousParam);
		}
	};
}

export function createCypressTask(procedure: CypressTaskProcedure): Task<undefined> {
	return class implements TaskInteraction<undefined> {
		/**
		 * A ability service object to invoke commands on.
		*/
		public cypressAbility: UseCypress;
		/**
		 * An actor to perform sub-tasks.
		 */
		public actor?: Actor;

		constructor(actor: Actor) {
			this.actor = actor;
			this.cypressAbility = actor.ability(UseCypress);
		}
		invoke(previousParam: any): any {
			return procedure(this.cypressAbility.create(), this.actor,
				previousParam);
		}
	};
}

/**
 * Shorthand for creating tasks using a specific ability.
 *
 * @param ability
 *   A constructor for an ability service.
 * @param procedure
 *   The procedure to fulfill this task.
 */
export function createTask<A extends object>(
	ability: { new(): A },
	procedure: TaskProcedure<A>,
) {
	return class implements TaskInteraction<undefined> {
		/**
		 * A ability service object to invoke commands on.
		 */
		public ability?: A;
		/**
		 * A ability service object to invoke commands on.
		*/
		public cypressAbility: UseCypress;
		/**
		 * An actor to perform sub-tasks.
		 */
		public actor?: Actor;

		constructor(actor: Actor) {
			this.actor = actor;
			this.ability = actor.ability(ability);
			this.cypressAbility = actor.ability(UseCypress);
		}
		invoke(previousParam: any): any {
			return procedure(
				isAbilityFactory(this.ability) ? this.ability.create() : this.ability,
				this.cypressAbility.create(),
				this.actor,
				previousParam,
			);
		}
	};
}
