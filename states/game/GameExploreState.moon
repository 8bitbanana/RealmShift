
require "states/state"

export class GameExploreState extends State
	new: (@parent, @params) =>
	
		print("GameExploreState:")
		print("@parent: #{@parent}")
		print("@params: #{@params}")
		print("#@params: #{#@params}")
		print("unpack(@params)")
		print(unpack(@params))
		print()
		
		@room_path = @params[1]
	
		@objects = ObjectManager!
		@current_room = Room(@room_path)--Room(@room_path)
		
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
		@objects\updateObjects!
		@objects\checkDestroyed!
		
	draw: =>
		Push\setCanvas("main")
		
		@current_room\draw(@camera.pos)
		
		lg.push!
		
		lg.translate(-@camera.pos.x, -@camera.pos.y)
		@objects\drawObjects!
		
		-- DEBUG PRINTING --
		shadowPrint("This is a test town area!\nIn here you will be able to talk to NPCs,\nvisit shops etc.")
		
		lg.pop!