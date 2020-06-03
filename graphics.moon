
export setupGraphics = ->
	lg.setDefaultFilter("nearest", "nearest")
	lg.setLineStyle("rough")
	lm.setVisible(false)

export setupWindow = ->
	lw.setTitle("Realm Shift")

	push_opts = {
		fullscreen: false,
		resizable: true,
		pixelperfect: true,
		canvas: true,
		-- stencil: true
	}
	Push\setupScreen(GAME_WIDTH, GAME_HEIGHT, GAME_WIDTH*SCALE, GAME_HEIGHT*SCALE, push_opts)

	Push\setupCanvas(
		{
			{
				name: "main",
			},
			{ -- Push has been modified to support x,y,w,h for canvases
				name: "dialogbox",
				width: 234,
				height: 50,
				x: 3,
				y: 107
			}
		}
	)
