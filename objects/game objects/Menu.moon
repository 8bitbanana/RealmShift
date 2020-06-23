
-- Menu class used for Main Menu / Game Over Menu / (Pause Menu)
export class Menu
	new: (@menu_y=80) =>
		@timer = Timer!
		@count = 0
		@blink = 0.4
		@cursor = 1

		@current_menu = nil -- Look at GameOverMenu for an example on how to use these
		@callbacks = nil

	moveCursor: =>
		if input\pressed('up')
			if @cursor == 1
				@cursor = #@current_menu
			else
				@cursor -= 1
		if input\pressed('down')
			if @cursor == #@current_menu
				@cursor = 1
			else
				@cursor += 1

	chooseOption: =>
		if input\pressed("confirm")
			current = @current_menu[@cursor]
			if @callbacks[current] then
				@callbacks[current]!

	drawPill: (x, y, w, h, col) =>
		lg.setColor(col)
		lg.ellipse("fill", round(x-2), round(y+8), 6, 6)
		lg.ellipse("fill", round(x+w+2), round(y+8), 6, 6)
		lg.rectangle("fill", x-2, y+2, w+4, 12)
		lg.setColor(WHITE)

	drawOptionBackground: (i, x, y, width, col) =>
		if i == @cursor
			@\drawPill(x, y+2, width, 12, BLACK)
			if (@count % @blink) < @blink/2
				@\drawPill(x, y, width, 12, {col[1]+0.1, col[2]+0.1, col[3]+0.1})
			else
				@\drawPill(x, y, width, 12, col)
		else
			@\drawPill(x, y, width, 12, {col[1]-0.1, col[2]-0.1, col[3]-0.1})

	drawMenuOption: (i, item, x, y, col) =>
		font = lg.getFont!
		width = font\getWidth(item)
		cx = x - (width/2)
		@\drawOptionBackground(i, cx, y, width, col)

		-- print option text
		if i == @cursor
			shadowPrint(item, cx, y)
		else
			shadowPrint(item, cx, y, {0.8, 0.8, 0.8}) -- Gray out text if not current option

	drawMenuOptions: (x=0, y=0, col) =>
		for i=1, #@current_menu
			ty = y + i*16
			@\drawMenuOption(i, @current_menu[i], x, ty, col)

	drawControls: (x=0, y=0) =>
		lg.setColor(WHITE)
		lg.print("z - accept", x, y+82)
		lg.print("x - back", x+96, y+82)

	update: =>
		@timer\update(dt)
		@count += dt

		@\moveCursor!
		@\chooseOption!

	draw: (col={0.1, 0.75, 0.85}) =>
		@\drawMenuOptions(GAME_WIDTH/2, @menu_y, col)
		@\drawControls(42, @menu_y)
