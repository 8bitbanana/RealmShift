
export class RoomExit
	new: (@pos={x: 0, y: 0}, @width=16, @height=16, @dest="test_room_1", @tx=0, @ty=0) =>
		
	
	gotoOverworld: =>
		print("gotoOverworld")
		-- game.state\changeState(GameOverworldState)
		game.next_state = GameOverworldState
	
	gotoRoom: =>
		
	
	changeRoom: =>
		if @dest == "overworld"
			@\gotoOverworld!
		else
			@\gotoRoom!
	
	checkPlayerEntered: =>
		p = game.state.player
		if p
			hw = p.width/2
			hh = p.height/2
			
			point = {x: p.pos.x+hw, y: p.pos.y+hh}
			box   = {x: @pos.x, y: @pos.y, width: @width, height: @height}
			
			if pointBoxCollision(point, box)
				@\changeRoom!
			
	
	update: =>
		@\checkPlayerEntered!
	
	draw: =>
		lg.setColor(ORANGE)
		lg.rectangle("line", @pos.x, @pos.y, @width, @height)
		lg.print({BLACK, "Dest: #{@dest}"}, @pos.x+1, @pos.y-15)
		lg.setColor(WHITE)
		lg.print("Dest: #{@dest}", @pos.x, @pos.y-16)