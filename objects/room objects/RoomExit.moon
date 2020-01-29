
export class RoomExit
	new: (@pos={x: 0, y: 0}, @width=16, @height=16, @dest="test_room_1", @tx=0, @ty=0) =>
		
	
	draw: =>
		lg.setColor(ORANGE)
		lg.rectangle("line", @pos.x, @pos.y, @width, @height)
		lg.print({BLACK, "Dest: #{@dest}"}, @pos.x+1, @pos.y-15)
		lg.setColor(WHITE)
		lg.print("Dest: #{@dest}", @pos.x, @pos.y-16)