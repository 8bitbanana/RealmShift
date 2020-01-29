
export class Room
	new: (room_path) =>
		@world = Bump.newWorld!
		@map = STI("rooms/#{room_path}.lua", {"bump"})
		@map\bump_init(@world)
		
	init: =>
		@\loadObjects!
	
	getObjectLayers: =>
		object_layers = {}
		layers = @map.layers
		for layer in *layers do
			if layer.type == "objectgroup"
				table.insert(object_layers, layer)
		
		return object_layers
	
	createMapObject: (obj_data) =>
		pos    = {x: obj_data.x, y: obj_data.y}
		width  = obj_data.width
		height = obj_data.height
		
		-- Get the class of the object we're trying to load
		obj_class = _G[obj_data.type]
		
		-- Get custom parameters of object
		params = table.stripKeys(obj_data.properties) -- returns a table with only the values from obj_data.properties without keys
		
		-- Check if class exists and create a new object if so
		if obj_class
			obj = obj_class(pos, width, height, unpack(params))
			return obj
	
	loadObjects: =>
		object_layers = @\getObjectLayers!
		for layer in *object_layers do
			for obj_data in *layer.objects do
				obj = @\createMapObject(obj_data)
				if obj
					game.state.objects\addObject(obj)
	
	update: =>
		@map\update(dt)
		
	draw: (pos={x: 0, y: 0}) =>
		lg.setColor(WHITE)
		@map\draw(-pos.x, -pos.y)
		
		if SHOW_COLLIDERS
			lg.setColor(RED)
			@map\bump_draw(@world, -pos.x, -pos.y)