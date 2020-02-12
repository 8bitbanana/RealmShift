
export class ObjectManager
	new: =>
		@objects = {}
	
	addObject: (obj) =>
		if obj then
			table.insert(@objects, obj)
	
	updateObjects: =>		
		for i=1, #@objects do
			o = @objects[i]
			if o.update and not o.destroyed then
				o\update!
	
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