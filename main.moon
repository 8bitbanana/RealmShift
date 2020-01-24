
export Input = require "lib/Input"
export Push  = require "lib/push"
export Bump  = require "lib/bump"
export STI   = require "lib/sti"
export Soda  = require "lib/sodapop"

require "constants"
require "utils"
require "graphics"
require "font"
require "image"
require "input"
require "game"
require "dialog"

requireFolder("states")
requireFolder("objects")
requireFolder("rooms")

love.load = ->
		setupGraphics!
		setupFonts!
		setupWindow!
		loadSprites!
		
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