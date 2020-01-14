
export class Game
	new: () =>
		@state = GameExploreState(@)
	
	update: =>
		@state\update!
		
	draw: =>
		@state\draw!