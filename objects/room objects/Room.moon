
export class Room
	new: (@room_path) =>
		@world = Bump.newWorld!

		@map = STI("rooms/#{@room_path}.lua", {"bump"})
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
			-- print("class #{obj_data.type} exists")
			-- Create object with default values
			obj = obj_class(pos, width, height)--, unpack(params))
			-- Loop through all the custom values in the object data
			-- and assign those values to the created object.
			for k, v in pairs(obj_data.properties) do
				obj[k] = v

			-- Call object initiate function if it has one
			if obj.init
				obj\init!

			-- ^^^^
			-- This way is much safer and ensures that values are assigned to
			-- the correct keys in the final object. Using the previous method
			-- of unpacking the values caused issues where tx and ty values
			-- for room doors were unpacking in the wrong order.

			-- If obj.solid then add obj to collision world
			if obj.solid
				@world\add(obj, obj.pos.x, obj.pos.y, obj.width, obj.height)

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
-- 		lg.setColor(WHITE)
		for layer in *@map.layers
			if layer.type == "tilelayer"
				layer.x = -pos.x
				layer.y = -pos.y
				@map\drawTileLayer(layer)

		if SHOW_COLLIDERS
			lg.setColor(RED)

			items = @world\getItems()
			for i in *items
				x,y,w,h = @world\getRect(i)
				c = game.state.camera
				lg.rectangle("line",x-c.pos.x,y-c.pos.y,w,h)

			--@map\bump_draw(@world, -pos.x, -pos.y)
