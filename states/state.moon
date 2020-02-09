
-- export changeState = (old_state_var, new_state, parent) ->
	-- old_state_var = new_state(parent)

export class State
	new: (@parent) =>		
	
	destroy: =>
		if @objects
			@objects\destroyAll!
	
	changeState: (new_state) =>
		-- print("changeState called")
		-- print(new_state.__name)
		
		@parent.state\destroy!
		@parent.state = new_state(@parent)
		
		if @parent.state.init
			@parent.state\init!
	
	update: =>
	
	
	draw: =>
		