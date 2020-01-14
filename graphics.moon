
export setupGraphics = ->
	lg.setDefaultFilter("nearest", "nearest")
	lg.setLineStyle("rough")
	lm.setVisible(false)

export setupWindow = ->
	lw.setTitle("Realm Shift")

	push_opts = { fullscreen: false, resizable: true, pixelperfect: true, canvas: true }
	Push\setupScreen(GAME_WIDTH, GAME_HEIGHT, GAME_WIDTH*SCALE, GAME_HEIGHT*SCALE, push_opts)