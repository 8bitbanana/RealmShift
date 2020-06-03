
require "states/state"

export class GameOverworldState extends State
	new: (@parent, @tx=0, @ty=0) =>
		@objects = ObjectManager!
		@current_room = Room("overworld/overworld_1")

	init: =>
		@current_room\init!

		@player = OverworldPlayer({x: @tx, y: @ty})
		@camera = Camera!
		@camera\setPos(@player.pos)
		@camera\limitPos(@current_room)

		@objects\addObject(@camera)
		@objects\addObject(@player)

		-- Add player to physics world so they can collide with tiles
		@current_room.world\add(@player, @player.pos.x, @player.pos.y, @player.width, @player.height)

	update: =>
		@objects\updateObjects!
		@objects\checkDestroyed!

	draw: =>
		Push\setCanvas("main")

		@current_room\draw(@camera.pos)


		lg.push!

		lg.translate(-@camera.pos.x, -@camera.pos.y)
		@objects\drawObjects!

		-- DEBUG PRINTING --
		-- shadowPrint("This is the overworld!\nThis is where the player will explore the\nworld and enter new areas such as towns &\ndungeons etc.\n\n\n\n\n\nCurrently all you can do is move.")

		lg.pop!
