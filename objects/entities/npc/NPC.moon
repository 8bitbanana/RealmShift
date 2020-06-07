
require "objects/entities/player/Player"

export class NPC extends Player
	new: (@pos = {x: 0, y: 0}) =>
		@width = 16
		@height = 16

		@vel = {x: 0, y: 0}
		@sprite = sprites.player.idle

		@state = NPCWanderState(@)
