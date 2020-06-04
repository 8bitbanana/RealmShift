
export class OverworldEnemy
	new: (@pos = {x: 0, y: 0}) =>
		@dir = math.random(4)
		@spd = 0.5 -- speed in seconds it takes to move across a tile
		@timer = Timer!

	checkCollidePlayer: =>
		p = game.state.player
		rect1 = {x: p.pos.x, y: p.pos.y, width: p.width, height: p.height}
		rect2 = {x: @pos.x, y: @pos.y, width: 8, height: 8}

		if AABB(rect1, rect2)
			print("Transition to Battle state!")
			game.next_state = {state: GameBattleState, params: {p.pos.x, p.pos.y}}


	update: =>
		@timer\update(dt)
		@\checkCollidePlayer!

	draw: =>
		sprites.overworld.enemy\draw(@pos.x, @pos.y)

