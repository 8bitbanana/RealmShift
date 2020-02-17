
require "states/state"

export class GameTransitionState extends State
	new: (@parent, @params={}) =>
	
		print("params: #{@params}")
		print("#params: #{#@params}")
		if @params[2]
			print(@params[2])
			print("room name is successfully sent to transition state")
		print()
	
		@next_state = table.remove(@params, 1) -- Pops off the next state from params so we can pass the rest of the parameters needed to the next state

		print("next state popped off @params")
		print("#params: #{#@params}")

		print("next_state: #{@next_state}")

		@length = 2
		@swipe_padding = 32
		@swipe_x = -@swipe_padding
		@timer = Timer!
		
		@temp_state_buffer = nil
		
		@\startTransitionOut!
		@timer\after(@length/2, @\startNextState)
		@timer\after(@length, @\completeTransition)
	
	startTransitionOut: =>
		@timer\tween(@length/2, @, {swipe_x: GAME_WIDTH + (@swipe_padding*2)}, 'out-cubic', @\startTransitionIn)
	
	startTransitionIn: =>
		@timer\tween(@length/2, @, {swipe_x: -@swipe_padding}, 'out-cubic')
	
	startNextState: =>
		print()
		print("startNextState:")
		print("params: #{@params}")
		print("#params: #{#@params}")
		print(unpack(@params))
		print("parent: #{@parent}")
		print("@next_state: #{@next_state.__name}")
		print()
		
		--@temp_state_buffer = GameExploreState(@parent, {"test_room"})
		-- a = ()->GameExploreState("test_room")
		@temp_state_buffer = @next_state(@parent, @params)
		
		-- if @temp_state_buffer.init
			-- @temp_state_buffer\init!
	
	completeTransition: =>
		@parent.state = @temp_state_buffer
		@\destroy!
	
	destroy: =>
		@timer\destroy!
	
	update: =>
		@timer\update(dt)
	
	drawTransition: =>
		-- Draw simple swipe using @swipe_x
		lg.setColor(BLACK)
		lg.rectangle("fill", -@swipe_padding, 0, @swipe_x, GAME_HEIGHT)
		lg.setColor(WHITE)
	
	draw: =>
		Push\setCanvas("main")
		
		if @temp_state_buffer
			@temp_state_buffer\draw!
		
		@\drawTransition!