
export class BattleWinState extends State
	new: (@parent, args) =>
		@timer = Timer!
		@blink_timer = 0
		@blink_len   = 1
		-- @rx & @ry is return position on overworld to put the player at after win screen
		@rx = args.rx
		@ry = args.ry

		@padding    = 32
		@width      = GAME_WIDTH-@padding
		@height     = GAME_HEIGHT-@padding
		@opacity    = 0
		@pcount     = 0
		@gcount     = 0
		@can_skip   = false
		@can_return = false

		@timer\tween(0.5, @, {opacity: 0.85}, 'out-cubic', @\startAnimation)

	startAnimation: =>
		@can_skip = true
		@timer\every(0.5, @\increasePlayerCount, 4, @\endBattleSummary, 'player_reveal')

	increasePlayerCount: =>
		-- Increases the number of player portraits to be drawn
		@pcount += 1

	skipAnimation: =>
		@timer\cancel('player_reveal')
		@pcount = 4
		@\endBattleSummary!

	checkSkip: =>
		if @can_skip and (input\pressed("confirm") or input\pressed("back"))
			@\skipAnimation!

	endBattleSummary: =>
		@can_return = true

	checkReturn: =>
		if @can_return and input\pressed("confirm")
			game.next_state = {state: GameOverworldState, params: {@rx, @ry}}

	update: =>
		@timer\update(dt)
		@blink_timer = (@blink_timer + dt)%@blink_len

		@\checkReturn!
		@\checkSkip!

	drawScreenBackground: =>
		dx = (GAME_WIDTH-@width)/2
		dy = (GAME_HEIGHT-@height)/2

		lg.setColor({0,0,0, @opacity})
		lg.rectangle("fill", dx, dy, @width, @height)
		lg.setColor(WHITE)

	drawHealthBar: (player, x, y) =>
		hp = player.hp
		max_hp = player.basestats.hp
		max_len = 40
		len = (hp/max_hp)*max_len

		lg.setColor(BLACK)
		lg.rectangle("fill", x+25, y-15, max_len, 2)
		lg.setColor(RED)
		lg.rectangle("fill", x+24, y-16, len, 2)
		lg.setColor(WHITE)
		shadowPrint("#{hp}/#{max_hp}", x+29, y-26)

	drawPortraitBorder: (x, y) =>
		w = 72
		h = -28

		lg.setColor({0.3,0.3,0.3, @opacity})
		lg.rectangle("line", x, y-4, w, h)

	drawPlayerPortraits: =>
		players = @parent.players

		for i=1, @pcount
			p = players[i]
			x = 32+(floor((i-1)/2)*104)
			y = 112-((i%2)*40)

			@\drawPortraitBorder(x, y)

			if p
				p.sprite\draw(x, y)
				@\drawHealthBar(p, x, y-6)

	drawButtonPrompt: =>
		if @blink_timer <= @blink_len/2
			x = 176
			y = GAME_HEIGHT-@padding

			if @can_skip and not @can_return
				x = 176
				shadowPrint("Skip", x+20, y)
			elseif @can_skip and @can_return
				x = 160
				shadowPrint("Confirm", x+20, y)

			if @can_skip
				sprites.gui.cursor\draw(x, y)

	draw: =>
		@\drawScreenBackground!
		@\drawPlayerPortraits!
		@\drawButtonPrompt!
