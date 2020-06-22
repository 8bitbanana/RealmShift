
export class GameOverState extends State
	new: (@parent) =>
		@timer = Timer!

		@timer\after(4, @restartGame, 'restart')

	init: =>
		-- do nothing

	restartGame: =>
-- 		game\init!
		game.next_state = {state: GameTitleState, params: {}}

	update: =>
		@timer\update(dt)

-- 		print(@timer\getTime('restart'))

	draw: =>
		lg.clear(BLACK)
		lg.setFont(big_font)

		lg.setColor(WHITE)
		lg.print("game over", 80, 72)

		lg.setFont(default_font)

