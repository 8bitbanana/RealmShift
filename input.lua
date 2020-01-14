
function setupInput()
	local input = Input()
	
	-- -- WASD
	input:bind("a", "left")
	input:bind("d", "right")
	input:bind("w", "up")
	input:bind("s", "down")
	
	-- -- ARROW KEYS
	input:bind("left", "left")
	input:bind("right", "right")
	input:bind("up", "up")
	input:bind("down", "down")
	
	-- MISC. KEYBOARD
	input:bind("r", function() le.quit("restart") end)
	input:bind("escape", le.quit)
	input:bind("f",
		function()
			-- game.fullscreen = not game.fullscreen
			Push:switchFullscreen()
		end
	)
	
	-- -- GAMEPAD
	-- input:bind("dpleft", "left")
	-- input:bind("dpright", "right")
	-- input:bind("dpup", "up")
	-- input:bind("dpdown", "down")
	
	return input
end