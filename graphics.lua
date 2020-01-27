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
    canvas = true,
    stencil = true
  }
  Push:setupScreen(GAME_WIDTH, GAME_HEIGHT, GAME_WIDTH * SCALE, GAME_HEIGHT * SCALE, push_opts)
  return Push:setupCanvas({
    {
      name = "main",
      stencil = true
    },
    {
      name = "dialogbox",
      width = 234,
      height = 50,
      x = 3,
      y = 107,
      stencil = true
    }
  })
end
