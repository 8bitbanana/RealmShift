
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
		if obj
			@pos.x = obj.pos.x - GAME_WIDTH/2
			@pos.y = obj.pos.y - GAME_HEIGHT/2

	followObjectLerp: (obj, p=0.005) =>
		if obj
			tx = obj.pos.x - GAME_WIDTH/2
			ty = obj.pos.y - GAME_HEIGHT/2

			@pos.x = lerp(@pos.x, tx, p)
			@pos.y = lerp(@pos.y, ty, p)

	limitPos: (room) =>
		width  = (room.map.width * room.map.tilewidth) - GAME_WIDTH
		height = (room.map.height * room.map.tileheight) - GAME_HEIGHT

		@pos.x = clamp(0, @pos.x, width)
		@pos.y = clamp(0, @pos.y, height)

	update: =>
		if game.state.player
			@\followObjectLerp(game.state.player)
		if game.state.current_room
			@\limitPos(game.state.current_room)
