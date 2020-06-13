
require "states/state"

export class GameTitleState extends State
	new: (@parent) =>
		@title = "Heroes of Highever"
		@timer = Timer!
		@room = Room("overworld/overworld_new")

		@count = 0
		@banner_opacity = 0
		@title_y = GAME_HEIGHT + 8
		@title_opacity = -0.5
		@title_wobble_factor = 0

		@active = false

		@timer\tween(3, @, {title_opacity: 1}, 'out-cubic')
		@timer\tween(3, @, {title_y: 32}, 'out-cubic', @\activate)

	init: =>

	activate: =>
		@active = true
		@timer\tween(2, @, {title_wobble_factor: 1}, 'in-out-cubic')
		@timer\tween(2, @, {banner_opacity: 1}, 'in-out-cubic')

	checkPlay: =>
		if @active
			if input\pressed('confirm')
				game.next_state = {state: GameExploreState, params: {}}

	update: =>
		@timer\update(dt)
		@count += dt

		@\checkPlay!

	drawBackground: =>
		lg.setColor({1,1,1,@banner_opacity})
		@room\draw!

	drawBanner: =>
		x = 0
		y = 0

		-- Banner main body
		for i=0, 107
			x = (2*i)
			y = 40 + @title_wobble_factor * (sin(1.5+@count*2-(i/12))*3)
			spr = sprites.gui.banner_strip
			spr.color = {1,1,1,@banner_opacity}
			spr\draw(x, y)

		-- Banner end fork
		for i=1, 11
			y = 40 + @title_wobble_factor * (sin(1.5+@count*2-((i+108)/12))*3)
			spr = sprites.gui.banner_strip_end[i]
			spr.color = {1,1,1,@banner_opacity}
			spr\draw(x+(2*i),y)

	drawTitle: =>
		lg.setFont(title_font)
		gap = 0
		for i=1, #@title
			letter = @title\sub(i,i)
			x = 40 + gap
			y_wobble = @title_wobble_factor * (sin(@count*2-(i/3))*3)
			y = @title_y + y_wobble
			shadowPrint(letter, x, y, {1,1,1,@title_opacity})

			gap += title_font\getWidth(letter)

		lg.setFont(default_font)

	drawPlayButton: =>
		if @active
			if (@count % 2) < 1
				shadowPrint("Z - Play", 96, GAME_HEIGHT-32)

	draw: =>
		lg.clear(BLACK)
		@\drawBackground()
		@\drawBanner()
		@\drawTitle()
		@\drawPlayButton()
-- 		lg.setFont(title_font)
-- 		lg.print(@title, 16, 32)
