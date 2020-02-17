
export class RoomExit
	new: (@pos={x: 0, y: 0}, @width=16, @height=16, @dest="test_town", @is_door=false, @tx=0, @ty=0) =>
		
	
	gotoOverworld: =>
		-- game.next_state = {state: GameOverworldState, params: {}}
		game.next_state = {state: GameTransitionState, params: {GameOverworldState}}
	
	gotoRoom: =>
		-- game.next_state = {state: GameExploreState, params: {@dest, @tx, @ty}}
		game.next_state = {state: GameTransitionState, params: {GameExploreState, @dest}}
		print("@dest: #{@dest}")
	
	changeRoom: =>
		if @dest == "overworld"
			@\gotoOverworld!
		else
			@\gotoRoom!
	
	checkPlayerEntered: =>
		p = game.state.player
		if p			
			box1 = {x: p.pos.x, y: p.pos.y, width: p.width, height: p.height}
			box2 = {x: @pos.x, y: @pos.y, width: @width, height: @height}
			
			if AABB(box1, box2)
				if @is_door
					if input\pressed("open_door")
						@\changeRoom!
				else
					@\changeRoom!
			
	
	update: =>
		@\checkPlayerEntered!
	
	draw: =>
		lg.setColor(ORANGE)
		lg.rectangle("line", @pos.x, @pos.y, @width, @height)
		lg.print({BLACK, "Dest: #{@dest}"}, @pos.x+1, @pos.y-15)
		lg.setColor(WHITE)
		lg.print("Dest: #{@dest}", @pos.x, @pos.y-16)