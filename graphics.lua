setupGraphics = function()
  lg.setDefaultFilter("nearest", "nearest")
  lg.setLineStyle("rough")
  return lm.setVisible(false)
end
setupWindow = function()
  lw.setTitle("Realm Shift")
  local push_opts = {
    fullscreen = false,
    resizable = true,
    pixelperfect = true,
    canvas = true
  }
  return Push:setupScreen(GAME_WIDTH, GAME_HEIGHT, GAME_WIDTH * SCALE, GAME_HEIGHT * SCALE, push_opts)
end
