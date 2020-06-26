
export class PauseMenu extends Menu
	new: =>
		super(64)

		@options = {
			"Resume",
			"Save & Quit",
		}
		@current_menu = @options

		@callbacks = {
			["Resume"]: @\resumeGame,
			["Save & Quit"]: @\saveAndQuit,
		}

	resumeGame: =>
		game.paused = false

	saveAndQuit: =>
		game.paused = false
		serialise(game) -- Save Game
		game.next_state = {state: GameTitleState, params: {}} -- Then Quit

	draw: (col) =>
		-- Darken screen and print 'Paused'
		lg.setColor({0,0,0, 0.75})
		lg.rectangle("fill", 0,0, GAME_WIDTH, GAME_HEIGHT)
		lg.setColor(WHITE)
		lg.setFont(big_font)
		shadowPrint("Paused", 92, 32)
		lg.setFont(default_font)

		-- Draw Menu options
		super\draw(col)

