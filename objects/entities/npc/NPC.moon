
require "objects/entities/player/Player"
require "objects/game objects/dialog/Dialog"
Inspect = require "lib/inspect"

export class NPC extends Player
	new: (@pos = {x: 0, y: 0}) =>
		@width = 16
		@height = 16
		@name = ""
		@talk_range = 8 -- Margin around NPC to check for player
		@vel = {x: 0, y: 0}
		@sprite = sprites.player.idle

		@state = NPCWanderState(@)

	init: =>
		-- Load NPC dialog after their name has been loaded from the map data
		-- so we know whose dialogue to load
		if @name
			@dialog = @\loadDialog()

	loadDialog: =>
		if (@name ~= nil) and (@name ~= "")
			file_path = "dialog/#{@name}.lua"
			-- load file as a 'chunk' of code to be executed
			file, error = loadfile(file_path)
			if error
				print(error)
			else
				-- return DialogTree inside file
				d = file()
				return d
		return nil

	getTalkZone: =>
		-- Returns the collision checking box for checking whether player
		-- is in range to talk to NPC
		return {pos: {x: @pos.x-@talk_range, y: @pos.y-@talk_range}, width: @width+(@talk_range*2), height: @height+(@talk_range*2)}

	-- Keeping this method in NPC means we can use it in multiple different states
	-- e.g. wandering state, idle state etc.
	checkTalk: =>
		talk_zone = @\getTalkZone!
		p = game.state.player

		if p
			if AABB(talk_zone, p)
				game.button_prompts = {z: "Talk", x: ""}

				gd = game.dialog
				if not gd.running
					if input\pressed "talk"
						print("setting dialog tree")
						gd\setTree(@dialog)
						@state\changeState(NPCTalkState)
						p.state\changeState(PlayerTalkState)

				else
					if input\pressed "talk"
						print ("advancing text")
						gd\advanceInput!
						if gd.tree and gd.tree.done
							print("dialog done")
							@state\changeState(NPCWanderState)
							p.state\changeState(PlayerIdleState)

	drawTalkZone: =>
		c = @\getTalkZone!
		lg.setColor(ORANGE)
		lg.rectangle("line", c.pos.x, c.pos.y, c.width, c.height)
		lg.setColor(WHITE)

	draw: =>
		@\drawTalkZone!
		super\draw!

