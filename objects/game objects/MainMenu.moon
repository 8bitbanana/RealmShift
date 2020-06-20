
export class MainMenu
	new: =>
		@timer = Timer!
		@count = 0
		@blink = 0.4

		@menu_y = GAME_HEIGHT + 8
		@main_menu = {
		"Start Game",
		"Options",
		"Credits",
		"Quit"}
		@option_menu = {
			"Toggle Fullscreen"
		}
		@credits_menu = {
			"Ethan (924610)",
			"Cody (924610)",
			"Anthony (941967)",
			"Daniel (943856)",
			"Jack (902197)",
			"Naomi (899468)",
			"Faybia (945607)",
		}
		@current_menu = @main_menu

		@cursor = 1

		@timer\after(0.5, @\animateMenu)

	animateMenu: =>
		@timer\tween(2, @, {menu_y: 64}, 'in-out-cubic')

	moveCursor: =>
		if input\pressed('up')
			@cursor = max(1, @cursor - 1)
		if input\pressed('down')
			@cursor = min(#@current_menu, @cursor + 1)

	chooseOption: =>
		if input\pressed('confirm')
			current = @current_menu[@cursor]

			switch(current)
				when "Start Game"
					@\startGame!

				when "Options"
					@\enterOptions!
				when "Toggle Fullscreen"
					@\toggleFullscreen!

				when "Credits"
					@\enterCredits!
				when "Quit"
					@\quitGame!

		elseif input\pressed('back')
			if @current_menu ~= @main_menu
				@current_menu = @main_menu
				@cursor = 1

	startGame: =>
		game.next_state = {state: GameExploreState, params: {}}

	quitGame: =>
		le.quit()

	enterOptions: =>
		@cursor = 1
		@current_menu = @option_menu

	enterCredits: =>
		@cursor = 1
		@current_menu = @credits_menu

	toggleFullscreen: =>
		Push\switchFullscreen!

	update: =>
		@timer\update(dt)
		@count += dt

		@\moveCursor!
		@\chooseOption!

	drawPill: (x, y, w, h, col={0.1, 0.75, 0.85}) =>
		lg.setColor(col)
		lg.ellipse("fill", round(x-2), round(y+8), 6, 6)
		lg.ellipse("fill", round(x+w+2), round(y+8), 6, 6)
		lg.rectangle("fill", x-2, y+2, w+4, 12)
		lg.setColor(WHITE)

	drawOptionBackground: (i, x, y, width) =>
		if i == @cursor
			@\drawPill(x, y+2, width, 12, BLACK)
			if (@count % @blink) < @blink/2
				@\drawPill(x, y, width, 12, {0.4, 0.85, 1.0})
			else
				@\drawPill(x, y, width, 12)
		else
			@\drawPill(x, y, width, 12)
-- 			lg.setColor({0.1, 0.75, 0.85})

-- 		lg.setColor({0.8, 0.8, 0.8})
-- 		lg.ellipse("fill", x-2, y+8, 6, 6)
-- 		lg.ellipse("fill", x+width+2, y+8, 6, 6)
-- 		lg.rectangle("fill", x-2, y+2, width+4, 12)
-- 		lg.setColor(WHITE)

	drawMenuOption: (i, item, x, y) =>
		font = lg.getFont!
		width = font\getWidth(item)
		cx = x - (width/2)
		@\drawOptionBackground(i, cx, y, width)
		shadowPrint(item, cx, y)

	drawMenuOptions: (x=0, y=0) =>
		for i=1, #@current_menu
			ty = y + i*16
			@\drawMenuOption(i, @current_menu[i], x, ty)

	drawControls: (x=0, y=0) =>
		lg.setColor(WHITE)
		lg.print("z - accept", x, y+82)
		lg.print("x - back", x+96, y+82)

	drawCreditsMenu: (x=0, y=0) =>
		font = lg.getFont!

		for i=1, #@current_menu
			tx = x + floor(i/4) * 114
			ty = y + (( (i-1)*16) % 64)

			item = @current_menu[i]
			width = font\getWidth(item)
			cx = tx - (width/2)

			@\drawPill(cx, ty, width, 12, GOLD)
			shadowPrint(item, cx, ty)

	draw: =>
-- 		@\drawPlayButton!
		if @current_menu == @credits_menu then
			@\drawCreditsMenu(64, 64)
		else
			@\drawMenuOptions(GAME_WIDTH/2, @menu_y)

		@\drawControls(42, @menu_y)
