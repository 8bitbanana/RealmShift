
-- export changeState = (old_state_var, new_state, parent) ->
	-- old_state_var = new_state(parent)

export class State
	new: (@parent) =>
		
		
	-- enterState: =>
		
		
	-- exitState: =>
		
	
	changeState: (new_state) =>
		@parent.state = new_state(@parent)
	
	update: =>
	
	
	draw: =>
		