
export class PlayerTalkState extends State
	new: (@parent) =>
		-- An empty class for now that just takes
		-- control away from the player whilst talking

	draw: =>
		if @parent.sprite
			@parent.sprite\draw(@parent.pos.x, @parent.pos.y)
