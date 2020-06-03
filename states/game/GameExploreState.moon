
require "states/state"

export class GameExploreState extends State
	new: (@parent, @room_path="towns/test_town", @tx=64, @ty=64) =>
		@objects = ObjectManager!
		@current_room = Room(@room_path)

	init: =>
		@current_room\init!

		@player = Player({x: @tx, y: @ty})
		@camera = Camera!
		@camera\setPos(@player.pos)
		@camera\limitPos(@current_room)

		-- Add objects to object manager
		@objects\addObject(@player)
		@objects\addObject(@camera)

		-- Add player to physics world so they can collide with tiles
		@current_room.world\add(@player, @player.pos.x, @player.pos.y + (@player.height/2), @player.width, @player.height/2)

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
		-- shadowPrint("This is a test town area!\nIn here you will be able to talk to NPCs,\nvisit shops etc.")

		lg.pop!
