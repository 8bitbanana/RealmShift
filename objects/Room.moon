
export class Room
	new: (room_path) =>
		@map = STI("rooms/#{room_path}.lua")
	
	update: =>
		@map\update(dt)
		
	draw: (pos={x: 0, y: 0}) =>
		lg.setColor(WHITE)
		@map\draw(-pos.x, -pos.y)