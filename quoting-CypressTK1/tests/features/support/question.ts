import UseCypress from '../abilities/useCypress';
import { AbilityType, Actor, isAbilityFactory } from './actor';

/**
 * Type definition for question interactions.
 */
export interface QuestionInteraction<R> {
  invoke(assert: (answer: R) => void): void;
}

/**
 * Type definition for questions.
 *
 * An question is a list of interactions that accept a parameter of type P and
 * and accept an assertion callback of type R.
 */
type QuestionType<R> = { new(actor: Actor): QuestionInteraction<R> };
export type Question<R> = QuestionType<R> | QuestionType<R>[];
export type QuestionProcedure<A extends object, R> = (
  ability: AbilityType<A>,
  assert: (answer: R) => void,
) => void;

/**
 * Shorthand for creating questions using a specific ability.
 *
 * @param ability
 *   A constructor for an ability service.
 * @param procedure
 *   The procedure to answer this question.
 */
export function createQuestion<A extends object, R>(
	ability: { new(): A },
	procedure: QuestionProcedure<A, R>,
) {
	return class implements QuestionInteraction<R> {
	/**
	 * A ability service object to invoke commands on.
	 */
	public ability?: A;

	/**
	 * An actor to perform sub-tasks.
	 */
	public actor?: Actor;

	constructor(actor: Actor) {
		this.actor = actor;
		this.ability = actor.ability(ability);
	}
	invoke(assert: (answer: R) => void): void {
		if (this.ability) {
			procedure(
				isAbilityFactory(this.ability) ? this.ability.create() : this.ability,
				assert,
			);
		}
	}
	};
}

export function createCypressQuestion<R>(
	procedure: QuestionProcedure<UseCypress, R>,
) {
	return createQuestion<UseCypress, R>(UseCypress, procedure);
}
