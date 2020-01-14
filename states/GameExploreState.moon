
require "states/state"

export class GameExploreState extends State
	new: (@parent, room_path="towns/test_town") =>
	
		-- no need to pass reference of 'game' object to 'current_room' as 'game' is global
		@current_room = Room(room_path)
		@objects = ObjectManager!
		
		@camera = Camera!
	
	update: =>
		@camera\move!
		@camera\limitPos(@current_room)
	
		@objects\updateObjects!
		@objects\checkDestroyed!
		
	draw: =>		
		@current_room\draw(@camera.pos)
		@objects\drawObjects!