
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
		-- params = table.stripKeys(obj_data.properties) -- returns a table with only the values from obj_data.properties without keys

		-- Check if class exists and create a new object if so
		if obj_class
			-- Create object with default values
			obj = obj_class(pos, width, height)--, unpack(params))
			-- Loop through all the custom values in the object data
			-- and assign those values to the created object.
			for k, v in pairs(obj_data.properties) do
				obj[k] = v

			-- ^^^^
			-- This way is much safer and ensures that values are assigned to
			-- the correct keys in the final object. Using the previous method
			-- of unpacking the values caused issues where tx and ty values
			-- for room doors were unpacking in the wrong order.

			return obj

	loadObjects: =>
		-- Load objects directly from the exported Tiled map
		-- that share the same name as an object class
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
		@map.layers[1].x = -pos.x
		@map.layers[1].y = -pos.y
		@map\drawTileLayer(@map.layers[1])

		if SHOW_COLLIDERS
			lg.setColor(RED)
			@map\bump_draw(@world, -pos.x, -pos.y)
