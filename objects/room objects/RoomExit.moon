
export class RoomExit
	new: (@pos={x: 0, y: 0}, @width=16, @height=16, @dest_room="test_town", @is_door=false, @tx=0, @ty=0) =>
		-- RoomExits are created when the current Room calls loadObjects.
		-- RoomExits are created with default values shown above and then
		-- have their custom values assigned in createMapObject in Room.moon

		--print("RoomExit: #{@dest_room}, #{@is_door}, #{@tx}, #{@ty}")

	gotoOverworld: =>
		-- game.next_state = {state: GameOverworldState, params: {}}
		-- game.next_state = {state: GameTransitionState, params: {GameOverworldState}}
		game.next_state = {state: GameOverworldState, params: {}}

	gotoRoom: =>
		-- game.next_state = {state: GameExploreState, params: {@dest_room, @tx, @ty}}
		-- game.next_state = {state: GameTransitionState, params: {GameExploreState, @dest_room}}
		game.next_state = {state: GameExploreState, params: {@dest_room, @tx, @ty}}

	changeRoom: =>
		if @dest_room == "overworld"
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
					game.button_prompts.z = "Enter"
					if input\pressed("open_door")
						@\changeRoom!
				else
					@\changeRoom!


	update: =>
		@\checkPlayerEntered!

	draw: =>
		lg.setColor(ORANGE)
		lg.rectangle("line", @pos.x, @pos.y, @width, @height)
		lg.print({BLACK, "Dest: #{@dest_room}"}, @pos.x+1, @pos.y-15)
		lg.setColor(WHITE)
		lg.print("Dest: #{@dest_room}", @pos.x, @pos.y-16)
