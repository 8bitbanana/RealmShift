
-- require "states.state"

-- export class GameTransitionState extends State
	-- new: (@parent, @params={}) =>
		-- @next_state = table.remove(@params, 1) -- Pops off the next state from params so we can pass the rest of the parameters needed to the next state

		-- @length = 2
		-- @swipe_padding = 32
		-- @swipe_x = -@swipe_padding
		-- @timer = Timer!
		
		-- @temp_state_buffer = nil
		
		-- @\startTransitionOut!
		-- @timer\after(@length/2, @\startNextState)
		-- @timer\after(@length, @\completeTransition)
	
	-- startTransitionOut: =>
		-- @timer\tween(@length/2, @, {swipe_x: GAME_WIDTH + (@swipe_padding*2)}, 'out-cubic', @\startTransitionIn)
	
	-- startTransitionIn: =>
		-- @timer\tween(@length/2, @, {swipe_x: -@swipe_padding}, 'out-cubic')
	
	-- startNextState: =>
		-- @temp_state_buffer = @next_state(@parent, unpack(@params))
		-- if @temp_state_buffer.init
			-- @temp_state_buffer\init!
	
	-- completeTransition: =>
		-- @parent.state = @temp_state_buffer
		-- @\destroy!
	
	-- destroy: =>
		-- @timer\destroy!
	
	-- update: =>
		-- @timer\update(dt)
	
	-- drawTransition: =>
		-- -- Draw simple swipe using @swipe_x
		-- lg.setColor(BLACK)
		-- lg.rectangle("fill", -@swipe_padding, 0, @swipe_x, GAME_HEIGHT)
		-- lg.setColor(WHITE)
	
	-- draw: =>
		-- Push\setCanvas("main")
		
		-- if @temp_state_buffer
			-- @temp_state_buffer\draw!
		
		-- @\drawTransition!