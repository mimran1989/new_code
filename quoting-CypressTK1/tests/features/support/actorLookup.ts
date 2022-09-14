import { Actor } from './actor';
import World from '../../support/world';
import UseCypress from '../abilities/useCypress';

export default class ActorLookup {
	private readonly actorByName = new Map<string, Actor>()
	private _lastActor: Actor;
	public findOrCreateActor(world: typeof World, actorName: string): Actor {
		let actor = this.actorByName.get(actorName);
		if (actor === undefined) {
			const actorNameLower = actorName.toLowerCase();
			if (actorNameLower === 'he' || actorNameLower === 'she') {
				actor = this._lastActor;
			} else {
				actor = new Actor([new UseCypress()], World, actorName);
				this.actorByName.set(actorName, actor);
			}
		}

		this._lastActor = actor;
		return actor;
	}

	public get actors(): IterableIterator<Actor> {
		return this.actorByName.values();
	}

	public get lastActor(): Actor {
		return this._lastActor;
	}
}
