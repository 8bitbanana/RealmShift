
export class OverworldEnemy
	new: (@pos = {x: 0, y: 0}) =>
		-- @dir = math.random(4)
		@spd = 1.5 -- speed in seconds it takes to move across a tile
		@wait = 0.75

		@timer = Timer!
		@\startChase!

	startChase: =>
		@timer\after(@wait, @\chasePlayer)

	addVariation: (n, p=0.10) =>
		-- p: percentage chance to add variation
		if math.random() <= p
			-- Swap direction
			return (n * -1)

		return n


	chasePlayer: =>
		p = game.state.player
		-- Get xy distance of enemy to player
		dx = p.pos.x - @pos.x
		dy = p.pos.y - @pos.y
		-- Normalize distances to end up with -1, 0 or 1
		dx /= abs(dx) if dx ~= 0
		dy /= abs(dy) if dy ~= 0

		-- Add some random variation
		dx = @\addVariation(dx)
		dy = @\addVariation(dy)

		print(dx, dy)

		-- Target xy position one tile closer to player
		tx = @pos.x + (dx * 8)
		ty = @pos.y + (dy * 8)

		-- Move to target position then call startChase again when target is reached
		@timer\tween(@spd, @pos, {x: tx, y: ty}, 'out-elastic', @\startChase)

	checkCollidePlayer: =>
		p = game.state.player
		rect1 = {x: p.pos.x, y: p.pos.y, width: p.width, height: p.height}
		rect2 = {x: @pos.x, y: @pos.y, width: 8, height: 8}

		if AABB(rect1, rect2)
			print("Transition to Battle state!")
			game.next_state = {state: GameBattleState, params: {p.pos.x, p.pos.y}}

	destroy: =>
		print("OverworldEnemy destroy called")
		@timer\destroy!
		@destroyed = true

	update: =>
		@timer\update(dt)
		@\checkCollidePlayer!

	draw: =>
		sprites.overworld.enemy\draw(@pos.x, @pos.y)

