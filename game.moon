
export class Game
	new: () =>
		@state = GameExploreState(@)
		@dialogbox = DialogBox("This is a test")
		@dialogbox\begin!
	
	update: =>
		@state\update!
		@dialogbox\update 0
		
	draw: =>
		@state\draw!
		@dialogbox\draw!