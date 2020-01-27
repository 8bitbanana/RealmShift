
export class Game
	new: () =>
		@state = GameExploreState(@)

		-- Placed directly in game class for now
		@dialogbox = DialogBox("This is a test of the dialog box{pause,30}\nIt seems to work fairly well so far,\nalthough I did have to edit {colour,0,0,1,1,8}Push.lua.{pause,30}\n3{pause,30}\n4{pause,30}\n5{pause,30}\n6{pause,50}\n{wave,4}Wow!")
	
	update: =>
		@state\update!
		@dialogbox\update 0

		if input\pressed "dialogdebug"
			if @dialogbox.done
				@dialogbox\reset!
			else
				@dialogbox\begin!
		
	draw: =>
		@state\draw!
		if @dialogbox.started
			@dialogbox\draw!