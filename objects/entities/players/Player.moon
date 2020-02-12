
export class Player
	new: (@pos = {x: 0, 0}, @width=16, @height=16) =>
		
		@vel = {x: 0, y: 0}
		@sprite = sprites.player.idle
		
		@state = PlayerIdleState(@)
	
	destroy: =>
		-- print("Player destroy called")
	
		@destroyed = true
		-- Remove Player from physics world
		world = game.state.current_room.world
		if world
			world\remove(@)
	
	update: =>
		@state\update!
		limitPosToCurrentRoom(@)
		
	draw: =>
		@state\draw!