
export class Camera
	new: (@pos={x: 0, y: 0}) =>
		
		
	move: =>
		if input\down("left")
			@pos.x -= 1
		if input\down("right")
			@pos.x += 1
		if input\down("up")
			@pos.y -= 1
		if input\down("down")
			@pos.y += 1
	
	followObject: (obj) =>
		if obj then
			@pos.x = obj.pos.x - GAME_WIDTH/2
			@pos.y = obj.pos.y - GAME_HEIGHT/2
	
	limitPos: (room) =>
		width  = (room.map.width * room.map.tilewidth) - GAME_WIDTH
		height = (room.map.height * room.map.tileheight) - GAME_HEIGHT
		
		@pos.x = clamp(0, @pos.x, width)
		@pos.y = clamp(0, @pos.y, height)
		
	update: =>
		if game.state.player
			@\followObject(game.state.player)
		if game.state.current_room
			@\limitPos(game.state.current_room)