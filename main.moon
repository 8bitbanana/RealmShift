
export Input = require "lib/Input"
export Push  = require "lib/push"
export STI   = require "lib/sti"

require "constants"
require "utils"
require "graphics"
require "input"
require "game"

requireFolder("states")
requireFolder("objects")
requireFolder("rooms")

love.load = ->
		setupGraphics!
		setupWindow!
		
		-- Exporting variables makes them global so they can be accessed from anywhere else
		export input = setupInput!
		export game = Game!


love.update = ->
	export dt = love.timer.getDelta()
	
	game\update!


love.resize = (w, h) ->
		Push\resize(w, h)


love.draw = ->
		Push\start!
		
		game\draw!
		
		Push\finish!