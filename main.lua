Input = require("lib/Input")
Timer = require("lib/Timer")
Push = require("lib/push")
Bump = require("lib/bump")
STI = require("lib/sti")
Soda = require("lib/sodapop")
require("constants")
require("utils_new")
require("graphics")
require("font")
require("image")
require("sound")
require("input")
require("game")
requireFolder("states")
requireFolder("objects")
requireFolder("rooms")
math.randomseed(os.time())
math.random()
love.load = function()
  setupGraphics()
  setupFonts()
  setupWindow()
  loadSprites()
  loadSounds()
  input = setupInput()
  game = Game()
  return game:init()
end
love.update = function()
  dt = love.timer.getDelta()
  return game:update()
end
love.resize = function(w, h)
  return Push:resize(w, h)
end
love.draw = function()
  Push:start()
  game:draw()
  return Push:finish()
end
