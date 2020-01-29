
require "states/state"

export class GameExploreState extends State
	new: (@parent, @room_path="towns/test_town") =>
		@objects = ObjectManager!
		@current_room = Room(@room_path)
		
	init: =>
		@current_room\init!
	
		@player = Player({x: 64, y: 64})
		@camera = Camera!
		
		-- Add objects to object manager
		@objects\addObject(@player)
		@objects\addObject(@camera)
		
		-- Add player to physics world so they can collide with tiles
		@current_room.world\add(@player, @player.pos.x, @player.pos.y, @player.width, @player.height)
	
	update: =>
		-- @camera\move!
		-- @camera\limitPos(@current_room)
	
		@objects\updateObjects!
		@objects\checkDestroyed!
		
	draw: =>		
		@current_room\draw(@camera.pos)
		
		lg.push!
		
		lg.translate(-@camera.pos.x, -@camera.pos.y)
		@objects\drawObjects!
		
		lg.pop!