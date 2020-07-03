
-- require "states.state"

-- export class GamePauseState extends State
-- 	new: (@parent, @return_state, @objects) =>
-- 		-- @return_state = the state to return to after exiting pause state
-- 		@timer = Timer!
-- 		@menu = PauseMenu!

-- 		@timer\after(1, @\returnFromPause)

-- 	init: =>


-- 	returnFromPause: =>
-- 		@timer\destroy!
-- -- 		@parent.state = @return_state!
-- -- 		@parent.state.objects = @objects


-- 	update: =>
-- 		@timer\update(dt)
