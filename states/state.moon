
-- export changeState = (old_state_var, new_state, parent) ->
	-- old_state_var = new_state(parent)

export class State
	new: (@parent) =>		
	
	destroy: =>
		if @objects
			@objects\destroyAll!
	
	changeState: (new_state, params={}) =>
		print("unpack params:")
		print(unpack(params))
	
		if #params > 0
			print(params[1].__name)
	
		@parent.state\destroy!
		@parent.state = new_state(@parent, params)
		
		if @parent.state.init
			@parent.state\init!
	
	update: =>
	
	
	draw: =>
		