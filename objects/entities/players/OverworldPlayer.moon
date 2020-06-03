
export class OverworldPlayer
	new: (@pos = {x: 48, y: 48}) =>
		@width  = 16
		@height = 16

	checkMove: =>
		interval = 0.25

		if input\down("left", interval)
			@\move(-1, 0)
		if input\down("right", interval)
			@\move(1, 0)
		if input\down("up", interval)
			@\move(0, -1)
		if input\down("down", interval)
			@\move(0, 1)

	move: (dx=0, dy=0) =>
		-- get Physics world of Overworld
		world = game.state.current_room.world
		-- Move player and deal with collisions
		d = 8 -- Distance to move
		@pos.x, @pos.y = world\move(@, @pos.x + (dx * d), @pos.y + (dy * d))

	update: =>
		@\checkMove!

		limitPosToCurrentRoom(@)

	destroy: =>
		-- print("Player destroy called")

		@destroyed = true
		-- Remove Player from physics world
		world = game.state.current_room.world
		if world
			world\remove(@)

	draw: =>
		x = @pos.x
		y = @pos.y

		-- Draw Temporary Player Counter
		lg.setColor(ORANGE)
		lg.circle("fill", x+7, y+8, 8)
		lg.setColor(WHITE)
		lg.circle("line", x+7, y+8, 8)
		lg.print({BLACK, "P"}, x+5, y+1)
		lg.print({WHITE, "P"}, x+4, y)

-- 		lg.setColor(RED)
-- 		lg.rectangle("line", x, y, @width, @height)
