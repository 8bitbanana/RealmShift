
export class GameOverState extends State
	new: (@parent) =>
		@timer = Timer!
		@menu =	GameOverMenu!

-- 		@timer\after(4, @restartGame, 'restart')

	init: =>
		-- do nothing

	restartGame: =>
-- 		game\init!
		game.next_state = {state: GameTitleState, params: {}}

	update: =>
		@timer\update(dt)
		@menu\update!

	drawGameOver: =>
		lg.clear(BLACK)
		lg.setFont(big_font)

		lg.setColor(WHITE)
		lg.print("game over", 80, 64)

		lg.setFont(default_font)

	draw: =>
		@\drawGameOver!
		@menu\draw({0.3, 0.3, 0.3})
