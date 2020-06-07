export class ObjectManager
	new: =>
		@objects = {}

	addObject: (obj) =>
		if obj then
			table.insert(@objects, obj)

	-- Returns the number of objects of a certain type
	countObjects: (class_name) =>
		count = 0
		-- Check if class with class_name actually exists
		if _G[class_name]
			for o in *@objects
				if o.__class.__name == class_name
					count += 1
		return count

	updateObjects: =>
		for i=1, #@objects do
			o = @objects[i]
			if o.update and not o.destroyed then
				o\update!

	sortByValue: (vtbl) =>
		-- vtbl table of values like: {"pos", "x"} to index obj.pos.x
		sort_func = -> return nil

		if #vtbl > 1
			sort_func = (a, b) ->
				av = a[vtbl[1]]
				for i=2, #vtbl
					av = av[vtbl[i]]

				bv = b[vtbl[1]]
				for i=2, #vtbl
					bv = bv[vtbl[i]]

				-- print("av: #{av}, bv: #{bv}")
				return av < bv
		else
			sort_func = (a, b) -> return a.vtbl[1] < b.vtbl[1]

		table.sort(@objects, sort_func)


	drawObjects: =>
		for i=1, #@objects do
			o = @objects[i]
			if o.draw then
				o\draw!

	destroyAll: =>
		for i=#@objects, 1, -1 do
			o = @objects[i]
			if o.destroy
				o\destroy!
			table.remove(@objects, i)

	checkDestroyed: =>
		for i=#@objects, 1, -1 do
			o = @objects[i]
			if o then
				if o.destroyed then
					table.remove(@objects, i)
