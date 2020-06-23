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
		game.next_state = {state: GameTitleState, params: {}}

	quitToMenu: =>
		game.next_state = {state: GameTitleState, params: {}}
