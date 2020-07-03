require "objects.game objects.Menu"

export class MainMenu extends Menu
	new: =>
		super(GAME_HEIGHT + 8)

		@main_menu = {
			"Play",
			"Options",
			"Credits",
			"Quit",
		}
		@play_menu = {
			"New Game",
			"Load Game",
		}
		@option_menu = {
			"Toggle Fullscreen",
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

		@callbacks = {
			["Play"]: @\enterPlayMenu,
			["New Game"]: @\startNewGame,
			["Load Game"]: @\loadGame,

			["Options"]: @\enterOptions,
			["Toggle Fullscreen"]: @\toggleFullscreen,
			["Credits"]: @\enterCredits,
			["Quit"]: @\quitGame,
		}

		@timer\after(0.5, @\animateMenu)

	animateMenu: =>
		@timer\tween(2, @, {menu_y: 64}, 'in-out-cubic')

	enterPlayMenu: =>
		@cursor = 1
		@current_menu = @play_menu

	startNewGame: =>
		game.next_state = {state: GameExploreState, params: {}}

	loadGame: =>
		-- CHECK FOR SAVE GAME DATA, IF EXISTS LOAD GAME, ELSE PLAY INCORRECT BUTTON SOUND
		save_data = io.open("save.dat", "rb")
		if save_data ~= nil
			print("save data exists!")
			deserialise(game, save_data\read("*all"))
			io.close(save_data)
			game.next_state = {state: GameExploreState, params: {}}
		else
			sounds.negative\stop!
			sounds.negative\play!

-- 	startGame: =>
-- 		game.next_state = {state: GameExploreState, params: {}}

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

	checkGoBack: =>
		if input\pressed('back')
			if @current_menu ~= @main_menu
				@current_menu = @main_menu
				@cursor = 1

	update: =>
		super\update()
		@\checkGoBack!

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

	draw: (col={0.1, 0.75, 0.85}) =>
-- 		@\drawPlayButton!
		if @current_menu == @credits_menu then
			@\drawCreditsMenu(64, 64)
		else
			@\drawMenuOptions(GAME_WIDTH/2, @menu_y, col)

		@\drawControls(42, @menu_y)
