
export class Room
	new: (room_path) =>
		@world = Bump.newWorld!
		@map = STI("rooms/#{room_path}.lua", {"bump"})
		@map\bump_init(@world)
	
	update: =>
		@map\update(dt)
		
	draw: (pos={x: 0, y: 0}) =>
		lg.setColor(WHITE)
		@map\draw(-pos.x, -pos.y)
		
		if SHOW_COLLIDERS
			lg.setColor(RED)
			@map\bump_draw(@world, -pos.x, -pos.y)