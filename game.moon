
export class Game
	new: () =>
		@state = GameExploreState(@)
		@next_state = nil

		-- Placed directly in game class for now
		@dialogbox = DialogBox("This is a test of the dialog box{pause,30}\nIt seems to work fairly well so far,\nalthough I did have to edit {colour,0,0,1,1,8}Push.lua.{pause,30}\n3{pause,30}\n4{pause,30}\n5{pause,30}\n6{pause,50}\n{wave,4}Wow!")
	
	init: =>
		@state\init!
	
	gotoNextState: =>
		@state\changeState(@next_state.state, @next_state.params)
		@next_state = nil
	
	update: =>
		if @state
			@state\update!
		@dialogbox\update 0

		-- DEBUG CODE, NEEDS TO BE MOVED --
		-----------------------------------
		if input\pressed "dialogdebug"
			if @dialogbox.done
				@dialogbox\reset!
			else
				@dialogbox\begin!
		-----------------------------------
		
		if @next_state
			@\gotoNextState!
		
	draw: =>
		if @state
			@state\draw!
		if @dialogbox.started
			@dialogbox\draw!