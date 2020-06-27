require "objects/game objects/Menu"

export class GameOverMenu extends Menu
	new: =>
		super(GAME_HEIGHT - 72)

		@options = {
			"Continue",
			"Quit To Menu"
		}
		@current_menu = @options

		@callbacks = {
			["Continue"]: @\continueGame,
			["Quit To Menu"]: @\quitToMenu,
		}

	continueGame: =>
		save_data = io.open("save.dat", "rb")
		if save_data ~= nil
			serial = save_data\read("*all")
			deserialise(game, serial) -- Load Save Game
			io.close(save_data)

		game.next_state = {state: GameExploreState, params: {}}

	quitToMenu: =>
		game.next_state = {state: GameTitleState, params: {}}
