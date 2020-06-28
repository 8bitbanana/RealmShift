
export class BridgeZone
	new: (@pos={x: 0, y: 0}, @width=16, @height=16) =>
		@has_bridge = false

	init: =>


	checkPlayerBridge: =>
		@has_bridge = false

		world = game.state.current_room.world
		player = game.state.player

		_, _, cols, len = world\check(@, @pos.x, @pos.y)
		for c in *cols
			other = c.other
			if other == player
				if game.inventory\hasItem(BridgeItem)
					@has_bridge = true

	update: =>
		@\checkPlayerBridge!

	drawBridge: =>
		sprites.overworld.bridge\draw(216, 136)

	draw: =>
		if @has_bridge
			@\drawBridge!
-- 		lg.setColor(ORANGE)
-- 		lg.rectangle("line", @pos.x, @pos.y, @width, @height)
